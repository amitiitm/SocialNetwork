require File.dirname(__FILE__) + '/../test_helper'

class CustomerInvoiceTest < ActiveSupport::TestCase
   fixtures :customer_invoices

  def test_truth
    assert true
  end
  
  def test_should_create_invoice
  assert_difference 'Customer::CustomerInvoice.count' do
    invoice = Customer::CustomerInvoice.new
    invoice.trans_bk = 'IN01'
    invoice.trans_date = '01/01/2009'
    invoice.customer_id = 100
    invoice.account_period_code = '200901'
    assert invoice.save , "#{invoice.errors.full_messages.to_sentence}"
  end
  end
  
  def test_should_not_allow_duplicate_trans_no
    invoice = Customer::CustomerInvoice.new
    invoice.trans_bk = 'IN01'
    invoice.trans_date = '01/01/2009'
    invoice.customer_id = 100
    invoice.account_period_code = '200901'
    assert invoice.save , "#{invoice.errors.full_messages.to_sentence}"
end  
  
end
