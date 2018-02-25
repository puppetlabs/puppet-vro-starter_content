#!/bin/bash
#
# Run this on your vRO appliance or vRA appliance if using the internal vRO to remove
# the installed Puppet plugin. You should remove the Puppet plugin before installing
# the same version again or another version.
#
# reference:
# https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2064575
# https://docs.vmware.com/en/vRealize-Orchestrator/7.3/com.vmware.vrealize.orchestrator-install-config.doc/GUID-F5C8EF0E-C169-43E1-8A6F-D9A191FE129D.html
#
service vco-server stop
sleep 10
rm -f /usr/lib/vco/app-server/plugins/o11nplugin-puppet.dar
rm -f /var/lib/vco/app-server/plugins/o11nplugin-puppet.dar
sed -i '/Puppet/d' /etc/vco/app-server/plugins/_VSOPluginInstallationVersion.xml
service vco-configurator restart
sleep 5
service vco-server start
