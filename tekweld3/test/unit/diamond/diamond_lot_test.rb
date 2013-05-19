require File.dirname(__FILE__) + '/../../test_helper'

class Diamond::DiamondLotTest < ActiveSupport::TestCase
  directory = File.join(File.dirname(__FILE__),"../../fixtures/diamond")
  Fixtures.create_fixtures(directory, "diamond_lots")
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_should_create_lot
    lot = Diamond::DiamondLot.new
    lot.lot_number='lot new'
    lot.description='lot new name'
    lot.company_id=1
    assert lot.save! 
   end

  def test_should_not_allow_duplicate_code
    lot = Diamond::DiamondLot.new
    lot.lot_number='AD'
    lot.description='American Diamond'
    lot.company_id=1
    assert !lot.save
  end  
  
end
