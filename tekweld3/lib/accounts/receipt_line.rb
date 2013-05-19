module Accounts::ReceiptLine
  include General
  include ClassMethods

  def validate_balance_amt
    apply_amt = nulltozero(self.apply_amt)
    disctaken_amt = nulltozero(self.disctaken_amt)
    balance_amt = nulltozero(self.balance_amt)
    #    if recpt_line.apply_flag = 'Y'
    if balance_amt > 0
      raise_error( "Apply amt cannot be less than 0") if apply_amt <  0     
      raise_error("Apply amt cannot be greater than Original Amount") if apply_amt > (balance_amt -disctaken_amt)            
    else
      raise_error("Apply amt cannot be greater than 0") if apply_amt > 0
      raise_error("Apply amt cannot be greater than Original Amount") if apply_amt < (balance_amt - disctaken_amt)         
    end       
  end

  def calculate_receipt_line_amounts
    apply_amt = nulltozero(self.apply_amt)
    disctaken_amt = nulltozero(self.disctaken_amt)
    self.old_balance_amt = nulltozero(self.balance_amt)
    #  balance_amt = nulltozero(self.balance_amt)
    #  self.balance_amt =  old_balance_amt - apply_amt + disctaken_amt
    self.apply_flag = apply_amt != 0 ? 'Y' : 'N'
    self.trans_flag = (apply_amt + disctaken_amt) != 0 ? 'A' : 'D'
  end

  def update_invoice_to_view_only
    trans_bk,trans_no = trans_bk_no_from_voucher_no(self.voucher_no)
    case trans_bk
    when 'SI01'
      trans_no = cal_trans_no_if_multiple_invoice(trans_no)
      Sales::SalesInvoice.make_view_only(trans_bk,trans_no,self.voucher_date,self.company_id)
    when 'SC01'
      Sales::SalesCreditInvoice.make_view_only(trans_bk,trans_no,self.voucher_date,self.company_id)
    when 'SI02'
      trans_no = cal_trans_no_if_multiple_invoice(trans_no)
      DiamondSale::DiamondSale.make_view_only(trans_bk,trans_no,self.voucher_date,self.company_id)
    when 'SC02'
      DiamondSale::DiamondSale.make_view_only(trans_bk,trans_no,self.voucher_date,self.company_id)
    when 'PI01'
      trans_no = cal_trans_no_if_multiple_invoice(trans_no)
      Purchase::PurchaseInvoice.make_view_only(trans_bk,trans_no,self.voucher_date,self.company_id)
    when 'PI02'
      trans_no = cal_trans_no_if_multiple_invoice(trans_no)
      DiamondPurchase::DiamondPurchase.make_view_only(trans_bk,trans_no,self.voucher_date,self.company_id)
    when 'PA01','RE01'
      GeneralLedger::BankTransaction.make_view_only(trans_bk,trans_no,self.voucher_date,self.company_id)
    end

  end

  def cal_trans_no_if_multiple_invoice(trans_no)
    invoice_suffix= trans_no["#{trans_no.strip.length}".to_i - 2,2].to_s
    if multiple_invoice(invoice_suffix) then
      trans_no = trans_no[0,"#{trans_no.strip.length}".to_i - 2].to_s 
    end 
    trans_no
  end

  def multiple_invoice(invoice_suffix)
    case invoice_suffix
      #    when 'a' , 'b', 'c' , 'd' , 'e' , 'f'   
    when '-A' , '-B', '-C' , '-D' , '-E' , '-F' , '-G' , '-H' , '-I' , '-J' , '-K' , '-L' 
      return true
    else
      return false
    end
  end
  
end
