# Class to configure an NFS server
#
# This example demonstrates a profile that configures an NFS server and ensures
# that appropriate firewall rules are created for it. Configurable port numbers
# are exposed as class parameters.
#
# In conjunction with the profile::firewall class, this can be used for
# purge-management of an iptables-based firewall on a target system.
#
class profile::example::nfsserver (
  $lockd_tcpport       = '32803',
  $lockd_udpport       = '32769',
  $mountd_port         = '892',
  $rquotad_port        = '875',
  $statd_port          = '662',
  $statd_outgoing_port = '2020',
) {

  ## Assume the details of setting up an NFS server (packages, services) are
  ## defined elsewhere.
  #include nfs::server

  ## This is a sample export
  #nfs::export { '/var/nfs':
  #  clients => '*',
  #  options => 'rw,sync',
  #}

  # Resource defaults
  Firewall {
    action => 'accept',
  }
  File_line {
    path   => '/etc/sysconfig/nfs',
    notify => Service['nfs'],
  }

  # Standard RPC 4.0 portmapper rules
  firewall { '100 allow RPC 4.0 portmapper TCP connections':
    proto   => 'tcp',
    dport   => '111',
  }
  firewall { '100 allow RPC 4.0 portmapper UDP connections':
    proto   => 'udp',
    dport   => '111',
  }

  # Standard NFSD rules
  firewall { '100 allow nfsd TCP connections':
    proto   => 'tcp',
    dport   => '2049',
  }
  firewall { '100 allow nfsd UDP connections':
    proto   => 'udp',
    dport   => '2049',
  }

  # Set portmapper fixed ports
  file_line { 'lockd_tcpport':
    line  => "LOCKD_TCPPORT=${lockd_tcpport}",
    match => 'LOCKD_TCPPORT=.*'
  }
  file_line { 'lockd_udpport':
    line  => "LOCKD_UDPPORT=${lockd_udpport}",
    match => 'LOCKD_UDPPORT=.*'
  }
  file_line { 'mountd_port':
    line  => "MOUNTD_PORT=${mountd_port}",
    match => 'MOUNTD_PORT=.*'
  }
  file_line { 'rquotad_port':
    line  => "RQUOTAD_PORT=${rquotad_port}",
    match => 'RQUOTAD_PORT=.*'
  }
  file_line { 'statd_port':
    line  => "STATD_PORT=${statd_port}",
    match => 'STATD_PORT=.*'
  }
  file_line { 'statd_outgoing_port':
    line  => "STATD_OUTGOING_PORT=${statd_outgoing_port}",
    match => 'STATD_OUTGOING_PORT=.*'
  }

  # Set firewall rules for portmapper fixed ports
  firewall { '100 allow lockd TCP connections':
    proto   => 'tcp',
    dport   => $lockd_tcpport,
  }
  firewall { '100 allow lockd UDP connections':
    proto   => 'udp',
    dport   => $lockd_udpport,
  }
  firewall { '100 allow mountd TCP connections':
    proto   => 'tcp',
    dport   => $mountd_port,
  }
  firewall { '100 allow mountd UDP connections':
    proto   => 'udp',
    dport   => $mountd_port,
  }
  firewall { '100 allow rquotad TCP connections':
    proto   => 'tcp',
    dport   => $rquotad_port,
  }
  firewall { '100 allow rquotad UDP connections':
    proto   => 'udp',
    dport   => $rquotad_port,
  }
  firewall { '100 allow statd TCP connections':
    proto   => 'tcp',
    dport   => $statd_port,
  }
  firewall { '100 allow statd UDP connections':
    proto   => 'udp',
    dport   => $statd_port,
  }

}
