class CreatePhoneCountries < ActiveRecord::Migration
  def self.up
    create_table :phone_countries, :id => false do |t|
      t.string :number, :limit => 20
      t.string :country_id, :limit => 2
    end
  end

  def self.down
    drop_table :phone_countries
  end
end
