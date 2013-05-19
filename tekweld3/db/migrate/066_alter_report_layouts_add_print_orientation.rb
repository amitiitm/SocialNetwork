class AlterReportLayoutsAddPrintOrientation < ActiveRecord::Migration
  def self.up
    add_column :report_layouts, :print_orientation, :string, :limit=>1, :default=>'P'
  end

  def self.down
    remove_column :report_layouts, :print_orientation
  end
end
