# Installs XHGui (https://github.com/preinheimer/xhgui), a MongoDB GUI for XHProf
class xhgui (
  $version           = 'master',
  $sample_size       = '100',
  $query_trigger     = undef,
  $user              = undef,
  $vhost_name        = "xhgui.${fqdn}",
  $dir               = "/var/www/xhgui",
  $xhprof_package    = $xhgui::params::xhprof_package,
  $php_mongo_package = $xhgui::params::php_mongo_package,
  $www_user          = $xhgui::params::www_user,
  $mongo_host        = '127.0.0.1:27017',
  $mongo_db          = 'xhprof'
) inherits xhgui::params {

  if !defined(Package[$xhprof_package]) {
    package { $xhprof_package:
      ensure => present
    }
  }

  class { 'xhgui::download':
    dir     => $dir,
    version => $version,
    user    => $user,
    require => Package[$xhprof_package],
  }

  class { 'xhgui::mongo':
    php_mongo_package => $php_mongo_package,
  }

  # The way to set profiling config for XHGui > 0.3.0
  file { "${dir}/config/config.php":
    content => template('xhgui/config.php.erb'),
    require => Class['Xhgui::Download'],
  }

  if $vhost_name {
    class { 'xhgui::vhost':
      name     => $vhost_name,
      dir      => $dir,
      www_user => $www_user,
      require  => Class['Xhgui::Download'],
    }
  }
}
