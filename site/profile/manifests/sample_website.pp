#
class profile::sample_website {

  $source_dir = 'puppet:///modules/profile/sample_website'

  case $::kernel {
    'windows': {
      $destination_dir = 'C:\inetpub\wwwroot\sample_website'

      file { $destination_dir:
        ensure  => directory,
      }

      file { 'sample website content':
        path    => $destination_dir,
        source  => $source_dir,
        recurse => true,
      }

    }
    'linux':   {
      $destination_dir = '/var/www/sample_website'

      file { $destination_dir:
        ensure  => directory,
      }

      file { 'sample website content':
        path    => $destination_dir,
        source  => $source_dir,
        recurse => true,
      }

    }
    'Darwin':   {
      $destination_dir = '/User/abir/Desktop/sample_website'

      file { $destination_dir:
        ensure  => directory,
      }

      file { 'sample website content':
        path    => $destination_dir,
        source  => $source_dir,
        recurse => true,
      }

    }
    default: { }
  }

}
