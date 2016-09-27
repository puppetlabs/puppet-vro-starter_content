#!/bin/bash

# This is the universal configuration script. Untar the environments code, and
# this moves everything it needs into place and configures the master.

# GLOBALS
PATH="/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin:/opt/puppet/bin:$PATH"
puppet_environmentpath=$(puppet config print environmentpath)
tools_path="${puppet_environmentpath}/production/scripts"
working_dir=$(basename $(cd $(dirname $0) && pwd))
containing_dir=$(cd $(dirname $0)/.. && pwd)
basename="${containing_dir}/${working_dir}"

main()
{
  pre_config

  # Bootstrap classification by using puppet-apply to configure the node
  # manager, then running puppet-agent to enforce all configured state.
  /bin/bash $tools_path/refresh_classes.sh
  puppet apply --exec 'include profile::master::node_manager'
  puppet agent --onetime --no-daemonize --color=false --verbose

  # In order to work around PE-14937, we need to clean out the code-dir
  find /etc/puppetlabs/code -name '.git*' | xargs rm -rf

  # We don't yet have the RBAC Directory Service puppetized so we have to
  # configure it separately. Sadness.
  /bin/bash $tools_path/connect_ds.sh

  post_config
}

pre_config()
{
  # Configuration relies on the Puppet environment (all the modules and
  # supporting manifests, a set of content this script is a part of) being
  # deployed to the codedir so that Puppet can use them to the configure the
  # system. In our AWS scenario, it won't yet be the case that this code is
  # already in the right place. In the pre_config step we therefore check to
  # see if the deploy script is running from the codedir, and if it isn't we'll
  # copy all the content from the current location into the codedir.
  if [ $basename != "${puppet_environmentpath}/production/scripts" ]; then
    echo "Syncing environment contents from $containing_dir to $puppet_environmentpath/production/"
    /bin/cp -Rfu "$containing_dir/"* "$puppet_environmentpath/production/"
    chown -R pe-puppet:pe-puppet "$puppet_environmentpath/production/"
  fi
}

post_config()
{
  # If this is a vagrant environment, there's nothing more to do. However, in
  # AWS we have the master self-deploy the rest of the environment.  We aren't
  # sure it's a good idea to enforce puppetlabs/aws resources during regular
  # runs. For now, just do it as a one-time post_config action.
  if [ ! -z "$(facter -p ec2_iam_info_0)" ]; then
    echo "on a properly setup AWS node, deploy the herd"
    gem install aws-sdk-core retries
    puppet apply --exec 'include tse_awsnodes::deploy'
  fi
}

main "$@"
