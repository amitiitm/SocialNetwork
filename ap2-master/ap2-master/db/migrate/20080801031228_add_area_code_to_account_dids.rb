class AddAreaCodeToAccountDids < ActiveRecord::Migration
  def self.up
    add_column :account_dids, :area_code, :string
  end

  def self.down
    remove_column :account_dids, :area_code
  end
end
