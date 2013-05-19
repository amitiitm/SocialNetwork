class Distribution < ActiveRecord::Base
  attr_accessor :return, :return_start_serial, :return_end_serial, :return_count, :return_end_method
  belongs_to :distributor
  has_many :cards
  has_many :distribution_inventories

  after_create :activate_cards
  
  def activate_cards
    range = Card.available_range(self.value, self.num_cards)
    self.serial_start = Card.find(:first, :conditions => {:serial_number => range.first}).formatted_serial
    self.serial_end = Card.find(:first, :conditions => {:serial_number => range.last}).formatted_serial
    self.cards_start = range.first
    self.cards_end = range.end
    self.save
    
    Card.activate(range, self.activation_date, self.id)    
  end
  
  def num_used
    self.cards.count(:conditions => {:used => true})
  end
  
end
