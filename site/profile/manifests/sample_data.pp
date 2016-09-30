#
class profile::sample_data {

  mysql::db { 'mydb':
    user     => 'admin',
    password => 'admin',
    host     => 'localhost',
    grant    => ['ALL'],
    sql      => 'puppet:///modules/profile/sample_data.sql',
  }

}
