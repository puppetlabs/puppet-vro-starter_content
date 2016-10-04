#
class role::windows_webserver (
    $webserver_port,
    $doc_root,
) {
  include profile::windows_baseline
  class { 'profile::iis':
    webserver_port => $webserver_port
  }
  class { 'profile::sample_website':
    doc_root       => $doc_root
    webserver_port => $webserver_port
  }
}
