class autosign_example (String $puppet_autosign_shared_secret = "S3cr3tP@ssw0rd!") {

  file { '/etc/puppetlabs/puppet/autosign.rb' :
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0700',
    content => template('autosign_example/autosign.rb.erb'),
    notify  => Service['pe-puppetserver'],
  }

  ini_setting { 'autosign script setting':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'master',
    setting => 'autosign',
    value   => '/etc/puppetlabs/puppet/autosign.rb',
    notify  => Service['pe-puppetserver'],
  }

}
