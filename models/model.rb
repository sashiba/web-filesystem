class User < ActiveRecord::Base
  def self.authenticate (username, password)
    user = User.find_by(username: username) if  User.find_by(username: username)
    if user && PasswordHash::validatePassword(password, user.password)
      user
    else
      nil
    end
  end
end