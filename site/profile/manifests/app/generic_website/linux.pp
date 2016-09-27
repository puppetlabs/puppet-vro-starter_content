class profile::app::generic_website::linux {

  $doc_root = '/var/www/generic_website'

  if !defined(Package['unzip']) {
    package { 'unzip': ensure => present; }
  }

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

  staging::deploy { 'pl_generic_site.zip':
    source  => 'puppet:///modules/profile/pl_generic_site.zip',
    target  => $doc_root,
    require => Apache::Vhost[$::fqdn],
    creates => "${doc_root}/index.html",
  }

}
