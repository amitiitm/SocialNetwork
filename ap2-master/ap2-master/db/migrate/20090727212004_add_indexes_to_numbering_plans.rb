class AddIndexesToNumberingPlans < ActiveRecord::Migration
  def self.up
    add_index :numbering_plans, :cns
    add_index :numbering_plans, :country_code
    add_index :numbering_plans, :country_name_2_letters
    add_index :numbering_plans, :country_name_3_letters
    add_index :numbering_plans, :phone_type
    add_index :numbering_plans, :area_code_length
  end

  def self.down
    remove_index :numbering_plans, :area_code_length
    remove_index :numbering_plans, :phone_type
    remove_index :numbering_plans, :country_name_3_letters    
    remove_index :numbering_plans, :country_name_2_letters
    remove_index :numbering_plans, :country_code
    remove_index :numbering_plans, :cns
  end
end
