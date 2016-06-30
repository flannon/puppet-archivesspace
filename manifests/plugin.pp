#
define archivesspace::plugin (
  $conf_file          = $archivesspace::params::conf_file,
  $install_dir        = $archivesspace::params::install_dir,
  $plugin             = $archivesspace::params::plugine,
  $plugin_conf        = $archivesspace::params::plugin_conf,
  $ensure             = $archivesspace::params::ensure,
  $plugin_install_dir = $archivesspace::params::plugin_install_dir,
  $plugin_prefix      = $archivesspace::params::plugin_prefix,
  $plugin_revision    = hiera('archivesspace::plugin_revision',
          $archivesspace::params::plugin_revision),
  $plugin_source      = $archivesspace::params::plugin_source,
  $user               = $archivesspace::params::user,
  ){
    ensure_resource('package', 'git', {'ensure' => 'present'})
    include archivesspace::params

    #if  ($plugin != undef) or ($plugin_source != undef) or ($plugin_conf != undef) {
    if  ($plugin != undef) or ($plugin_source != undef) {
      vcsrepo { "${plugin_install_dir}/${plugin}":
        ensure   => $ensure,
        owner    => $user,
        group    => $user,
        provider => 'git',
        source   => $plugin_source,
        revision => $plugin_revision,
        require  => Package[ 'git' ],
      }
      file_line { $plugin :
        ensure            => $ensure,
        path              => $conf_file,
        line              => $plugin_conf,
        match             => $plugin_prefix,
        match_for_absence => true,
      }
    }
    else {
      warning ('$plugin, $plugin_source $plugin_conf must be defined.')
    }

}
