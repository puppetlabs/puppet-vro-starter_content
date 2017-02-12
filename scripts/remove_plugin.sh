#!/bin/bash
#
# Run this on your vRO appliance or vRA appliance if using the internal vRO to remove
# the installed Puppet plugin. You should remove the 1.0 plugin before attempting
# install of the 2.0 plugin.
#
# reference:
# https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2064575
#
service vco-server stop
sleep 10
rm -f /usr/lib/vco/app-server/plugins/o11nplugin-puppet.dar
sed -i '/Puppet/d' /etc/vco/app-server/plugins/_VSOPluginInstallationVersion.xml
service vco-configurator restart
sleep 5
service vco-server start
