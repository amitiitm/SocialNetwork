class CreateEndpoints < ActiveRecord::Migration
  def self.up
    create_table :endpoints do |t|
      t.string :name
      t.string :ip
      t.string :port
      t.text :settings
      t.integer :endpoint_type

      t.timestamps
    end
  end

  def self.down
    drop_table :endpoints
  end
end
