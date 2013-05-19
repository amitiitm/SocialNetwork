ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'  
require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

class MonitorSeconds
  attr_accessor :start_id, :end_id, :current_day_number, :cache, :seconds, :new_seconds
  
  def initialize()
    self.cache = Rails.cache #MemCache.new("localhost")
  end
  
  def day_changed?
    self.current_day_number != Time.now.day
  end
  
  def update(first_time = false)
		self.end_id = Cdr.last.id
    if self.start_id == self.end_id
      self.new_seconds = 0
      return 0
    end

  	if first_time
    	self.new_seconds = Cdr.sum(:duration, :conditions => ["id >= ? and id <= ? and disposition = ? and traffic_type = ? and date >= ?",start_id, end_id, "ANSWER", 1, Time.now.beginning_of_day.utc])
  	else
  		self.new_seconds = Cdr.sum(:duration, :conditions => ["id > ? and id <= ? and disposition = ? and traffic_type = ? and date >= ?",start_id, end_id, "ANSWER", 1, Time.now.beginning_of_day.utc])
  	end
  	self.seconds += self.new_seconds
  	self.cache.write("seconds", self.seconds)
		self.start_id = self.end_id
  end
  
  def reset_stats
    self.cache.write("seconds", 0)
    self.current_day_number = Time.now.day
    self.start_id = Cdr.find(:first, :conditions => [
      "date >= ? and disposition = ? and traffic_type = ?",
      Time.now.beginning_of_day.utc,
      "ANSWER", 1
    ]).id
    self.end_id = Cdr.last.id
		self.seconds = 0
		self.new_seconds = 0
    update(true)
    mlog
    self.start_id = self.end_id
  end
  
  def run
    reset_stats    
    while true
      if day_changed?
        reset_stats
      else
        update
      end
      mlog
      sleep 3
    end
  end
  
  def mlog
    #puts "minutes: #{self.seconds / 60}:#{self.seconds % 60} | from: #{self.start_id} to:#{self.end_id} | new_seconds: #{self.new_seconds}"
  end
end

ms = MonitorSeconds.new
ms.run
