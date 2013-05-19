class AlterCatalogParametersAddShowPriceFlag < ActiveRecord::Migration
  def self.up
    add_column :catalog_parameters, :show_price_flag, :string ,:limit=>1, :default=>'Y' # Y Show price, N do not show price on catalog.
  end

  def self.down
   remove_column :catalog_parameters, :show_price_flag
  end
end
