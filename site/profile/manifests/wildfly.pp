class profile::wildfly (
  $version = '8.0.0',
  $source = 'http://download.jboss.org/wildfly/8.0.0.Final/wildfly-8.0.0.Final.tar.gz'
) {
  include profile::firewall
  class { 'java':
    version => latest,
  }

  class { '::wildfly':
    install_source => $source,
    version        => $version,
    require        => Class['java'],
    java_home      => '/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.95-2.6.4.0.el7_2.x86_64/',
  }

  firewall { '100 allow connections to wildfly':
    proto   => 'tcp',
    dport   => '8080',
    action  => 'accept',
  }

}
