Account.all.each do |account|
  account.users.each do |user|
    tmp_password = TmpPassword.new
    tmp_password.password = AuthUser.random_password
    
    auth_user = AuthUser.new
    auth_user.tmp_password = tmp_password
    auth_user.password = tmp_password.password
    auth_user.password_confirmation = tmp_password.password    
    auth_user.user = user
    
    if user.email.blank?
      login = "#{user.first_name[0..0]}.#{user.last_name}".downcase
      auth_user.email = "#{login}@NOTVALID"
      auth_user.login = login
    else
      auth_user.login = user.email
      auth_user.email = user.email
    end
    
    begin
      auth_user.save_without_validation
    rescue Exception => e
      login = "#{user.first_name[0..0]}.#{user.last_name}".downcase
      auth_user.email = "#{login}@NOTVALID"
      auth_user.login = login
      auth_user.save_without_validation
    end
        
  end
end