class MyApp < Sinatra::Base

  get '/' do 
    erb :index
  end

  get '/login' do
    if session[:username] != nil
      '<a href="/logout"> You must log out first </a>'
    else
     erb :login
    end
  end

  post '/login' do 
    b = (params[:userid].length == 0 or params[:psw].length == 0)
    if b == false
      user = User.authenticate(params[:userid], params[:psw])
      if user 
        session[:username] = params[:userid]
        @list = Dir.glob("./files/#{username}/*.*").map{ |f| f.split('/').last }
        redirect "/home/userid=#{username}"
      else 
        '<a href="/login"> User is missing or wrong password.</a>'
      end
    else
      '<a href="/login"> Some fields are empty.</a>'
    end
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
      '<a href="/login"> Forbidden</a>'
    end
  end

  post '/profile/userid=:userid' do
    @userchange = User.find_by(username: params[:userid])
    if PasswordHash::validatePassword(params[:psw],@userchange.password) && (params[:pswNew] == params[:pswNew1])
      @userchange.password = PasswordHash::createHash(params[:pswNew])
      @userchange.save
      "Changed password"
      redirect "/profile/userid=#{username}"
    else
      "Wrong passwords"
    end
  end

  get '/signup' do
    erb :signup, locals: {messages: nil}
  end

  post '/signup' do
    reg = RegisterVerification.new
    reg.import( userid: params[:userid],
                email: params[:email],
                psw: params[:psw],
                firstname: params[:firstname],
                lastname: params[:lastname]
                )    
    if reg.verification == false
      erb :signup, :locals => { messages: reg.getMessages}
    else
      if User.find_by(username: params[:userid])
        '<a href="/signup"> Username taken</a>'
      else
        user = User.new(username: params[:userid],
                        password: PasswordHash::createHash(params[:psw]),
                        accdetails:(params[:firstname] + ' ' + params[:lastname]),
                        email: params[:email], vip: 0, filecount: 0)
        user.save if user.valid?
        Dir.mkdir("C:/Users/Alexander/ruby/proekt/files/#{params[:userid]}") unless File.exists?("C:/Users/Alexander/ruby/proekt/files/#{params[:userid]}")
        Dir.mkdir("C:/Users/Alexander/ruby/proekt/files/#{params[:userid]}/public") unless File.exists?("C:/Users/Alexander/ruby/proekt/files/#{params[:userid]}/public")
        redirect ('/')
     end
   end
  end

  get '/home/userid=:userid' do
    if (session[:username] == params[:userid])
      user = User.find_by(username: params[:userid])
      @user      = user.username
      erb :home
    else
      '<a href="/login"> Forbidden</a>'
    end
  end
end