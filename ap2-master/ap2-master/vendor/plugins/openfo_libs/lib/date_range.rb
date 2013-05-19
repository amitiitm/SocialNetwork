class DateRange
  attr_accessor :start_date
  
  def initialize(start_date)
    self.start_date = ensure_date(start_date)
  end
  
  def ensure_date(date)
    if date.class == String
      date = Chronic.parse(date)
    end
    date
  end
  
  def upto(date,step = 1.month,&block)
    date = ensure_date(date)
    d = self.start_date
    while d <= date
      yield d
      d += step
    end
  end
end