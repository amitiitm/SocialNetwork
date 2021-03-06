class CachedAccountCountryCdr < ActiveRecord::Base
  belongs_to :account
  
  def self.update(options)    
    cdr = options[:cdr]
    return if ((cdr.country_id.blank?) or (cdr.country_id == nil))
    
    month = cdr.date.beginning_of_month.strftime("%Y-%m-%d")
    cache = 
      cdr.account.cached_account_country_cdrs.find(:first, :conditions => {:month => month, :country_id => cdr.country_id}) ||
      self.new(:account => cdr.account, :month => month, :country_id => cdr.country_id)
    cache.country_id = cdr.country_id
    cache.calls += 1
    cache.duration += cdr.duration if cdr.disposition == "ANSWER"
    cache.sell_cost += cdr.cost
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
