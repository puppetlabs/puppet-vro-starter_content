#!/bin/bash

# This is a great way to show how a machine could be "tagged" with
# a role like "tomcat" by a provisioning system like vRA.
<<EXAMPLE_CSR_ATTRIB
---
  extension_requests:
    pp_role: tomcat
    pp_uuid: 123-456-789
EXAMPLE_CSR_ATTRIB
# Simply: `mkdir -p /etc/puppetlabs/puppet` and drop the contents above
# (without heredoc bookends) into csr_attributes.yaml in that directory.
# Then install the puppet agent via "curl | bash" method and the trusted
# facts will be included in the CSR and will persist in the signed cert.
#
# note: the pp_uuid is also set as an example of how a unique machine id fact
# could be used by our policy-based autosigner by having it query the
# provisioner for UUIDs of machines it created. Many other attributes can be
# set. For more info see:
# https://docs.puppetlabs.com/puppet/latest/reference/config_file_csr_attributes.html

PATH="/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin:/opt/puppet/bin:$PATH"

curl -X POST -H 'Content-Type: application/json' \
-d \
'{
    "name": "RHEL Tomcat",
    "classes": {
      "profile::tomcat": {}
    },
    "environment": "production",
    "environment_trumps": false,
    "parent": "00000000-0000-4000-8000-000000000000",
    "rule": [
      "and",
        [ "=",
          [ "trusted", "extensions", "pp_role" ],
          "tomcat"
        ],
        [ "=",
          [ "fact", "os", "family" ],
          "RedHat"
        ]
    ],
    "variables": {}
}' \
--cacert `puppet agent --configprint localcacert` \
--cert `puppet agent --configprint hostcert` \
--key `puppet agent --configprint hostprivkey` \
--insecure \
https://localhost:4433/classifier-api/v1/groups
