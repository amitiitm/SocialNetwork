class Carrier < ActiveRecord::Base
  attr_accessor :lc, :la
  has_many :routes
  has_many :zones, :through => :routes
	has_many :cdrs
	has_many :card_cdrs

	has_many :carrier_endpoints
	has_many :endpoints, :through => :carrier_endpoints
	
	has_many :carrier_trunks
	has_many :trunks, :through => :carrier_trunks
	
	has_many :rate_sheets
	has_many :rate_sheet_revesions
	
	has_many :card_cdrs
	
  validates_presence_of :name,  :message => "Name can't be blank"
  validates_presence_of :ip, :message => "IP can't be blank, WTF!!!"
  validates_presence_of :codec, :message => "Provide at least one codec!"
  #validates_presence_of :short_name, :message => "Carrier Identifier can't be blank, WTF!!!"
  
  #validates_uniqueness_of :short_name, :message => "Short name can't be duplicate"
  #validates_presence_of :trunk_name,  :message => "can't be blank"
  #validates_presence_of :signaling,  :message => "can't be blank"
  #validates_presence_of :channel_limit, :message => "can't be blank"
  
  accepts_nested_attributes_for :endpoints
  
  has_many :rates
  
  def last_call
    self.lc ||= Cdr.find(:last, :conditions => {:carrier_id => self.id})
  end
  
  def last_answer
    self.la ||= Cdr.find(:last, :conditions => {:carrier_id => self.id, :disposition => "ANSWER"})
  end
  
  def country_descs(country)
    if country.class == Class
      id = country.id
    else
      id = country
    end
    
    distinct_descs = Rate.find(:all, :conditions => {:carrier_id => self.id, :country_id => id}, :select => "distinct carrier_desc")
    descs = []
    for dd in distinct_descs
      desc_rate = DescRates.new
      desc_rate.desc = dd.carrier_desc
      desc_rate.carrier_id = self.id
      desc_rate.rates = Rate.find(:all, :conditions => {:carrier_id => self.id, :carrier_desc => desc_rate.desc, :country_id => id}, :order => "prefix_length asc")
      desc_rate.count = desc_rate.rates.size
      descs << desc_rate
    end
    descs
  end
  
  def print_country_descs(country)
    descs = self.country_descs(country)
    for desc in descs
      puts desc.desc
      for r in desc.rates
        puts " #{r.prefix}: #{r.buy.to_s}"
      end
      puts "-------"
    end
  end
  
  def self.select_options
    Carrier.find(:all, :conditions => {:archived => false }, :order => "name ASC").map  { |c| [c.name, c.id] }
  end
  
end


