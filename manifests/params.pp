# Parameters derived from facts
class xhgui::params
{
  $xhprof_package = $::osfamily ? {
    'debian' => 'php5-xhprof',
    'redhat' => 'php-pecl-xhprof',
  }

  $php_mongo_package = $::osfamily ? {
    'debian' => 'php5-mongo',
    'redhat' => 'php-pecl-mongo',
  }

  $www_user = $::osfamily ? {
    'debian' => 'www-data',
    'redhat' => 'apache',
  }
}
