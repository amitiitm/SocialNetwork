class RemoveAreaCodeFromAssignedDid < ActiveRecord::Migration
  def self.up
    remove_column :assigned_dids, :area_code_id
    add_column :assigned_dids, :area_code, :string
  end

  def self.down
    remove_column :assigned_dids, :area_code
  end
end
