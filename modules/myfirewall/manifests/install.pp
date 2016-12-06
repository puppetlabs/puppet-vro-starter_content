class myfirewall::install inherits myfirewall {

  package { $::myfirewall::firewall_service:
    ensure => installed,
  }
}
