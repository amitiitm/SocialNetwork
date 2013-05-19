module DiscountCouponHelper
  def fetch_discount_specific_prices(discount_coupon)
    catalog_item = Item::CatalogItem.find_all_by_id(discount_coupon.catalog_item_id)
    discount_coupon = Item::PriceUtility.apply_charge_code(discount_coupon.discount_type,discount_coupon,catalog_item)
    discount_coupon
  end
end