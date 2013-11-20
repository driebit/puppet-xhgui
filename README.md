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

In your Puppet manifests:

```puppet
class { 'xhgui':
  phpMongoPackage => 'your-custom-pecl-mongo'
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

By default, you can access XHGui at http://xhgui.your_domain_name.extension.
