#
class profile::sample_website {

  case $::kernel {
    'windows': {
      staging::deploy { 'pl_generic_site.zip':
        source  => 'puppet:///modules/profile/pl_generic_site.zip',
        target  => 'C:\inetpub\wwwroot\generic_website',
        require => Iis::Manage_site[$::fqdn],
        creates => 'C:\inetpub\wwwroot\generic_website\index.html',
      }
    }
    'linux':   {
      staging::deploy { 'pl_generic_site.zip':
        source  => 'puppet:///modules/profile/pl_generic_site.zip',
        target  => '/var/www/generic_website',
        require => Apache::Vhost[$::fqdn],
        creates => '/var/www/generic_website/index.html',
      }
    }
    default: { }
  }

}
