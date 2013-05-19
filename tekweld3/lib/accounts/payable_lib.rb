module Accounts::PayableLib
  include General
  include ClassMethods  
  include Accounts::GenerateCheckNumber
  
def fill_vendor_address(vendor)
#  vendor = self.vendor
  self.name = vendor.name
  self.city= vendor.city
  self.state = vendor.state
  self.zip = vendor.zip
#  self.contact1 = vendor.contact1
  self.phone1 = vendor.phone
end

def fill_header_from_vendor(vendor,trans_type)
  self.vendor_id = vendor.id
  self.vendor_code = vendor.code
  self.purchaseperson_code = (vendor.purchaseperson_code || 'NA')
  self.term_code = vendor.memo_term_code   if credit_invoice?(trans_type)
  self.term_code = vendor.memo_term_code  if payments?(trans_type) 
  self.term_code = vendor.invoice_term_code  if invoice?(trans_type)
  #flexible date format
  date_format = 'standard'
  account_period =  Setup::AccountPeriod.period_from_date(self.trans_date)
  self.account_period_code = account_period.code if account_period
end   

def vendor_gl_account
#  vendor_category = self.vendor.vendor_category
#  return vendor_category.gl_account_payable_id, vendor_category.gl_discount_account_id if vendor_category
  glsetup = GeneralLedger::GlSetup.find(:first)
  return  glsetup.ap_account_id ,glsetup.discount_purchase_account_id
end

def fill_check_details
  bank =  GeneralLedger::Bank.fetch_bank(self.bank_id)
  self.payment_type = bank.payment_type   if bank
  self.check_no = Accounts::GenerateCheckNumber.generate_check_no('PAYM', self.bank_id, self.payment_type)
  self.check_date = Time.now
end


end
