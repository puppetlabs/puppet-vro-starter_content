#
class profile::sample_website {

  case $::kernel {
    'windows': { include profile::sample_website::windows }
    'Linux':   { include profile::sample_website::linux   }
  }

}
