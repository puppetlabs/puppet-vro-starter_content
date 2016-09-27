class role::jenkins {
  include profile::jenkins::server
  include profile::jenkins::jobs
  include profile::jenkins::plugins
}
