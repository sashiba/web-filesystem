require_relative './spec_helper'

describe "Users service" do
  include Rack::Test::Methods

  it "should display index page" do
    get '/'
    expect(last_response).to be_ok
  end

  it "should display login page" do
    get '/login'
    expect(last_response).to be_ok
  end

  it "should login with user" do 
    post '/login', params = {:userid => 'test2', :psw => '2'}
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/home/userid=test2')
  end 

  it "Not enough params" do 
    post '/login', params = {:userid => '', :psw => ''}
    expect(last_response.body).to eq ('<a href="/login"> Some fields are empty.</a>')
  end

  it "wrong password" do 
    post '/login', params = {:userid => 'test2', :psw => '123'}
    expect(last_response.body).to eq ('<a href="/login"> User is missing or wrong password.</a>')
  end

  it "should logout" do
    get '/logout', :session => {:username => nil}
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/')
  end

  it "home with session" do
    username = 'test2'
    post '/login', params = {:userid => username, :psw =>"1"}
    get "/home/userid=#{username}"
    expect(last_response).to be_ok
  end

  it "home with no session" do 
    get 'home/userid='
    expect(last_response.status).to eq(404) 
  end 

  it "with no current session - forbiden" do
    username = "error"
    post '/login' , params = {:userid => username, :psw =>1}
    get "home/userid=#{username}"
    expect(last_response.body).to eq('<a href="/login"> Forbidden</a>') 
  end

  it "display profile page" do
    username = 'test2'
    post '/login', params = {:userid => username, :psw =>"1"}
    get "profile/userid=#{username}"
    expect(last_response).to be_ok
  end

  it "no session profile page - Forbidden" do
    username = 'error'
    post '/login', params = {:userid => username, :psw =>"1"}
    get "profile/userid=#{username}"
    expect(last_response.body).to eq('<a href="/login"> Forbidden</a>')
  end

  it "profile with no session" do 
    get 'profile/userid='
    expect(last_response.status).to eq(404) 
  end 

  it "change pw in profile" do
   post 'profile/userid=test2', params = {:psw => '1', :pswNew => '2', :pswNew1 => '2'}
   expect(last_response).to be_ok
  end

  it "should display Wrong password" do
    post 'profile/userid=test2', params = {:psw => '5',:pswNew => '1', :pswNew1 => '2'}
    expect(last_response.body).to eq ('Wrong passwords')
  end

  it "should display signup" do
    get '/signup'
    expect(last_response).to be_ok
  end

  it "Singing up - already existing username" do
    post '/signup', params = {:userid => 'test2', 
                              :psw => '1',
                              :email => '1',
                              :firstname => '1',
                              :lastname => '1'}
    expect(last_response.body).to eq('<a href="/signup"> Username taken</a>')
  end

  it "Sing up - with no errors" do
    User.find_by(:username => "rspec1").destroy
    post '/signup', params = {:userid => 'rspec1', 
                              :psw => 'rspec', 
                              :email => 'rspec@rspec.com',
                              :firstname => 'Rspec',
                              :lastname => 'Rspec'}
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq ('/')
    #User.find_by(:username => "rspec1").destroy
  end
end