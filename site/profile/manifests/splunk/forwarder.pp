class profile::splunk::forwarder (
  $server,
  $splunkd_port  = '8089',
  $logging_port  = '9997',
  $purge_inputs  = false,
  $purge_outputs = false,
) {
  include profile::firewall

  class { '::splunk::forwarder':
    server        => $server,
    logging_port  => $logging_port,
    splunkd_port  => $splunkd_port,
    purge_inputs  => $purge_inputs,
    purge_outputs => $purge_outputs,
  }

  # If we wanted to, we could open up the firewall to allow connections to the
  # splunk daemon. For our purposes now, we don't want to.
  #
  #   firewall { '100 allow connections to splunkd':
  #     proto   => 'tcp',
  #     dport   => $web_port,
  #     action  => 'accept',
  #   }

}
