class CachedAccountCdr < ActiveRecord::Base
  belongs_to :account
  
  def self.update(options)
    cdr = options[:cdr]
    month = cdr.date.beginning_of_month.strftime("%Y-%m-%d")
    cache = 
      cdr.account.cached_account_cdrs.find(:first, :conditions => {:month => month}) ||
      self.new(:account => cdr.account, :month => month)
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
      when "NOINPUT"
        cache.no_input += 1
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
