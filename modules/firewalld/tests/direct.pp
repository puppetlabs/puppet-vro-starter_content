class { 'firewalld':
  purge_direct_rules => true,
}

#firewalld_direct_rule { 'LOG_DROPS':
#  ensure => present,
#  inet_protocol => 'ipv4',
#  chain => 'LOG_DROPS', 
#  priority => '0',
#  table => 'filter',
#  args => "-j LOG --log-prefix '# IPTABLES DROPPED: '"
#}
#
