class  AlterCatalogItemExtensions < ActiveRecord::Migration
  def self.up
    remove_column :catalog_item_extensions, :min_qty
    remove_column :catalog_item_extensions, :max_qty
    remove_column :catalog_item_extensions, :METAL_COLOR
    remove_column :catalog_item_extensions, :METAL_SIZE
    remove_column :catalog_item_extensions, :METAL_TYPE
    remove_column :catalog_item_extensions, :METAL_RATE
    remove_column :catalog_item_extensions, :METAL_WT
    remove_column :catalog_item_extensions, :METAL_UNIT
    remove_column :catalog_item_extensions, :METAL_COST
    remove_column :catalog_item_extensions, :METAL_MU
    remove_column :catalog_item_extensions, :METAL_AMT
    remove_column :catalog_item_extensions, :METAL_MU_RETAIL
    remove_column :catalog_item_extensions, :METAL_AMT_RETAIL
    add_column :catalog_item_extensions, :CASTING_COLOR, :string, :limit=>25
    add_column :catalog_item_extensions, :CASTING_SIZE, :decimal, :precision=>7, :scale=>2
    add_column :catalog_item_extensions, :CASTING_TYPE, :string, :limit=>25	
    add_column :catalog_item_extensions, :CASTING_RATE, :decimal, :precision=>7, :scale=>2
    add_column :catalog_item_extensions, :CASTING_WT, :decimal, :precision=>10, :scale=>2
    add_column :catalog_item_extensions, :CASTING_UNIT, :string, :limit=>25	
    add_column :catalog_item_extensions, :CASTING_COST, :decimal, :precision=>10, :scale=>2
    add_column :catalog_item_extensions, :CASTING_MU, :decimal, :precision=>5, :scale=>2
    add_column :catalog_item_extensions, :CASTING_AMT, :decimal, :precision=>10, :scale=>2
    add_column :catalog_item_extensions, :CASTING_MU_RETAIL, :decimal, :precision=>7, :scale=>2
    add_column :catalog_item_extensions, :CASTING_AMT_RETAIL, :decimal, :precision=>10, :scale=>2
    add_column :catalog_item_extensions, :FINDING_COLOR, :string, :limit=>25
    add_column :catalog_item_extensions, :FINDING_SIZE, :decimal, :precision=>7, :scale=>2
    add_column :catalog_item_extensions, :FINDING_TYPE, :string, :limit=>25	
    add_column :catalog_item_extensions, :FINDING_RATE, :decimal, :precision=>7, :scale=>2
    add_column :catalog_item_extensions, :FINDING_WT, :decimal, :precision=>10, :scale=>2
    add_column :catalog_item_extensions, :FINDING_UNIT, :string, :limit=>25	
    add_column :catalog_item_extensions, :FINDING_COST, :decimal, :precision=>10, :scale=>2
    add_column :catalog_item_extensions, :FINDING_MU, :decimal, :precision=>5, :scale=>2
    add_column :catalog_item_extensions, :FINDING_AMT, :decimal, :precision=>10, :scale=>2
    add_column :catalog_item_extensions, :FINDING_MU_RETAIL, :decimal, :precision=>7, :scale=>2
    add_column :catalog_item_extensions, :FINDING_AMT_RETAIL, :decimal, :precision=>10, :scale=>2
    add_column :catalog_item_extensions, :vendor_fixed_cost , :decimal, :precision=>10, :scale=>2
  end
  def self.down
    add_column :catalog_item_extensions, :min_qty, :integer
    add_column :catalog_item_extensions, :max_qty, :integer
    add_column :catalog_item_extensions, :METAL_COLOR, :string, :limit=>25
    add_column :catalog_item_extensions, :METAL_SIZE, :decimal, :precision=>7, :scale=>2
    add_column :catalog_item_extensions, :METAL_TYPE, :string, :limit=>25	
    add_column :catalog_item_extensions, :METAL_RATE, :decimal, :precision=>7, :scale=>2
    add_column :catalog_item_extensions, :METAL_WT, :decimal, :precision=>10, :scale=>2
    add_column :catalog_item_extensions, :METAL_UNIT, :string, :limit=>25	
    add_column :catalog_item_extensions, :METAL_COST, :decimal, :precision=>10, :scale=>2
    add_column :catalog_item_extensions, :METAL_MU, :decimal, :precision=>5, :scale=>2
    add_column :catalog_item_extensions, :METAL_AMT, :decimal, :precision=>10, :scale=>2
    add_column :catalog_item_extensions, :METAL_MU_RETAIL, :decimal, :precision=>7, :scale=>2
    add_column :catalog_item_extensions, :METAL_AMT_RETAIL, :decimal, :precision=>10, :scale=>2
    remove_column :catalog_item_extensions, :CASTING_COLOR
    remove_column :catalog_item_extensions, :CASTING_SIZE
    remove_column :catalog_item_extensions, :CASTING_TYPE
    remove_column :catalog_item_extensions, :CASTING_RATE
    remove_column :catalog_item_extensions, :CASTING_WT
    remove_column :catalog_item_extensions, :CASTING_UNIT
    remove_column :catalog_item_extensions, :CASTING_COST
    remove_column :catalog_item_extensions, :CASTING_MU
    remove_column :catalog_item_extensions, :CASTING_AMT
    remove_column :catalog_item_extensions, :CASTING_MU_RETAIL
    remove_column :catalog_item_extensions, :CASTING_AMT_RETAIL
    remove_column :catalog_item_extensions, :FINDING_COLOR
    remove_column :catalog_item_extensions, :FINDING_SIZE
    remove_column :catalog_item_extensions, :FINDING_TYPE
    remove_column :catalog_item_extensions, :FINDING_RATE
    remove_column :catalog_item_extensions, :FINDING_WT
    remove_column :catalog_item_extensions, :FINDING_UNIT
    remove_column :catalog_item_extensions, :FINDING_COST
    remove_column :catalog_item_extensions, :FINDING_MU
    remove_column :catalog_item_extensions, :FINDING_AMT
    remove_column :catalog_item_extensions, :FINDING_MU_RETAIL
    remove_column :catalog_item_extensions, :FINDING_AMT_RETAIL
    remove_column :catalog_item_extensions, :vendor_fixed_cost
  end
end
