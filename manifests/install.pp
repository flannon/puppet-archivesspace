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
  $db_host       = hiera('archivesspace::db_host',
      $archivesspace::params::db_host),
  $db_name       = hiera('archivesspace::db_name',
      $archivesspace::params::db_name),
  $db_passwd     = hiera('archivesspace::db_passwd',
        $archivesspace::params::db_passwd),
  $db_user       = hiera('archivesspace::db_user',
        $archivesspace::params::db_user),
  $java_heap_max = hiera('archivesspace::java_heap_max',
        $archivesspace::params::java_heap_max),
  $log_level     = hiera('archivesspace::log_level',
        $archivesspace::params::log_level),
  $install_dir   = $archivesspace::params::install_dir,
  $user          = hiera('archivesspace::user',
        $archivesspace::params::user),
  $version       = hiera('archivesspace::version',
        $archivesspace::params::version),
) inherits archivesspace::params {

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
