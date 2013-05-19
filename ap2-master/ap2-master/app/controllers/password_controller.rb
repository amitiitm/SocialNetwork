class PasswordController < ApplicationController
  def reset
    @user = User.find(params[:id])
  end
  
  def do_reset
    login = params[:login][:login]
    password = params[:login][:password]    
    user = User.find(params[:id])
    
    if user.auth_user.tmp_password
      user.auth_user.tmp_password.password = password
      user.auth_user.tmp_password.save
      
      user.auth_user.password = password
      user.auth_user.password_confirmation = password
      user.auth_user.save
    else
      tmp_password = TmpPassword.new
      tmp_password.password = password
      user.auth_user.tmp_password = tmp_password
      user.auth_user.password = password
      user.auth_user.password_confirmation = password
      user.auth_user.save
    end    
  end

end
