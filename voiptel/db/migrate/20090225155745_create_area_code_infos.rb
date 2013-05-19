class CreateAreaCodeInfos < ActiveRecord::Migration
  def self.up
    create_table :area_code_infos do |t|
      t.integer :npa
      t.integer :nxx
      t.integer :county_pop
      t.integer :zipcode_count
      t.integer :zipcode_freq
      t.decimal :lat ,:precision => 12,:scale => 8
      t.decimal :long , :precision => 12,:scale => 8
      #t.string
      #t.string 
      t.string :state, :limit => 2
      t.string :city
      t.string :county
      t.string :timezone
      t.string :observes_dst
      t.string :nxx_use_type
      t.string :nxx_intro_version
      t.string :zipcode
      t.string :npa_new
      t.string :fips
      t.string :lata
      t.string :overlay
      t.string :ratecenter
      t.string :switch_clli
      t.string :msa_cbsa
      t.string :msa_cbsa_code
      t.string :ocn
      t.string :company
      t.string :coverage_area_name
      t.integer :npanxx

      t.timestamps
    end
  end

  def self.down
    drop_table :area_code_infos
  end
end
