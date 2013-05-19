module SetupHelper
  def fetch_setup_charge_for_item_options1(catalog_attribute_code,customer_id)
    @setup_catalog_item_options1,@setup_cust_option_prices1 = Item::CatalogItemCrud.fetch_setup_charge_for_item_option_code(catalog_attribute_code,customer_id)
  end
  def fetch_setup_charge_for_item_options2(catalog_attribute_code,customer_id)
    @setup_catalog_item_options2,@setup_cust_option_prices2 = Item::CatalogItemCrud.fetch_setup_charge_for_item_option_code2(catalog_attribute_code,customer_id)
  end
  def fetch_setup_charge_for_item_option_values1(attribute_code_id,catalog_attribute_value_code,customer_id)
    @setup_catalog_item_values1,@setup_cust_value_prices1 = Item::CatalogItemCrud.fetch_setup_charge_for_item_option_value(attribute_code_id,catalog_attribute_value_code,customer_id)
  end
  def fetch_setup_charge_for_item_option_values2(attribute_code_id,catalog_attribute_value_code,customer_id)
    @setup_catalog_item_values2,@setup_cust_value_prices2 = Item::CatalogItemCrud.fetch_setup_charge_for_item_option_value2(attribute_code_id,catalog_attribute_value_code,customer_id)
  end
end
