class myfirewall::params {

$firewall_status  = 'running'
$firewall_service = 'firewalld'
$myport = [ '22', '53', '25', '21' ]
$myproto = true
$servicerule = [ 'https', 'ftp', 'ssh' ]
}
