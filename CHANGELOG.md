# Change Log

## Unreleased

Bugfixes:

  - Files downloaded to the master for the OraDB demo now have correct permissions

## 2015.3.1-2 (2016-01-21)

Features:

  - Added IIS/Deploying .NET App Demo

Improvements:

  - Added WebSphere content (not yet documented)

Workarounds:

  - `profile::example::registry` has been modified not to throw errors by
    commenting out the registry\_value resource which caused problems. This
    should be investigated and fixed for real in the future.

## 2015.3.1-1 (2015-12-15)

Features:

  - Update to PE 2015.3.1. Resolves major security vulnerability found in 2015.3.0.
  - Added `profile::example::generic\_website`
  - Added `profile::example::wordpress`

Improvements:

  - Added Zabbix content (not yet documented)
  - Added Oracle 12c EE content (not yet documented)

## 2015.3.0-2 (2015-12-08)

Improvements:

  - Rakefile is less verbose, more useful when building artifacts

Bugfixes:

  - RG Bank Orchestrator application instances are no longer commented out in the site.pp file
  - RG Bank Orchestrator node groups now configure clients to disable pluginsync and use cached catalogs

## 2015.3.0-1 (2015-12-08)

Features:

  - Environment now ready for Puppet Enterprise 2015.3.0!
  - RG Bank App Orchestration Demo

Improvements:

  - Updated lwf/remote\_file to newest release, 1.1.0
  - Do not continuously enforce node\_groups. Only apply node\_groups once,
    during provisioning. This de-couples the Console from the code, so that
    changes users make in the console are not overriden when Puppet runs.
  - Add locp/cassandra module from the Forge and parameterize the cluster\_name
    of the cassandra profile.
  - Move the git source of the puppetlabs/firewall module back to the Puppet
    Labs github repo. (We are able to do this now that a necessary patch has
    been merged).

## 2015.2.3-1 (2015-11-13)

(this space intentionally left blank)

---

# Legend

This is a suggested format for Changelog. Not every catagory need be filled in for every release.

## tag (release date)

Features:

  - Notable new functionality
  - Does not necessarily have a 1:1 correspondence with commits

Bugfixes:

  - Commits made that fix things previously broken or bugged
  - Typically things that would be considered z-level fixes in Semantic Versioning

Improvements:

  - Changes made to streamline performance or clean up technical debt
  - Changes made to better align our code or layout with Professional Services
    or best practices
  - Betterment work which is not strictly a feature or a bugfix

Workarounds:

  - Things we've done that aren't permanent, but which allow us to advance
    features or bugfixes where we otherwise couldn't.
  - Oftentimes this might be something like using a git checkout for a module
    while we wait for a release to be cut with a needed fix or feature
  - It is expected that most workarounds will eventually be replaced by an
    improvement.
