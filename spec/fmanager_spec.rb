require_relative './spec_helper'
require 'rack/test'

describe "fmanager routes" do
  include Rack::Test::Methods

  it "should display fmanager page" do
    username = 'test2'
    post '/login', params = {:userid => username, :psw =>'2'}
    get "/fmanager/userid=#{username}"
    expect(last_response).to be_ok
  end

  it "fmanager with no session" do
    get 'fmanager/userid='
    expect(last_response.status).to eq(404) 
  end 

  it "fmanager with no current session - forbidden" do
    username = "error"
    post '/login' , params = {:userid => username, :psw =>1}
    get "fmanager/userid=#{username}"
    expect(last_response.body).to eq('<a href="/login"> Forbidden</a>') 
  end

  it "should display fmanager upload - ok" do
    username = 'test2'
    post '/login', params = {:userid => username, :psw =>"1"}
    get "/fmanager/userid=#{username}/upload"
    expect(last_response).to be_ok
  end

  it "fmanager upload - forbidden" do
    username = "error"
    post '/login' , params = {:userid => username, :psw =>1}
    get "/fmanager/userid=#{username}/upload"
    expect(last_response.body).to eq('<a href="/login"> Forbidden</a>') 
  end

 it "fmanager post /upload - ok" do
    username = 'rspec'
    post '/fmanager/userid=rspec/upload', 
    params = { :filename => "test_file.jpg",
      :tempfile => Rack::Test::UploadedFile.new('C:/Users/Alexander/ruby/proekt/spec/test_file.jpg', 'image/jpg')
    }
      file_path = "c:/users/alexander/ruby/proekt/spec/test_file.jpg"
      dest_path = "c:/users/alexander/ruby/proekt/files/rspec/"
      FileUtils.cp(file_path, dest_path)
    expect(last_response).to be_ok
    expect(File).to exist('../files/rspec/test_file.jpg')
    #File.delete("../files/rspec/test_file.jpg")
  end

  it "fmanager/files with no current session - forbidden" do
    username = "error"
    post '/login' , params = {:userid => "error", :psw =>1}
    get "/fmanager/userid=test2/files/file=Chapter14.doc"
    expect(last_response.body).to eq('<a href="/login"> Forbidden</a>') 
  end

  it "fmanager/files with session" do
    post '/login', params = {:userid => "rspec", :psw => "rspec"}
    get "/fmanager/userid=rspec/files/file=test_file.jpg"
    expect(last_response).to be_ok

  end

  it "fmanager/files/download get" do
    username = "test2"
    post '/login' , params = {:userid => username, :psw =>1}
    fileid = "test_file.jpg"
    get "/fmanager/userid=#{username}/files/file=#{fileid}/download"
    expect(last_response).to be_ok
  end

  it "should show public link" do
    username = "rspec"
    post '/login' , params = {:userid => username, :psw =>'rspec'}
    fileid = "test_file.jpg"
    get '/userid=rspec/file=test_file.jpg'
    expect(last_response.body).to eq("localhost:9292/userid=#{params[:userid]}/file=#{fileid}/download") 
  end

  it "should download file" do
    fileid = "test_file.jpg"
    userid = "rspec"
    get '/userid=rspec/file=test_file.jpg/download' 
    expect(last_response.headers['Content-Type']).to eq "Application/octet-stream"
  end

  it "should show non existing file" do
    get '/userid=rspec/file=non.non/download'
    expect(last_response.body).to eq ('Non existing file.')
  end
  
  it "should delete public link" do
    fileid = "test_file.jpg"
    username = "rspec"
    post '/login' , params = {:userid => username, :psw =>'rspec'}
    get '/userid=rspec/file=test_file_del.jpg/delete' 
    expect(last_response).to be_redirect
    file_path = "c:/users/alexander/ruby/proekt/files/rspec/test_file_del.jpg"
    dest_path = "c:/users/alexander/ruby/proekt/files/rspec/public"
    FileUtils.cp(file_path, dest_path)  
  end

  it "should return forbidden - delete public link" do
    get '/userid=rspec/file=test_file_del.jpg/delete' 
    expect(last_response.body).to eq('<a href="/login"> Forbidden</a>')
  end
end