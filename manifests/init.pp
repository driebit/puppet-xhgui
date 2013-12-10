#
# Installs XHGui (https://github.com/preinheimer/xhgui), a MongoDB GUI for XHProf
#
# Requires:
# - puppetlabs/puppet-vcsrepo (https://github.com/puppetlabs/puppetlabs-vcsrepo)
# - example42/puppet-apache
class xhgui (
  $vhostName       = "xhgui.${fqdn}",
  $vhostDir        = '/var/www/xhgui',
  $version         = 'v0.3.0',
  $apacheUser      = 'apache',
  $xhprofPackage   = 'php-pecl-xhprof',
  $phpMongoPackage = 'php-pecl-mongo',
  $mongoServer     = '127.0.0.1:27017',
  $mongoDb         = 'xhprof',
  $sampleSize      = '100',
  $queryTrigger    = undef
) {
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin' ] }

  if !defined(Package['mongodb']) {
    package { 'mongodb':
      ensure => present
    }
  }

  if !defined(Package[$phpMongoPackage]) {
    package { $phpMongoPackage:
      ensure => present
    }
  }

  if !defined(Package[$xhprofPackage]) {
    package { $xhprofPackage:
      ensure => present
    }
  }

  file { $vhostDir:
    ensure => 'directory',
    owner  => 'vagrant'
  }

  vcsrepo { $vhostDir:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/preinheimer/xhgui.git',
    revision => $version,
    user     => 'vagrant',
    require  => File[$vhostDir]
  }

  apache::vhost { $vhostName:
    port          => '80',
    docroot       => "${vhostDir}/webroot",
    require       => Vcsrepo[$vhostDir],
    directory     => $vhostDir,
    directory_allow_override => 'All',
  }

  exec { 'xhgui permissions':
    command => "setfacl -R -m u:${apacheUser}:rwX -m u:`whoami`:rwX ${vhostDir}/cache \
      && setfacl -R -m u:${apacheUser}:rwX -m u:`whoami`:rwX ${vhostDir}/cache",
    require => Vcsrepo[$vhostDir]
  }

  exec { 'xhgui composer install':
    command     => "composer install --working-dir ${vhostDir}",
    environment => "COMPOSER_HOME=/home/vagrant/.",
    timeout     => 0,
    require     => [ Vcsrepo[$vhostDir], Package[$phpMongoPackage], Package[$xhprofPackage] ]
  }

  # For backwards compatibility with XHGui <= 0.3.0
  file { "${vhostDir}/external/header-custom.php":
    content => template('xhgui/header.php.erb'),
    require => Vcsrepo[$vhostDir],
  }

  # The way to set profiling config for XHGui > 0.3.0
  file { "${vhostDir}/config/config.php":
    content => template('xhgui/config.php.erb'),
    require => Vcsrepo[$vhostDir],
  }

  # Add mongo indexes
  exec { 'mongo indexes':
    command => 'mongo xhprof --eval "db.results.ensureIndex( { \'meta.SERVER.REQUEST_TIME\' : -1 } );
      db.results.ensureIndex( { \'profile.main().wt\' : -1 } );
      db.results.ensureIndex( { \'profile.main().mu\' : -1 } );
      db.results.ensureIndex( { \'profile.main().cpu\' : -1 } );
      db.results.ensureIndex( { \'meta.url\' : 1 } )"',
    require => [ Service['mongod'], Package['mongodb'] ],
  }
}