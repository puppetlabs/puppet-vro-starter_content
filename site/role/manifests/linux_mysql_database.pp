# This role installs a MySQL databse and sample data
#
# @summary MySQL database server on Linux with sample data
class role::linux_mysql_database {
  include profile::linux_baseline
  include profile::mysql
  include profile::sample_data
}
