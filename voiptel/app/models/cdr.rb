class Cdr < ActiveRecord::Base
  #include ReportsHelper
  #include ActionView::Helpers::NumberHelper
  belongs_to :did
  belongs_to :account
  belongs_to :user
  belongs_to :phone
  belongs_to :country, :class_name => "V2Country"
  belongs_to :feedback
  belongs_to :carrier
	belongs_to :zone
	has_one :cdr_cache
	has_one :cdr_stat
	
	
	named_scope :answered_calls_between, lambda { |range|
	  {
	    :conditions => {:disposition => "ANSWER", :date => range}
	  }
	}
	
	named_scope :answered, :conditions => {:disposition => "ANSWER"}
	named_scope :answer, :conditions => {:disposition => "ANSWER"}
	
	named_scope :between, lambda { |range|
	  {
	    :conditions => {:date => range}
	  }
	}
	
	named_scope :cc, :conditions => {:traffic_type => 1}
	named_scope :tr, :conditions => {:traffic_type => 2}
	named_scope :card, :conditions => {:traffic_type => 3}
  named_scope :trunk, :conditions => {:traffic_type => 2}
  
  DISPOSITIONS = [
    ["Answer", "ANSWER"],
    ["Congestion", "CONGESTION"],
    ["Busy", "BUSY"],
    ["No Answer", "NOANSWER"],
    ["No Input", "NOINPUT"]
  ]
	
	
  after_save :update_account

    def update_account
      begin
          account.last_answered_cdr = Time.now #.utc
          account.save
      rescue
      end
    end


  def self.avg(range)
    (answered.between(range).average(:duration)/60)
  end
  
  
  def self.average_daily(range)
    
  end
  
  def fb
    feedback.feedback
  end
  
  def fb=(text)
    feedback.feedback = text
    feedback.save
  end
  
  def self.monthly_usage(y, m)
    date = Chronic.parse("#{y}-#{m}-01 00:00:00")
    start_of_month = date.beginning_of_month.utc.to_formatted_s(:db)
    end_of_month = date.end_of_month.utc.to_formatted_s(:db)
    sum(:duration, :conditions => ["date > ? and date < ? and disposition = ?", start_of_month, end_of_month, "ANSWER"])
  end
  
  def billing_minute
    return 0 if self.duration < 59
    minutes = self.duration / 60
    minutes += 1 if self.duration % 60 != 0
    minutes
  end
  
  def update_cached_stuff
    updated = false
    unless self.cdr_stat
      self.cdr_stat = CdrStat.new
    end
    unless self.cdr_stat.account
      if self.account
        CachedAccountCdr.update(:cdr => self)
        CachedAccountCountryCdr.update(:cdr => self)
      end
      updated = true
      self.cdr_stat.account = true
    end
    unless self.cdr_stat.ap
      CachedApCdr.update(:cdr => self)
      CachedApCountryCdr.update(:cdr => self)
      updated = true
      self.cdr_stat.ap = true
    end
    unless self.cdr_stat.ap_daily
      CachedApDailyCdr.update(:cdr => self)
      CachedApDailyCountryCdr.update(:cdr => self)
      updated = true
      self.cdr_stat.ap_daily = true
    end
    if updated
      self.cdr_stat.save
    end
  end
  
  def self.find_with_out_stats
    join = "LEFT OUTER JOIN cdr_stats cs ON cdrs.id = cs.cdr_id"
    find(:all, :joins => join, :conditions => "cs.id IS NULL and cdrs.traffic_type = 1")
  end
end
