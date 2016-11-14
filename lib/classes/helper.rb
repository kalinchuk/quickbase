module Quickbase
  class Helper
    def self.hash_to_xml(my_hash)
      my_hash.map do |k,v|
        key = k.to_s.encode(xml: :text)
        value = v.to_s.encode(xml: :text)
        "<#{key}>#{value}</#{key}>"
      end
    end

    def self.generate_xml(xml_input)
      # xml_input is an array of xml strings
      # you can use hash_to_xml to generate it
      Nokogiri::XML("<qdbapi>#{xml_input.join}</qdbapi>")
    end

    def self.generate_fields(fields)
      fields.map do |key,value|
        attr_name = (key =~ /^[-+]?[0-9]+$/) ? 'fid' : 'name'
        "<field #{attr_name}=#{key.to_s.encode(xml: :attr)}>#{value.to_s.encode(xml: :text)}</field>"
      end
    end
  end
end
