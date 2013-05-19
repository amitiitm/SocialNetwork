# class ChangeTablesForOldZones < ActiveRecord::Migration
#   def self.up
#     rename_column :cdrs, :zone_id, :old_zone_id
#     rename_column :old_routes, :zone_id, :old_zone_id
#   end
# 
#   def self.down
#     rename_column :old_routes, :old_zone_id, :zone_id
#     rename_column :cdrs, :old_zone_id, :zone_id
#   end
# end

class ChangeTablesForOldZones < ActiveRecord::Migration
  def self.up
  end

  def self.down
  end
end
