class myfirewall::config inherits myfirewall {

#  myfirewall { 'icmp':
#    ensure      => absent,
#    zone        => 'public',
#    block_icmp  => [ 'echo-reply', 'echo-request'],
#    notify      =>  Exec['Reloading firewall rules'],
#  }

#  myfirewall { 'richrule':
#    ensure      => absent,
#    zone        => 'public',
#    richrule    => [ 'rule family="ipv4" source address="192.168.10.0/24" port port="3001" protocol="tcp" accept'],
#    notify      =>  Exec['Reloading firewall rules'],
#  }

#  myfirewall { 'Create a new zone':
#    ensure       => present,
#    zone         => 'carlee',
#    myzones      => true,
#    permanent    => true,
#    notify       =>  Exec['Reloading firewall rules'],
#  }

#  myfirewall { 'Create a new zone mustard':
#    ensure       => present,
#    zone         => 'mustard',
#    myzones      => true,
#    permanent    => true,
#    notify       =>  Exec['Reloading firewall rules'],
#  }

#  myfirewall { 'Create a rule for service':
#    ensure       => absent,
#    zone         => 'public',
#    service      => 'http',
#    permanent    => true,
#    notify       =>  Exec['Reloading firewall rules'],
#  }

#  myfirewall { 'Create a rule for port':
#    ensure       => absent,
#    zone         => 'public',
#    port         => '3544',
###    protocol     => 'tcp',
#    permanent    => true,
#    notify       =>  Exec['Reloading firewall rules'],
#  }

#  myfirewall { 'Create a rule for multiple port':
#    ensure       => absent,
#    zone         => 'public',
#    port         => $::myfirewall::myport,
#    tcp_udp      => true,
#    permanent    => true,
#    notify       =>  Exec['Reloading firewall rules'],
#  }
}
