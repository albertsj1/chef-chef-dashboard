maintainer        "Erik Hollensbe"
maintainer_email  "erik+chef@hollensbe.org"
license           "Apache 2.0"
description       "Installs the chef-dashboard application on a server and configures servers to report to it."
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1.0"

%w{ debian ubuntu }.each do |os|
  supports os
end

depends "nginx"
depends "unicorn2"
depends "chef_handler"
