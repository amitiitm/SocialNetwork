class CachedApCdr < ActiveRecord::Base
  def self.update(options)
    cdr = options[:cdr]
    month = cdr.date.beginning_of_month.strftime("%Y-%m-%d")
    cache = 
      self.find(:first, :conditions => {:month => month} ) ||
      self.new(:month => month)
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
  
  def self.monthly_traffic_for_year(year)
    year = (year.blank?) ? Time.now.year.to_s : year
    graph_data = self.graph_data(year)
    chart = HighChart.new('graph') do |f|
      f.series(
        :name=>"Traffic - #{year}",
        :data=> graph_data[:datas],
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
      f.options[:chart][:defaultSeriesType] = "line"
      f.options[:chart][:inverted] = false
      f.options[:x_axis][:categories] = MONTHS
      f.options[:y_axis][:title] = {:text => "Minutes", :x => -20}
      min = graph_data[:min]

      f.options[:y_axis][:min] = min
    end
    chart
  end
  
  def self.daily_average_for_year(year)
    year = (year.blank?) ? Time.now.year.to_s : year
    graph_data = self.graph_data(year, :type => :average, :with_current_month => true)
    chart = HighChart.new('graph') do |f|
      f.series(
        :name=>"Daily Average - #{year}",
        :data=> graph_data[:datas],
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
      f.options[:title] = {:text=>"Daily Average - #{year}"}
      f.options[:chart][:defaultSeriesType] = "line"
      f.options[:chart][:inverted] = false
      f.options[:x_axis][:categories] = MONTHS
      f.options[:y_axis][:title] = {:text => "Minutes", :x => -20}
      min = graph_data[:min]

      f.options[:y_axis][:min] = min
    end
    chart
  end
  
  def self.graph_data(year, options = {})
    datas = []
    
    cache = CachedApCdr.find(:first, :conditions => {:month => "#{year}-01-01"})
    if cache
      min = max = cache.duration / 60
    else
      min = max = 0
    end
    
    months_in_year(year, :with_current_month => options[:with_current_month]).each do |m|
      cache = CachedApCdr.find(:first, :conditions => {:month => m})
      if cache
        minutes = (cache.duration / 60)
        if options[:type] == :average
          month_number = Chronic.parse(m).month
          if Time.now.year.to_s == year.to_s
            if Time.now.month == month_number
              days_upto_now = Time.now.day - 1
              minutes_upto_now = (Time.now.hour * 60) + Time.now.min              
              partial_now = days_upto_now + (minutes_upto_now / 1440.0)
              if partial_now < 1
                partial_now = 1
              end
              minutes = (minutes / partial_now).to_i
            else
              minutes = minutes / days_in_month(year.to_i, month_number)
            end            
          else
            minutes = minutes / days_in_month(year.to_i, month_number)
          end                 
        end
        
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
end
