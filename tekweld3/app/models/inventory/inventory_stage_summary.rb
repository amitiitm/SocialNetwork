class Inventory::InventoryStageSummary < ActiveRecord::Base
  require 'has_finder'
  include UserStamp
  include Dbobject
  include General
  include ClassMethods
  
  

end
