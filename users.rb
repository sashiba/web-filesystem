require 'sinatra'
require 'sinatra/activerecord'
gem 'sqlite3'

ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'w'))
ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :host     => "host",
  :username => "user",
  :password => "password",
  :database => "example.db"
)

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'users'
    create_table :users do |table|
      table.column :username,   :string
      table.column :password,   :string
      table.column :email,      :string
      table.column :accdetails, :string
      table.column :vip,        :integer
    end
  end
end

class Users < ActiveRecord::Base
 # belongs_to :users
end

sasho = Users.create(:username => 'sashiba',
					 :password => 'sasho', 
					:email     => 'sashopirnarev@gmail.com',
					:accdetails => 'Alexander Pirnarev',
					:vip => 1
	)