class CreatePhones < ActiveRecord::Migration
  def self.up
    create_table :phones do |t|
      t.string :country_code
      t.string :area_code
      t.string :phone_number
      t.integer :phone_type, :limit => 1
      t.integer :user_id
      t.integer :account_id      
      
      t.timestamps
    end
  end

  def self.down
    drop_table :phones
  end
end
