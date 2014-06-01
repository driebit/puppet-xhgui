# Installs MongoDB and creates indexes for XHGui
class xhgui::mongo(
  $php_mongo_package
) {
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin' ] }

  if !defined(Package['mongodb']) {
    package { 'mongodb':
     ensure => present
   }
  }

  if !defined(Package[$php_mongo_package]) {
    package { $php_mongo_package:
      ensure => present
    }
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
