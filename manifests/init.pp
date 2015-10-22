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


 #file { '/etc/puppet/hieradata/common.temp':
  #  ensure  => file,
  #  source  => 'puppet:///modules/housekeeping/common.yaml',
  #  require => File['/etc/puppet/hieradata'],
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0600',
  #}

  #file { '/usr/local/archivesspace/common/lib/mysql-connector-java-5.1.34.jar':
  file { '/tmp/mysql-connector-java-5.1.34.jar':
    ensure  => file,
    source  => 'puppet:///modules-local/archivesspaces/mysql-connector-java-5.1.34.jar',
    #require => File['/usr/local/archivesspace'],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  #file { '/usr/local/archivesspace/common/config/configconfig-defaults.rb':
  #  ensure  => file,
  #  source  => 'puppet:///modules-local/archivesspaces/config-defaults.rb',
  #  #require => File['/usr/local/archivesspace'],
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0644',
  #}

  #file { '/usr/local/archivesspace/launcher/archivesspace.sh':
  #file { '/etc/init.d/archivesspace':
  #  ensure  => link,
  #  #require => File['/usr/local/archivesspace/launcher/archivespace.sh'],
  #  #target  => '/etc/init.d/archivesspace',
  #  target  => '/usr/local/archivesspace/launcher/archivesspace.sh',
  #}

  #service { 'archivesspace':
  #  enable => true,
  #}


}
