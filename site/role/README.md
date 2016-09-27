# Role Module #

[![Build Status](https://travis-ci.org/puppetlabs-seteam/puppet-module-role.svg?branch=master)](https://travis-ci.org/puppetlabs-seteam/puppet-module-role)

Roles are intended to be aggregator Puppet classes. Apply a single role at the
classification level. If more than one role is being applied to a single node,
perhaps it should be a profile instead, or perhaps that combination of profiles
should be turned into a role.

This is the role module for the Puppet Labs SE Team. It is a site-specific
module, and is not designed to plug-n-play into other environments. In some
ways, this is one of a few modules that _define_ the environment.
