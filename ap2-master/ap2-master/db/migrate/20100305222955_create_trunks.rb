class CreateTrunks < ActiveRecord::Migration
  def self.up
    create_table :trunks do |t|
      t.string :name
      t.string :description
      t.string :protocol
      t.string :tech_prefix

      t.timestamps
    end
  end

  def self.down
    drop_table :trunks
  end
end
