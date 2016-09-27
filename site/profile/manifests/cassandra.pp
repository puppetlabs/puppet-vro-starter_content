class profile::cassandra (
  $seednodes = $::ipaddress,
  $cluster_name = 'CassandraTestCluster',
) {

  #As this sits, it should only be applied to a single node since the seeds would have to be manually specified.
  #I would really like to find a way to export the ip address list if a param (like 'isseed') is set to true and then collect them and pass them in as the seeds param.
  #Additionally, the locp/cassandra module doesnt accept an array and that should be fixed.
  #Also needs 2GB of ram allocated to host
  class { 'cassandra::datastax_repo':
    before => Class['cassandra']
  }

  class { 'cassandra::java':
    before => Class['cassandra']
  }

  class { 'cassandra':
    cluster_name    => $cluster_name,
    endpoint_snitch => 'GossipingPropertyFileSnitch',
    listen_address  => $::ipaddress,
    num_tokens      => 256,
    seeds           => $seednodes,
    auto_bootstrap  => false,
  }
}
