class CardsInventory < ActiveRecord::Base
  has_one :distribution_inventory
  
  attr_accessor :return, :return_start_serial, :return_end_serial, :return_count, :return_end_method
  
  before_save :check_for_return
  
  def status
    if self.allocated
      self.distribution_inventory.distribution.distributor.bname
    else
      "<span class='red'>Not Allocated</span>"
    end
  end
  
  def card_by_serial(serial)
    Card.find(:first, :conditions => {:serial => serial})
  end
  
  def last_card
    Card.find(:first, :conditions => {:serial => self.serial_end})
  end
  
  def first_card
    Card.find(:first, :conditions => {:serial => self.serial_start})
  end
  
  
  private
  def where_is_card
    return :first   if  @starting_card.serial_number == self.cards_start
    return :last    if  @starting_card.serial_number == self.cards_end
    return :middle  if  (@starting_card.serial_number > self.cards_start) and
                        (card.serial_number < self.cards_end)
    raise "WTF!!!"
  end
  
  def check_for_return
    if self.return == "true"
      return start_to_reallocate
    end
  end
  
  def relocate_inventory(options)
    if (options[:from].serial == self.serial_start) && (options[:to].serial == self.last_card.serial)
      self.allocated = false
      Card.find(:all, :conditions => {:distribution_id => self.distribution_inventory.distribution_id}).each do |card|
        card.deactivate
      end
      self.distribution_inventory.distribution.delete
      self.distribution_inventory.delete
    else
      split_inventory(options)      
    end
    true
  end
  
  def split_inventory(options)
    # | LEFT  |  MIDDLE  |  RIGHT  |
    left_count    = (options[:from].serial_number - first_card.serial_number)
    middle_count  = (options[:to].serial_number   - options[:from].serial_number + 1)
    right_count   = (last_card.serial_number      - options[:to].serial_number )
    
    # delete distro inventories
    @distribution_id = self.distribution_inventory.distribution.id
            
    left_inventory(options, left_count)     if left_count > 0
    wipe_middle(options, middle_count)      if middle_count > 0
    right_inventory(options, right_count)   if right_count > 0
  end
  
  def left_inventory(options, count)
    card_end          = Card.find(:first, :conditions => {:serial_number => (options[:from].serial_number - 1)})
    # left              = self.clone
    # left.num_cards    = count
    # left.cards_start  = first_card.serial_number
    # left.cards_end    = card_end.serial_number
    # 
    # left.serial_start = first_card.serial
    # left.serial_end = card_end.serial
    # left.allocated = true
    # left.save
    #create_distribution_inventory(left)
    logger.info { "LEFT: value:#{self.value} num cards: #{count} start: #{first_card.serial_number} end: #{card_end.serial_number} range: #{first_card.serial}-#{card_end.serial}" }       
  end
  
  
  def wipe_middle(options, count)
    #self.distribution_inventory.delete
    logger.info { " MIDDLE should be wiped! Count: #{count}" }
    # Card.find(:all, :conditions => ["serial_number >= ? and serial_number <= ?", options[:from].serial_number, options[:to].serial_number]).each do |cdr|
    #   # cdr.deactivate
    #   logger.info { "------ DEACTIVATING: #{cdr.serial}" }
    # end
  end
  
  def right_inventory(options, count)
    card_start        = Card.find(:first, :conditions => {:serial_number => (options[:to].serial_number + 1)}) 
    #right             = self.clone
    #right.num_cards   = count
    #right.cards_start = card_start.serial_number
    #right.cards_end   = last_card.serial_number

    #right.serial_start = card_start.serial
    #right.serial_end = last_card.serial
    #right.allocated = true
    #right.save
    #create_distribution_inventory(right)
    logger.info { "RIGHT: value:#{self.value} num cards: #{count} start: #{card_start.serial_number} end: #{last_card.serial_number} range: #{card_start.serial}-#{last_card.serial}" }
  end
  
  def create_distribution_inventory(inventory)
    attributes = inventory.attributes
    attributes.delete("allocated")
    attributes.delete("created_at")
    attributes.delete("updated_at")
    attributes.delete("value")
    attributes = attributes.merge("distribution_id" => @distribution_id)
    
    di = DistributionInventory.new(attributes)
    inventory.distribution_inventory = di    
  end
  
  
  
  def start_to_reallocate
    return false if start_serial_is_not_ok?
    to = case self.return_end_method
      when "to_end"
        last_card
      when "serial"
        card_by_serial(self.return_end_serial.gsub("-", ""))
      else
      self.errors.add_to_base("Please select a method to reallocate cards")  
      return false
    end
    logger.info { "------ TO: #{to.serial_number}" }
    relocate_inventory(:from => @starting_card, :to => to) 
    #self.destroy
  end
  
  def start_serial_is_not_ok?
    serial = self.return_start_serial.gsub("-", "")
    begin
      @starting_card = Card.find(:first, :conditions => {:serial => serial})
      return ((@starting_card.serial_number < self.cards_start) and (@starting_card.serial_number > self.cards_end))
    rescue Exception => e
      self.errors.add_to_base("Start serial is not correct!")
      return true
    end
    
  end  
end
