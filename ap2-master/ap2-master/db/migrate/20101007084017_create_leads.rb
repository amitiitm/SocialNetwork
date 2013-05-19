class CreateLeads < ActiveRecord::Migration
  def self.up
    create_table :leads do |t|
      t.string :first_name
      t.string :last_name
      t.string :time_zone
      t.string :zip_code
      t.string :city
      t.string :state
      t.string :country_id
      t.string :phone
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :leads
  end
end
