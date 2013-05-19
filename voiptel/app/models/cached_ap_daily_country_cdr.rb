class CachedApDailyCountryCdr < ActiveRecord::Base
  def self.update(options)
    cdr = options[:cdr]
    #return if ((cdr.country_id.blank?) or (cdr.country_id == nil))
    
    day = cdr.date.strftime("%Y-%m-%d")
    cache = 
      self.find(:first, :conditions => {:day => day, :country_id => cdr.country_id}) ||
      self.new(:day => day, :country_id => cdr.country_id)
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
end
