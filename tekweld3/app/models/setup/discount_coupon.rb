class Setup::DiscountCoupon < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  include ClassMethods
  include GenericSelects
  belongs_to :customer, :class_name => 'Customer::Customer'
  has_many :discount_coupon_charges, :class_name =>'Setup::DiscountCouponCharge', :extend=>ExtendAssosiation
  
  def add_line_errors_to_header
  end


  def add_line_details(line_doc)
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first   
    line = discountcouponcharges(line_doc.name,id)
    line.apply_attributes(line_doc) if line  
  end

  def discountcouponcharges(name,id)
    discount_coupon_charges.find_or_build(id) if name == 'discount_coupon_charge'
  end

  def apply_header_fields_to_lines()
    self.discount_coupon_charges.each{ |line|
      line.company_id = self.company_id
    }
  end

  def apply_line_fields_to_header()
   
  end

  def save_lines
    discount_coupon_charges.save_line
  end

  def add_line_errors_to_header
    add_line_item_errors(discount_coupon_charges) if discount_coupon_charges
  end

end
