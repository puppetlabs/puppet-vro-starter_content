#
class profile::sample_website {

  file { $destination_dir:
    ensure  => directory,
    path    => $doc_root,
    source  => $source_dir,
    recurse => true,
  }

}
