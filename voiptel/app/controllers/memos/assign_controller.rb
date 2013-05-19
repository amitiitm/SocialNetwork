class Memos::AssignController < ApplicationController
  
  def create
    
  end
  
  def leads
    has_pager(Lead, {}, 50)
    @filter = FormFilter.new(params[:form_filter])

    @leads = Lead.find(:all, :conditions => @conditions.merge(@filter_conditions), :order => "created_at DESC", :offset => @start, :limit => @limit)
    @path = leads_memo_assign_path
    resp
  end
  
end
