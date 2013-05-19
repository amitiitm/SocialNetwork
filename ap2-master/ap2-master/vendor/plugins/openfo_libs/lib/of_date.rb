class OfDate
  attr_accessor :date

  def initialize(date)
    self.date = date
  end
  
  def starting
    self.date.beginning_of_month.utc
  end
  
  def ending
    self.date.end_of_month.utc
  end
  
  def to_str
    self.date
  end
  
end