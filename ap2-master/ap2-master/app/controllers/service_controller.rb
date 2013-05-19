class ServiceController < ApplicationController
  layout nil
  skip_filter :login_required, :except => [:active_calls, :call]
	def logger
	end

  def call
    #params[:id] = "19498782298"
    admin_user = AdminUser.find(session[:admin_user_id])
    res = Net::HTTP.post_form(URI.parse('http://pbx.voipontel.com:88/service/call'),
            {
              'ext'        => admin_user.ext,
              'phone'        => params[:id],
              'cid'       => admin_user.cid
            })
  end
  
  def account_finder
    @q = params[:q]
    @search_type = nil
    
    case
      when /.*@.*/ === @q
        @users = User.find(:all, :conditions => ["email like ?", "%#{@q}%"])
        @search_type = "email"
      when  /^[\d]+$/ === @q
        @phones = Phone.find(:all, :conditions => ["number like ?", "%#{@q}%"])
        @search_type = "phone"        
      else
        
        #@users = User.find(:all, :conditions => ["first_name like ? or last_name like ?", "%#{@q}%", "%#{@q}%"])
        names = @q.split(" ")
        conditions = ["(first_name like ? or last_name like ?)", "%#{names[0]}%", "%#{names[0]}%"]
        (names.size - 1).times do |i|
          conditions[0] = "#{conditions[0]} and (first_name like ? or last_name like ?)"
          conditions << "%#{names[i+1]}%"
          conditions << "%#{names[i+1]}%"
        end
        @users = []
        if not @q.blank?
          @users = User.find(:all, :conditions => conditions)
        end
        @search_type = "name"        
    end
  end
  
  def did_finder
    @q = params[:q]
    @dids = Did.find(:all,
      :conditions => ["number like ? and did_type = '0'", "%#{@q}%"],
      :select => "id, number, area_code"
    )
  end
  
  def destination
    d = Destination.new(params[:id])
    render :text => d.to_json
  end
  
  def calls_monitor
    @mcl1 = Rails.cache.read("media1_calls")
    @mch1 = Rails.cache.read("media1_channels")
    @mcl2 = Rails.cache.read("media2_calls")
    @mch2 = Rails.cache.read("media2_channels")
    @mcl3 = Rails.cache.read("media3_calls")
    @mch3 = Rails.cache.read("media3_channels")
    @total_cl = @mcl1.to_i + @mcl2.to_i + @mcl3.to_i
    @total_ch = @mch1.to_i + @mch2.to_i + @mch3.to_i
    @seconds = Rails.cache.read("seconds").to_i
    render :layout => false
  end
  
  def df
    resp
  end
  
  def phone
    @q = params[:query]
    @phones = Phone.find(:all, :conditions => ["number like ?", "%#{params[:query]}%"])
    respond_to do |format|
      format.json {render :template => "test/phone.json.erb", :layout => false}
    end
  end
  
  def live
    @q = params[:q]    
    case
      when /^p\d{12}$/ === @q
        if @q.length == 13
          @card = Card.find(:first, :conditions => {:number => @q[1..-1]})
          @search_type = "card"                  
        end
      when /^\D\D\d{5}$/ === @q
        @card = Card.find(:first, :conditions => {:serial => @q})
        @search_type = "card"
      when @q.index("@")
        #email
        @users = User.find(:all, :conditions => ["email LIKE ?", "%#{@q.gsub('@', '%@%')}%"])
        @leads = Lead.find(:all, :conditions => ["email LIKE ?", "%#{@q.gsub('@', '%@%')}%"])
        @users += @leads
        
        @search_type = "email"
      when  /^[\d]+$/ === @q
        if @q.length >= 3
          @phones = Phone.find(:all, :conditions => ["number like ? and user_id IS NOT NULL", "%#{@q}%"])
          @phones += TmpPhone.find(:all, :conditions => ["number like ?", "%#{@q}%"])
          @phones += Lead.find(:all, :conditions => ["phone like ?", "%#{@q}%"])
          @search_type = "phone"
          render :template => "service/live_phone"
        else
          render :text => ""
        end
        
      else        
        unless /^p\d*$/ === @q
          names = @q.split(" ")
          conditions = ["(first_name like ? or last_name like ?)", "%#{names[0]}%", "%#{names[0]}%"]
          (names.size - 1).times do |i|
            conditions[0] = "#{conditions[0]} and (first_name like ? or last_name like ?)"
            conditions << "%#{names[i+1]}%"
            conditions << "%#{names[i+1]}%"
          end
          @users = []
          if not @q.blank?
            @users = User.find(:all, :conditions => conditions)
          end
          @search_type = "name"
        end
      end
        
  end
  
end
