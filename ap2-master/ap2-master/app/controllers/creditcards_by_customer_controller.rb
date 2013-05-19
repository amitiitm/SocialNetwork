class CreditcardsByCustomerController < ApplicationController
  def index
    condition = "admin_user_id is null"
    has_pager(TransactionReference, condition, 25)
    @credit_cards = TransactionReference.find(:all, :conditions => condition, :order=> "created_at DESC", :offset => @start, :limit => @limit)
    @path = "/creditcards_by_customer"
    respond_to do |format|
      format.html { render :partial => "cc_by_customer", :layout => 'application_new' }
      if params[:page].blank?
        format.js { render :layout => false }
      else
        format.js { render :partial => 'index', :layout => false }
      end
    end
  end

  def destroy
    tr = TransactionReference.find(params[:id])
    @account_id = tr.account.id
    tr.is_deleted = 1
    tr.save
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
