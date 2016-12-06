#
class profile::sample_website::linux (
    $doc_root,
    $webserver_port,
) {
  require profile::apache
  include myfirewall

  # configure apache
  apache::vhost { $::fqdn:
    port    => $webserver_port,
    docroot => $doc_root,
    require => File[$doc_root],
  }

  myfirewall { 'Open port for web':
    ensure    => present,
    name      => 'public',
    zone      => 'public',
    port      => '80',
    protocol  => 'tcp',
    permanent => true,
  }

  # deploy website
  $website_source_dir  = lookup('website_source_dir')

  file { $website_source_dir:
    ensure  => directory,
    owner   => $::apache::user,
    group   => $::apache::group,
    mode    => '0755',
    path    => $doc_root,
    source  => $website_source_dir,
    recurse => true,
  }

  file { "${doc_root}/index.html":
    ensure  => file,
    content => epp('profile/index.html.epp'),
  }

}
