class Inventory::InventoryDetail < ActiveRecord::Base
  require 'has_finder'
  include UserStamp
  include Dbobject
  
  def self.save_detail(invndetails)
    for invndtl in invndetails
      invndtl.save!
    end
  end

end
