class AlterJewelryCastingFindings < ActiveRecord::Migration
  def self.up
    remove_column :catalog_item_castings, :cost
    remove_column :catalog_item_castings, :labor
    remove_column :catalog_item_castings, :wt
    remove_column :catalog_item_castings, :finished_wt
    remove_column :catalog_item_castings, :total_wt
    remove_column :catalog_item_castings, :gold_surcharge
    remove_column :catalog_item_castings, :labor_wt
    add_column :catalog_item_castings, :cost, :decimal, :precision => 12, :scale => 2, :default => 0.0
    add_column :catalog_item_castings, :labor, :decimal, :precision => 12, :scale => 2, :default => 0.0
    add_column :catalog_item_castings, :wt, :decimal, :precision => 12, :scale => 4, :default => 0.0
    add_column :catalog_item_castings, :finished_wt, :decimal, :precision => 12, :scale => 4, :default => 0.0
    add_column :catalog_item_castings, :total_wt, :decimal, :precision => 12, :scale => 4, :default => 0.0
    add_column :catalog_item_castings, :gold_surcharge, :decimal, :precision => 12, :scale => 2, :default => 0.0
    add_column :catalog_item_castings, :labor_wt, :decimal, :precision => 12, :scale => 2, :default => 0.0
    remove_column :catalog_item_findings, :cost
    remove_column :catalog_item_findings, :labor
    remove_column :catalog_item_findings, :wt
    remove_column :catalog_item_findings, :finished_wt
    remove_column :catalog_item_findings, :total_wt
    remove_column :catalog_item_findings, :gold_surcharge
    remove_column :catalog_item_findings, :labor_wt
    add_column :catalog_item_findings, :cost, :decimal, :precision => 12, :scale => 2, :default => 0.0
    add_column :catalog_item_findings, :labor, :decimal, :precision => 12, :scale => 2, :default => 0.0
    add_column :catalog_item_findings, :wt, :decimal, :precision => 12, :scale => 4, :default => 0.0
    add_column :catalog_item_findings, :finished_wt, :decimal, :precision => 12, :scale => 4, :default => 0.0
    add_column :catalog_item_findings, :total_wt, :decimal, :precision => 12, :scale => 4, :default => 0.0
    add_column :catalog_item_findings, :gold_surcharge, :decimal, :precision => 12, :scale => 2, :default => 0.0
    add_column :catalog_item_findings, :labor_wt, :decimal, :precision => 12, :scale => 2, :default => 0.0
  end

  def self.down
    remove_column :catalog_item_castings, :cost
    remove_column :catalog_item_castings, :labor
    remove_column :catalog_item_castings, :wt
    remove_column :catalog_item_castings, :finished_wt
    remove_column :catalog_item_castings, :total_wt
    remove_column :catalog_item_castings, :gold_surcharge
    remove_column :catalog_item_castings, :labor_wt
    add_column :catalog_item_castings, :cost, :decimal, :precision => 10, :scale => 0, :default => 0.0
    add_column :catalog_item_castings, :labor, :decimal, :precision => 8, :scale => 0, :default => 0.0
    add_column :catalog_item_castings, :wt, :decimal, :precision => 8, :scale => 0, :default => 0.0
    add_column :catalog_item_castings, :finished_wt, :decimal, :precision => 8, :scale => 0, :default => 0.0
    add_column :catalog_item_castings, :total_wt, :decimal, :precision => 8, :scale => 0, :default => 0.0
    add_column :catalog_item_castings, :gold_surcharge, :decimal, :precision => 12, :scale => 0, :default => 0.0
    add_column :catalog_item_castings, :labor_wt, :decimal, :precision => 12, :scale => 2, :default => 0.0
    remove_column :catalog_item_findings, :cost
    remove_column :catalog_item_findings, :labor
    remove_column :catalog_item_findings, :wt
    remove_column :catalog_item_findings, :finished_wt
    remove_column :catalog_item_findings, :total_wt
    remove_column :catalog_item_findings, :gold_surcharge
    remove_column :catalog_item_findings, :labor_wt
    add_column :catalog_item_findings, :cost, :decimal, :precision => 10, :scale => 0, :default => 0.0
    add_column :catalog_item_findings, :labor, :decimal, :precision => 8, :scale => 0, :default => 0.0
    add_column :catalog_item_findings, :wt, :decimal, :precision => 8, :scale => 0, :default => 0.0
    add_column :catalog_item_findings, :finished_wt, :decimal, :precision => 8, :scale => 0, :default => 0.0
    add_column :catalog_item_findings, :total_wt, :decimal, :precision => 8, :scale => 0, :default => 0.0
    add_column :catalog_item_findings, :gold_surcharge, :decimal, :precision => 12, :scale => 0, :default => 0.0
    add_column :catalog_item_findings, :labor_wt, :decimal, :precision => 12, :scale => 2, :default => 0.0
  end
end
