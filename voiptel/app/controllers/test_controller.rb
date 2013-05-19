class TestController < ApplicationController
  def logger
    nil
  end
  
  def gs
    if not params[:id].blank?
      @b = Baghali.new(params[:id])
    else
      @b = nil
    end  
  end

  def index
        
  end
  
  def upload
    resp
  end
  
  def slide
    resp
  end
  
  def hg
    @eta = `tail -1 /tmp/logs`.gsub("\t", " | ")
    year = params[:year]
    year = (year.blank?) ? 2010 : year
    data = shaftak_baghali(year)
    @h = HighChart.new('graph') do |f|
      f.series(
        :name=>"Traffic - #{year}",
        :data=> data[:datas],
        :dataLabels => {
          :enabled => true,
          #:rotation => -45,
          #:x => -30, :y => 30,
          :y => -10,
          :color => "#FFFFFF",
          #:align => "right",
          :style => "font: 'normal 13px Verdana, sans-serif'; color: #FFFFFF",          
        }
      )
      #f.options[:legend] = {:layout => "vertical", :style => {:left => "auto", :bottom => "auto", :right => "50px", :top => "350px"}}
      f.options[:title] = {:text=>"Monthly Traffic - #{year}"}
      f.options[:chart][:defaultSeriesType] = "areaspline"
      f.options[:chart][:inverted] = false
      f.options[:x_axis][:categories] = MONTHS
      f.options[:y_axis][:title] = {:text => "Minutes", :x => -20}
      min = data[:min]
      if min < 0
        min = 0
      end
      f.options[:y_axis][:min] = min
    end
    resp    
  end
  
  def shaftak_baghali(year)
    datas = []
    
    cache = CachedApCdr.find(:first, :conditions => {:month => "#{year}-01-01"})
    if cache
      min = max = cache.duration / 60
    else
      min = max = 0
    end
    
    months_in_year(year).each do |m|
      cache = CachedApCdr.find(:first, :conditions => {:month => m})
      if cache
        minutes = (cache.duration / 60)
        if min > minutes
          min = minutes
        end
        if max < minutes
          max = minutes
        end
      else
        data = 0
      end
      datas << minutes
    end
    
    {:min => min, :max => max, :datas => datas}
    
  end
  
  def ghaz
    Thread.new {
      Ghazanfar.new
    }
  end
  
  def spawn
    Thread.new do
      sleep 5
      Rails.logger.info {"Done with baghali"}
    end
  end
  
  def download
    @files = MyFile.all
  end
  
  def ac
    q = params[:q]
    @users = User.find(:all, :conditions => ["first_name like ? or last_name like ?", "%#{q}%", "%#{q}%"])
    render :layout => false
  end
  
  def shafang
    @q = params[:query]
    @users = User.find(:all, :conditions => ["first_name like ? or last_name like ?", "%#{params[:query]}%", "%#{params[:query]}%"])
    respond_to do |format|
      format.json {render :template => "test/name.json.erb", :layout => false}
    end
  end
  
  def send_data
    render :juggernaut do |page|
      page["#chat_data"].prepend "<li>#{h params[:chat_input]}</li>"
    end
    render :nothing => true
  end
  
  def phone
    @q = params[:query]
    @phones = Phone.find(:all, :conditions => ["number like ?", "%#{params[:query]}%"])
    respond_to do |format|
      format.json {render :template => "test/phone.json.erb", :layout => false}
    end
  end
  
  def shaf
    @user = User.find(params[:user_id])
  end
  
  def dyjs
    render :template => "test/dyjs.html.erb", :layout => false
  end
  
  def ex
    @accounts = Account.all
  end
  
  def new_layout
    render :layout => "layout"
  end
  
  def baghali
    cols = params[:cols]
    render :text => "Okeyt"
    cols.keys.each do |k|
      cols[k].each do |i|
        logger.info { "#{k}:#{i}" }
      end
    end
  end
    
end
