module AuthenticatedTestHelper
  # Sets the current user in the session from the user fixtures.
  #set_fixture_class :users=>Admin::User
=begin
  def login_as(user)
    @request.session[:user_id] = user ? users(user).id : nil
  end

  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'test') : nil
  end
=end  
end
