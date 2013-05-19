class CreateNpanxxes<ActiveRecord::Migration
  def self.up
    create_table :npanxxes do |t|
      t.string :npa
    	t.string :nxx
    	t.string :state
    	t.string :city
    	t.string :county
    	t.string :country
    	t.string :lata
    	t.string :company
    	t.string :overlay
    	t.string :ocn
    	t.string :observes_dst
    	t.string :latitude
    	t.string :longitude
    	t.string :time_zone
    	t.string :country_population
    	t.string :fips_county_code
    	t.string :msa_county_code
    	t.string :pmsa_county_code
    	t.string :cbsa_county_code
    	t.string :zipcode_postalcode
    	t.string :zipcode_count
    	t.string :zipcode_frequency
    	t.string :new_npa
    	t.string :nxx_use_type
    	t.string :nxx_intro_version
    	t.string :rate_center
    	t.string :switch_clli
    	t.string :rc_vertical
    	t.string :rc_horizontal
	
      t.timestamps
    end
  end

  def self.down
  drop_table :npanxxes
  end
end
