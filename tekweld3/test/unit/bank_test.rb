require File.dirname(__FILE__) + '/../test_helper'

class BankTest < Test::Unit::TestCase
   fixtures :banks
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_should_create_bank
  assert_difference 'GeneralLedger::Bank.count' do
    bank = GeneralLedger::Bank.new
    bank.code='bank new'
    bank.name='bank new name'
    bank.company_id=1
    bank.gl_category_id=1
    assert bank.save , "#{bank.errors.full_messages.to_sentence}"
  end
  end
  
  def test_should_not_allow_duplicate_code
    bank = GeneralLedger::Bank.new
    bank.code='HSBC'
    bank.name='bank new1'
    bank.company_id=1
    assert bank.save, "#{bank.errors.full_messages.to_sentence}"
end  
end
