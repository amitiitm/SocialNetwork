require File.dirname(__FILE__) + '/../../test_helper'

class CatalogGroupTest < ActiveSupport::TestCase
require 'test/unit'
require 'catalog_group'
fixtures :catalog_groups

 def test_should_create_catalog_group
  assert_difference 'Catalog::CatalogGroup.count' do
  catalog_group = Catalog::CatalogGroup.new
  catalog_group.code='catalog_group new'
  catalog_group.name='catalog_group new name'
  catalog_group.company_id=1
  assert catalog_group.save, "error while saving catalog_group"
  end
  end

def test_should_not_allow_duplicate_code
  catalog_group = Catalog::CatalogGroup.new
  catalog_group.code='catalog_group new1'
  catalog_group.name='catalog_group new1'
  catalog_group.company_id=1
  assert !catalog_group.save, "error on code duplicate test"
end  

end
