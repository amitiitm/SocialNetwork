class JsController < ApplicationController
  layout false
  
  def cdr_grid
    @disposition = params[:disposition]
    @id = params[:account_id]
  end
  
end
