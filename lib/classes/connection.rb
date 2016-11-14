module Quickbase
  class Connection
    class << self
      attr_writer :username, :password, :hours, :apptoken, :dbid, :org, :http_proxy
    end
    attr_reader :username, :password, :hours, :apptoken, :dbid, :org, :http_proxy

    def self.expectant_reader(*attributes)
      attributes.each do |attribute|
        (class << self; self; end).send(:define_method, attribute) do
          attribute_value = instance_variable_get("@#{attribute}")
          attribute_value
        end
      end
    end
    expectant_reader :username, :password, :hours, :apptoken, :dbid, :org, :http_proxy

    def initialize(options = {})
      [:username, :password, :hours, :apptoken, :dbid, :org, :http_proxy].each do |attr|
        instance_variable_set "@#{attr}", (options[attr].nil? ? Quickbase::Connection.send(attr) : options[attr])
      end
      instance_variable_set "@org", "www" if org.nil?
    end

    def instantiate
      {
        username: username,
        password: password,
        hours: hours,
        apptoken: apptoken,
        dbid: dbid,
        org: org,
        http_proxy: http_proxy
      }
    end

    def http
      Quickbase::HTTP.new(instantiate)
    end

    def api
      Quickbase::API.new(self)
    end
  end
end
