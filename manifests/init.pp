# == Class: archivesspace
#
# Full description of class archivesspace here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'archivesspace':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class archivesspace {

  file { '/usr/local/archivesspace/lib/mysql-connector-java-5.1.34.jar':
    ensure  => file,
    source  => 'puppet:///modules-local/archivesspaces/mysql-connector-java-5.1.34.jar',
    #require => File['/usr/local/archivesspace'],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/usr/local/archivesspace/config/config.rb':
    ensure   => file,
    source   => 'puppet:///modules/archivesspace/config.rb',
    #require => File['/usr/local/archivesspace'],
    owner    => 'root',
    group    => 'root',
    mode     => '0644',
    #require  => Class['puppi::netinstall']a
    # THIS has to run after puppi::netinstall
  }


  # Link to the startup script
  file { '/etc/init.d/archivesspace':
    ensure  => link,
    #require => File['/usr/local/archivesspace/launcher/archivespace.sh'],
    target  => '/usr/local/archivesspace/archivesspace.sh',
  }

  #file { '/tmp/.4.1-1.noarch.rpm':
  #  ensure  => file,
  #  #source => 'puppet:///modules-local/archivesspaces/mysql-connector-java-5.1.34.jar',
  #  source  => 'puppet:///modules-local/archivesspace/archivesspace-1.4.1-1.noarch.rpm',
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0644',
  #}

  #package { 'archivesspace-1.4.1-1.noarch':
  #  ensure          => present,
  #  provider        => 'rpm',
  #  install_options => ['Uvh'],
  #  source          => '/tmp/archivesspace-1.4.1-1.noarch.rpm',
  #  require         => File['/tmp/archivesspace-1.4.1-1.noarch.rpm'],
  #}

  #service { 'archivesspace':
  #  enable => true,
  #}


}
