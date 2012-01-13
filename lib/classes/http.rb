module Quickbase
  class HTTP
    include HTTParty
    attr_accessor :qb_params
  
    def initialize(config)
      self.class.base_uri "https://#{config[:org]}.quickbase.com"
      instance_variable_set "@qb_params", {:dbid => "main"}
      response = post("API_Authenticate", Quickbase::Helper.hash_to_xml(config))
      qb_params[:ticket] = response.xpath("//ticket").first.content
      qb_params[:apptoken] = config[:apptoken]
      qb_params[:dbid] = config[:dbid]
    end
      
    def post(quickbase_action, params = [])
      params = params.concat(Quickbase::Helper.hash_to_xml(qb_params))
      clean_xml_string = Quickbase::Helper.generate_xml(params).to_s
      self.class.headers({"Content-Length" => clean_xml_string.length.to_s})
      self.class.headers({"Content-Type" => "application/xml"})
      self.class.headers({"QUICKBASE-ACTION" => quickbase_action})
      response = Nokogiri::XML([self.class.post("/db/#{qb_params[:dbid]}", :body => clean_xml_string)].to_xml)
      error_handler(response)
      response
    end
  
    private
    
    def error_handler(response)
      case response.xpath("//errcode").first.content.to_i
      when 0
        return true
      else
        errcode = response.xpath('//errcode').first.content
        errtext = response.xpath('//errtext').first.content
        raise "#{errcode}: #{errtext}"
        return false
      end
    end
  end
  
  class Http < HTTP
    puts "Class Http will be deprecated. Please use HTTP instead."
  end
end