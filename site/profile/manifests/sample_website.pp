# This profile installs sample web content for the webserver
#
# @summary Install sample website content
class profile::sample_website {

  case $::kernel {
    'windows': { include profile::sample_website::windows }
    'Linux':   { include profile::sample_website::linux   }
  }

}
