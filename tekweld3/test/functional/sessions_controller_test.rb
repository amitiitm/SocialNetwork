require File.dirname(__FILE__) + '/../test_helper'
require 'session_controller'

# Re-raise errors caught by the controller.
class SessionController; def rescue_action(e) raise e end; end

class SessionControllerTest < Test::Unit::TestCase
 
  fixtures :users
  set_fixture_class :users=>Admin::User
  
  def setup
    @controller = SessionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_login_and_redirect
    post :create, :login => 'martin', :password => 'jewel'
    assert session[:user_id]
    assert_response :redirect
  end

  def test_should_fail_login_and_not_redirect
    post :create, :login => 'martin', :password => 'bad'
    assert_equal "badlogin", @response.body
    assert_nil session[:user_id]
    assert_response :success
  end

  def test_should_logout
    login_as :martin
    get :destroy
    assert_nil session[:user_id]
    assert_response :redirect
  end

  def test_should_remember_me
    post :create, :login => 'martin', :password => 'jewel', :remember_me => "1"
    assert_not_nil @response.cookies["auth_token"]
  end

  def test_should_not_remember_me
    post :create, :login => 'martin', :password => 'jewel', :remember_me => "0"
    assert_nil @response.cookies["auth_token"]
  end

  def test_should_delete_token_on_logout
    login_as :martin
    get :destroy
    assert_equal @response.cookies["auth_token"], []
  end

  def test_should_login_with_cookie
    users(:martin).remember_me
    @request.cookies["auth_token"] = cookie_for(:martin)
    get :create
    assert @controller.send(:logged_in?)
    #assert_equal false, @controller.send(:logged_in?)
  end

  def test_should_fail_expired_cookie_login
    users(:martin).remember_me
    users(:martin).update_attribute :remember_token_expires_at, 5.minutes.ago
    @request.cookies["auth_token"] = cookie_for(:martin)
    get :create
    assert !@controller.send(:logged_in?)
  end

  def test_should_fail_cookie_login
    users(:martin).remember_me
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :create
    assert !@controller.send(:logged_in?)
  end

  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(user)
      auth_token users(user).remember_token
    end

    def login_as(user)
      @request.session[:user_id] = user ? users(user).id : nil
    end    

    def authorize_as(user)
      @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'test') : nil
    end
end
