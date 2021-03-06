# == Class: archivesspace::install
#
# Full description of class archivesspace here.
#
# === Authors
#
# Author Name flannon@nyu.edu
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class archivesspace::install (
  #  String $ensure        = lookup('archivesspace::ensure', String, 'first' ),
  String $version         = lookup('archivesspace::version', String, 'unique'),
  String $install_dir     = lookup('archivesspace::install_dir', String, 'first' ),
  String $conf_dir        = lookup('archivesspace::conf_dir', String, 'first' ),
  String $conf_file       = lookup('archivesspace::conf_file', String, 'first' ),
  String $java_heap_max   = lookup('archivesspace::java_heap_max', String, 'first' ),
  String $log_level       = lookup('archivesspace::log_level', String, 'first' ),
  String $enable_backend  = lookup('archivesspace::enable_backend', String, 'first' ),
  String $enable_frontend = lookup('archivesspace::enable_frontend', String, 'first' ),
  String $enable_public   = lookup('archivesspace::enable_public', String, 'first' ),
  String $enable_solr     = lookup('archivesspace::enable_solr', String, 'first' ),
  String $enable_indexer  = lookup('archivesspace::enable_indexer', String, 'first' ),
  String $enable_docs     = lookup('archivesspace::enable_docs', String, 'first' ),
  String $enable_oai      = lookup('archivesspace::enable_oai', String, 'first' ),
  String $fsdb            = lookup('archivesspace::fsdb', String, 'first' ),
  String $user            = lookup('archivesspace::user', String, 'first' ),
  String $group           = lookup('archivesspace::group', String, 'first' ),
  String $db_passwd       = lookup('archivesspace::db_passwd', String, 'first' ),
  String $db_name         = lookup('archivesspace::db_name', String, 'first' ),
  String $db_user         = lookup('archivesspace::db_user', String, 'first' ),
  String $db_url          = lookup('archivesspace::db_url', String, 'first' ),
  String $plugin          = lookup('archivesspace::plugin', String, 'first' ),
  String $plugin_conf     = lookup('archivesspace::plugin_conf', String, 'first' ),
  String $plugin_install_dir = lookup('archivesspace::plugin_install_dir', String, 'first' ),
  String $plugin_ensure   = lookup('archivesspace::plugin_ensure', String, 'first' ),
  String $plugin_prefix   = lookup('archivesspace::plugin_prefix', String, 'first' ),
  String $plugin_revision = lookup('archivesspace::plugin_revision', String, 'first' ),
  String $plugin_source   = lookup('archivesspace::plugin_source', String, 'first' ),
){

  # Create the aspace user
  user { $user :
    ensure  => present,
    comment => 'Archivesspace system user',
  }

  # Install the package
  package { 'archivesspace' :
    ensure => $version,
  }

  # Make sure aspace owns the package
  file { $install_dir :
    ensure  => directory,
    owner   => $user,
    group   => $user,
    require => [ Package['archivesspace'], User["${user}"] ],
    }

  # Load the mysql connector
  archivesspace::remote_file{"${install_dir}/lib/mysql-connector-java-5.1.39.jar":
    remote_location => 'http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.39/mysql-connector-java-5.1.39.jar',
    require => Package['archivesspace'],
  }

  $config_version=regsubst($version, '^([0-9].*)\-(.*)$', '\1')
  $config_version_major=regsubst($version, '^([0-9]*).([0-9]*).([0-9]*)\-(.*)$', '\1')

  alert("config_version_major: $config_version_major")

  # write the config file
  file { "${install_dir}/config/config.rb" :
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0644',
    content => template("archivesspace/config.rb.${config_version_major}.erb"),
    require => Package['archivesspace'],
    notify  => File["${install_dir}/archivesspace.sh"],
  }

  file { "${install_dir}/archivesspace.sh" :
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0755',
    content => template("archivesspace/archivesspace.sh.${config_version_major}.erb"),
    require => Package['archivesspace'],
    notify  => Exec['scripts/setup-database.sh'],
  }

  # run setup-database.sh
  exec { 'scripts/setup-database.sh' :
    cwd     => $install_dir,
    command => "${install_dir}/scripts/setup-database.sh",
    timeout => 2600,
    creates => "${install_dir}/.setup-database.complete",
    require  => [Archivesspace::Remote_file["${install_dir}/lib/mysql-connector-java-5.1.39.jar"], File["${install_dir}/config/config.rb"] ],
    notify  => File["${install_dir}/.setup-database.complete"],
  }
  file { "${install_dir}/.setup-database.complete" :
    ensure  => present,
    content => 'Database migration complete.',
    owner   => $user,
    group   => $user,
  }
}
