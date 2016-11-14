require 'rubygems'
require 'bundler/setup'
require 'simplecov'
require 'vcr'

SimpleCov.start do
  add_filter "/spec/"
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.ignore_localhost = true
  config.default_cassette_options = { record: :none }
  config.configure_rspec_metadata!
end

Dir[File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "**", '*.rb'))].each {|f| require f }
