#
class profile::sample_website (
    $doc_root   = '/var/www/sample_website',
    $source_dir = 'puppet:///modules/profile/sample_website'
) {

  case $::kernel {
    'windows': {
      iis::manage_app_pool {'sample_website':
        require => [
          Windowsfeature[$iis_features],
          Iis::Manage_site['Default Web Site'],
          ],
        }

      iis::manage_site { $::fqdn:
        site_path  => $doc_root,
        port       => "${webserver_port}",
        ip_address => '*',
        app_pool   => 'sample_website',
        require    => [
          Windowsfeature[$iis_features],
          Iis::Manage_app_pool['sample_website']
          ],
        }
    }
    'linux':   {
      $doc_root  = lookup('profile::apache:doc_root')

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

    }
    default: {
      $doc_root  = lookup('profile::apache:doc_root')
    }
  }

  notify {"webroot: ${doc_root}/${sitename}":}

  file { $destination_dir:
    ensure  => directory,
    path    => "${doc_root}/${sitename}",
    source  => $source_dir,
    recurse => true,
  }

}
