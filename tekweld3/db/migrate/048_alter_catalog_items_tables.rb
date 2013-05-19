class AlterCatalogItemsTables < ActiveRecord::Migration
  def self.up
    add_column :catalog_item_castings, :markup_per, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_castings, :price, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_castings, :remarks, :string, :limit=>250
    add_column :catalog_item_findings, :markup_per, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_findings, :price, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_findings, :remarks, :string, :limit=>250
    add_column :catalog_item_findings, :price_flag, :string, :limit=>1
    add_column :catalog_item_diamonds, :remarks, :string, :limit=>250
    add_column :catalog_item_stones, :remarks, :string, :limit=>250
    remove_column :catalog_item_extensions, :cstone_mu_retail
    add_column :catalog_item_extensions, :color_stone_mu_retail, :decimal, :precision=>12, :scale=>2
    remove_column :catalog_item_extensions, :cstone_amt_retail
    add_column :catalog_item_extensions, :color_stone_amt_retail, :decimal, :precision=>12, :scale=>2
    remove_column :catalog_item_extensions, :ctrstone_retail_mu		
    add_column :catalog_item_extensions, :center_stone_retail_mu, :decimal, :precision=>12, :scale=>2
    remove_column :catalog_item_extensions, :ctrstone_retail_price	
    add_column :catalog_item_extensions, :center_stone_retail_price, :decimal, :precision=>12, :scale=>2
    remove_column :catalog_item_extensions, :ctrstone_wt		
    add_column :catalog_item_extensions, :center_stone_wt, :decimal, :precision=>12, :scale=>4
    add_column :catalog_item_extensions, :subtotal_cost, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_extensions, :vendor_po_cost, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_diamonds, :markup_per, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_stones, :markup_per, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_stones, :price, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_diamonds, :price, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_others, :price, :decimal, :precision=>12, :scale=>2
    remove_column :catalog_item_extensions, :paladium_base_rate
    remove_column :catalog_item_extensions, :paladium_surcharge
    remove_column :catalog_item_extensions, :paladium_total_rate
    remove_column :catalog_item_extensions, :paladium_mu
    add_column :catalog_item_extensions, :palladium_base_rate, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_extensions, :palladium_surcharge, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_extensions, :palladium_total_rate, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_extensions, :palladium_mu, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_castings, :casting_cost, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_findings, :finding_cost, :decimal, :precision=>12, :scale=>2
  end
  
  def self.down
    remove_column :catalog_item_castings, :markup_per
    remove_column :catalog_item_castings, :price
    remove_column :catalog_item_castings, :remarks
    remove_column :catalog_item_findings, :markup_per
    remove_column :catalog_item_findings, :price
    remove_column :catalog_item_findings, :remarks
    remove_column :catalog_item_findings, :price_flag
    remove_column :catalog_item_diamonds, :remarks
    remove_column :catalog_item_stones, :remarks
    add_column :catalog_item_extensions, :cstone_mu_retail, :decimal, :precision=>12, :scale=>2
    remove_column :catalog_item_extensions, :color_stone_mu_retail
    add_column :catalog_item_extensions, :cstone_amt_retail, :decimal, :precision=>12, :scale=>2
    remove_column :catalog_item_extensions, :color_stone_amt_retail
    add_column :catalog_item_extensions, :ctrstone_retail_mu, :decimal, :precision=>12, :scale=>2		
    remove_column :catalog_item_extensions, :center_stone_retail_mu
    add_column :catalog_item_extensions, :ctrstone_retail_price, :decimal, :precision=>12, :scale=>2	
    remove_column :catalog_item_extensions, :center_stone_retail_price
    add_column :catalog_item_extensions, :ctrstone_wt, :decimal, :precision=>12, :scale=>4	
    remove_column :catalog_item_extensions, :center_stone_wt
    remove_column :catalog_item_extensions, :subtotal_cost
    remove_column :catalog_item_extensions, :vendor_po_cost
    remove_column :catalog_item_diamonds, :markup_per
    remove_column :catalog_item_stones, :markup_per
    remove_column :catalog_item_stones, :price
    remove_column :catalog_item_diamonds, :price
    remove_column :catalog_item_others, :price
    remove_column :catalog_item_others, :remarks
    add_column :catalog_item_extensions, :paladium_base_rate, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_extensions, :paladium_surcharge, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_extensions, :paladium_total_rate, :decimal, :precision=>12, :scale=>2
    add_column :catalog_item_extensions, :paladium_mu, :decimal, :precision=>12, :scale=>2
    remove_column :catalog_item_extensions, :palladium_base_rate
    remove_column :catalog_item_extensions, :palladium_surcharge
    remove_column :catalog_item_extensions, :palladium_total_rate
    remove_column :catalog_item_extensions, :palladium_mu
    remove_column :catalog_item_castings, :casting_cost
    remove_column :catalog_item_findings, :finding_cost
  end
end
