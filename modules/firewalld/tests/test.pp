
include firewalld

firewalld_zone { 'restricted':
  ensure           => present,
  target           => '%%REJECT%%',
  icmp_blocks      => 'echo-request',
  purge_rich_rules => true,
}



