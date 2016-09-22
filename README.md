# vRO Starter Content Pack

Installation with git
```
cd /etc/puppetlabs/code/environments/production; rm -rf *
git clone git@github.com:puppetlabs/puppet-vro-starter_content.git
```

Installation with curl https://github.com/settings/tokens

For private repo's you need add `-u <GITHUB_USERNAME>:<GITHUB_PERSONAL_APITOKEN>` to the curl command. Get token from https://github.com/settings/tokens

```
rm -rf /etc/puppetlabs/code/environments/production/*
curl -sSL https://github.com/puppetlabs/puppet-vro-starter_content/archive/production.tar.gz | tar --strip-components 1 -zx -C /etc/puppetlabs/code/environments/production
```

Special thanks to Abir Majumdar, and the Puppet TSE team for inspiration and bulk of contributions.
Jeremy Adams was a more minor contributor but a major commit squasher.
