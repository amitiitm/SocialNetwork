class CreateDistributors < ActiveRecord::Migration
  def self.up
    create_table :distributors do |t|
      t.string :first_name
      t.string :last_name
      t.string :business_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :zip
      t.string :phones

      t.timestamps
    end
  end

  def self.down
    drop_table :distributors
  end
end
