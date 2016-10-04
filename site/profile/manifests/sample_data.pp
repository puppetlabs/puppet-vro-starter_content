# Installs sample database
class profile::sample_data (
    $database_content
) {

  file { '/tmp/sample_data.sql':
      ensure => file,
      source => $database_content,
    }

    mysql::db { 'mydb':
      user     => 'admin',
      password => 'admin',
      host     => 'localhost',
      grant    => ['ALL'],
      sql      => '/tmp/sample_data.sql',
    }
}
