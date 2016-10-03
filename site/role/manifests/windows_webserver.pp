#
class role::windows_webserver {
  require profile::windows_baseline
  include profile::iis
  include profile::sample_website
}
