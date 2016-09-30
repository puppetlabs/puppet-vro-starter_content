#
class profile::apache {

  $doc_root = '/var/www/generic_website'

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

  firewall { '80 allow apache access':
    dport  => [80],
    proto  => tcp,
    action => accept,
  }

}
