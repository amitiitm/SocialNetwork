class Setup::Term < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  has_many:purchase_orders,  :class_name => 'PurchaseOrder::PurchaseOrder'
  has_many:purchase_invoices , :class_name => 'PurchaseInvoice::PurchaseInvoice'
  #  has_many:purchase_cancellations
  has_many :customers, :class_name => 'Customer::Customer'
  attr_accessor  :pay1_date
  
  def self.calculate_no_of_invoices(term)
    no_of_entries = 0
    if term.pay1_per > 0 
      no_of_entries = 1 
    end  
    if term.pay2_per > 0 
      no_of_entries = 2 
    end  
    if term.pay3_per > 0 
      no_of_entries = 3 
    end  
    if term.pay4_per > 0 
      no_of_entries = 4 
    end  
    if term.pay5_per > 0 
      no_of_entries = 5 
    end  
    if term.pay6_per > 0 
      no_of_entries = 6 
    end 

    if term.pay1_per + term.pay2_per + term.pay3_per + term.pay4_per + term.pay5_per + term.pay6_per != 100 
      #throw exception('Terms incorrect')
    end 
    no_of_entries
  end

  def self.generate_invoice_no(i, term, no_of_entries, trans_no)
    amt_percent = 0
    due_days = 0
    trans_no1 = trans_no
    case i
    when 1
      amt_percent = term.pay1_per
      due_days = term.pay1_days
      if no_of_entries > 1
        trans_no1 = trans_no.strip + 'a'
      end
    when 2
      amt_percent = term.pay2_per
      due_days = term.pay2_days
      trans_no1 = trans_no.strip + 'b'
    when 3
      amt_percent = term.pay3_per
      due_days = term.pay3_days
      trans_no1 = trans_no.strip + 'c'
    when 4
      amt_percent = term.pay4_per
      due_days = term.pay4_days
      trans_no1 = trans_no.strip + 'd'
    when 5
      amt_percent = term.pay5_per
      due_days = term.pay5_days
      trans_no1 = trans_no.strip + 'e'
    when 6
      amt_percent = term.pay6_per
      due_days = term.pay6_days
      trans_no1 = trans_no.strip + 'f'
    end
    return amt_percent, due_days, trans_no1
  end

  def self.calculate_discount_details_from_terms(term, trans_date)
    disc_days = 0
    disc_per = 0
    if not term.disc_days.nil?
      disc_days = term.disc_days
    end
    disc_date = relativedate(trans_date, disc_days)
    if not term.disc_per.nil?
      disc_per = term.disc_per
    end
    return disc_per, disc_date
  end

  def self.calculate_due_date(sale_date, due_days, trans_date)
    due_date = trans_date
    if due_days > 0
      due_date = relativedate(sale_date, due_days)
    end

    if due_date < sale_date
      #throw exception('Due date can not be less  sale date')
    end

    if due_date.nil?
      due_date = trans_date
    end
    due_date
  end
  
  
  def self.fill_terms(code,trans_date)
    term = Setup::Term.find_by_code(code) if code
    if term
      term.pay1_date = nulltozero(term.pay1_days) == 0 ? trans_date :  relativedate(trans_date ,term.pay1_days.to_i)  #due dste
      #      term.pay2_date = nulltozero(term.disc_days) == 0 ? trans_date:  relativedate(trans_date ,term.disc_days.to_i)   #discount date
      #      term.disc_per = nulltozero(term.disc_per)
      #term.pay1_date = term.pay1_date.to_time  if  term.pay1_date
      term.pay1_date = term.pay1_date.is_a?(ActiveSupport::TimeWithZone) ? term.pay1_date.time.strftime('%Y/%m/%d')  : term.pay1_date.to_time.strftime('%Y/%m/%d')   if  term.pay1_date
    end

    return term
  end
  def add_line_errors_to_header
  end
end

