require 'sinatra/base'
#require 'bundler/setup'
require 'sinatra/activerecord'
require 'find'
require 'fileutils'

require_relative 'PasswordHash'
require_relative 'models/model'
require_relative 'routes/users'
require_relative 'routes/forgot'
require_relative 'routes/fmanager'
require_relative 'helpers/helpers'

class MyApp < Sinatra::Base
	enable  :sessions
	set :root          , File.dirname(__FILE__)
  set :views         , "C:/Users/Alexander/ruby/proekt/views"
  set :app_file      , __FILE__

  ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => "C:/Users/Alexander/ruby/proekt/users_db.sqlite3",
)
end