class CachedApDailyCdr < ActiveRecord::Base
  def self.duration_on(day)
    if day.acts_like? :time
      day = day.strftime("%Y-%m-%d")
    end
    cached = self.find(:first, :conditions => {:day => day}) || self.new
    cached.duration
  end
  def self.update(options)
    cdr = options[:cdr]
    day = cdr.date.strftime("%Y-%m-%d")
    cache = 
      self.find(:first, :conditions => {:day => day} ) ||
      self.new(:day => day)
    cache.calls += 1
    cache.sell_cost += cdr.cost
    cache.duration += cdr.duration if cdr.disposition == "ANSWER"
    case cdr.disposition
      when "ANSWER"
        cache.answer += 1
      when "CANCEL"
        cache.cancel += 1
      when "BUSY"
        cache.busy += 1
      when "INVALIDNUM"
        cache.invalid_num += 1
      when "CONGESTION"
        cache.congestion += 1
      when "CHANUNAVAIL"
        cache.congestion += 1      
      else
        cache.other_dispositions += 1
    end
    return cache.save    
  end
  
  def self.daily_average_for(year, month)
    year = (year.blank?) ? Time.now.year.to_s : year
    month = (month.blank?) ? Time.now.month.to_s : month
    
    date = Chronic.parse("#{year}-#{month}-01")
    date_label = date.strftime('%B, %Y')
    
    graph_data = self.daily_average_graph_data(year, month)
    graph_data2 = self.graph_data(year, month)
    chart = HighChart.new('graph') do |f|
      f.series(
        :type => "column",
        :name=>"Daily Traffic",
        :data=> graph_data2[:datas],
        :dataLabels => {
          :enabled => true,
          :rotation => 0,
          #:x => -30, :y => 30,
          :y => -10,
          :color => "#FFFFFF",
          #:align => "right",
          :style => "font: 'normal 13px Verdana, sans-serif'; color: #FFFFFF",          
        }
      )
      
      f.series(
        :type => "line",
        :enabled => false,
        :name=>"Daily Average",
        :data=> graph_data[:datas],
        :dataLabels => {
          :enabled => false,    
        }
      )
      
      f.options[:title] = {:text=>"Daily Traffic #{date_label}"}
      f.options[:chart][:inverted] = false
      f.options[:x_axis][:categories] = (1..days_in_month(year, month))
      f.options[:x_axis][:labels] = { :align=>'center',:rotation=> 0 }
      f.options[:y_axis][:title] = {:text => "Minutes", :x => -20}
      min = graph_data[:min]
    end
    chart
  end
  
  def self.daily_traffic_for(year, month)
    year = (year.blank?) ? Time.now.year.to_s : year
    month = (month.blank?) ? Time.now.month.to_s : month
    
    date = Chronic.parse("#{year}-#{month}-01")
    date_label = date.strftime('%B, %Y')
    
    graph_data = self.graph_data(year, month)
    chart = HighChart.new('graph') do |f|
      f.series(
        :type => "column",
        :name=>"Daily Traffic",
        :data=> graph_data[:datas],
        :dataLabels => {
          :enabled => true,
          :rotation => 0,
          #:x => -30, :y => 30,
          :y => -10,
          :color => "#FFFFFF",
          #:align => "right",
          :style => "font: 'normal 13px Verdana, sans-serif'; color: #FFFFFF",          
        }
      )
      f.series(
        :type => "line",
        :name=>"Daily Traffic, #{year}-#{month}",
        :data=> graph_data[:datas],
        :dataLabels => {
          :enabled => false,
          #:rotation => 0,
          #:x => -30, :y => 30,
          #:y => -10,
          #:color => "#FFFFFF",
          #:align => "right",
          :style => "font: 'normal 13px Verdana, sans-serif'; color: #FFFFFF",          
        }
      )
      f.series(
        :type => "line",
        :enabled => false,
        :name=>"Average Line",
        :data=> graph_data[:average],
        :dataLabels => {
          :enabled => false,
          #:rotation => 0,
          #:x => -30, :y => 30,
          #:y => -10,
          #:color => "#FFFFFF",
          #:align => "right",
          #:style => "font: 'normal 13px Verdana, sans-serif'; color: #FFFFFF",          
        }
      )
      #f.options[:legend] = {:layout => "vertical", :style => {:left => "auto", :bottom => "auto", :right => "50px", :top => "350px"}}
      f.options[:title] = {:text=>"Daily Traffic #{date_label}"}
      #f.options[:chart][:defaultSeriesType] = "column"
      f.options[:chart][:inverted] = false
      f.options[:x_axis][:categories] = (1..days_in_month(year, month))
      f.options[:x_axis][:labels] = { :align=>'center',:rotation=> 0 }
      f.options[:y_axis][:title] = {:text => "Minutes", :x => -20}
      min = graph_data[:min]

      #f.options[:y_axis][:min] = min
    end
    chart
  end
  
  def self.daily_average_graph_data(year, month, options = {})
    datas = []
    current_month = false
    cache = CachedApDailyCdr.find(:first, :conditions => {:day => "#{year}-#{month}-01"})
    if cache
      min = max = cache.duration / 60
    else
      min = max = 0
    end
    if Time.now.year == year.to_i and Time.now.month == month.to_i
      current_month = true
      days = Time.now.day
      days_upto_now = Time.now.day - 1
      minutes_upto_now = (Time.now.hour * 60) + Time.now.min              
      partial_now = days_upto_now + (minutes_upto_now / 1440.0)
      if partial_now < 1
        partial_now = 1
      end
    else
      days = days_in_month(year.to_i, month.to_i)
      partial_now = days
    end
    total = 0
    (1..days).each do |d|
      cache = CachedApDailyCdr.find(:first, :conditions => {:day => "#{year}-#{month}-#{d}"})
      if cache
        minutes = (cache.duration / 60)        
        if min > minutes
          min = minutes
        end
        if max < minutes
          max = minutes
        end
      else
        minutes = 0
      end
      total += minutes
      if current_month and Time.now.day == d
        average = total / partial_now
      else
        average = total / d
      end
      datas << average
    end
    avg = (total / partial_now).to_i
    {:min => min, :max => max, :datas => datas, :total => total}    
  end
  
  def self.graph_data(year, month, options = {})
    datas = []
    
    cache = CachedApDailyCdr.find(:first, :conditions => {:day => "#{year}-#{month}-01"})
    if cache
      min = max = cache.duration / 60
    else
      min = max = 0
    end
    if Time.now.year == year.to_i and Time.now.month == month.to_i
      days = Time.now.day
      days_upto_now = Time.now.day - 1
      minutes_upto_now = (Time.now.hour * 60) + Time.now.min              
      partial_now = days_upto_now + (minutes_upto_now / 1440.0)
      if partial_now < 1
        partial_now = 1
      end
    else
      days = days_in_month(year.to_i, month.to_i)
      partial_now = days
    end
    total = 0
    (1..days).each do |d|
      cache = CachedApDailyCdr.find(:first, :conditions => {:day => "#{year}-#{month}-#{d}"})
      if cache
        minutes = (cache.duration / 60)        
        if min > minutes
          min = minutes
        end
        if max < minutes
          max = minutes
        end
      else
        minutes = 0
      end
      total += minutes
      datas << minutes
    end
    avg = (total / partial_now).to_i
    average = (1..days).collect {|d| avg }
    {:min => min, :max => max, :datas => datas, :total => total, :average => average}    
  end
end
