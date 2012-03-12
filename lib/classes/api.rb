module Quickbase
  class API
    attr_accessor :connection
  
    def initialize(connection)
      instance_variable_set "@connection", connection
    end
  
    # Documentation at http://www.quickbase.com/api-guide/do_query.html
    def do_query(params)
      params[:fmt] = 'structured' if params[:fmt].nil? or params[:fmt].empty?
      clist = params[:clist].to_s.split(".")
      friendly = params[:friendly].to_s.split(".")
      keys = friendly.empty? ? clist : friendly.map(&:to_sym)
      response = connection.http.post("API_DoQuery", Quickbase::Helper.hash_to_xml(params))
      array_of_records = response.xpath("//record[@type='array']/record")
      records = array_of_records.empty? ? response.xpath("//record") : array_of_records
      return [] if records.empty?

      records.map{|record|
        array_of_fields = record.xpath("f[@type='array']/f")
        fields = array_of_fields.empty? ? record.xpath("f") : array_of_fields
        Hash[fields.to_enum(:each_with_index).collect{|field,index|
          field.content = "" unless field.xpath("id").first.nil? # QuickBase adds ID to the tag if its empty
          Hash[keys[index],field.content] 
        }.map(&:flatten)]
      }
    end
    
    # Documentation at http://www.quickbase.com/api-guide/add_record.html
    def add_record(fields)
      fields = Quickbase::Helper.generate_fields(fields)
      connection.http.post("API_AddRecord", fields)
    end
    
    # Documentation at http://www.quickbase.com/api-guide/edit_record.html
    def edit_record(rid, fields)
      tags = Quickbase::Helper.generate_fields(fields)
      tags << Quickbase::Helper.hash_to_xml({:rid => rid.to_s})
      connection.http.post("API_EditRecord", tags)
    end
    
    # Documentation at http://www.quickbase.com/api-guide/delete_record.html
    def delete_record(rid)
      tags = Quickbase::Helper.hash_to_xml({:rid => rid.to_s})
      connection.http.post("API_DeleteRecord", tags)
    end
  end
  
  class Api < API
    puts "Class Api will be deprecated. Please use API instead."
  end
end