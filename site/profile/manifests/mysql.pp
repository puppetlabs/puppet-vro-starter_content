#
class profile::mysql {

  class { 'mysql::server':
    remove_default_accounts => true
  }

}
