# == Define: unzip
#
# Given a source zip file and a directory/file that should result when it is
# extracted, this defined type implicitly ensures that an archive is
# extracted.
#
# === Parameters
#
# [*source*]
#   The fully-qualified path to the zip file to extract. This file must
#   already exist on the system; that is, it cannot be a remote URL. You can
#   use pget or another resource to fetch it first.
#
# [*creates*]
#   A file or folder that will result from extracting the archive. This is
#   used to determine whether or not the archive has been successfully
#   extracted.
#
# [*destination*]
#   Optional. The destination directory into which to extract the archive. If
#   not specified, the dirname of the *creates* parameter will be used as the
#   destination.
#
# === Examples
#
#  archive { "example":
#    source  => 'C:\src\bar.zip',
#    creates => 'C:\test\bar',
#  }
#
define unzip (
  $source,
  $creates,
  $destination = undef,
) {
  # This defined type has only been implemented for Windows
  if $::osfamily != 'windows' { fail("unsupported platform") }

  $dest = $destination ? {
    default => $destination,
    undef   => unzip_dirname($creates),
  }

  exec { "unzip $source to $dest":
    command  => "\$sh=New-Object -COM Shell.Application;\$sh.namespace((Convert-Path '$dest')).Copyhere(\$sh.namespace((Convert-Path '$source')).items(), 16)",
    creates  => $creates,
    provider => powershell,
  }

}
