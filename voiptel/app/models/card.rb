class Card < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  
  has_many :phone_cards
  has_many :tmp_phones, :through => :phone_cards
  
  belongs_to :distribution
  has_many :card_cdrs
  has_one :memo, :as => :memoable
  
  has_many :notifications, :as => :emailable
  has_many :pbx_cdrs, :as => :contactable
  has_many :voice_testimonials, :as => :customer
  
  def select_options_for_contactable
    [["#{self.info}", 1]]
  end
  
  def select_options_for_contactable_number(contactable_id)
    #[["#{number_to_phone(self.tmp_phone.number, :area_code => true)}", 1]]
    self.tmp_phones.map { |p| [number_to_phone(p.number), p.id] }
  end
  
  def args_for_call_link(contactable_id, memo, admin_user)
    args = {}
    args['contactable_type'] = "Card"
    args['contactable_id'] = contactable_id
    args['ext'] = admin_user.ext
    args['admin_user_id'] = admin_user.id
    args['cid'] = "19493257005"
    args['memo_id'] = memo.id
    args.to_param.gsub("&", "|")
  end
  
  def deactivate
    self.activated = false
    self.activation_date = nil
    self.distribution_id = nil
    self.save
  end
  
  def other_cards
    phone_cards = []
    cards = []
    self.tmp_phones.each do |p|
      phone_cards += p.phone_cards.find(:all, :conditions => ["card_id != ?", self.id], :order => "created_at desc")
    end
    
    phone_cards.each do |pc|
      cards << pc.card
    end
    cards
  end
  
  def user_for_convert
    user = User.new
    self.tmp_phones.each do |p|
      user.phones << Phone.new(:number => p.number)
    end
    user.auth_user = AuthUser.new
    user
  end
  
  def last_call
    self.card_cdrs.find(:last, :conditions => {:disposition => "ANSWER"})
  end
  
  
  def formatted_number
    "#{number[0..3]}-#{number[4..7]}-#{number[8..11]}"
  end
  
  def formatted_serial
    "#{serial[0..1]}-#{serial[2..3]}-#{serial[4..-1]}"
  end
  
  def self.available(value)
    if value == 2
      count(:conditions => ["activated = ? and value = ? and serial_number >= ? and serial_number <= ?", false, value, 2483, 2500])
    else
      count(:conditions => {:activated => false, :value => value})
    end
  end
  
  def self.active(value)
    count(:conditions => {:activated => true, :value => value})
  end
  
  def self.available_range(value, count)
    if  available(value) < count
      return false
    end
    if value == 2
      first = find(:first, :conditions => ["activated = ? and value = ? and serial_number >= ? and serial_number <= ? ", false, value, 2483, 2500], :order => "serial asc").serial_number
    else
      first = find(:first, :conditions => {:activated => false, :value => value}, :order => "serial asc").serial_number
    end
    (first..(first - 1 + count))
  end
  
  def info
    self.formatted_serial
  end
  
  def self.activate(range, activation_date, distribution_id)
    find(:all, :conditions => {:serial_number => range}).each do |c|
      c.activated = true
      c.activation_date = activation_date
      c.distribution_id = distribution_id
      Rails.logger.info {"------DID: #{distribution_id}"}
      c.save
    end
  end  
  
  def self.find_without_memo(memo_type = nil)
    find_memo_also = (memo_type) ? (" and m.memo_type_id = '#{memo_type}'") : ""
    join = "LEFT OUTER JOIN memos m ON #{table_name}.id = m.memoable_id and m.memoable_type = '#{self.to_s}'#{find_memo_also}"
    find(:all, :select => "#{table_name}.*", :joins => join, :conditions => "m.id IS NULL")
  end
  
end
