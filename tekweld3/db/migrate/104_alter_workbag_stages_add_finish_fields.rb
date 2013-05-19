class AlterWorkbagStagesAddFinishFields < ActiveRecord::Migration
  def self.up
    add_column :workbag_stages, :allow_transfer , :string ,:limit=>1
    add_column :workbag_stages, :finish_flag , :string ,:limit=>1
  end

  def self.down
    remove_column :workbag_stages, :allow_transfer
    remove_column :workbag_stages, :finish_flag
  end
end
