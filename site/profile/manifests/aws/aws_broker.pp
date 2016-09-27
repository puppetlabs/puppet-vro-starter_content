class profile::aws::aws_broker(
  String $region = 'us-west',
  String $aws_access_key_id = '',
  String $aws_secret_access_key = '',
){
  #Install aws-sdk
  package {['aws-sdk','retries']:
    ensure   => present,
    provider => puppet_gem,
  }

  File {
    mode   => '0600',
    ensure => file,
    owner  => 'root',
    group  => 'root',
  }

  file { '/root/.aws':
    ensure => directory,
  }
  file { '/root/.aws/credentials':
    content => template('profile/aws/credentials.erb'),
  }
  file { '/root/.aws/config':
    content => template('profile/aws/config.erb'),
  }
}
