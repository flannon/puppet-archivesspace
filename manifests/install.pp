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
  String $db_host       = lookup('archivesspace::db_host', String, 'first'),
  String $db_name       = lookup('archivesspace::db_name', String, 'first'),
  String $db_passwd     = lookup('archivesspace::db_passwd', String, 'first'),
  String $db_user       = lookup('archivesspace::db_user', String, 'first'),
  String $java_heap_max = lookup('archivesspace::java_heap_max', String, 'first'),
  String $log_level     = lookup('archivesspace::log_level', String, 'first'),
  String $install_dir   = lookup('archivesspace::install_dir', String, 'first'),
  String $user          = lookup('archivesspace::user', String, 'first'),
  String $group         = lookup('archivesspace::group', String, 'first'),
  String $version       = lookup('archivesspace::version', String, 'first'),
  String $enable_backend  = lookup('archivesspace::enable_backend', String, 'first'),
  String $enable_frontend = lookup('archivesspace::enable_frontend', String, 'first'),
  String $enable_public   = lookup('archivesspace::enable_public', String, 'first'),
  String $enable_solr     = lookup('archivesspace::enable_solr', String, 'first'),
  String $enable_indexer  = lookup('archivesspace::enable_indexer', String, 'first'),
  String $enable_docs     = lookup('archivesspace::enable_docs', String, 'first'),
  String $enable_oai      = lookup('archivesspace::enable_oai', String, 'first'),

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
  file { "$install_dir" :
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

  alert("version: $version")
  # version outputL: 2.2.2-1.el7

  $config_version=regsubst($version, '^([0-9].*)\-(.*)$', '\1')

  alert("config_rb: $config_version")

  # write the config file
  file { "${install_dir}/config/config.rb" :
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0644',
    content => template("archivesspace/config.rb.${config_version}.erb"),
    require => Package['archivesspace'],
    notify  => File["${install_dir}/archivesspace.sh"],
  }

  file { "${install_dir}/archivesspace.sh" :
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0755',
    content => template("archivesspace/archivesspace.sh.${config_version}.erb"),
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
