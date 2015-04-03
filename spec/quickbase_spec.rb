require "active_record"
require "cgi"
require 'pp'
require 'spec_helper'

#fill in your own quickbase account / database
Quickbase::Connection.username = ""
Quickbase::Connection.password = ""
Quickbase::Connection.org = ""
apptoken = ""
dbid = ""

describe Quickbase::Connection do
  describe "initialize" do
    it "initializes successfully" do
      quickbase = Quickbase::Connection.new(:apptoken => apptoken, :dbid => dbid)
      
      connection_hash = {
        :apptoken => quickbase.apptoken,
        :dbid => quickbase.dbid,
        :hours => quickbase.hours,
        :org => quickbase.org,
        :password => quickbase.password,
        :username => quickbase.username
      }
      
      default_values_hash = {
        :apptoken => apptoken,
        :dbid => dbid,
        :hours => nil,
        :org => Quickbase::Connection.org,
        :password => Quickbase::Connection.password,
        :username => Quickbase::Connection.username
      }
      
      connection_hash.should == default_values_hash
    end
  end
end

describe Quickbase::Helper do
  describe "self.hash_to_xml" do
    it "creates XML out of a hash" do
      hash = {:test => "this is the content of the test tag", :test2 => "contents of test2"}
    
      Quickbase::Helper.hash_to_xml(hash).join.should == "<test>this is the content of the test tag</test><test2>contents of test2</test2>"
    end
  end
  
  describe "self.generate_xml" do
    it "returns a formatted Quickbase XML" do
      hash = {:test => "this is the content of the test tag", :test2 => "contents of test2"}
      Quickbase::Helper.generate_xml(Quickbase::Helper.hash_to_xml(hash)).to_s.should == Nokogiri::XML("<qdbapi><test>this is the content of the test tag</test><test2>contents of test2</test2></qdbapi>").to_s
    end
  end
  
  describe "self.generate_fields" do
    it "creates an array of tags with all the fields" do
      fields = {:first_name => "John", :last_name => "Smith"}
      Quickbase::Helper.generate_fields(fields).should ==  ["<field name=\"first_name\">John</field>", "<field name=\"last_name\">Smith</field>"]
    end
  end
end

describe Quickbase::API do
  describe "do_query" do
    it "queries for data" do
      quickbase = Quickbase::Connection.new(:apptoken => apptoken, :dbid => dbid)
      
      results = quickbase.api.do_query(:query => "{'1'.XEX.'1'}", :clist => "1.2", :slist => "1")
      results.length.should_not == 0
    end
  end
  
  describe "do_query_return_xml" do
    it "return xml" do
      quickbase = Quickbase::Connection.new(:apptoken => apptoken, :dbid => dbid)
      
      xml = quickbase.api.do_query_return_nokogiri_obj(:query => "{'1'.XEX.'1'}", :clist => "1.2", :slist => "1")
      xml.class.to_s.should == "Nokogiri::XML::Document"
    end
  end
end