class FailedCreditcardsController < ApplicationController
  def index
    month = Time.now.month
    year = Time.now.year
    # condition = "success != 1 AND transaction_reference_id != 'null' AND transaction_reference_id IN (SELECT id FROM transaction_references WHERE is_deleted = 0 AND (exp_year >= #{year} AND exp_month >= #{month}))"
    condition = "success != 1 AND transaction_reference_id != 'null' AND transaction_reference_id IN (SELECT id FROM transaction_references WHERE is_deleted = 0 AND id NOT IN (SELECT id FROM transaction_references WHERE exp_year < #{year}) AND id NOT IN (SELECT id FROM transaction_references WHERE exp_year = #{year} AND exp_month < #{month}))"
    has_pager(OrderTransaction, condition, 25)
    @credit_cards = OrderTransaction.find(:all, :conditions => condition, :order=> "created_at, transaction_reference_id DESC", :offset => @start, :limit => @limit)
    @path = "/failed_creditcards"
    respond_to do |format|
      format.html { render :partial => "index", :layout => 'application_new' }
      if params[:page].blank?
        format.js { render :layout => false }
      else
        format.js { render :partial => 'index', :layout => false }
      end
    end
  end

  def show_notes
    @credit_notes = OrderTransaction.find_by_id(params[:id])
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
