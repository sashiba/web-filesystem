require 'sinatra'
require 'sinatra/activerecord'
gem 'sqlite3'
gem 'rake'
require 'find'
require 'fileutils'
require "C:/Users/Alexander/ruby/proekt/users"
require "C:/Users/Alexander/ruby/proekt/PasswordHash.rb"
#class Sashibox < Sinatra::Base
#set :database, {adapter: "sqlite3", database: "users.sqlite3"}
ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => "C:/Users/Alexander/ruby/proekt/users_db.sqlite3",
)
enable :sessions

#Per-user ограничение за общия размер на всички качени файлове.Това да може да е различно за 
#различните потребители(напр. за VIP потребители да може да е повече, както си написал).
#--------------------------------------------------------------------
#IZCHISTI BAZATA i wij chata oprawi error massages
class User < ActiveRecord::Base
	def self.authenticate (username, password)
		user = Users.find_by(username: username) if  Users.find_by(username: username)
		if user && PasswordHash::validatePassword(password, user.password)
			user
		else
			nil
		end
	end
end
	helpers do  
  	def login?
    	if session[:username].nil?
      	return false
    	else
      	return true
    	end
  	end
  	def username
   	 return session[:username]
  	end
  	def auth(user)
  		session[:userid] == userid
  	end
  #end
