class Vendor::Vendor < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
  
  belongs_to :vendor_category, :class_name => 'Vendor::VendorCategory'
  belongs_to :gl_account, :class_name => 'GeneralLedger::GlAccount'
  has_many :metal_transactions, :class_name => 'Metal::MeltingTransaction' , :extend=>ExtendAssosiation

  validates :code,:vendor_category_id,:presence => true
  validates_uniqueness_of :code, :message=> ' is duplicate!!!'
  validates_length_of :code, :maximum=>25, :allow_nil=>true ,:message=> ' cannot be more than 25 chars'   

end
