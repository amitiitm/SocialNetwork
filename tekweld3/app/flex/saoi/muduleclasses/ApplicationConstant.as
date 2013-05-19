package saoi.muduleclasses
{
	public class ApplicationConstant
	{
		public function ApplicationConstant()
		{
		}
		
		//reorder type
		//public static const REORDER_TYPE_NORMAL:String  		 	 = 'NORMAL';
		//public static const REORDER_TYPE_CHANGE:String  			 = 'CHANGE';
		//public static const REORDER_TYPE_CHANGEWITHARTWORK:String  	 = 'CHANGEWITHARTWORK';
		
		//RUSH CHNARGES
		public static const MULTIOPTION:String  		 = 'MULTI';
		
		//RUSH CHNARGES
		public static const RUSH_TYPE1:String  		 	 = 'RUSHDAY1';
		public static const RUSH_TYPE2:String  			 = 'RUSHDAY2';
		public static const RUSH_TYPE3:String  	 		 = 'RUSHDAY1-NOCHARGE';
		public static const RUSH_TYPE4:String  			 = 'RUSHDAY2-NOCHARGE';
		public static const RUSH_TYPE5:String  	 		 = '';
		
		
		
		public static const REORDER_COMMENT:String  		 	 	 = 'THIS ARTWORK COPIED FROM ORDER #';
		
		public static const REORDER_TYPE_NORMAL:String  		 	 = 'EXACT';
		public static const REORDER_TYPE_CHANGE:String  			 = 'CHANGE NO ART';
		public static const REORDER_TYPE_CHANGEWITHARTWORK:String  	 = 'CHANGE W / ART';
		
		//item work flow
		public static const ITEM_IMPRINTTYPE:String  		 = 'IMPRINTTYPE';
		public static const ITEM_WORKFLOW_EMBROIDERY:String  = 'EMBROIDERY';
		public static const ITEM_WORKFLOW_WATER:String  	 = 'WATER';
		
		//artwork type
		public static const ARTWORK_TYPE_CUSTOMER_PO:String   = 'CUSTOMER PO';
		public static const ARTWORK_TYPE_CUSTOMER_ART:String  = 'CUSTOMER ART';
		
		
		// service charges
		public static const DEFAULT_SETUP:String  = 'SETUP';
		//public static const DEFAULT_CHANGE_WITH_PROOF:String  = 'CHANGEWITHPROOF';
		public static const DEFAULT_CHANGE_WITH_PROOF:String  = 'SETUP';
		
		// shipping provider
		public static const SHIPPING_PROVIDER_UPS:String  = 'UPS';
		public static const SHIPPING_PROVIDER_USPS:String  = 'USPS';
		public static const SHIPPING_PROVIDER_FEDEX:String  = 'FEDEX';
		
		
		//default shipping method
		public static const DEFAULT_SHIPPING_METHOD_UPS:String  = '03';
		public static const DEFAULT_SHIPPING_METHOD_USPS:String  = 'PARCEL_POST';
		public static const DEFAULT_SHIPPING_METHOD_FEDEX:String  = 'FEDEX_GROUND';
		
		
		//default shipping method
		public static const SHIPPING_CHARGE_DISCOUNT_CODE:String  = 'SHIPPINGCHARGEDISCOUNT';
	}
}