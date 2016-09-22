# Unzip #

Windows only.

Given a source zip file and a directory/file that should result when it is
extracted, this defined type implicitly ensures that an archive is
extracted.

## Parameters ##

### source ###

The fully-qualified path to the zip file to extract. This file must
already exist on the system; that is, it cannot be a remote URL. You can
use pget or another resource to fetch it first.

### creates ###

A file or folder that will result from extracting the archive. This is
used to determine whether or not the archive has been successfully
extracted.

### destination ###

Optional. The destination directory into which to extract the archive. If
not specified, the dirname of the *creates* parameter will be used as the
destination.

## Examples ##

    unzip { "example":
      source  => 'C:\src\bar.zip',
      creates => 'C:\test\bar',
    }
