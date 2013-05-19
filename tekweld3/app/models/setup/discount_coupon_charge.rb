class Setup::DiscountCouponCharge < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  include ClassMethods
  belongs_to :discount_coupon, :class_name => 'Setup::DiscountCoupon'
  validates :catalog_item_id,:if=>Proc.new{|value| value.trans_flag == 'A'},:uniqueness => {:scope => [:trans_flag,:discount_coupon_id],:message => "Already Exists."}
end
