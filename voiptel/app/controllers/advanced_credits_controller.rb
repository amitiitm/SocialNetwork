class AdvancedCreditsController < ApplicationController
  def index
    condition = "is_paid = 0 AND category IN (1)"
    has_pager(Credit, condition, 25)
    @credits = Credit.find(:all, :conditions => condition, :order=> "created_at DESC", :offset => @start, :limit => @limit)
    @path = "/advanced_credits"
    respond_to do |format|
      format.html { render :partial => "index", :layout => 'application_new' }
      if params[:page].blank?
        format.js { render :layout => false }
      else
        format.js { render :partial => 'index', :layout => false }
      end
    end
  end

  def destroy
    tr = Credit.find(params[:id])

    @acc = Account.find(tr.account_id)
    @acc.balance = @acc.balance - tr.amount.to_f
    @acc.save(false)

    tr.is_paid = 1
    tr.save(false)
  end

  def show_notes
    @credit_notes = Credit.find_by_id(params[:id])
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
