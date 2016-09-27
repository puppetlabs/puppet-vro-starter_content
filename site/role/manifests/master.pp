# The `puppetmaster` role sets up a master system, synchronizes files from
# Amazon, and generally enables SE Team specific patterns dependent on master
# capabilities.
#
class role::master {
  include profile::puppet::rootenv
  include profile::master::puppetserver
  include profile::master::yum_repository
  include profile::master::fileserver
  include profile::master::files::splunk
  include profile::master::files::tomcat
  include profile::master::files::dotnetcms
  include profile::master::files::jdk
  include profile::master::files::basic_iis
  include profile::master::files::pe_demo_repos
}
