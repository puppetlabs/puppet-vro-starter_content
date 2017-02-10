# This role installs a baseline of packages on Linux machines
#
# @example Declaring the class
#   include role::linux_base
#
class role::linux_base {
  include profile::linux_baseline
}
