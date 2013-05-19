class MemosController < ApplicationController
  def index
    @memoable = find_memoable
    if @memoable.class.reflections[:memos]
      @memos = @memoable.memos.find(:all, :order => "created_at desc")
    else
      @memos = (@memoable.memo) ? [@memoable.memo] : []
    end

    resp
  end

  def new
    @memoable = find_memoable
    @memo = Memo.new()
    @memo.created_by_id = session[:admin_user_id].to_i
    @memo.followup = true
    resp
  end

  def edit
    @memo = Memo.find(params[:id])
    @memoable = @memo.memoable
    resp
  end

  def latest_memo_notes
    @account = Account.find_by_id(params[:id])
    begin
      @account = Account.find_by_id(params[:id])
      @memo = @account.memos.find(:first, :order => "created_at desc")
    rescue
      @memo = []
    end
    resp
  end

  def memo_note
    @account = Account.find(params[:id])
    @memo = Memo.find(:first, :order => "created_at desc")
    resp
  end


  def view_and_assign

  end

  def contactable_numbers
    @memo = Memo.find(params[:id])
    @memoable = params[:memoable_type].constantize.find(params[:memoable_id])
    resp
  end

  def assign

  end

  def create
    @memoable = find_memoable
    if @memoable.class.reflections[:memos]
      @memo = @memoable.memos.build(params[:memo])
    else
      @memo = @memoable.memo = Memo.new(params[:memo])
    end
    @result = @memo.save

    resp(@result)
  end

  def update
    @memo = Memo.find(params[:id])
    @result = @memo.update_attributes(params[:memo])

    if @result
      emails = params[:emails] || {}
      emails.keys.each do |k|
        if emails[k] == "1"
          NotificationTemplate.send_notification(@memo.memo_updates.last, k)
        end
      end
    end

    resp(@memo.valid?)
  end

  def destroy
    @memo = Memo.find(params[:id]).destroy
  end

  def batch_assign
    ids = params[:ids]
    assign_to = params[:assign_to].to_i
    ids.split(",").each do |id|
      memo = Memo.find(id)
      params[:memo].keys.each do |k|
        params[:memo].delete(k) if params[:memo][k].blank?
      end
      memo.update_attributes(params[:memo])
    end
  end

  def batch_create
    ids = params[:ids]
    @memo = memo_template = Memo.new(params[:memo])
    if memo_template.valid?
      @errors = false
      ids.split(",").each do |id|
        memo = memo_template.clone
        memo.memoable_id = id.to_s
        memo.save
      end
    else
      @errors = memo_template.errors.full_messages.join("\n")
    end
  end

  def all
    if session[:admin_user_id].to_i > 2
      unless params[:form_filter]
        params[:form_filter] = Hash.new
      end
      params[:form_filter][:assigned_to_id] = session[:admin_user_id].to_s
    end


    has_advanced_pager(Memo, :limit => 10)

    @memos = Memo.find(
        :all,
        :conditions => [@sql_conditions],
        :order => "created_at DESC", :offset => @start, :limit => @limit
    )

    @path = all_memos_path
    resp
  end

  def reassign
    if session[:admin_user_id].to_i > 2
      unless params[:form_filter]
        params[:form_filter] = Hash.new
      end
      params[:form_filter][:assigned_to_id] = session[:admin_user_id].to_s
    end


    has_advanced_pager(Memo, :limit => 10)

    @memos = Memo.find(
        :all,
        :conditions => [@sql_conditions],
        :order => "created_at DESC", :offset => @start, :limit => @limit
    )

    @path = reassign_memos_path
    resp
  end

  private
  def find_memoable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
