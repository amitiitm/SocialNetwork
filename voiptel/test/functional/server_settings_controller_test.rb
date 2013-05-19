require 'test_helper'

class ServerSettingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:server_settings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create server_setting" do
    assert_difference('ServerSetting.count') do
      post :create, :server_setting => { }
    end

    assert_redirected_to server_setting_path(assigns(:server_setting))
  end

  test "should show server_setting" do
    get :show, :id => server_settings(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => server_settings(:one).to_param
    assert_response :success
  end

  test "should update server_setting" do
    put :update, :id => server_settings(:one).to_param, :server_setting => { }
    assert_redirected_to server_setting_path(assigns(:server_setting))
  end

  test "should destroy server_setting" do
    assert_difference('ServerSetting.count', -1) do
      delete :destroy, :id => server_settings(:one).to_param
    end

    assert_redirected_to server_settings_path
  end
end
