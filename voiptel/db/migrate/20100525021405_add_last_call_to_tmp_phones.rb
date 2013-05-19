class AddLastCallToTmpPhones < ActiveRecord::Migration
  def self.up
    add_column :tmp_phones, :last_call, :datetime
  end

  def self.down
    remove_column :tmp_phones, :last_call
  end
end
