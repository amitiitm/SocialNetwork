class HelloController < ApplicationController
  def show
  end
  
  def redirect
    #redirect_to(hello_path("Hello_#{self.current_admin_user.bname}!"))
    redirect_to(accounts_path)
  end

end
