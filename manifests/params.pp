# == Class: archivesspace::params
#
# Full description of class archivesspace here.
#
# To install the barcoder plugin
#
#   archivesspace::plugin { 'barcoder' : 
#     plugin        => 'barcoder',
#     plugin_source => 'https://github.com/archivesspace/barcoder.git'
#   }
#
#
# === Authors
#
# Author Name flannon@nyu.edu
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class archivesspace::params {

  $ensure             = 'present'
  $install_dir        = '/opt/archivesspace'
  $conf_dir           = "${install_dir}/config"
  $conf_file          = "${conf_dir}/config.rb"
  $db_host            = 'localhost'
  $db_name            = 'asdb'
  $db_passwd          = 'aspace'
  $db_user            = 'asdb'
  $java_heap_max      = '-Xmx1024m'
  $log_level          = '"debug"'
  $user               = 'aspace'
  $version            = 'installed'
  $plugin             = undef
  $plugin_conf        = undef
  $plugin_install_dir = "${install_dir}/plugins"
  $plugin_prefix      = '^AppConfig[:plugins] ='
  $plugin_revision    = 'master'
  $plugin_source      = undef

}
