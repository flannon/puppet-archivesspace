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
  String $ensure        = lookup('archivesspace:::ensure', String, 'first' ),
  String $version       = lookup('archivesspace::version', String, 'first' ),
  String $install_dir   = lookup('archivesspace::install_dir', String, 'first' ),
  String $conf_dir   = lookup('archivesspace::conf_dir', String, 'first' ),
  String $conf_file   = lookup('archivesspace::conf_file', String, 'first' ),
  String $java_heap_max = lookup('archivesspace::java_heap_max', String, 'first' ),
  String $log_level     = lookup('archivesspace::log_level', String, 'first' ),
  String $enable_backend = lookup('archivesspace::enable_backend', String, 'first' ),
  String $enable_frontend = lookup('archivesspace::enable_frontend', String, 'first' ),
  String $enable_public = lookup('archivesspace::enable_public', String, 'first' ),
  String $enable_solr = lookup('archivesspace::enable_solr', String, 'first' ),
  String $enable_indexer = lookup('archivesspace::enable_indexer', String, 'first' ),
  String $enable_docs = lookup('archivesspace::enable_docs', String, 'first' ),
  String $enable_oai = lookup('archivesspace::enable_oai', String, 'first' ),
  String $fsdb          = lookup('archivesspace::fsdb', String, 'first' ),
  String $user          = lookup('archivesspace::user', String, 'first' ),
  String $group         = lookup('archivesspace::group', String, 'first' ),
  String $db_passwd     = lookup('archivesspace::db_passwd', String, 'first' ),
  String $db_name       = lookup('archivesspace::db_name', String, 'first' ),
  String $db_user       = lookup('archivesspace::db_user', String, 'first' ),
  String $db_host       = lookup('archivesspace::db_host', String, 'first' ),
  String $plugin = lookup('archivesspace::plugin', String, 'first' ),
  String $plugin_conf = lookup('archivesspace::plugin_conf', String, 'first' ),
  String $plugin_install_dir = lookup('archivesspace::plugin_install_dir', String, 'first' ),
  String $plugin_ensure = lookup('archivesspace::plugin_ensure', String, 'first' ),
  String $plugin_prefix = lookup('archivesspace::plugin_prefix', String, 'first' ),
  String $plugin_revision = lookup('archivesspace::plugin_revision', String, 'first' ),
  String $plugin_source = lookup('archivesspace::plugin_source', String, 'first' ),
){

  ensure_resource('package', 'git', {'ensure' => 'present'})

  class { archivesspace::install:
    version => $version,
  }
  class { archivesspace::service: 
    install_dir =>  $install_dir,
  }

}
