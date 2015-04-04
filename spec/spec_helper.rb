require 'rubygems'
require 'bundler/setup'
require 'simplecov'

SimpleCov.start do
  add_filter "/spec/"
end

Dir[File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "**", '*.rb'))].each {|f| require f }
