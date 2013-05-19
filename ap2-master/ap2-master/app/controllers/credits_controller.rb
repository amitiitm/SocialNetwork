class CreditsController < ApplicationController
  def index
    has_pager(Credit, nil, 30)
    @credits = Credit.find(:all, :conditions => @conditions, :order => "created_at DESC", :offset => @start, :limit => @limit)
    resp
  end

end
