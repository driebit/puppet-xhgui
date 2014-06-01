# Installs XHGui
class xhgui::download(
  $dir,
  $version,
  $user       = undef,
  $repository = 'https://github.com/perftools/xhgui.git'
) {
  # Don't use composer create-project, as it doesn't support installing a
  # specific commit hash.
  vcsrepo { $dir:
    ensure   => present,
    provider => git,
    source   => $repository,
    revision => $version,
    user     => $user,
  }

  # Install vendors
  composer::exec { 'xhgui':
    cmd       => 'install',
    cwd       => $dir,
    user      => $user,
    scripts   => true,
    logoutput => on_failure, # So the more detailed Composer error message is shown
    require   => Vcsrepo[$dir],
  }
}
