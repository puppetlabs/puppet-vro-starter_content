# Example cross platform generic website class
class profile::app::generic_website {

  case $::kernel {
    'windows': { include profile::app::generic_website::windows }
    'linux':   { include profile::app::generic_website::linux   }
  }

}
