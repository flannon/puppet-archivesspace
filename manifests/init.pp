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
  String $db_host       = lookup('archivesspace::db_host', String, 'first' ),
  String $db_name       = lookup('archivesspace::db_name', String, 'first' ),
  String $db_passwd     = lookup('archivesspace::db_passwd', String, 'first' ),
  String $db_user       = lookup('archivesspace::db_user', String, 'first' ),
  String $java_heap_max = lookup('archivesspace::java_heap_max', String, 'first' ),
  String $log_level     = lookup('archivesspace::log_level', String, 'first' ),
  String $install_dir   = lookup('archivesspace::install_dir', String, 'first' ),
  String $conf_dir   = lookup('archivesspace::conf_dir', String, 'first' ),

  String $user          = lookup('archivesspace::user', String, 'first' ),
  String $group         = lookup('archivesspace::group', String, 'first' ),
  String $version       = lookup('archivesspace::version', String, 'first' ),
  String $plugin_ensure = lookup('archivesspace::plugin_ensure', String, 'first' ),
  String $ensure        = lookup('archivesspace::params::ensure', String, 'first' ),
){

  ensure_resource('package', 'git', {'ensure' => 'present'})

  include archivesspace::install
  include archivesspace::service
  Class['archivesspace::install']->
  Class['archivesspace::service']

}
