class profile::tomcat (
  $package = undef,
  $version = undef,
) {
  include profile::firewall

  class { '::tomcat':
    package => $package,
    version => $version,
  }

  include tomcat::app::docs
  include tomcat::app::admin

  firewall { '100 allow connections to tomcat':
    proto   => 'tcp',
    dport   => '8080',
    action  => 'accept',
  }

}
