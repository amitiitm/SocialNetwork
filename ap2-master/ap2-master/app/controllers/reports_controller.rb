# YA ALI
class ReportsController < ApplicationController
  
  def old_daily
    @header_title = "Daily Traffic Charts"
    @year = params[:year] || Time.now.strftime("%Y")
    @month = params[:month] || Time.now.strftime("%m")
    @date = Chronic.parse("#{@year}-#{@month}-01")

    @current_month = @date.beginning_of_month == Time.now.beginning_of_month
    
    cc_seconds = CardCdr.answered.sum(:duration, :conditions => ["date > ? and date < ?", @date.beginning_of_month.utc.to_formatted_s(:db), @date.end_of_month.utc.to_formatted_s(:db)])
    @cc_total = cc_seconds.to_i / 60
        
    ac_seconds = Cdr.cc.answered.sum(:duration, :conditions => ["date > ? and date < ?", @date.beginning_of_month.utc.to_formatted_s(:db), @date.end_of_month.utc.to_formatted_s(:db)])
    @ac_total = ac_seconds.to_i / 60
    
    trunk_seconds = Cdr.trunk.answered.sum(:duration, :conditions => ["date > ? and date < ?", @date.beginning_of_month.utc.to_formatted_s(:db), @date.end_of_month.utc.to_formatted_s(:db)])
    @trunk_total = trunk_seconds.to_i / 60
    
    if @current_month
      days_upto_now = Time.now.day - 1
      minutes_upto_now = (Time.now.hour * 60) + Time.now.min
      partial_now = days_upto_now + (minutes_upto_now / 1440.0)
      if partial_now < 1
        partial_now = 1
      end
      
      # access connect
      @ac_yesterday = Cdr.cc.answered.between(Time.now.yesterday.beginning_of_day.utc..Time.now.yesterday.end_of_day.utc).sum(:duration).to_i / 60
      @ac_today = Cdr.cc.answered.sum(:duration, :conditions => {:date => Time.now.beginning_of_day.utc..Time.now.end_of_day.utc}).to_i / 60          
      @ac_partial_average = @ac_total.to_f / partial_now
      @ac_average = @ac_total / Time.now.day
      @ac_partial_average = @ac_partial_average.to_i
      
      # card connect
      @cc_yesterday = CardCdr.answered.between(Time.now.yesterday.beginning_of_day.utc..Time.now.yesterday.end_of_day.utc).sum(:duration).to_i/ 60
      @cc_today = CardCdr.answered.sum(:duration, :conditions => {:date => Time.now.beginning_of_day.utc..Time.now.end_of_day.utc}).to_i / 60    
      @cc_partial_average = @cc_total.to_f / partial_now
      @cc_average = @cc_total / Time.now.day
      @cc_partial_average = @cc_partial_average.to_i
      
      #trunk
      @trunk_yesterday = Cdr.trunk.answered.between(Time.now.yesterday.beginning_of_day.utc..Time.now.yesterday.end_of_day.utc).sum(:duration).to_i/ 60
      @trunk_today = Cdr.trunk.answered.sum(:duration, :conditions => {:date => Time.now.beginning_of_day.utc..Time.now.end_of_day.utc}).to_i / 60
      @trunk_partial_average = @trunk_total.to_f / partial_now
      @trunk_average = @trunk_total / Time.now.day
      @trunk_partial_average = @trunk_partial_average.to_i
    else
      @ac_average = @ac_total / Time.days_in_month(@month.to_i)
      @cc_average = @cc_total / Time.days_in_month(@month.to_i)
      @trunk_average = @trunk_total / Time.days_in_month(@month.to_i)
    end
    resp
  end
  
  def data    
    @year = params[:year] || Time.now.strftime("%Y")
    @month = params[:month] || Time.now.strftime("%m")
    
    render :text => chart_json(@year, @month)       
  end
  
  def data2    
    @year = params[:year] || Time.now.strftime("%Y")
    @month = params[:month] || Time.now.strftime("%m")
    
    render :text => chart_json2(@year, @month)       
  end
  
  def data3
    @year = params[:year] || Time.now.strftime("%Y")
    @month = params[:month] || Time.now.strftime("%m")
    
    render :text => chart_json3(@year, @month)       
  end
  
  def chart_json(year, month)
    labels = []
    values = []

    cache_data = false

    current_month = Time.now.strftime("%m")
    current_year  = Time.now.strftime("%Y")

    if (current_year.to_i == year.to_i) and (current_month.to_i == month.to_i)
      logger.info { "Current Year and Month Matches: #{current_year}-#{current_month} Params: #{year}-#{month}" }
    else    
      json_data = Rails.cache.read("minutes_ac_#{year}_#{month}")
      if json_data
        return json_data
      else
        logger.info { "I dont have in cache!" }
        cache_data = true
      end      
    end

    day = Chronic.parse("#{year}-#{month}-01").beginning_of_month

    if day.end_of_month > Time.now
      ending = Time.now
    else
      ending = day.end_of_month
    end

    while day < ending
      labels << day.strftime("%d\n%a")
      cached_traffic = Rails.cache.read("minutes_ac_#{day.strftime('%y-%m-%d')}")
      if cached_traffic
        minutes = cached_traffic
      else
        minutes = Cdr.sum(:duration, :conditions => ["date > ? and date < ? and disposition = ? and traffic_type = ?", day.beginning_of_day.utc.to_formatted_s(:db), day.end_of_day.utc.to_formatted_s(:db), "ANSWER", 1]) / 60
        if day.end_of_day.past?
          Rails.cache.write("minutes_ac_#{day.strftime('%y-%m-%d')}", minutes, :expires_in => (Time.now.end_of_month.to_i - Time.now.to_i))
          logger.info { "I'm Going to WRITE minutes_ac_#{day.strftime('%y-%m-%d')}" }
        end
      end
      values << minutes
      day += 1.day
    end

    chart = Chart.new(:bar_filled, 3500, 500)
    chart.title = "Daily AccessConnect Traffic"
    chart.values = values
    chart.labels = labels

    json_data = chart.to_json
    if cache_data
      Rails.cache.write("minutes_ac_#{year}_#{month}", json_data)
    else
      logger.info { "For some resean I'm not writing in cache!" }
    end
    json_data
  end
  
  def chart_json2(year, month)
    labels = []
    values = []

    cache_data = false

    current_month = Time.now.strftime("%m")
    current_year  = Time.now.strftime("%Y")

    if (current_year.to_i == year.to_i) and (current_month.to_i == month.to_i)
      logger.info { "Current Year and Month Matches: #{current_year}-#{current_month} Params: #{year}-#{month}" }
    else
      logger.info { "Reading from cache: minutes_trunk_#{year}_#{month}" }
      json_data = Rails.cache.read("minutes_trunk_#{year}_#{month}")
      if json_data
        return json_data
      else
        logger.info { "I dont have in cache!" }
        cache_data = true
      end      
    end

    day = Chronic.parse("#{year}-#{month}-01").beginning_of_month

    if day.end_of_month > Time.now
      ending = Time.now
    else
      ending = day.end_of_month
    end

    while day < ending
      labels << day.strftime("%d\n%a")
      cached_traffic = Rails.cache.read("minutes_trunk_#{day.strftime('%y-%m-%d')}")
      if cached_traffic
        minutes = cached_traffic
      else
        minutes = Cdr.trunk.answered.sum(:duration, :conditions => ["date > ? and date < ? and traffic_type = ?", day.beginning_of_day.utc.to_formatted_s(:db), day.end_of_day.utc.to_formatted_s(:db), 2]) / 60
        if day.end_of_day.past?
          Rails.cache.write("minutes_trunk_#{day.strftime('%y-%m-%d')}", minutes, :expires_in => (Time.now.end_of_month.to_i - Time.now.to_i))
          logger.info { "I'm Going to WRITE minutes_trunk_#{day.strftime('%y-%m-%d')}" }
        end
      end
      values << minutes
      day += 1.day
    end

    chart = Chart.new(:bar_filled, 500, 100)
    chart.title = "Daily Trunk Traffic"
    chart.values = values
    chart.labels = labels

    json_data = chart.to_json
    if cache_data
      Rails.cache.write("minutes_trunk_#{year}_#{month}", json_data)
    else
      logger.info { "For some resean I'm not writing in cache!" }
    end
    json_data
  end
  
  def chart_json3(year, month)
    labels = []
    values = []

    cache_data = false

    current_month = Time.now.strftime("%m")
    current_year  = Time.now.strftime("%Y")

    if (current_year.to_i == year.to_i) and (current_month.to_i == month.to_i)
      logger.info { "Current Year and Month Matches: #{current_year}-#{current_month} Params: #{year}-#{month}" }
    else    
      json_data = Rails.cache.read("minutes_cc_#{year}_#{month}")
      if json_data
        return json_data
      else
        logger.info { "I dont have in cache!" }
        cache_data = true
      end      
    end

    day = Chronic.parse("#{year}-#{month}-01").beginning_of_month

    if day.end_of_month > Time.now
      ending = Time.now
    else
      ending = day.end_of_month
    end

    while day < ending
      labels << day.strftime("%d\n%a")
      cached_traffic = Rails.cache.read("minutes_cc_#{day.strftime('%y-%m-%d')}")
      if cached_traffic
        minutes = cached_traffic
      else
        minutes = CardCdr.sum(:duration, :conditions => ["date > ? and date < ? and disposition = ?", day.beginning_of_day.utc.to_formatted_s(:db), day.end_of_day.utc.to_formatted_s(:db), "ANSWER"]) / 60
        if day.end_of_day.past?
          Rails.cache.write("minutes_cc_#{day.strftime('%y-%m-%d')}", minutes, :expires_in => (Time.now.end_of_month.to_i - Time.now.to_i))
          logger.info { "I'm Going to WRITE minutes_cc_#{day.strftime('%y-%m-%d')}" }
        end
      end
      values << minutes
      day += 1.day
    end

    chart = Chart.new(:bar_filled, 500, 100)
    chart.title = "Daily CardConnect Traffic"
    chart.values = values
    chart.labels = labels

    json_data = chart.to_json
    if cache_data
      Rails.cache.write("minutes_cc_#{year}_#{month}", json_data)
    else
      logger.info { "For some resean I'm not writing in cache!" }
    end
    json_data    
  end
end
