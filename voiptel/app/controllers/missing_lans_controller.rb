class MissingLansController < ApplicationController
  def index
    # condition = "deleted = 0 AND is_per_lan = 0 AND id NOT IN (SELECT phone_id from assigned_dids) AND account_id IN (select account_id from account_dids)"
    condition = "deleted = 0 AND ((is_per_lan = 0 OR is_per_lan = 2 OR notes is NOT NULL) OR id NOT IN (SELECT phone_id from assigned_dids))"
    # condition = "deleted = 0 AND is_per_lan = 0"
    has_pager(Phone, condition, 25)
    @phones = Phone.find(:all, :conditions => condition, :order=> "created_at DESC", :offset => @start, :limit => @limit)
    @path = "/missing_lans"
    respond_to do |format|
      format.html { render :partial => "index", :layout => 'application_new' }
      if params[:page].blank?
        format.js { render :layout => false }
      else
        format.js { render :partial => 'index', :layout => false }
      end
    end
  end

  def add_notes
    @phones = Phone.find(params[:ph_id])
    @phones.notes = params[:note]
    @phones.save(false)
    render :text => params[:ph_id]
  end

  def destroy
    ph = Phone.find(params[:id])
    ph.is_per_lan = 1
    ph.notes=nil
    ph.save(false)
  end

  private
  def find_contactable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
