class Inventory::InventoryAgingTable < ActiveRecord::BaseWithoutTable
  attr_accessor :item_category
  attr_accessor :item_code
  attr_accessor :item_name
  attr_accessor :serial_no
  attr_accessor :trans_bk
  attr_accessor :trans_no
  attr_accessor :trans_date
  attr_accessor :due_days
  attr_accessor :group1_stock
  attr_accessor :group2_stock
  attr_accessor :group3_stock
  attr_accessor :group4_stock
  attr_accessor :current_stock
  attr_accessor :company_code
  attr_accessor :company_name
  
  def fill_temp_table(item_category,item_code,item_name,serial_no,trans_bk,trans_no,trans_dt,due_days,group1_stock,group2_stock,
                      group3_stock,group4_stock,current_stock,company_code,company_name)
    self.item_category = item_category
    self.item_code = item_code
    self.item_name = item_name
    self.serial_no = serial_no
    self.trans_bk = trans_bk
    self.trans_no = trans_no
    self.trans_date = trans_dt
    self.due_days = due_days
    self.group1_stock = group1_stock
    self.group2_stock = group2_stock
    self.group3_stock = group3_stock
    self.group4_stock = group4_stock
    self.current_stock = current_stock
    self.company_name = company_name
    self.company_code = company_code
  end 
end
