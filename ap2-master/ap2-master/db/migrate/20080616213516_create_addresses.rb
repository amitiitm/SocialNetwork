class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :state, :limit => 50
      t.integer :zipcode
      t.integer :user_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
