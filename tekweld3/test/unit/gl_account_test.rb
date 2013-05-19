require File.dirname(__FILE__) + '/../test_helper'

class GlAccountTest < Test::Unit::TestCase
  fixtures :gl_accounts
  def test_truth
    assert true
  end
  
  def test_should_create_bank
    assert_difference 'GeneralLedger::GlAccount.count' do
      gl = GeneralLedger::GlAccount.new
      gl.code='gl new'
      gl.name='gl new name'
      gl.company_id=1
#      gl.gl_category_id=1
      assert gl.save , "#{gl.errors.full_messages.to_sentence}"
  end
  end
end
