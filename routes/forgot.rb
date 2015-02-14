class MyApp < Sinatra::Base
  get '/forgot' do
    erb :forgot
  end

  post '/forgot' do
    if User.find_by(username: params[:userid])
      user = User.find_by(username: params[:userid])
    else
      '<a href="/forgot"> Wrong details</a>'
    end
    if (User.find_by(username: params[:userid])) && user.email == params[:email]
      @@userforgot = user
      redirect "/resetpw"
    else
      '<a href="/forgot"> Wrong details</a>'
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
end 