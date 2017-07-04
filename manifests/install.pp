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
  String $version       = lookup('archivesspace::version', String, 'first'),
){

  # Create the aspace user
  user { $user :
    ensure  => present,
    comment => 'Archivesspace system user',
    home    => $install_dir,
    shell   => '/bin/bash',
    uid     => '2046',
  }

  # Install the package
  #package { 'archivesspace' :
  #  ensure => $version,
  #}
  ##vcsrepo

  # Make sure aspace owns the package
  file { "$install_dir" :
    ensure  => directory,
    owner   => $user,
    group   => $user,
    recurse => true,
    require => [ Package['archivesspace'], User["${user}"] ],
    }

  # Load the mysql connector
  remote_file{"${install_dir}/lib/mysql-connector-java-5.1.34.jar":
    remote_location => 'http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.34/mysql-connector-java-5.1.34.jar',
    require         => Package['archivesspace'],
  }

  # write the config file
  file { '/opt/archivesspace/config/config.rb' :
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0644',
    content => template('archivesspace/config.rb.erb'),
    require => Package['archivesspace'],
    notify  => File ['/opt/archivesspace/archivesspace.sh'],
  }

  # Install the init script
  file { '/opt/archivesspace/archivesspace.sh' :
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0755',
    content => template('archivesspace/archivesspace.sh.erb'),
    require => Package['archivesspace'],
    notify  => Exec ['scripts/setup-database.sh'],
  }

  # run setup-database.sh
  exec { 'scripts/setup-database.sh' :
    cwd     => $install_dir,
    command => "${install_dir}/scripts/setup-database.sh",
    timeout => 2600,
    creates => "${install_dir}/.setup-database.complete",
    require  => [Remote_file["${install_dir}/lib/mysql-connector-java-5.1.34.jar"], File['/opt/archivesspace/config/config.rb'] ],
    notify  => File["${install_dir}/.setup-database.complete"],
  }
  file { "${install_dir}/.setup-database.complete" :
    ensure  => present,
    content => 'Database migration complete.',
    owner   => $user,
    group   => $user,
  }

  # install the service script
  file { '/etc/init.d/archivesspace' :
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('archivesspace/archivesspace.erb'),
    require => Package['archivesspace'],
  }

}
