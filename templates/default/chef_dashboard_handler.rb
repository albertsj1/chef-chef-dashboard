require 'chef/rest'

class Chef
  class DashboardHandler < Chef::Handler
    def report
      hash = {
        "name" => node.name,
        "fqdn" => node.fqdn,
        "ipaddress" => node.ipaddress,
        "success"   => success?,
        "resources" => updated_resources.map(&:to_s).uniq
      }

      r = Chef::REST.new('http://<%= node["dashboard"]["host"] %>')
      r.put_rest('report', hash)
    end
  end
end
