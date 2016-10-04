#
class profile::mysql {

  include mysql::server
  include mysql::bindings
  include mysql::bindings::php

}
