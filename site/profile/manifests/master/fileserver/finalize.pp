# This class contains configuration representing the "deployment" of the master
# as an app. It is intended to be included in the deploy_app stage. This
# configuration being applied represents the server configuration being
# practically complete.
class profile::master::fileserver::finalize {

  file { '/opt/tse-files/deployed.txt':
    ensure  => file,
    owner   => $profile::master::fileserver::admin_file_owner,
    group   => $profile::master::fileserver::admin_file_group,
    mode    => '0644',
    content => "complete\n",
  }

}
