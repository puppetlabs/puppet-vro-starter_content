# Fact: git_version
#
# Purpose: get git's current version
#
# Resolution:
#   Uses git's --version flag and parses the result from 'version'
#
# Caveats:
#   none
#
# Notes:
#   None
Facter.add('git_version') do
  confine :kernel=>"windows"
  has_weight 100
  setcode do
    nil
  end
end
