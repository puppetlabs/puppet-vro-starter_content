# Run this script from the master
# /vagrant/scripts/setup_ds.sh
# to configure the sample DS.

PATH="/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin:/opt/puppet/bin:$PATH"

curl -X PUT -H 'Content-Type: application/json' \
-d \
'{
    "base_dn": "ou=system",
    "connect_timeout": 10,
    "display_name": "Sample Directory",
    "group_lookup_attr": "cn",
    "group_member_attr": "uniqueMember",
    "group_name_attr": "description",
    "group_object_class": "*",
    "group_rdn": "ou=groups",
    "help_link": "",
    "hostname": "master.inf.puppet.vm",
    "login": "uid=admin,ou=system",
    "password": "secret",
    "port": 10389,
    "ssl": false,
    "type": null,
    "user_display_name_attr": "displayName",
    "user_email_attr": "mail",
    "user_lookup_attr": "cn",
    "user_rdn": "ou=users"
}' \
--cacert `puppet config print localcacert` \
--cert   `puppet config print hostcert` \
--key    `puppet config print hostprivkey` \
--insecure \
https://localhost:4433/rbac-api/v1/ds | python -m json.tool
