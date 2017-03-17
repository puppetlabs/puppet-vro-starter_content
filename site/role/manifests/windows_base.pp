# This role installs a baseline of packages on Windows machines
#
# @summary Baseline Windows server
class role::windows_base {
  include profile::windows_baseline
}
