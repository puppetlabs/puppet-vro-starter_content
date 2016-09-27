# Example cross platform generic website class
class profile::example::generic_website {
  include profile::app::generic_website

  notify { 'profile::example::generic_website deprecation':
    message => 'Class[profile::example::generic_website] is deprecated. Use Class[profile::app::generic_website] instead.',
  }

}
