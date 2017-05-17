require 'httparty'
module Quickbase
  class HTTP
    include HTTParty
    attr_accessor :qb_params

    def initialize(config)
      self.class.base_uri "https://#{config[:org]}.quickbase.com"
      instance_variable_set "@qb_params", {:dbid => "main"}

      http_proxy = config[:http_proxy] || ENV['http_proxy']
      setup_proxy(http_proxy) if http_proxy

      qb_params[:dbid] = config[:dbid]
      qb_params[:usertoken] = config[:usertoken]
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
    def auth_ticket(config)
      response = post("API_Authenticate", Quickbase::Helper.hash_to_xml(config))
      response.xpath("//ticket").first.content
    end

    def no_proxy?
      host = URI.parse(self.class.base_uri).host
      ENV.fetch('no_proxy','').split(',').any? do |pattern|
        # convert patterns like `*.example.com` into `.*\.example\.com`
        host =~ Regexp.new(pattern.gsub(/\./,'\\.').gsub(/\*/,'.*'))
      end
    end

    def setup_proxy(proxy_url)
      return if no_proxy?

      proxy_url = URI.parse(proxy_url)

      self.class.http_proxy(proxy_url.host, proxy_url.port,
                            proxy_url.user, proxy_url.password)
    end

    def error_handler(response)
      errcode = response.xpath("//errcode").first.content

      unless errcode.to_i.zero?
        errtext = response.xpath('//errtext').first.content
        raise "#{errcode}: #{errtext}"
      end
    end
  end
end
