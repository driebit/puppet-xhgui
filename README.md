driebit/puppet-xhgui
====================

Introduction
-----------
A Puppet module that installs [XHGui](https://github.com/preinheimer/xhgui),
a MongoDB-backed GUI for [XHProf](https://github.com/facebook/xhprof).

Configuration
-------------

### Requirements

* [Vcsrepo Puppet module](https://github.com/puppetlabs/puppetlabs-vcsrepo)
* [Apache Puppet module](https://github.com/example42/puppet-apache)
* Composer, for instance from the [PHP Puppet module](http://forge.puppetlabs.com/nodes/php).

### Puppet configuration

In your Puppet manifest:

```puppet
class { 'xhgui': }
```

You can set the following parameters:

* `phpMongoPackage`: custom php-mongo package name
* `vhostName`: custom virtual host name (defaults to `xhgui.domain.extension`)
* `vhostDir`: custom virtual host dir (defaults to `/var/www/xhgui`)
* `version`: which version of XHGui to install (defaults to `v0.3.0`)
* `apacheUser`: name of your Apache user (defaults to `apache`)
* `xhprofPackage`: custom name of XHProf package (defaults to `php-pecl-xhprof`)
* `sampleSize`: see below (defaults to `100`)
* `queryTrigger`: a URL query that will trigger profiling for the request (disabled by default)

For instance:

```puppet
class { 'xhgui':
    vhostName       => 'stats.my_app.dev',
    phpMongoPackage => 'php53u-pecl-mongo'
}
```

In your application's Virtual host configuration (for instance the `.htaccess` file):

```apache
php_value auto_prepend_file "/var/www/xhgui/external/header-custom.php"
SetEnv XHGUI_SAMPLE_SIZE 100
```

The `XHGUI_SAMPLE_SIZE` environment variable determines how often requests will
be profiled: a sample size of 100 means one in every 100 requests will be
profiled. To profile all requests, set `XHGUI_SAMPLE_SIZE` to 1.

Usage
-----

### Web interface

By default, you can access XHGui at http://xhgui.domain.extension.

### Trigger profiling by query string

Enable the query string trigger in your Puppet manifest:

```puppet
class { 'xhgui':
    ...
    queryTrigger => 'profile'
    ...
}
```

And then request the URI with your query string, e.g., http://dev.local/some/url?*profile*.