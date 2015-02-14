require_relative './spec_helper'

describe "forgot routes" do
  include Rack::Test::Methods

  it "should display /forgot route" do
    get '/forgot'
    expect(last_response).to be_ok
    expect(last_response.status).to eq (200)
  end

  it "should display /resetpw route" do
    get '/resetpw'
    expect(last_response).to be_ok
    expect(last_response.status).to eq (200)
  end

  it "post /forgot - wrong details" do
    post '/forgot', params = { :userid => 'tozigonqma' }
    expect(last_response.body).to eq ('<a href="/forgot"> Wrong details</a>')
  end

  it "post /forgot - wrong details 2" do
    post '/forgot', params = { :userid => 'test1', :email => "greshenemail" }
    expect(last_response.body).to eq ('<a href="/forgot"> Wrong details</a>')
  end
  it "post / forgot - correct" do
    post '/forgot', params = { :userid => 'test1', :email => "test@gmail.com" }
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/resetpw')
  end

  it "post /resetpw" do
    post '/resetpw', params = {:psw => '1'}
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq('/')
  end
end