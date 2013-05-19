class Customer::Customer < ActiveRecord::Base
  require 'has_finder'
  include UserStamp
  include Dbobject
  include General
  include ClassMethods
  include GenericSelects

  attr_protected :id, :updated_at, :created_at
  #  attr_accessor  :parent_code, :customer_category_code
  belongs_to :company, :class_name => 'Setup::Company'
  belongs_to :customer_category
  belongs_to :memo_terms ,  :class_name => "Setup::Term",
    :foreign_key => "memo_term_id"
  belongs_to :invoice_terms ,  :class_name => "Setup::Term",
    :foreign_key => "inv_term_id" 
                          
  belongs_to :shipping, :class_name => 'Setup::Shipping'
  belongs_to :bill_to,  :class_name => "Customer",
    :foreign_key => "billto_id"
  has_many :customer_payment_profiles, :class_name => 'Payment::CustomerPaymentProfile',:dependent => :destroy, :extend=>ExtendAssosiation
  has_many :customer_shippings, :dependent => :destroy, :extend=>ExtendAssosiation
  has_many :customer_notes, :dependent => :destroy, :extend=>ExtendAssosiation
  has_many :customer_asirankings, :dependent => :destroy, :extend=>ExtendAssosiation
  has_many :customer_salespeople, :dependent => :destroy, :extend=>ExtendAssosiation
  has_many :customer_relationships,:class_name =>'Customer::CustomerRelationship',:dependent => :destroy, :extend=>ExtendAssosiation
  #  has_many :customer_wishlists, :dependent => :destroy, :extend=>ExtendAssosiation
  has_many :customer_item_pricings,:class_name =>'Customer::CustomerItemPricing',:dependent => :destroy, :extend=>ExtendAssosiation
  has_many :customer_item_production_days,:class_name =>'Customer::CustomerItemProductionDay',:dependent => :destroy, :extend=>ExtendAssosiation
  has_many :customer_contacts,:class_name =>'Customer::CustomerContact',:dependent => :destroy, :extend=>ExtendAssosiation
  has_many :discount_coupons, :class_name => 'Setup::DiscountCoupon', :extend => ExtendAssosiation
  belongs_to :salesperson
  scope :activecustomer, :conditions => { :trans_flag => 'A' }
                            
  #  belongs_to :tax   -----tax table to be defined

  #  has_many :sales_orders

  validates_numericality_of  :discount_per, :less_than_or_equal_to=>999.99,:allow_nil=>true
  validates_numericality_of  :coop_per, :less_than_or_equal_to=>999.99,:allow_nil=>true
  validates_numericality_of  :salescomm_per, :less_than_or_equal_to=>999.99,:allow_nil=>true
  validates_numericality_of  :due_days, :less_than_or_equal_to=>99999,:allow_nil=>true
  validates_numericality_of  :return_checks, :less_than_or_equal_to=>99999,:allow_nil=>true
  validates_numericality_of  :postdated_checks, :less_than_or_equal_to=>99999,:allow_nil=>true
  validates_numericality_of  :credit_limit, :less_than_or_equal_to=>9999999999.99,:allow_nil=>true
  validates_numericality_of  :base_goldprice, :less_than_or_equal_to=>999.99,:allow_nil=>true
  validates_numericality_of  :impairment_percent, :less_than_or_equal_to=>999.99,:allow_nil=>true
  validates_uniqueness_of :code, :message=>" is duplicate. This Customer Code already exist!!!!"
  #  validates_associated  :company, :customer_category, :memo_terms, :invoice_terms, :shipping
  
  validate do
    #    errors.add(:memo_term_id," does not exist") if not self.memo_terms 
    #    errors.add(:inv_term_id," does not exist") if not self.invoice_terms  
  end
  
  
  after_create do
    if is_blank_id?("#{self.billto_id}")   
      self.update_attributes(:billto_id => self.id)
    end
  end

  def add_line_details(line_doc)
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first
    line = asirankings(line_doc.name,id) || notes(line_doc.name,id) || shippings(line_doc.name,id)|| salespeople(line_doc.name,id) || relationships(line_doc.name,id) || item_pricings(line_doc.name,id) || contacts(line_doc.name,id) || production_days(line_doc.name,id) || nil
    line.apply_attributes(line_doc) if line
    line.fill_default_detail_values if (line_doc.name == 'customer_item_pricing')
    line
  end
 
  def production_days(name,id)
    customer_item_production_days.find_or_build(id) if name == 'customer_item_production_day'
  end
  def asirankings(name,id)
    customer_asirankings.find_or_build(id) if name == 'customer_asiranking'
  end
 
  def notes(name,id)
    customer_notes.find_or_build(id) if name == 'note'
  end
 
  def shippings(name,id)
    customer_shippings.find_or_build(id)  if name == 'shipping'
  end
 
  def salespeople(name,id)
    customer_salespeople.find_or_build(id)  if name == 'customer_salesperson'
  end
  
  def relationships(name,id)
    customer_relationships.find_or_build(id)  if name == 'customer_relationship'
  end
  
  def contacts(name,id)
    customer_contacts.find_or_build(id)  if name == 'customer_contact'
  end
  #  def wishlists(name,id)
  #    customer_wishlists.find_or_build(id)  if name == 'customer_wishlist'
  #  end

  def item_pricings(name,id)
    customer_item_pricings.find_or_build(id)  if name == 'customer_item_pricing'
  end
  def save_lines
    customer_asirankings.save_line 
    customer_notes.save_line 
    customer_shippings.save_line 
    customer_salespeople.save_line
    customer_relationships.save_line
    #    customer_wishlists.save_line
    customer_item_pricings.save_line
    customer_contacts.save_line
    customer_item_production_days.save_line
  end
 
  def add_line_errors_to_header
    add_line_item_errors(customer_asirankings) if customer_asirankings
    add_line_item_errors(customer_notes) if customer_notes
    add_line_item_errors(customer_shippings) if customer_shippings
    add_line_item_errors(customer_salespeople) if customer_salespeople
    add_line_item_errors(customer_relationships) if customer_relationships
    #    add_line_item_errors(customer_wishlists) if customer_wishlists
    add_line_item_errors(customer_item_pricings)if customer_item_pricings
    add_line_item_errors(customer_contacts)if customer_contacts
    add_line_item_errors(customer_item_production_days) if customer_item_production_days
  end
 
end


