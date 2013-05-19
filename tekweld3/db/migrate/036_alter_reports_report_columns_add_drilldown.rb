class AlterReportsReportColumnsAddDrilldown < ActiveRecord::Migration
  def self.up
    add_column :reports, :drilldown_component_code, :string, :limit=>100
    add_column :report_columns, :drilldown_component_code, :string, :limit=>100
  end

  def self.down
    remove_column :reports, :drilldown_component_code
    remove_column :report_columns, :drilldown_component_code
  end
end
