class CreateActiveNumberingPlans < ActiveRecord::Migration
  def self.up
    create_table :active_numbering_plans do |t|
      t.integer :first
      t.integer :last
    end
  end

  def self.down
    drop_table :active_numbering_plans
  end
end
