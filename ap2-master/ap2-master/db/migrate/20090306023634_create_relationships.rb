class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.string :to_me

      t.timestamps
    end
  end

  def self.down
    drop_table :relationships
  end
end
