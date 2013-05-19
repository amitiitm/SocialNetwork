class Accounts::EndpointsController < ApplicationController
  layout nil
  
  def index
    @account = Account.find(params[:account_id])
  end
  def create
    @account = Account.find(params[:account_id])
    @endpoint = Endpoint.new(params[:endpoint])
    if @endpoint.save
      @error = false
      @account.endpoints << @endpoint
      @account.save
    else
      @error = @endpoint.errors.full_messages.join("\n")
    end        
  end
  
  def edit
    @account = Account.find(params[:account_id])
    @endpoint = Endpoint.find(params[:id])
  end
  
  def update
    @account = Account.find(params[:account_id])
    @endpoint = Endpoint.find(params[:id])
    if @endpoint.update_attributes(params[:endpoint])
      @error = false
    else
      @error = @endpoint.errors.full_messages.join("\n")
    end
  end
  
  def destroy
    @endpoint = Endpoint.find(params[:id])
    @endpoint.destroy
  end
end
