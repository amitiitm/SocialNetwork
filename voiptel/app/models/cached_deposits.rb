class CachedDeposits < ActiveRecord::Base
  belongs_to :account
  def self.increment(options)
    month = options[:date].beginning_of_month.strftime("%Y-%m-%d")
    cache = 
      options[:account].cached_deposits.find(:first, :conditions => {:month => month}) ||
      self.new(:account => options[:account], :month => month)
    cache.amount += options[:amount]
    cache.number_of_deposits += 1
    cache.save
    cache
  end
end
