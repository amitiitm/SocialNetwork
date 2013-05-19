class DistributionInventory < ActiveRecord::Base
  belongs_to :cards_inventory
  belongs_to :distribution
end
