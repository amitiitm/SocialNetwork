module PointOfSale::Receipt
include General
include ClassMethods

#def fill_header
#  self.trans_bk = 'PS01'  
#  self.docu_type = 'POSREC'
#
#  fill_default_header_values
#end
#  
#def fill_default_header_values
#  self.trans_date ||= Time.now 
#  self.item_amt || 0
#  self.discount_per || 0
#  self.discount_amt || 0
#  self.tax_per || 0
#  self.tax_amt || 0
##  self.shipping_amt || 0
#  self.ship_amt || 0
#  self.net_amt || 0
#  account_period = Setup::AccountPeriod.period_from_date(self.trans_date)
#  self.account_period_code = account_period.code if account_period
#end
#
#
#def generate_trans_no
#  self.trans_no = Setup::Sequence.generate_docu_no(self.trans_bk,self.docu_type,self.class,self.company_id)
#end
# 
#def update_trans_no
#  Setup::Sequence.upd_book_code(self.trans_bk,self.docu_type,self.trans_no,self.company_id)  
#end 
#
def validate_pos_invoice
  if self.customer_id && !self.pos_invoice_addresses
    raise_error('Billing address Required!!!!')
  end
end
#
#def sum_of_item_amounts
#  return pos_invoice_lines.applied_lines.inject(0){|sum,x| sum += nulltozero(x.item_amt)} if pos_invoice_lines
#end
#
def post_pos_invoices
  return_receipts = []
  returns.each{|ret|
    receipt_line_item = PointOfSale::PosInvoiceLine.find_by_id(ret.ref_pos_invoice_id)
    receipt_line_item.clear_qty =-  ret.item_qty
    return_receipts << receipt_line_item 
  }
  return_receipts
#  returns
end
#
def returns
  return  self.pos_invoice_lines.to_ary.find_all{|li| li.trans_flag=='A' and nulltozero(li.net_amt) != 0 and li.ref_pos_invoice_id }
end

end
