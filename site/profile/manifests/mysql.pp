# This profile installs MySQL
#
# @summary MySQL database
class profile::mysql {

  class { 'mysql::server':
    remove_default_accounts => true
  }

}
