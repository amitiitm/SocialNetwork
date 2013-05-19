require File.dirname(__FILE__) + '/../spec_helper'
  
# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe AdminUsersController do
  fixtures :admin_users

  it 'allows signup' do
    lambda do
      create_admin_user
      response.should be_redirect
    end.should change(AdminUser, :count).by(1)
  end

  


  it 'requires login on signup' do
    lambda do
      create_admin_user(:login => nil)
      assigns[:admin_user].errors.on(:login).should_not be_nil
      response.should be_success
    end.should_not change(AdminUser, :count)
  end
  
  it 'requires password on signup' do
    lambda do
      create_admin_user(:password => nil)
      assigns[:admin_user].errors.on(:password).should_not be_nil
      response.should be_success
    end.should_not change(AdminUser, :count)
  end
  
  it 'requires password confirmation on signup' do
    lambda do
      create_admin_user(:password_confirmation => nil)
      assigns[:admin_user].errors.on(:password_confirmation).should_not be_nil
      response.should be_success
    end.should_not change(AdminUser, :count)
  end

  it 'requires email on signup' do
    lambda do
      create_admin_user(:email => nil)
      assigns[:admin_user].errors.on(:email).should_not be_nil
      response.should be_success
    end.should_not change(AdminUser, :count)
  end
  
  
  
  def create_admin_user(options = {})
    post :create, :admin_user => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
  end
end

describe AdminUsersController do
  describe "route generation" do
    it "should route admin_users's 'index' action correctly" do
      route_for(:controller => 'admin_users', :action => 'index').should == "/admin_users"
    end
    
    it "should route admin_users's 'new' action correctly" do
      route_for(:controller => 'admin_users', :action => 'new').should == "/signup"
    end
    
    it "should route {:controller => 'admin_users', :action => 'create'} correctly" do
      route_for(:controller => 'admin_users', :action => 'create').should == "/register"
    end
    
    it "should route admin_users's 'show' action correctly" do
      route_for(:controller => 'admin_users', :action => 'show', :id => '1').should == "/admin_users/1"
    end
    
    it "should route admin_users's 'edit' action correctly" do
      route_for(:controller => 'admin_users', :action => 'edit', :id => '1').should == "/admin_users/1/edit"
    end
    
    it "should route admin_users's 'update' action correctly" do
      route_for(:controller => 'admin_users', :action => 'update', :id => '1').should == "/admin_users/1"
    end
    
    it "should route admin_users's 'destroy' action correctly" do
      route_for(:controller => 'admin_users', :action => 'destroy', :id => '1').should == "/admin_users/1"
    end
  end
  
  describe "route recognition" do
    it "should generate params for admin_users's index action from GET /admin_users" do
      params_from(:get, '/admin_users').should == {:controller => 'admin_users', :action => 'index'}
      params_from(:get, '/admin_users.xml').should == {:controller => 'admin_users', :action => 'index', :format => 'xml'}
      params_from(:get, '/admin_users.json').should == {:controller => 'admin_users', :action => 'index', :format => 'json'}
    end
    
    it "should generate params for admin_users's new action from GET /admin_users" do
      params_from(:get, '/admin_users/new').should == {:controller => 'admin_users', :action => 'new'}
      params_from(:get, '/admin_users/new.xml').should == {:controller => 'admin_users', :action => 'new', :format => 'xml'}
      params_from(:get, '/admin_users/new.json').should == {:controller => 'admin_users', :action => 'new', :format => 'json'}
    end
    
    it "should generate params for admin_users's create action from POST /admin_users" do
      params_from(:post, '/admin_users').should == {:controller => 'admin_users', :action => 'create'}
      params_from(:post, '/admin_users.xml').should == {:controller => 'admin_users', :action => 'create', :format => 'xml'}
      params_from(:post, '/admin_users.json').should == {:controller => 'admin_users', :action => 'create', :format => 'json'}
    end
    
    it "should generate params for admin_users's show action from GET /admin_users/1" do
      params_from(:get , '/admin_users/1').should == {:controller => 'admin_users', :action => 'show', :id => '1'}
      params_from(:get , '/admin_users/1.xml').should == {:controller => 'admin_users', :action => 'show', :id => '1', :format => 'xml'}
      params_from(:get , '/admin_users/1.json').should == {:controller => 'admin_users', :action => 'show', :id => '1', :format => 'json'}
    end
    
    it "should generate params for admin_users's edit action from GET /admin_users/1/edit" do
      params_from(:get , '/admin_users/1/edit').should == {:controller => 'admin_users', :action => 'edit', :id => '1'}
    end
    
    it "should generate params {:controller => 'admin_users', :action => update', :id => '1'} from PUT /admin_users/1" do
      params_from(:put , '/admin_users/1').should == {:controller => 'admin_users', :action => 'update', :id => '1'}
      params_from(:put , '/admin_users/1.xml').should == {:controller => 'admin_users', :action => 'update', :id => '1', :format => 'xml'}
      params_from(:put , '/admin_users/1.json').should == {:controller => 'admin_users', :action => 'update', :id => '1', :format => 'json'}
    end
    
    it "should generate params for admin_users's destroy action from DELETE /admin_users/1" do
      params_from(:delete, '/admin_users/1').should == {:controller => 'admin_users', :action => 'destroy', :id => '1'}
      params_from(:delete, '/admin_users/1.xml').should == {:controller => 'admin_users', :action => 'destroy', :id => '1', :format => 'xml'}
      params_from(:delete, '/admin_users/1.json').should == {:controller => 'admin_users', :action => 'destroy', :id => '1', :format => 'json'}
    end
  end
  
  describe "named routing" do
    before(:each) do
      get :new
    end
    
    it "should route admin_users_path() to /admin_users" do
      admin_users_path().should == "/admin_users"
      formatted_admin_users_path(:format => 'xml').should == "/admin_users.xml"
      formatted_admin_users_path(:format => 'json').should == "/admin_users.json"
    end
    
    it "should route new_admin_user_path() to /admin_users/new" do
      new_admin_user_path().should == "/admin_users/new"
      formatted_new_admin_user_path(:format => 'xml').should == "/admin_users/new.xml"
      formatted_new_admin_user_path(:format => 'json').should == "/admin_users/new.json"
    end
    
    it "should route admin_user_(:id => '1') to /admin_users/1" do
      admin_user_path(:id => '1').should == "/admin_users/1"
      formatted_admin_user_path(:id => '1', :format => 'xml').should == "/admin_users/1.xml"
      formatted_admin_user_path(:id => '1', :format => 'json').should == "/admin_users/1.json"
    end
    
    it "should route edit_admin_user_path(:id => '1') to /admin_users/1/edit" do
      edit_admin_user_path(:id => '1').should == "/admin_users/1/edit"
    end
  end
  
end
