#
class role::win_web_server {
  include dotnet
  include profile::windows::baseline
  include profile::windows::iis
  include cmsapp
}
