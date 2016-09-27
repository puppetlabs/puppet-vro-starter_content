class profile::windows::chocolatey (
  #$chocolatey_download_url = undef,
) {

  case $::facts['os']['release']['full'] {
    '2008 R2': {
      $chocolatey_download_url = 'https://s3-us-west-2.amazonaws.com/tse-builds/misc/chocolatey.0.9.9.9.nupkg'
    }
    default  : {
      $chocolatey_download_url = undef
    }
  }

  class { 'chocolatey':
    chocolatey_download_url => $chocolatey_download_url,
  }

  require profile::windows::dotnet

  Class['profile::windows::dotnet'] -> Class['chocolatey']

}
