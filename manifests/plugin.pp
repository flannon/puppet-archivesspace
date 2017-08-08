#
define archivesspace::plugin (
  String $install_dir        = lookup('archivesspace::install_dir', String, 'first'),
  String $conf_dir           = lookup('archivesspace::conf_dir', String, 'first' ),
  String $conf_file          = lookup('archivesspace::conf_file', String, 'first' ),
  String $plugin             = lookup('archivesspace::plugin', String, 'first'),
  String $plugin_conf        = lookup('archivesspace::plugin_conf', String, 'first'),
  String $ensure             = lookup('archivesspace::plugin_ensure', String, 'first'),
  String $plugin_install_dir = lookup('archivesspace::plugin_install_dir', String, 'first'),
  String $plugin_prefix      = lookup('archivesspace::plugin_prefix', String, 'first'),
  String $plugin_revision    = lookup('archivesspace::plugin_revision', String, 'first'),
  String $plugin_source      = lookup('archivesspace::plugin_source', String, 'first'),
  String $user               = lookup('archivesspace::user', String, 'first'),
  String $group              = lookup('archivesspace::group', String, 'first'),
  ){
    ensure_resource('package', 'git', {'ensure' => 'present'})

    # This is a stupid kludge.  The enclosing quotes in the call to 
    # vcsrepo on line 26 should interpret / as a literal values, but it
    # chokes on it.  The only I could get it to work was either adding
    # a trainling / to the file path defined as a varialbe value in
    # common.yaml, which breaks the file path convention for everything
    # else, or by defiing $slash below.
    $slash = '/'

    if ($plugin_source != undef) {
      vcsrepo { "${plugin_install_dir}${slash}${title}" :
        ensure   => $ensure,
        owner    => $user,
        group    => $user,
        provider => 'git',
        source   => $plugin_source,
        revision => $plugin_revision,
        require  => Package[ 'git' ],
      }
      file_line { $title :
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
