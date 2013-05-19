class Vendor::VendorAgingTable < ActiveRecord::BaseWithoutTable

#  column :serial_no,:integer
#  column :inv_no, :string
#  column :inv_dt, :datetime
#  column :due_dt, :datetime
#  column :due_days, :integer
#  column :group1_amt, :decimal 
#  column :group2_amt,:decimal
#  column :group3_amt,:decimal
#  column :group4_amt,:decimal
#  column :credit_amt,:decimal
#  column :current_amt, :decimal
#  column :company_code, :string
#  column :company_name, :string
#  column :inv_amt, :decimal
#  column :inv_bk, :string
#  column :sale_dt, :datetime
#  column :balance_amt, :decimal
#  column :vendor_code, :string
#  column :vendor_name, :string
#  column :city, :string
#  column :phone, :string
#  column :fax, :string
#  column :vendor_catagory_code, :string
#
#  def fill_temp_table(ll_serial_no,ls_inv_no,ldt_inv_dt,ldt_due_dt,li_due_days,ldec_group1_amt,ldec_group2_amt,ldec_group3_amt,ldec_group4_amt,
#                      ldec_credit_amt,ldec_current_amt,ldec_inv_amt, as_comp_cd,ls_inv_bk,ldt_sale_dt,ldec_balance_amt,
#                      vendor_code,vendor_name,city,phone,fax,vendor_catagory_code)
#
#    self.serial_no =ll_serial_no
#    self.inv_no = ls_inv_no
#    self.inv_dt = ldt_inv_dt
#    self.due_dt = ldt_due_dt
#    self.due_days = li_due_days
#    self.group1_amt = ldec_group1_amt
#    self.group2_amt = ldec_group2_amt
#    self.group3_amt = ldec_group3_amt
#    self.group4_amt = ldec_group4_amt
#    self.credit_amt = ldec_credit_amt
#    self.current_amt = ldec_current_amt
#    self.inv_amt = ldec_inv_amt
#    self.company_code = as_comp_cd
#    self.inv_bk = ls_inv_bk
#    self.sale_dt = ldt_sale_dt
#    self.balance_amt = ldec_balance_amt
#    self.vendor_code = vendor_code
#    self.vendor_name = vendor_name
#    self.city = city
#    self.fax = phone
#    self.fax = fax
#    self.vendor_catagory_code = vendor_catagory_code
#  end
end

