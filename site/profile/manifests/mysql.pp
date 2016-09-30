#
class profile::mysql {

  include apache
  include apache::mod::php
  include mysql::server
  include mysql::bindings
  include mysql::bindings::php

}
