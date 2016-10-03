#
class profile::sample_website {

  case $::kernel {
    'windows': {
      require profile::iis
      staging::deploy { 'sample_website.zip':
        source  => 'puppet:///modules/profile/sample_website.zip',
        target  => 'C:\inetpub\wwwroot\sample_website',
        creates => 'C:\inetpub\wwwroot\sample_website\index.html',
      }
    }
    'linux':   {
      require profile::apache
      staging::deploy { 'sample_website.zip':
        source  => 'puppet:///modules/profile/sample_website.zip',
        target  => '/var/www/sample_website',
        creates => '/var/www/sample_website/index.html',
      }
    }
    default: { }
  }

}
