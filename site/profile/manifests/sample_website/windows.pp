#
class profile::sample_website::windows (
    $doc_root,
    $webserver_port
) {
  iis::manage_app_pool {'sample_website':
    require => [
      Windowsfeature[$iis_features],
      Iis::Manage_site['Default Web Site'],
    ],
  }

  iis::manage_site { $::fqdn:
    site_path  => $doc_root,
    port       => $webserver_port,
    ip_address => '*',
    app_pool   => 'sample_website',
    require    => [
      Windowsfeature[$iis_features],
      Iis::Manage_app_pool['sample_website']
    ],
  }

  windows_firewall::exception { 'WINRM':
    ensure       => present,
    direction    => 'in',
    action       => 'Allow',
    enabled      => 'yes',
    protocol     => 'TCP',
    local_port   => '$webserver_port',
    display_name => 'HTTP Inbound',
    description  => 'Inbound rule for HTTP Server',
  }

  $website_source_dir  = lookup('website_content')

  file { $destination_dir:
    ensure  => directory,
    path    => $doc_root,
    source  => $website_source_dir,
    recurse => true,
  }

}
