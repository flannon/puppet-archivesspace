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
class archivesspace::service (
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
){

  alert("in service class")
  # install the service script
  if ($facts['os']['family'] == 'RedHat') and ($facts['os']['release']['m    ajor'] == '6') {

  file { "/etc/init.d/archivesspace" :
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0755',
    content => template("archivesspace/archivesspace.erb"),
    require => Package['archivesspace'],
    notify  => File["${install_dir}/archivesspace.sh"],
    }
    service { 'archivesspace' :
      enable     => true,
      ensure     => true,
      hasstatus  => true,
      provider   => 'init',
      require => [ Package['archivesspace'], File['/etc/systemd/system/archivesspace.service'], File["${install_dir}/.setup-database.complete"]],
    }
  }
  elsif ($facts['os']['family'] == 'RedHat') and ($facts['os']['release']['m    ajor'] == '7') {
    alert("Loading archivesspace unit file on $facts['os']['release']['major'")
    file { '/etc/systemd/system/archivesspace.service' :
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('archivesspace/archivesspace.service.erb'),
      require => Package['archivesspace'],
    }
    alert('Making the unit file link')
    file {'/etc/systemd/system/multi-user.target.wants/archivesspace.service':
      ensure => link,
      owner  => 'root',
      group  => 'root',
      target => '/etc/systemd/system/archivesspace.service',
    }
    alert("Starting service on $facts['os']['release']['major'")
    service { 'archivesspace.service' :
      enable     => true,
      ensure     => running,
      hasstatus  => true,
      provider   => 'systemd',
      require => [ Package['archivesspace'], File['/etc/systemd/system/archivesspace.service'], File["${install_dir}/.setup-database.complete"]],
    }
  }

}
