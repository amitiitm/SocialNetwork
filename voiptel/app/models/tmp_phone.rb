class TmpPhone < ActiveRecord::Base
  has_many :phone_cards
  has_many :cards, :through => :phone_cards
  
  belongs_to :card
  
  belongs_to :did
  belongs_to :area_code_info
end
