# Changelog

## 2.5.0

- Implement instances for sshkey (only for non-hashed entries)

## 2.4.0

- Add sshd_config_match type and provider (#GH 5)
- Purge multiple array entries in ssh_config provider (GH #12)

## 2.3.0

- Add sshkey provider (GH #13)
- sshd_config: munge condition parameter
- Improve test setup
- Get rid of Gemfile.lock
- Improve README badges

## 2.2.2

- Properly insert values after commented out entry if case doesn't match (GH #6)

## 2.2.1

- Convert specs to rspec3 syntax
- Fix metadata.json

## 2.2.0

- sshd_config: consider KexAlgorithms and Ciphers as array values (GH #4)

## 2.1.0

- Add ssh_config type & provider

## 2.0.0

- First release of split module.
