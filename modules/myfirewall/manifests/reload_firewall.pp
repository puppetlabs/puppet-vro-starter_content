class myfirewall::reload_firewall inherits myfirewall {

  exec { 'Reloading firewall rules':
    path        => '/bin:/usr/bin',
    command     => 'firewall-cmd --reload',
    refreshonly => true,
  }
}
