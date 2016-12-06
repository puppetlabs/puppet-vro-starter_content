class myfirewall::service inherits myfirewall {

  service { $::myfirewall::firewall_service:
    ensure => $::myfirewall::firewall_status,
  }
}
