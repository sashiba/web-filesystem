class MyApp < Sinatra::Base

  get '/fmanager/userid=:userid' do
    if (session[:username] == params[:userid])
      user = User.find_by(username: params[:userid])
      @user = user.username
      @list = Dir.glob("./files/#{username}/*.*").map{ |f| f.split('/').last }
      erb :fmanager
    else
      '<a href="/login"> Forbidden</a>'
    end
  end

  get '/fmanager/userid=:userid/upload' do 
    if (session[:username] == params[:userid])
      user = User.find_by(username: params[:userid])
      @user = user.username
      erb :upload
    else
      '<a href="/login"> Forbidden</a>'
    end
  end

  post '/fmanager/userid=:userid/upload' do
    if (session[:username] == params[:userid])
      user = User.find_by(username: params[:userid])
      @user = user.username
      if user.filecount <= 15
        File.open("c:/users/alexander/ruby/proekt/files/#{username}/" + params['myfile'][:filename], "wb") do |f|
          f.write(params['myfile'][:tempfile].read)
        end
        user.filecount = user.filecount + 1
        user.save
        return "The file was successfully uploaded!"
      else
      "Buy Vip."
      end
    else
      '<a href="/login"> Forbidden</a>'
    end
  end 

  get '/fmanager/userid=:userid/files/file=:fileid' do
    if (session[:username] == params[:userid])
      user = User.find_by(username: params[:userid])
      @user = user.username
      @idfile = params[:fileid]
      erb :file   
    else
      '<a href="/login"> Forbidden</a>'
    end
  end

  get '/userid=:userid/file=:fileid' do
    if File.exist?("c:/users/alexander/ruby/proekt/files/#{username}/public/#{params[:fileid]}")
      "localhost:9292/userid=#{params[:userid]}/file=#{params[:fileid]}/download"
    else
      file_path = "c:/users/alexander/ruby/proekt/files/#{username}/#{params[:fileid]}"
      dest_path = "c:/users/alexander/ruby/proekt/files/#{username}/public/"
      FileUtils.cp(file_path, dest_path)
        redirect "/userid=#{params[:userid]}/file=#{params[:fileid]}"
    end
  end

  get '/userid=:userid/file=:fileid/download' do
    if File.exist?("c:/users/alexander/ruby/proekt/files/#{params[:userid]}/public/#{params[:fileid]}")
      send_file "./files/#{params[:userid]}/#{params[:fileid]}", :filename => params[:fileid],:type => 'Application/octet-stream'
    else
      "Non existing file."
    end
  end

  get '/userid=:userid/file=:fileid/delete' do
    if (session[:username] == params[:userid])
      File.delete("c:/users/alexander/ruby/proekt/files/#{params[:userid]}/public/#{params[:fileid]}")
      redirect "/fmanager/userid=#{params[:userid]}"
    else
      '<a href="/login"> Forbidden</a>'
    end
  end

  get '/fmanager/userid=:userid/files/file=:fileid/download' do
    if (session[:username] == params[:userid])
      user = User.find_by(username: params[:userid])
      @user = user.username
      send_file "./files/#{username}/#{params[:fileid]}", :filename => params[:fileid],:type => 'Application/octet-stream'
    else
      '<a href="/login"> Forbidden</a>'
    end
  end

  get '/fmanager/userid=:userid/files/file=:fileid/remove' do 
    if (session[:username] == params[:userid])
      user = User.find_by(username: params[:userid])
      @user = user.username
      File.delete("./files/#{username}/#{params[:fileid]}")
      redirect "/fmanager/userid=#{params[:userid]}" 
    else
      '<a href="/login"> Forbidden</a>'
    end
  end
end