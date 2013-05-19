class PhoneBook < ActiveRecord::Base
  belongs_to :account
  
  validates_presence_of :phone_number
  validates_presence_of :easy_dial_number, :unless => :phone_number_blank?
  
  def to_s
    "phone_book"
  end
  
  private  
  def phone_number_blank?
    self.phone_number.blank?
  end
  
end
