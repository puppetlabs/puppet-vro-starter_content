#
class profile::iis {

  $doc_root = 'C:\inetpub\wwwroot\sample_website'
  $iis_features = [
    'Web-Server',
    'Web-WebServer',
    'Web-Http-Redirect',
    'Web-Mgmt-Console',
    'Web-Mgmt-Tools'
  ]

  windowsfeature { $iis_features:
    ensure => present,
  }

  iis::manage_site {'Default Web Site':
    ensure => absent,
  }

  iis::manage_app_pool {'sample_website':
    require => [
      Windowsfeature[$iis_features],
      Iis::Manage_site['Default Web Site'],
    ],
  }

  iis::manage_site { $::fqdn:
    site_path  => $doc_root,
    port       => '80',
    ip_address => '*',
    app_pool   => 'sample_website',
    require    => [
      Windowsfeature[$iis_features],
      Iis::Manage_app_pool['sample_website']
    ],
  }
# Uncomment the following code to configure windows firewall
#  windows_firewall::exception { 'WINRM':
#    ensure       => present,
#    direction    => 'in',
#    action       => 'Allow',
#    enabled      => 'yes',
#    protocol     => 'TCP',
#    local_port   => '80',
#    display_name => 'HTTP Inbound',
#    description  => 'Inbound rule for HTTP Server - Port 80',
#  }

}
