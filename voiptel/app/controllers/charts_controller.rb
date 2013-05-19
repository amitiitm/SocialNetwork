class ChartsController < ApplicationController
  skip_filter :login_required
  def index

  end
  
  def data
    respond_to do |format|
      format.xml {render :layout => false}
      format.json {render :layout=> false}      
    end
  end
end
