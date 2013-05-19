class AlterMeltingStageMasterSequenceNo < ActiveRecord::Migration
  def self.up
    remove_column :melting_stage_master,:sequence_no
    add_column :melting_stage_master,:sequence_no,:integer
  end

  def self.down
    remove_column :vendors,:password
    add_column :melting_stage_master,:sequence_no,:string, :limit => 50
  end
end

