class ForwardingsController < ApplicationController
  def index
    @account = Account.find(params[:id])
    @forwardings = @account.forwardings
    resp
  end
  
  def show
    @forwarding = Forwarding.find(params[:id])
    resp
  end
  
  def new
    @forwarding = Forwarding.new
    resp
  end
  
  def create
    @forwarding = Forwarding.new(params[:forwarding])
    @path = forwardings_path
    resp @forwarding.save
  end
  
  def edit
    @forwarding = Forwarding.find(params[:id])
    resp
  end
  
  def update
    @forwarding = Forwarding.find(params[:id])
    @path = forwardings_path
    resp @forwarding.update_attributes(params[:forwarding])
  end
  
  def destroy
    @forwarding = Forwarding.find(params[:id])
    @path = forwardings_path
    resp @forwarding.destroy
  end
end
