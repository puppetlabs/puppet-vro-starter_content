# Installs iis and opens port in firewall
class profile::iis {

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

}
