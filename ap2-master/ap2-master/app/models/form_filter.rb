class FormFilter
  attr_accessor :hash, :operators, :model
  OPERATORS = {
    "g"   => ">",
    "ge"  => ">=",
    "l"   => "<",
    "le"  => "<=",
    "like"  => "like",
    "not" => "!="
  }
  def initialize(model, *args)
    if model
      self.model = "#{model.table_name}."
    end
    self.operators = {}
    self.hash = Hash.new
    return if args[0].class == NilClass
    if args[0].class == HashWithIndifferentAccess or args[0].class == Hash
      args[0].keys.each do |k|
        if k.to_s.index("__")
          key, op = k.to_s.split("__")  
          Rails.logger.info { "------- KEY: #{key} op: #{op}" }
          self.operators[key] = OPERATORS[op]
          self.hash[key] = args[0][k]
          self.hash[k] = args[0][k]
        else
          self.hash[k.to_s] = args[0][k]
        end
      end
    else
      for atr in args
        self.hash[atr.to_s] = nil
      end      
    end
  end
  
  def method_missing(m, *args)
    m = m.to_s
    if m.index("=")
      m = m.gsub("=", "")
      self.hash[m] = args[0]
    else
      Rails.logger.info { "------ ASKING FOR: #{m}: #{self.hash[m]}" }
      self.hash[m]      
    end
  end
  
  def conditions
    #conditions = Hash.new
    conditions = []
    self.hash.keys.each do |k|
      val = self.hash[k]
      if not val.blank? and val != nil and not k.index("__")
        if self.operators[k]
          op = self.operators[k]
          q = self.hash[k]
          q = "%#{q}%" if op == "like"
          self.hash["#{k}__#{op}".to_sym] = self.hash[k]
        else
          op = "="
          q = self.hash[k]
        end
        conditions << "#{self.model}#{k} #{op} '#{q}'"
      end
    end
    result = conditions.join(" AND ")
    self.hash.keys.each do |k|
      Rails.logger.info { "-- #{k}: #{self.hash[k]}" }
    end
    result
  end  
  
  def to_s
    "form_filter"
  end
end