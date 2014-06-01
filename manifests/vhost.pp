# Configures an Apache vhost for XHGui
class xhgui::vhost(
  $name,
  $dir,
  $www_user
) {
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin' ] }

  apache::vhost { $name:
    docroot => "${dir}/webroot",
  }

  exec { 'xhgui permissions':
    command => "setfacl -R -m u:${www_user}:rwX -m u:`whoami`:rwX ${dir}/cache \
        && setfacl -R -m u:${www_user}:rwX -m u:`whoami`:rwX ${dir}/cache"
  }
}
