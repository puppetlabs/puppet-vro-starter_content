#
class role::linux_webserver {
  include profile::linux_baseline
  include profile::apache
  include profile::sample_website
}
