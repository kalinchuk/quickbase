require "active_record"
require "cgi"
require 'pp'
require 'spec_helper'

#fill in your own quickbase account / database
Quickbase::Connection.username = "username"
Quickbase::Connection.password = "password"
Quickbase::Connection.org = "intuitcorp"
apptoken = "apptoken"
dbid = "dbid"

describe Quickbase::Connection do
  let(:connection) { described_class.new(:apptoken => apptoken, :dbid => dbid) }
  let(:connection_hash) do
    {
      apptoken: connection.apptoken,
      dbid: connection.dbid,
      hours: connection.hours,
      org: connection.org,
      password: connection.password,
      username: connection.username
    }
  end

  let(:default_values_hash) do
    {
      apptoken: apptoken,
      dbid: dbid,
      hours: nil,
      org: described_class.org,
      password: described_class.password,
      username: described_class.username
    }
  end

  describe "initialize" do
    it "initializes successfully" do
      expect(connection_hash).to eq default_values_hash
    end
  end
end

describe Quickbase::Helper do
  describe "self.hash_to_xml" do
    let(:params) { {test: "this is the content of the test tag", test2: "contents of test2"} }
    let(:result) { ["<test>this is the content of the test tag</test>", "<test2>contents of test2</test2>"] }

    subject { described_class.hash_to_xml(params) }

    it { is_expected.to eq result }
  end

  describe "self.generate_xml" do
    let(:input) { ["<test>this is the content of the test tag</test>", "<test2>contents of test2</test2>"] }
    let(:expect_xml) { Nokogiri::XML("<qdbapi><test>this is the content of the test tag</test><test2>contents of test2</test2></qdbapi>") }

    subject { described_class.generate_xml(input).to_s }

    it 'returns a formatted Quickbase XML' do
      expect(subject).to eq expect_xml.to_s
    end
  end

  describe "self.generate_fields" do
    let(:fields) { {first_name: "John", last_name: "Smith"} }
    let(:result) { ["<field name=\"first_name\">John</field>", "<field name=\"last_name\">Smith</field>"] }

    subject { described_class.generate_fields(fields) }

    it { is_expected.to eq result }
  end
end

describe Quickbase::API do
  let(:connection) { Quickbase::Connection.new(apptoken: apptoken, dbid: dbid) }
  let(:api) { connection.api }

  describe "do_query", vcr: {cassette_name: 'do_query'} do
    subject { api.do_query(query: "{'1'.XEX.'1'}", clist: "1.2", slist: "1") }

    it { is_expected.to eq [{"1"=>"1280355979800", "2"=>"1280355979800"}, {"1"=>"1280355979800", "2"=>"1280355979800"}] }
  end

  describe "do_query_return_xml", vcr: {cassette_name: 'do_query'} do
    let(:xml_response) { IO.read('./spec/fixtures/xml_response.xml') }
    subject { api.do_query_return_nokogiri_obj(query: "{'1'.XEX.'1'}", clist: "1.2", slist: "1") }

    it "returns xml" do
      expect(subject).to be_a_kind_of Nokogiri::XML::Document
      expect(subject.to_s).to eq xml_response
    end
  end
end
