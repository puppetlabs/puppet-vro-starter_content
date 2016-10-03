#
class profile::apache {

  $doc_root = $profile::sample_website::doc_root

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
    port    => "${webserver_port}",
    docroot => $doc_root,
    require => File[$doc_root],
  }

  firewalld_port { 'Open port for web':
    ensure   => present,
    zone     => 'public',
    port     => $webserver_port,
    protocol => 'tcp',
  }

}
