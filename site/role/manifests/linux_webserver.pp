#
class role::linux_webserver {

  include profile::linux_baseline
  include profile::vro_provisioned
  include profile::apache
  include profile::sample_website

}
