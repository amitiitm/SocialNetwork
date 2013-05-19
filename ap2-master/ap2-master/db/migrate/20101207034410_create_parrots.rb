class CreateParrots < ActiveRecord::Migration
  def self.up
    create_table :parrots do |t|
    end
  end

  def self.down
    drop_table :parrots
  end
end
