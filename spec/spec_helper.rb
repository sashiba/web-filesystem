require 'sinatra'
require File.expand_path("../proekt.rb", File.dirname(__FILE__))
require 'rspec'
require 'rack/test'

ENV['RACK_ENV'] = 'test'
set :environment, :test

def app()
  MyApp
end

RSpec.configure do |conf|
   conf.include Rack::Test::Methods
end
