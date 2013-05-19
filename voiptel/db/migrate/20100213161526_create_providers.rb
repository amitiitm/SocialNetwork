class CreateProviders < ActiveRecord::Migration
  def self.up
    create_table :providers do |t|
      t.string :name
      t.boolean :termination, :default => false
      t.boolean :origination, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :providers
  end
end
