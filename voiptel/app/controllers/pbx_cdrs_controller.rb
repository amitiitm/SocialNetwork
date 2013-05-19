class PbxCdrsController < ApplicationController
  def index
    condition = ""
    if params["type"] == "outbound"
      @type = "outbound"
      condition += "(disposition NOT LIKE '%_IN' or disposition is null)"
    else
      @type = "inbound"
      condition += "disposition_status != 0 AND disposition LIKE '%_IN'"
    end
    @contable = find_contactable
    if @contable
      if @contable.class == Account
        user_ids = @contable.users.collect(&:id).join(',')
        condition += " AND contactable_type = 'User' AND contactable_id in (#{user_ids})"
      elsif @contable.class == Card
        condition += " AND contactable_type = 'Card' AND contactable_id = (#{@contable.id})"
      end
    end
    has_pager(PbxCdr, condition, 25)
    @cdrs = PbxCdr.find(:all, :conditions => @conditions, :order => "date desc", :offset => @start, :limit => @limit)
    @path = pbx_cdrs_path

    respond_to do |format|
      format.html { render :partial => "pbx_cdr", :layout => 'application_new' }
      if params[:page].blank?
        format.js { render :layout => false }
      else
        format.js { render :partial => 'inbound', :layout => false }
      end
    end
  end

  def inbound
  
    @type = "inbound"
    condition = "disposition LIKE '%_IN'"
    @contable = find_contactable
    if @contable
      if @contable.class == Account
        user_ids = @contable.users.collect(&:id).join(',')
        condition = "disposition_status != 0 AND disposition LIKE '%_IN' AND contactable_type = 'User' AND contactable_id in (#{user_ids})"
      elsif @contable.class == Card
        condition += " AND contactable_type = 'Card' AND contactable_id = (#{@contable.id})"
      end
    end


    has_pager(PbxCdr, condition, 25)
    @cdrs = PbxCdr.find(:all, :conditions => @conditions, :order => "date desc", :offset => @start, :limit => @limit)
    @path = inbound_pbx_cdrs_path
    respond_to do |format|
      format.html { render :partial => "pbx_cdr", :layout => 'application_new' }
      if params[:page].blank?
        format.js { render :partial => 'inbound', :layout => false }
      else
        format.js { render :partial => 'inbound', :layout => false }
      end
    end
  end

  def outbound
 
    @type = "outbound"
    condition = "disposition NOT LIKE '%_IN'"
    @contable = find_contactable
    if @contable
      if @contable.class == Account
        user_ids = @contable.users.collect(&:id).join(',')
        condition += " AND contactable_type = 'User' AND contactable_id in (#{user_ids})"
      elsif @contable.class == Card
        condition += " AND contactable_type = 'Card' AND contactable_id = (#{@contable.id})"
      end
    end

    has_pager(PbxCdr, condition, 25)
    @cdrs = PbxCdr.find(:all, :conditions => @conditions, :order => "date desc", :offset => @start, :limit => @limit)
    @path = outbound_pbx_cdrs_path
    respond_to do |format|
      format.html { render :partial => "pbx_cdr", :layout => 'application_new' }
      if params[:page].blank?
        format.js { render :partial => 'outbound', :layout => false }
      else
        format.js { render :partial => 'outbound', :layout => false }
      end
    end
  end

  def voicemail
    @pbx_cdr = PbxCdr.find_by_id(params[:id])
    @filename = "vm_#{@pbx_cdr.id}.mp3"
    file_name = RAILS_ROOT+"/public/audio/#{@filename}"
    unless File.exist?(file_name)
      File.open(file_name, 'w') do |f|
        f.write(@pbx_cdr.voicemail)
      end
    end
    render :partial => 'player'
  end

  def recording
    @pbx_cdr = PbxCdr.find_by_id(params[:id])
    @filename = "rc_#{@pbx_cdr.id}.wav"
    file_name = RAILS_ROOT+"/public/audio/#{@filename}"
    unless File.exist?(file_name)
      File.open(file_name, 'w') do |f|
        f.write(@pbx_cdr.recording)
      end
    end
    render :partial => 'player'
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
