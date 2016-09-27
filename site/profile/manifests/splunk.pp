class profile::splunk (
  $web_port      = '8000',
  $splunkd_port  = '8090',
  $logging_port  = '9997',
  $purge_inputs  = false,
  $purge_outputs = false,
) {
  include profile::firewall

  class { '::splunk':
    logging_port  => $logging_port,
    splunkd_port  => $splunkd_port,
    web_port      => $web_port,
    purge_inputs  => $purge_inputs,
    purge_outputs => $purge_outputs,
  }

  firewall { '100 allow connections to splunk web service':
    proto   => 'tcp',
    dport   => $web_port,
    action  => 'accept',
  }
  firewall { '100 allow connections to splunk logging service':
    proto   => 'tcp',
    dport   => $logging_port,
    action  => 'accept',
  }

}
