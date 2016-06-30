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
  $db_host    = hiera('archivesspace::db_host',
      $archivesspace::params::db_host),
  $db_name    = hiera('archivesspace::db_name',
      $archivesspace::params::db_name),
  $db_passwd   = hiera('archivesspace::db_passwd',
        $archivesspace::params::db_passwd),
  $db_user     = hiera('archivesspace::db_user',
        $archivesspace::params::db_user),
  $install_dir = $archivesspace::params::install_dir,
  $user        = hiera('archivesspace::user',
        $archivesspace::params::user),
  $version = hiera('archivesspace::version',
        $archivesspace::params::version),
) inherits archivesspace::params {

  package { 'archivesspace' :
    ensure => $version,
  }

  # load the mysql connector
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
    #source  => 'puppet:///modules/archivesspace/config.rb',
    content => template('archivesspace/config.rb.erb'),
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

  # service
  file { '/etc/init.d/archivesspace' :
    ensure  => link,
    #owner  => 'root',
    #group  => 'root',
    #source => 'puppet:///modules/archivesspace/archivesspace',
    target  => '/opt/archivesspace/archivesspace.sh',
    require => Package['archivesspace'],
  }

  service { 'archivesspace' :
    ensure     => 'running',
    enable     => true,
    hasstatus  => false,
    hasrestart => false,
    provider   => 'redhat',
    require    => [File['/etc/init.d/archivesspace'],
        File["${install_dir}/.setup-database.complete"]],
  }
}
