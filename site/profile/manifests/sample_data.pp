#
class profile::sample_data {

  file { '/tmp/sample_data.sql':
      ensure => file,
      source => $profile::sample_data::database_source,
    }

    mysql::db { 'mydb':
      user     => 'admin',
      password => 'admin',
      host     => 'localhost',
      grant    => ['ALL'],
      sql      => '/tmp/sample_data.sql',
    }
}
