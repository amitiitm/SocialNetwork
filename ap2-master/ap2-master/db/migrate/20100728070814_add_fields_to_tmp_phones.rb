class AddFieldsToTmpPhones < ActiveRecord::Migration
  def self.up
    add_column :tmp_phones, :area_code_info_id, :integer
    add_column :tmp_phones, :did_id, :integer
    add_column :tmp_phones, :phone_type, :integer
  end

  def self.down
    remove_column :tmp_phones, :phone_type
    remove_column :tmp_phones, :did_id
    remove_column :tmp_phones, :area_code_inof_id
  end
end
