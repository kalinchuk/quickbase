module Quickbase
  class Helper
    def self.hash_to_xml(hash)
      hash.map{|key,value|
        "<#{key}>#{value}</#{key}>"
      }
    end
    
    def self.generate_xml(params)
      Nokogiri::XML("<qdbapi>#{params.join}</qdbapi>")
    end
    
    def self.generate_fields(fields)
      fields.map{|key,value|
        field = "<field "
        fid = (key =~ /^[-+]?[0-9]+$/) ? field.concat('fid="'+key.to_s+'"') : field.concat('name="'+key.to_s+'"')
        field.concat(">#{value}</field>")
      }
    end
  end
end