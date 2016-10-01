#
class profile::apache {

  $doc_root = '/var/www/sample_website'

  class { 'apache':
    default_vhost => false,
  }

  file { $doc_root:
    ensure => directory,
    owner  => $::apache::user,
    group  => $::apache::group,
    mode   => '0755',
  }

  apache::vhost { $::fqdn:
    port    => '80',
    docroot => $doc_root,
    require => File[$doc_root],
  }

# Uncomment the following code to configure firewalld
#  firewalld_port { 'Open port 80 for web':
#    ensure   => present,
#    zone     => 'public',
#    port     => 80,
#    protocol => 'tcp',
#  }

}
