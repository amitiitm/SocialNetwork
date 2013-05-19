class LeadsController < ApplicationController
  def upload
    @lead = Lead.new
    @lead.upload = true
    resp
  end  
  
  def index
    has_advanced_pager(Lead, :method => "find_without_memo", :filter_options => {:do_not_call => 0})
    @leads = Lead.find_without_memo(:conditions => [@sql_conditions], :order => "created_at DESC", :offset => @start, :limit => @limit)
    @path = leads_path
    @memoable_type = "Lead"
    resp
  end
  
  def all
    has_advanced_pager(Lead)
    @leads = Lead.find(:all, :conditions => [@sql_conditions], :order => "created_at DESC", :offset => @start, :limit => @limit)
    @path = all_leads_path
    resp
  end
  
  def show
    @lead = Lead.find(params[:id])
    resp
  end
  
  def create
    @lead = Lead.new(params[:lead])
    if @lead.upload == "true"
      @lead.import
    else
      @lead.admin_user_id = session[:admin_user_id]
      @lead.save
    end
    redirect_to leads_path
  end
  
  def update
    @lead = Lead.find(params[:id])
    @lead.update_attributes(params[:lead])
  end
  
end
