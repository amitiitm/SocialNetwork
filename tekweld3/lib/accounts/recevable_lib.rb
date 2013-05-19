
module Accounts::RecevableLib
  include General
  include ClassMethods   

  #def gl_postings
  #   GeneralLedger::GlDetail.find_all_by_trans_no_and_trans_bk(self.trans_no,self.trans_bk)
  #end
  
  def fill_header_from_customer(customer,trans_type)
    self.customer_id = customer.id
    self.salesperson_code = customer.salesperson_code
    self.parent_id = customer.billto_id || customer.id
    if customer.billto_id == customer.id
      self.parent_code = customer.code 
    else
      self.parent_code = customer.bill_to.code if customer.bill_to
    end
    self.customer_code = customer.code if customer
    self.term_code = customer.memo_term_code   if credit_invoice?(trans_type)
    self.term_code = customer.memo_term_code  if receipts?(trans_type) 
    self.term_code = customer.invoice_term_code  if invoice?(trans_type)
    account_period =  Setup::AccountPeriod.period_from_date(self.trans_date)
    self.account_period_code = account_period.code if account_period
  end

  def customer_address(customer)
    self.name = customer.name
    self.city= customer.city
    self.state = customer.state
    self.zip = customer.zip
    self.contact1 = customer.contact1
    self.phone1 = customer.phone1
  end

  def fill_payment_details
    bank =  GeneralLedger::Bank.fetch_bank(self.bank_id)
    self.receipt_type = bank.payment_type   if bank
    #  self.check_no = Accounts::GenerateCheckNumber.generate_check_no('PAYM', self.bank_id, self.payment_type)
    self.check_date = Time.now
  end

  def fill_bank_details(bank)
    self.receipt_type = bank.payment_type   if bank
    #  self.check_no = Accounts::GenerateCheckNumber.generate_check_no('PAYM', self.bank_id, self.payment_type)
    self.check_date = Time.now
  end

  #def fill_header_from_terms
  #  term = Setup::Term.find_by_code(self.term_code) if self.term_code
  #  if term
  #    self.due_date = nulltozero(term.pay1_days) == 0 ? self.sale_date :  relativedate(self.sale_date ,term.pay1_days)
  #    self.discount_date = nulltozero(term.disc_days) == 0 ? self.sale_date :  relativedate(self.sale_date ,term.disc_days)
  #    self.discount_per = nulltozero(term.disc_per)
  #  end
  #end

  def customer_gl_account
    #  customer_category = self.customer.customer_category
    #  return customer_category.gl_accounts_receivable_id, customer_category.gl_discount_account_id if customer_category
    glsetup = GeneralLedger::GlSetup.find(:first)
    return  glsetup.ar_account_id ,glsetup.discount_sales_account_id
  end


end
