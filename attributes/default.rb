default["dashboard"]                  = { }
default["dashboard"]["repository"]    = "https://github.com/erikh/chef-dashboard.git"
default["dashboard"]["revision"]      = "HEAD"
default["dashboard"]["host"]          = "server.local"

install_path = default["dashboard"]["install_path"] = "/www/chef-dashboard"

set_unless["applications"] = [
  {
    "path" => install_path,
    "bin"  => "unicorn",
    "config_path" => "#{install_path}/config/unicorn.rb"
  }
]
