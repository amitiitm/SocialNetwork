require File.dirname(__FILE__) + '/../helper'

RE_Admin_user      = %r{(?:(?:the )? *(\w+) *)}
RE_Admin_user_TYPE = %r{(?: *(\w+)? *)}
steps_for(:admin_user) do

  #
  # Setting
  #
  
  Given "an anonymous admin_user" do 
    log_out!
  end

  Given "$an $admin_user_type admin_user with $attributes" do |_, admin_user_type, attributes|
    create_admin_user! admin_user_type, attributes.to_hash_from_story
  end
  
  Given "$an $admin_user_type admin_user named '$login'" do |_, admin_user_type, login|
    create_admin_user! admin_user_type, named_admin_user(login)
  end
  
  Given "$an $admin_user_type admin_user logged in as '$login'" do |_, admin_user_type, login|
    create_admin_user! admin_user_type, named_admin_user(login)
    log_in_admin_user!
  end
  
  Given "$actor is logged in" do |_, login|
    log_in_admin_user! @admin_user_params || named_admin_user(login)
  end
  
  Given "there is no $admin_user_type admin_user named '$login'" do |_, login|
    @admin_user = AdminUser.find_by_login(login)
    @admin_user.destroy! if @admin_user
    @admin_user.should be_nil
  end
  
  #
  # Actions
  #
  When "$actor logs out" do 
    log_out
  end

  When "$actor registers an account as the preloaded '$login'" do |_, login|
    admin_user = named_admin_user(login)
    admin_user['password_confirmation'] = admin_user['password']
    create_admin_user admin_user
  end

  When "$actor registers an account with $attributes" do |_, attributes|
    create_admin_user attributes.to_hash_from_story
  end
  

  When "$actor logs in with $attributes" do |_, attributes|
    log_in_admin_user attributes.to_hash_from_story
  end
  
  #
  # Result
  #
  Then "$actor should be invited to sign in" do |_|
    response.should render_template('/sessions/new')
  end
  
  Then "$actor should not be logged in" do |_|
    controller.logged_in?.should_not be_true
  end
    
  Then "$login should be logged in" do |login|
    controller.logged_in?.should be_true
    controller.current_admin_user.should === @admin_user
    controller.current_admin_user.login.should == login
  end
    
end

def named_admin_user login
  admin_user_params = {
    'admin'   => {'id' => 1, 'login' => 'addie', 'password' => '1234addie', 'email' => 'admin@example.com',       },
    'oona'    => {          'login' => 'oona',   'password' => '1234oona',  'email' => 'unactivated@example.com'},
    'reggie'  => {          'login' => 'reggie', 'password' => 'monkey',    'email' => 'registered@example.com' },
    }
  admin_user_params[login.downcase]
end

#
# AdminUser account actions.
#
# The ! methods are 'just get the job done'.  It's true, they do some testing of
# their own -- thus un-DRY'ing tests that do and should live in the admin_user account
# stories -- but the repetition is ultimately important so that a faulty test setup
# fails early.  
#

def log_out 
  get '/sessions/destroy'
end

def log_out!
  log_out
  response.should redirect_to('/')
  follow_redirect!
end

def create_admin_user(admin_user_params={})
  @admin_user_params       ||= admin_user_params
  post "/admin_users", :admin_user => admin_user_params
  @admin_user = AdminUser.find_by_login(admin_user_params['login'])
end

def create_admin_user!(admin_user_type, admin_user_params)
  admin_user_params['password_confirmation'] ||= admin_user_params['password'] ||= admin_user_params['password']
  create_admin_user admin_user_params
  response.should redirect_to('/')
  follow_redirect!

end



def log_in_admin_user admin_user_params=nil
  @admin_user_params ||= admin_user_params
  admin_user_params  ||= @admin_user_params
  post "/session", admin_user_params
  @admin_user = AdminUser.find_by_login(admin_user_params['login'])
  controller.current_admin_user
end

def log_in_admin_user! *args
  log_in_admin_user *args
  response.should redirect_to('/')
  follow_redirect!
  response.should have_flash("notice", /Logged in successfully/)
end
