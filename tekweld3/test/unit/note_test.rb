require File.dirname(__FILE__) + '/../test_helper'

class NoteTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :notes
  def test_truth
    assert true
  end
  
  def test_invalid_with_empty_attributes
    notes = Setup::Note.new
    #notes['company_id'] = 1
    #notes['user_id'] = 5
    assert !notes.valid?
    #assert notes.errors.invalid?(:company_id)
    #assert notes.errors.invalid?(:user_id)
  end  
  
  def test_valid_with_attributes
    notes = Setup::Note.new
    notes['company_id'] = 1
    notes['user_id'] = 5
    assert notes.valid?
  end  

end
