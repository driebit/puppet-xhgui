driebit/puppet-xhgui
====================

Introduction
-----------
A Puppet module that installs [XHGui](https://github.com/perftools/xhgui),
a MongoDB-backed GUI for [XHProf](https://github.com/facebook/xhprof).

Configuration
-------------

### Requirements

* [Vcsrepo Puppet module](https://github.com/puppetlabs/puppetlabs-vcsrepo)
* [Composer Puppet module](https://forge.puppetlabs.com/tPl0ch/composer)

### Puppet configuration

In your Puppet manifest:

```puppet
class { 'xhgui': }
```

You can set the following parameters:

* `version`: either a tagged version or a commit hash to install; defaults to
  `master`
* `sample_size`: see below (defaults to `100`)
* `query_trigger`: a URL query string that will enable profiling for the request
  (disabled by default)
* `dir`: directory where to install XHGui; defaults to `/var/www/xhgui/{version}`
* `vhost_name`: used to create an Apache vhost; if you want no vhost, set this
  to `undef`
* `mongo_host`: host your MongoDB server can be reached at; defaults to `127.0.0.1:27017`
* `mongo_db`: MongoDB database name; defaults to `xhprof`
* `xhprof_package`: custom XHProf package name
* `php_mongo_package`: custom PHP MongoDB module name
* `www_user`: custom webserver user

For instance:

```puppet
class { 'xhgui':
  vhost_name        => 'stats.my_app.dev',
  php_mongo_package => 'php53u-pecl-mongo'
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
    # ...
    query_trigger => 'profile'
    # ...
}
```

And then request the URI with your query string, e.g., http://dev.local/some/url?profile.
