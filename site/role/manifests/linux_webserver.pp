# This role installs an apache webserver and sample content on port 80.
#
# @summary Apache webserver on Linux with example website
class role::linux_webserver {
  include profile::linux_baseline
  include profile::vro_provisioned
  include profile::apache
  include profile::sample_website
}
