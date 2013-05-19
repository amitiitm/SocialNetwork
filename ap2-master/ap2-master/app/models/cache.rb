class Cache < ActiveRecord::Base
  serialize :v
    
  def key=(key)
    self.k = key
  end
  
  def key
    self.k
  end
  
  def value=(v)
    self.v = {:value => v}
  end
  
  def value
    self.v[:value]
  end
  
  def self.read(key)
    self.find(:first, :conditions => {:k => key})
  end
  
  def self.write(key, value)
    cache = self.read(key)
    if cache
      cache.value = value
    else
      Cache.new(:key => key, :value => value).save
    end
  end
  
end
