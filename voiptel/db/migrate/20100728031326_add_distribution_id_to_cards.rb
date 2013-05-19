class AddDistributionIdToCards < ActiveRecord::Migration
  def self.up
    add_column :cards, :distribution_id, :integer
  end

  def self.down
    remove_column :cards, :distribution_id
  end
end
