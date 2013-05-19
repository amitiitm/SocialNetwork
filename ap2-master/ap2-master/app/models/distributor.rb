class Distributor < ActiveRecord::Base
  has_many :distributions
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def bname
    if not business_name.blank?
      if first_name.blank? and last_name.blank?
        "#{business_name}"
      else
        "#{business_name} (#{name})"
      end
    else
      name
    end
  end  
end
