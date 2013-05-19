require File.dirname(__FILE__) + '/../../test_helper'

class Diamond::DiamondCategoryTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  directory = File.join(File.dirname(__FILE__),"../../fixtures/diamond")
  Fixtures.create_fixtures(directory, "diamond_categories")
  def test_truth
    assert true
  end
  
  def test_should_create_category
    assert_difference 'Diamond::DiamondCategory.count' do
      category = Diamond::DiamondCategory.new
      category.code='category new'
      category.name='category new name'
      category.company_id=1
      assert category.save , "#{category.errors.full_messages.to_sentence}"
    end
   end

  def test_should_not_allow_duplicate_code
    category = Diamond::DiamondCategory.new
    category.code='AD'
    category.name='American Diamond'
    category.company_id=1
    assert !category.save, "#{category.errors.full_messages.to_sentence}"
  end  
end