end

	get '/' do 
		erb :index
	end
	get '/home/userid=:userid' do
		if (session[:username] == params[:userid])
			user = User.find_by(username: params[:userid])
			@user      = user.username
			erb :home
		else
				"Forbidden"
		end
	end

	get '/login' do
		erb :login
	end

	get '/forgot' do
		erb :forgot
	end
	post '/forgot' do
		if Users.find_by(username: params[:userid])
				user = Users.find_by(username: params[:userid])
			else
				"wrong details"
			end
		if (Users.find_by(username: params[:userid])) && user.email == params[:email]
			@@userforgot = user
			redirect "/resetpw"
		else
			"Wrong details"
		end
	end

	get '/resetpw' do
		erb :resetpw
	end
	post '/resetpw' do
		@@userforgot.password = PasswordHash::createHash(params[:psw])
		@@userforgot.save
		redirect "/"
	end

	get '/logout' do 
		"Loging out"
		session[:username] = nil
		redirect to('/')
	end
	get '/profile/userid=:userid' do
		if (session[:username] == params[:userid])
			user = User.find_by(username: params[:userid])
			@user      = user.username
			@name      = user.accdetails
			@email     = user.email
			@filecount = user.filecount
			if user.vip == 1
				@vip = "Yes"
			else
				@vip = "No"
			end
			erb :profile
		else
				"Forbidden"
		end
	end

	post '/profile/userid=:userid' do
		@userchange = User.find_by(username: params[:userid])
		if PasswordHash::validatePassword(params[:psw],@userchange.password) && (params[:pswNew] == params[:pswNew1])
			@userchange.password = PasswordHash::createHash(params[:pswNew])
			@userchange.save
			"Changed password"#oprawi tiq suobshteniq da se pokazwat
			redirect "/profile/userid=#{username}" #oprawi
		else
			"wrong passwords"
		end
	end

	post '/login' do 
		b = (params[:userid].length == 0 or params[:psw].length == 0)
		if b 
			user = User.authenticate(params[:userid],params[:psw])
			if user 
			session[:username] = params[:userid]
			@list = Dir.glob("./files/#{username}/*.*").map{|f| f.split('/').last}
			redirect "/home/userid=#{username}"
			else 
				"Nqma go" # podobri
			end
		else
			"Populnete wsichko"
		end
	end
	

	post '/signup' do
		if User.find_by(username: params[:userid])
			"imeto e zaeto"
		else
		b = (params[:userid].length == 0 or params[:psw].length == 0 or params[:firstname].length == 0 or params[:email].length == 0 or params[:lastname].length == 0)
			if b	
				"Populnete wsihcki poleta"	
			else
			user = User.new(username: params[:userid],
				password: PasswordHash::createHash(params[:psw]),
				accdetails:(params[:firstname] + ' ' + params[:lastname]),email: params[:email], vip: 0,filecount: 0)
			user.save if user.valid?
			session[:username] = params[:userid]
			Dir.mkdir("C:/Users/Alexander/ruby/proekt/files/#{username}") unless File.exists?("C:/Users/Alexander/ruby/proekt/files/#{username}")
			Dir.mkdir("C:/Users/Alexander/ruby/proekt/files/#{username}/public") unless File.exists?("C:/Users/Alexander/ruby/proekt/files/#{username}/public")
			redirect ('/')
			end
		end
	end


	get '/signup' do
		erb :signup
	end
	get '/fmanager/' do
		erb :fmanager
	end
	get '/fmanager/userid=:userid' do
		if (session[:username] == params[:userid])
			user = User.find_by(username: params[:userid])
			@user      = user.username
			@list = Dir.glob("./files/#{username}/*.*").map{|f| f.split('/').last}
			erb :fmanager
		else
				"Forbidden"
		end
	end

	get '/fmanager/userid=:userid/upload' do 
		if (session[:username] == params[:userid])
			user = User.find_by(username: params[:userid])
			@user      = user.username
			erb :upload
		else
				"Forbidden"
		end
	end
	post '/fmanager/userid=:userid/upload' do
		if (session[:username] == params[:userid])
			user = User.find_by(username: params[:userid])
			@user      = user.username
			if user.filecount <= 15
				File.open("c:/users/alexander/ruby/proekt/files/#{username}/" + params['myfile'][:filename], "wb") do |f|
	    		f.write(params['myfile'][:tempfile].read)
  				end
  				user.filecount = user.filecount + 1
  				user.save
  				return "The file was successfully uploaded!"
  			else
  				"Kupete vip"
  			end
  			redirect '/fmanager/userid=:userid'
		else
				"Forbidden"
		end
	end	

	get '/fmanager/userid=:userid/files/file=:fileid' do
		if (session[:username] == params[:userid])
			user = User.find_by(username: params[:userid])
			@user      = user.username
			@idfile = params[:fileid]
			erb :file		
		else
				"Forbidden"
		end
	end
	get '/userid=:userid/file=:fileid' do
		if File.exist?("c:/users/alexander/ruby/proekt/files/#{username}/public/#{params[:fileid]}")
			"localhost:4567/userid=#{params[:userid]}/file=#{params[:fileid]}/download"
		else
			file_path = "c:/users/alexander/ruby/proekt/files/#{username}/#{params[:fileid]}"
			dest_path =	"c:/users/alexander/ruby/proekt/files/#{username}/public/"
			FileUtils.cp(file_path, dest_path)
	    	redirect "/userid=#{params[:userid]}/file=#{params[:fileid]}"
		end
	end

	get '/userid=:userid/file=:fileid/download' do
		if File.exist?("c:/users/alexander/ruby/proekt/files/#{params[:userid]}/public/#{params[:fileid]}")
			send_file "./files/#{params[:userid]}/#{params[:fileid]}", :filename => params[:fileid],:type => 'Application/octet-stream'
		else
			"./files/#{params[:userid]}/#{params[:fileid]}"
		end
	end

	get '/userid=:userid/file=:fileid/delete' do
		File.delete("c:/users/alexander/ruby/proekt/files/#{params[:userid]}/public/#{params[:fileid]}")
  			redirect "/fmanager/userid=#{params[:userid]}"
	end


	get '/fmanager/userid=:userid/files/file=:fileid/download' do
		if (session[:username] == params[:userid])
			user = User.find_by(username: params[:userid])
			@user      = user.username
			send_file "./files/#{username}/#{params[:fileid]}", :filename => params[:fileid],:type => 'Application/octet-stream'
		else
				"Forbidden"
		end
	end

	get '/fmanager/userid=:userid/files/file=:fileid/remove' do 
		if (session[:username] == params[:userid])
			user = User.find_by(username: params[:userid])
			@user      = user.username
			File.delete("./files/#{username}/#{params[:fileid]}")
  			redirect '/'
		else
				"Forbidden"
		end
	end
#end