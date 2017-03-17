# This role installs IIS and sample content on port 80.
#
# @summary IIS webserver on Windows with example website
class role::windows_webserver {
  include profile::windows_baseline
  include profile::vro_provisioned
  include profile::iis
  include profile::sample_website
}
