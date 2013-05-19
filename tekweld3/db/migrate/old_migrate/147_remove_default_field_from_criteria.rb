class RemoveDefaultFieldFromCriteria < ActiveRecord::Migration
  def self.up
    remove_column :criterias, :default_yn
  end

  def self.down
    add_column :criterias, :default_yn, :string, :limit=>1
  end
end
