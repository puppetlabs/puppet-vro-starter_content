#
class role::linux_mysql_database {
  include profile::linux_baseline
  include profile::mysql
  include profile::sample_data
}
