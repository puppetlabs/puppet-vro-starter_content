#
class profile::sample_website::linux (
    $doc_root,
    $webserver_port,
) {

  file { $doc_root:
    ensure => directory,
    owner  => $::apache::user,
    group  => $::apache::group,
    mode   => '0755',
  }

  apache::vhost { $::fqdn:
    port    => $webserver_port,
    docroot => $doc_root,
    require => File[$doc_root],
  }

  firewalld_port { 'Open port for web':
    ensure   => present,
    zone     => 'public',
    port     => $webserver_port,
    protocol => 'tcp',
  }

  $website_source_dir  = lookup('website_source_dir')

  file { $destination_dir:
    ensure  => directory,
    path    => $doc_root,
    source  => $website_source_dir,
    recurse => true,
  }

}
