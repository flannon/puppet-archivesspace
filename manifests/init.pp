# == Class: archivesspace
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
class archivesspace (
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
  $plugin_ensure = $archivesspace::params::plugin_ensure,
  $ensure        = $archivesspace::params::ensure,
) inherits archivesspace::params {

  ensure_resource('package', 'git', {'ensure' => 'present'})

  include archivesspace::install
  include archivesspace::service
  Class['archivesspace::install']->Class['archivesspace::service']



}
