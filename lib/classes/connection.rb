module Quickbase
  class Connection
    class << self
      attr_writer :username, :password, :hours, :apptoken, :dbid, :org
    end
    attr_reader :username, :password, :hours, :apptoken, :dbid, :org
  
    def self.expectant_reader(*attributes)
      attributes.each do |attribute|
        (class << self; self; end).send(:define_method, attribute) do
          attribute_value = instance_variable_get("@#{attribute}")
          attribute_value
        end
      end
    end
    expectant_reader :username, :password, :hours, :apptoken, :dbid, :org
  
    def initialize(options = {})
      [:username, :password, :hours, :apptoken, :dbid, :org].each do |attr|
        instance_variable_set "@#{attr}", (options[attr].nil? ? Quickbase::Connection.send(attr) : options[attr])
      end
      instance_variable_set "@org", "www" if org.nil?
    end
  
    def instantiate
      config = {
        :username => username,
        :password => password,
        :hours => hours,
        :apptoken => apptoken,
        :dbid => dbid,
        :org => org
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