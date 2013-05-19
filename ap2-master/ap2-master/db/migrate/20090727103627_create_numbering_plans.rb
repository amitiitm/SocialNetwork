class CreateNumberingPlans < ActiveRecord::Migration
  def self.up
    create_table :numbering_plans do |t|
      t.string :cns                       ,:limit => 15
      t.string :country_code              ,:limit => 3
      t.string :area_code                 ,:limit => 14
      t.string :country_name_2_letters    ,:limit => 2
      t.string :country_name_3_letters    ,:limit => 3
      t.decimal :utc_min
      t.decimal :utc_max
      t.string :country_name              ,:limit => 255
      t.string :phone_type                ,:limit => 3
      t.string :description               ,:limit => 50
      t.string :location                  ,:limit => 255
      t.string :registrar                 ,:limit => 255
      t.integer :area_code_length         ,:limit => 1
      t.integer :min_subscr_nr_length     ,:limit => 2
      t.integer :max_subscr_nr_length     ,:limit => 2
      t.date :range_activation
      t.date :range_deactivation
      t.string :range_status              ,:limit => 10
      t.string :mobile_country_code       ,:limit => 3
      t.string :mobile_network_code       ,:limit => 3
      t.string :operating_company_number  ,:limit => 4
      
      t.timestamps
    end
  end

  def self.down
    drop_table :numbering_plans
  end
end
