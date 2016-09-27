# Requires rtyler/jenkins module
class profile::jenkins::server {

  class { 'jenkins':
    configure_firewall => true,
    direct_download    => 'http://pkg.jenkins-ci.org/redhat-stable/jenkins-1.651.2-1.1.noarch.rpm',
  }

  jenkins::user { 'sailseng':
    email    => 'sailseng@example.com',
    password => 'puppetlabs',
  }

}
