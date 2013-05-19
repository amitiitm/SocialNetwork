class Destination
  attr_accessor :number, :valid, :np, :country, :area_code, :phone_country, :options
  
  def initialize(number, options = {})
    self.options = options
    self.valid = false
    return unless is_number?(number)
    self.phone_country = nil
    self.number = number
            
    if (self.number.length >= 5) or (options[:loose])
      if find_country
        if self.phone_country && self.options[:country_only]
          return self
        end
        validate
      end
    end    
  end
  
  def find_country
    find_phone_country
    if self.phone_country
      self.country = self.phone_country.country
      return true
    end
    (0..2).each do |length|
      country_code = self.number[0..length]
      country = V2Country.find(:first, :conditions => {:country_code => country_code}, :select => "id, name, min_digits, max_digits, special_case, smin_cns, smax_cns, min_cns, max_cns, country_code, parent_country_id, validation")
      if country
        self.country = country
        return true        
      end
    end
    return false
  end
  
  def find_phone_country    
    begin
      self.phone_country = PhoneCountry.find(self.number)
    rescue Exception => e
      self.phone_country = nil
    end    
  end
  
  def validate
    if self.country.special_case
      find_np
    end    
    valid_number_of_digits?
    if valid?
      set_phone_country
    end
  end
  
  def find_np
    # finally after spending so much time & $$$ (added: love my comments! 2010-03-28 7AM)
    # first check to see the entered number is smaller than the min cns or greater than the max cns length
    
    if self.country.special_case
      min_cns = self.country.smin_cns
      max_cns = self.country.smax_cns
    else
      min_cns = self.country.min_cns
      max_cns = self.country.max_cns
    end
    
    (max_cns - 1).downto(min_cns - 1) do |length|
      cns = self.number[0..length]
      #puts "trying #{cns}"      
      np = V2NumberingPlan.find(:first, :conditions => {:cns => cns}, :select => "id, location, area_code_length, phone_type, min_subscr_nr_length, max_subscr_nr_length, country_id")
      if np
        # found the numbering plan, now start validating
        self.area_code = cns[ (self.country.country_code.to_s.length)..(self.country.country_code.to_s.length + np.area_code_length - 1)]
        self.np = np
        if self.country.special_case
          if np.phone_type == "COU"
            self.country = V2Country.find(np.country.parent_country_id, :select => "id, name, min_digits, max_digits, special_case, smin_cns, smax_cns, min_cns, max_cns, country_code, parent_country_id, validation")
            self.np = V2NumberingPlan.find(:first, :conditions => {:phone_type => "COU", :country_id => self.country.id}, :select => "id, location, area_code_length, phone_type, min_subscr_nr_length, max_subscr_nr_length, country_id")
          else
            self.country = np.country            
          end
        end
        return np
      end
    end
    self.country = V2Country.find(self.country.parent_country_id, :select => "id, name, min_digits, max_digits, special_case, smin_cns, smax_cns, min_cns, max_cns, country_code, parent_country_id, validation")
    self.valid = false
    nil
  end
  
  def valid?
    self.valid
  end
  
  private

  def validate_np?
    if self.np.area_code_length > 0
      country_code_and_area_code_length = self.country.country_code.to_s.length + self.np.area_code_length
      subscriber_number = self.number[country_code_and_area_code_length..-1]
    else
      subscriber_number = self.number[self.country_code.length..-1]
    end
    self.subscriber_number = subscriber_number
    puts "#{self.subscriber_number}"
    puts "#{self.subscriber_number.length} min_len: #{self.np.min_subscr_nr_length} max_len: #{self.np.max_subscr_nr_length}"
    if subscriber_number.length >= self.np.min_subscr_nr_length and subscriber_number.length <= self.np.max_subscr_nr_length
      self.valid = true
    else
      self.valid = false
    end
  end
  
  def is_number?(number)
    /^[\d]+$/ === number
  end
  
  def set_phone_country
    if self.phone_country == nil and self.number.length <= 20
      self.phone_country = PhoneCountry.new(:country_id => self.country.id)
      self.phone_country.number = self.number
      self.phone_country.save
    end
  end
  
  def valid_number_of_digits?
    if self.country.validation < 2
      if (self.number.length < self.country.min_digits) or (self.number.length > self.country.max_digits)
        return self.valid = false
      end
    end
    self.valid = true      
  end
  
  def find_phone_country    
    begin
      self.phone_country = PhoneCountry.find(self.number)
    rescue Exception => e
      self.phone_country = nil
    end    
  end
end
