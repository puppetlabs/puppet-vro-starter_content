#
class profile::sample_website {

  case $::kernel {
    'windows': { include profile::sample_website::windows }
    'linux':   { include profile::sample_website::linux   }
  }

}
