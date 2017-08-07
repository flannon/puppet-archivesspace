# == Class: archivesspace::database
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
class archivesspace::database (
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

  #class { "mysql::server" :
  #  remove_default_accounts => true,
  #}
  mysql::db { $db_name :
    user     => $db_user,
    password => $db_passwd,
    dbname   => $db_name,
    host     => 'localhost',
    grant    => [ 'ALL' ],
    #require  => Class['mysql::server'],
    #notify   => Class['archivesspace'],
  }

}
