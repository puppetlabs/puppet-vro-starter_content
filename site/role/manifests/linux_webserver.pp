#
class role::linux_webserver (
    $webserver_port,
    $doc_root,
) {
  include profile::linux_baseline
  include profile::vro_provisioned
  class { 'profile::apache':
    webserver_port => $webserver_port
  }
  class { 'profile::sample_website':
    doc_root       => $doc_root
    webserver_port => $webserver_port
  }
}
