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

class RegisterVerification
  include Enumerable
  def initialize
   @messages = []
  end

  def import(userid:,email:, psw:, firstname:, lastname:)
    @userid = userid
    @email = email
    @psw = psw
    @firstname = firstname
    @lastname = lastname
  end

  def verification
    self.isEmpty
    if @messages == []
      return true
    else
      return false
    end
  end

  def save_user
    user = User.new
  end

  def getMessages
    return @messages
  end

  def user
    return @userid
  end

  def isEmpty
    if ( @userid.length == 0 )
      @messages << "Username field is blank."
    end
    if ( @psw.length == 0 )
      @messages << "Password field is blank."
    end
    if ( @firstname.length == 0 )
      @messages << "Firstname field is blank."
    end
    if ( @lastname.length == 0 )
      @messages << "Lastname field is blank."
    end
    if ( @email.length == 0 )
      @messages << "E-mail field is blank."
    end
  end
end