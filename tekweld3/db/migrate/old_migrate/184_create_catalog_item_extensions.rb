class CreateCatalogItemExtensions < ActiveRecord::Migration
  def self.up
    create_table :catalog_item_extensions do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :catalog_item_id, :default=>0

      t.decimal   :wt,  :precision=>10, :scale=> 4, :null=>true
      t.decimal   :min_wt, :precision=>10, :scale=> 4, :null=>true
      t.decimal   :max_wt, :precision=>10, :scale=> 4, :null=>true
      t.decimal   :min_qty, :precision=>10, :scale=> 2, :null=>true
      t.decimal   :max_qty, :precision=>10, :scale=> 2, :null=>true
      t.string    :mm_size, :limit=>25
      t.decimal   :style_cost, :precision=>10, :scale=> 2, :null=>true

      t.decimal   :silver_base_rate, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :silver_surcharge, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :silver_total_rate, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :silver_mu, :precision=>12, :scale=> 2, :null=>true

      t.decimal   :gold_base_rate, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :gold_surcharge, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :gold_total_rate, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :gold_mu, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :gold_increment, :precision=>8, :scale=> 6, :null=>true

      t.decimal   :platinum_base_rate, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :platinum_surcharge, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :platinum_total_rate, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :platinum_mu, :precision=>12, :scale=> 2, :null=>true

      t.decimal   :paladium_base_rate, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :paladium_surcharge, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :paladium_total_rate, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :paladium_mu, :precision=>12, :scale=> 2, :null=>true

      t.string    :metal_color, :limit=>25
      t.decimal   :metal_size, :precision=>7, :scale=> 2, :null=>true
      t.string    :metal_type, :limit=>25
      t.decimal   :metal_rate, :precision=>7, :scale=> 2, :null=>true
      t.decimal   :metal_wt, :precision=>10, :scale=> 2, :null=>true
      t.string    :metal_unit, :limit=>25
      t.decimal   :metal_cost, :precision=>10, :scale=> 2, :null=>true
      t.decimal   :metal_mu, :precision=>5, :scale=> 2, :null=>true
      t.decimal   :metal_amt, :precision=>10, :scale=> 2, :null=>true
      t.decimal   :metal_mu_retail , :precision=>7, :scale=> 2
      t.decimal   :metal_amt_retail , :precision=>10, :scale=> 2

      t.string    :diamond_qlty, :limit=>25
      t.integer   :diamond_qty
      t.decimal   :diamond_wt, :precision=>10, :scale=> 4, :null=>true
      t.decimal   :diamond_cost, :precision=>10, :scale=> 2, :null=>true
      t.decimal   :diamond_mu, :precision=>5, :scale=> 2, :null=>true
      t.decimal   :diamond_amt, :precision=>10, :scale=> 2, :null=>true
      t.decimal   :diamond_mu_retail, :precision=>7, :scale=> 2, :null=>true
      t.decimal   :diamond_amt_retail, :precision=>10, :scale=> 2, :null=>true

      t.string    :color_stone_type, :limit=>25
      t.string    :color_stone_shape, :limit=>25
      t.string    :color_stone_size, :limit=>25
      t.string    :color_stone_qlty, :limit=>25
      t.integer   :color_stone_qty
      t.decimal   :color_stone_wt, :precision=>10, :scale=> 4, :null=>true
      t.decimal   :color_stone_cost, :precision=>7, :scale=> 2, :null=>true
      t.decimal   :color_stone_mu, :precision=>5, :scale=> 2, :null=>true
      t.decimal   :color_stone_amt, :precision=>10, :scale=> 2, :null=>true
      t.decimal   :cstone_amt_retail , :precision=>10, :scale=> 2
      t.decimal   :cstone_mu_retail, :precision=>10, :scale=> 2
      t.decimal   :cstone_amt_retail, :precision=>10, :scale=> 2
      
      t.string    :center_stone_size, :limit=>25
      t.string    :center_stone_type, :limit=>25
      t.string    :center_stone_shape, :limit=>25
      t.string    :center_stone_qlty, :limit=>25
      t.decimal   :ctrstone_wt, :precision=>8, :scale=> 4, :null=>true
      t.decimal   :center_stone_cost, :precision=>10, :scale=> 2, :null=>true
      t.decimal   :center_stone_mu, :precision=>7, :scale=> 2, :null=>true
      t.decimal   :center_stone_amt, :precision=>10, :scale=> 2, :null=>true
      t.decimal   :ctrstone_retail_mu, :precision=>7, :scale=> 2, :null=>true
      t.decimal   :ctrstone_retail_price, :precision=>10, :scale=> 2, :null=>true

      t.decimal   :finishing_labor_cost, :precision=>10, :scale=> 2, :null=>true
      t.decimal   :finishing_labor_mu, :precision=>5, :scale=> 2, :null=>true
      t.decimal   :finishing_labor_amt, :precision=>10, :scale=> 2, :null=>true
      t.decimal   :finishinglabor_mu_retail, :precision=>7, :scale=> 2
      t.decimal   :finishinglabor_amt_retail, :precision=>10, :scale=> 2

      t.decimal   :settinglabor_cost, :precision=>10, :scale=> 2, :null=>true
      t.decimal   :settinglabor_mu, :precision=>5, :scale=> 2, :null=>true
      t.decimal   :settinglabor_amt, :precision=>10, :scale=> 2, :null=>true
      t.string    :setter_instrucion, :limit=>100
      t.decimal   :settinglabor_mu_retail, :precision=>7, :scale=> 2
      t.decimal   :settinglabor_amt_retail, :precision=>10, :scale=> 2

      t.decimal   :other_cost, :precision=>10, :scale=> 2, :null=>true
      t.decimal   :other_mu, :precision=>7, :scale=> 2, :null=>true
      t.decimal   :other_amt, :precision=>10, :scale=> 2, :null=>true
      t.decimal   :other_mu_retail, :precision=>7, :scale=> 2, :null=>true
      t.decimal   :other_amt_retail, :precision=>10, :scale=> 2, :null=>true

      t.decimal   :total_cost, :precision=>10, :scale=> 2, :null=>true
      t.decimal   :markup_per, :precision=>5, :scale=> 2, :null=>true
      t.decimal   :margin_per, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :margin_amt, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :price, :precision=>10, :scale=> 2, :null=>true

      t.string    :mu_margin_flag, :limit=>1
      t.string    :certificate, :limit=>1, :default=>'N'

      t.decimal   :surcharge_per, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :surcharge_amt, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :discount_per, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :discount_amt, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :duty_per, :precision=>6, :scale=> 2, :null=>true
      t.decimal   :duty_amt, :precision=>12, :scale=> 2, :null=>true
      t.decimal   :markup_per_retail, :precision=>7, :scale=> 2, :null=>true
      t.decimal   :retail_price, :precision=>12, :scale=> 2, :null=>true

      t.string    :setter_instrucion, :limit=>100
    end
  end

  def self.down
    drop_table :catalog_item_extensions
  end
end
