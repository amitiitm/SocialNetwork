class CardCdrsController < ApplicationController
  def index
    @header_title = "CDRs"
    has_pager(CardCdr, nil)
    @cdrs = CardCdr.find(:all, :conditions => @conditions, :order => "date desc, ivr_seq desc, sequence desc", :offset => @start, :limit => @limit)
    resp                
  end
  
  def etisal_logs
    @cdr = CardCdr.find(params[:id], :select => "session_id")
    @logs = MY_REDIS.get(@cdr.session_id)
    @debug_logs = MY_REDIS.get("#{@cdr.session_id}_debug")
    render :layout => false
  end
end
