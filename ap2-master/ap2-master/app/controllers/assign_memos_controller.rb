class AssignMemosController < ApplicationController
  
  def leads
    @filter = FormFilter.new(params[:form_filter])
    has_pager(Lead, {}, 50)

    @leads = Lead.find(:all, :conditions => @conditions.merge(@filter_conditions), :order => "created_at DESC", :offset => @start, :limit => @limit)
    @path = leads_assign_memos_path
    resp
  end
  
  def accounts
  end

  def cards
  end

  def create
  end

  def update
  end

end
