define rgbank::load (
  $balancermembers,
  $port = 80,
) {

  haproxy::listen {"rgank-${name}":
    collect_exported => false,
    ipaddress        => '0.0.0.0',
    mode             => 'http',
    options          => {
      'option'       => ['forwardfor', 'http-server-close', 'httplog'],
      'balance'      => 'roundrobin',
    },
    ports            => '80',
  }

  $balancermembers.each |$member| {
    haproxy::balancermember { $member['host']:
      listening_service => "rgbank-${name}",
      server_names      => $member['host'],
      ipaddresses       => $member['ip'],
      ports             => $member['port'],
      options           => 'check verify none',
    }
  }

  firewall { "000 accept rgbank load connections on ${port}":
    dport  => $port,
    proto  => tcp,
    action => accept,
  }

}

Rgbank::Load produces Http {
  name => $name,
  ip   => $::ipaddress,
  host => $::fqdn,
  port => $port,
}
#Rgbank::Load consumes Http { }
