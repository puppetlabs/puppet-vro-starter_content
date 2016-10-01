#
class profile::sample_data {

  file { '/tmp/sample_data.sql':
      ensure => file,
      source => 'puppet:///modules/profile/sample_data.sql',
    }

    mysql::db { 'mydb':
      user     => 'admin',
      password => 'admin',
      host     => 'localhost',
      grant    => ['ALL'],
      sql      => '/tmp/sample_data.sql',
    }
}
