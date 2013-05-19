class AlterEnquriesAddTitle < ActiveRecord::Migration
  def self.up
    add_column :enquiries, :title, :string, :limit=>100
  end

  def self.down
    remove_column :enquiries, :title
  end
end
