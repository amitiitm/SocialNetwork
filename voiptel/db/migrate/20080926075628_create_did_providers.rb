class CreateDidProviders < ActiveRecord::Migration
  def self.up
    create_table :did_providers do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :did_providers
  end
end
