require File.dirname(__FILE__) + '/../test_helper'

class CustomerTest < Test::Unit::TestCase
fixtures :customers
def test_truth
    assert true
  end
  
def test_should_create_customer
  assert_difference 'Customer::Customer.count' do
    customer = Customer::Customer.new
    customer.code='customernew'
    customer.name='customer new name'
    customer.company_id=1
    assert customer.save , "#{customer.errors.full_messages.to_sentence}"
  end
  end

def test_should_not_allow_duplicate_code
  customer = Customer::Customer.new
  customer.code='dave'
  customer.name='customer new1'
  customer.company_id=1
  customer.stop_ship = 'N'
  assert customer.save, "#{customer.errors.full_messages.to_sentence}"
end  

end
