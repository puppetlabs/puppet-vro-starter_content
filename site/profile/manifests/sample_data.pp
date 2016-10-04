# Installs sample database
class profile::sample_data (
    $database_content,
    $database_name,
) {

  file { '/tmp/sample_data.sql':
      ensure => file,
      source => $database_content,
    }

    mysql::db { $database_name:
      user     => 'admin',
      password => 'admin',
      host     => 'localhost',
      grant    => ['ALL'],
      sql      => '/tmp/sample_data.sql',
    }
}
