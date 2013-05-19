class DbStatusController < ApplicationController
  
  def show
    if RAILS_ENV != "production"
      redirect_to(accounts_path)
      return
    end
    
    @db = DBStatus.new
    resp
  end

end
