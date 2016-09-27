class role::win_sqlweb_demo {
  include tse_sqlserver
  include sqlwebapp::db
  include sqlwebapp
}
