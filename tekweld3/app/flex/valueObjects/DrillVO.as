package valueObjects
{
	import mx.controls.Alert;
	
	public class DrillVO
	{
		public var drillrow:XML			=	null;	
		public var drillcolumn:String	=	null;	
		
		private var drillDownCriteria:XML;
		public function DrillVO() {}
		
		public function getDrillDownCriteria(component_path:String,company_id:int,user_id:int,document_id:int):XML
		{
			drillDownCriteria	=	 new ViewVO().criteria;
			
			drillDownCriteria['default_request']	=	'N';
			drillDownCriteria['name']				=	'DRILL';
			drillDownCriteria['trans_flag']			=	'A';
			drillDownCriteria['default_yn']			=	'N';
			drillDownCriteria['criteria_type']		=	'U';
			
			drillDownCriteria['company_id']			=	company_id;
			drillDownCriteria['user_id']			=	user_id;
			drillDownCriteria['document_id']		=	 document_id;
			
			switch(component_path)
			{
				case 'saoi/discountcoupons/components/DiscountCoupons.swf':
					
					drillDownCriteria['str1']				=	drillrow.child('coupon_code').toString();
					drillDownCriteria['str2']				=	drillrow.child('coupon_code').toString();
					drillDownCriteria['str3']				=	'';
					drillDownCriteria['str4']				=	'zzzz';
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['str7']    			= 	'';
					drillDownCriteria['str8']    			= 	'zzzz';
					break;	
				
				case 'puoi/purchaseorder/components/PurchaseOrder.swf':
				
				drillDownCriteria['str1']				=	'';
				drillDownCriteria['str2']				=	'zzzz';
				drillDownCriteria['str3']				=	drillrow.child('trans_no').toString();
				drillDownCriteria['str4']				=	drillrow.child('trans_no').toString();
				drillDownCriteria['str5']				=	''
				drillDownCriteria['str6']				=	'zzzz'
				drillDownCriteria['dt1']    			= 	'01/01/1990';
				drillDownCriteria['dt2']    			= 	'12/12/2025';
				break;	
				case 'saoi/artworkquery/components/ArtworkQuery.swf':
					
					drillDownCriteria['str1']				=	'';
					drillDownCriteria['str2']				=	'zzzz';
					drillDownCriteria['str3']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str4']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['str7']				=	''
					drillDownCriteria['str8']				=	'zzzz'
					drillDownCriteria['str9']				=	''
					drillDownCriteria['str10']				=	'zzzz'
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
					break;	
				
				case 'saoi/sendmultipleartworktocustomer/components/SendMultipleArtworkToCustomer.swf':
				
				drillDownCriteria['str1']				=	'';
				drillDownCriteria['str2']				=	'zzzz';
				drillDownCriteria['str3']				=	drillrow.child('trans_no').toString();
				drillDownCriteria['str4']				=	drillrow.child('trans_no').toString();
				drillDownCriteria['str5']				=	''
				drillDownCriteria['str6']				=	'zzzz'
				drillDownCriteria['str7']				=	''
				drillDownCriteria['str8']				=	'zzzz'
				drillDownCriteria['str9']				=	''
				drillDownCriteria['str10']				=	'zzzz'
				drillDownCriteria['dt1']    			= 	'01/01/1990';
				drillDownCriteria['dt2']    			= 	'12/12/2025';
				break;	
					
				case 'saoi/assignedartwork/components/AssignedArtwork.swf':
					
					drillDownCriteria['str1']				=	'';
					drillDownCriteria['str2']				=	'zzzz';
					drillDownCriteria['str3']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str4']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['str7']				=	''
					drillDownCriteria['str8']				=	'zzzz'
					drillDownCriteria['str9']				=	''
					drillDownCriteria['str10']				=	'zzzz'
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
					break;
				
				case 'cust/customer/components/CustomerMaster.swf':
					
					drillDownCriteria['str1']				=	drillrow.child('customer_code').toString();
					drillDownCriteria['str2']				=	drillrow.child('customer_code').toString();
					drillDownCriteria['str3']				=	''
					drillDownCriteria['str4']				=	'zzzz'
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['str7']				=	''
					drillDownCriteria['str8']				=	'zzzz'
					drillDownCriteria['str9']				=	''
					drillDownCriteria['str10']				=	'zzzz'
					drillDownCriteria['str11']				=	''
					drillDownCriteria['str12']				=	'zzzz'
					break;
				
				case 'cust/contact/components/Contact.swf':
					
					drillDownCriteria['str1']				=	drillrow.child('first_name').toString();
					drillDownCriteria['str2']				=	drillrow.child('first_name').toString();
					drillDownCriteria['str3']				=	drillrow.child('last_name').toString();
					drillDownCriteria['str4']				=	drillrow.child('last_name').toString();
					drillDownCriteria['str5']				=	drillrow.child('customer_code').toString()
					drillDownCriteria['str6']				=	drillrow.child('customer_code').toString()
					drillDownCriteria['str7']				=	''
					drillDownCriteria['str8']				=	'zzzz'
					break;
				
				case 'invn/item/components/Item.swf':
					
					drillDownCriteria['str1']				=	drillrow.child('catalog_item_code').toString();
					drillDownCriteria['str2']				=	drillrow.child('catalog_item_code').toString();
					drillDownCriteria['str3']				=	''
					drillDownCriteria['str4']				=	'zzzz'
					drillDownCriteria['All2']             = 	'Y'
				break;
				
				case 'vend/vendor/components/Vendor.swf':
					
					drillDownCriteria['str1']				=	drillrow.child('code').toString();
					drillDownCriteria['str2']				=	drillrow.child('code').toString();
					drillDownCriteria['str3']				=	drillrow.child('name').toString();
					drillDownCriteria['str4']				=	drillrow.child('name').toString();
				break;
				
				// START OF SALES MODULE
				
				case 'saoi/salesinvoice/components/SalesInvoice.swf':
					
					drillDownCriteria['str1']				=	'';
					drillDownCriteria['str2']				=	'zzzz';
					drillDownCriteria['str3']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str4']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['str7']				=	''
					drillDownCriteria['str8']				=	'zzzz'
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
					break;	
				
				case 'saoi/reorder/components/ReOrder.swf':
					
					drillDownCriteria['str1']				=	''
					drillDownCriteria['str2']				=	'zzzz'
					drillDownCriteria['str3']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str4']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['str7']				=	''
					drillDownCriteria['str8']				=	'zzzz'
					drillDownCriteria['str9']				=	''
					drillDownCriteria['str10']				=	'zzzz'
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
				
				break;
				case 'prod/productionorder/components/ProductionOrder.swf':
					
					drillDownCriteria['str1']				=	''
					drillDownCriteria['str2']				=	'zzzz'
					drillDownCriteria['str3']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str4']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['str7']				=	''
					drillDownCriteria['str8']				=	'zzzz'
					drillDownCriteria['str9']				=	''
					drillDownCriteria['str10']				=	'zzzz'
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
				
				break;
				
				case 'ship/shipjob/components/ShipJob.swf':
					
					drillDownCriteria['str1']				=	''
					drillDownCriteria['str2']				=	'zzzz'
					drillDownCriteria['str3']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str4']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['str7']				=	''
					drillDownCriteria['str8']				=	'zzzz'
					drillDownCriteria['str9']				=	''
					drillDownCriteria['str10']				=	'zzzz'
					drillDownCriteria['str11']				=	drillrow.child('ship_address1').toString();
					drillDownCriteria['str12']				=	drillrow.child('ship_address1').toString();
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
					drillDownCriteria['dt3']    			= 	drillrow.child('ship_date').toString();
					drillDownCriteria['dt4']    			= 	drillrow.child('ship_date').toString();
					
					break;
				case 'prod/indigojob/components/IndigoJob.swf':
					
					drillDownCriteria['str1']				=	''
					drillDownCriteria['str2']				=	'zzzz'
					drillDownCriteria['str3']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str4']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['str7']				=	''
					drillDownCriteria['str8']				=	'zzzz'
					drillDownCriteria['str9']				=	''
					drillDownCriteria['str10']				=	'zzzz'
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
					
					break;
				
				case 'saoi/salesquotation/components/SalesQuotation.swf':
					
					drillDownCriteria['str1']				=	''
					drillDownCriteria['str2']				=	'zzzz'
					drillDownCriteria['str3']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str4']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['str7']				=	''
					drillDownCriteria['str8']				=	'zzzz'
					drillDownCriteria['str9']				=	''
					drillDownCriteria['str10']				=	'zzzz'
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
					
					break;
				case 'saoi/salesorder/components/SalesOrder.swf':
					
					drillDownCriteria['str1']				=	''
					drillDownCriteria['str2']				=	'zzzz'
					drillDownCriteria['str3']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str4']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['str7']				=	''
					drillDownCriteria['str8']				=	'zzzz'
					drillDownCriteria['str9']				=	''
					drillDownCriteria['str10']				=	'zzzz'
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
				
				break;
				
				case 'saoi/sampleorder/components/SampleOrder.swf':
					
					drillDownCriteria['str1']				=	''
					drillDownCriteria['str2']				=	'zzzz'
					drillDownCriteria['str3']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str4']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['str7']				=	''
					drillDownCriteria['str8']				=	'zzzz'
					drillDownCriteria['str9']				=	''
					drillDownCriteria['str10']				=	'zzzz'
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
				
					break;
				
					case 'saoi/virtualorder/components/VirtualOrder.swf':
						
					drillDownCriteria['str1']				=	''
					drillDownCriteria['str2']				=	'zzzz'
					drillDownCriteria['str3']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str4']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['str7']				=	''
					drillDownCriteria['str8']				=	'zzzz'
					drillDownCriteria['str9']				=	''
					drillDownCriteria['str10']				=	'zzzz'
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
					
					break;
				
				case 'saoi/assignedartwork/components/AssignedArtwork.swf':
					
					drillDownCriteria['str1']				=	''
					drillDownCriteria['str2']				=	'zzzz'
					drillDownCriteria['str3']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str4']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['str7']				=	''
					drillDownCriteria['str8']				=	'zzzz'
					drillDownCriteria['str9']				=	''
					drillDownCriteria['str10']				=	'zzzz'
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
				
					break;
				case 'saoi/assignedorder/components/AssignedOrder.swf':
					
					drillDownCriteria['str1']				=	''
					drillDownCriteria['str2']				=	'zzzz'
					drillDownCriteria['str3']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str4']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['str7']				=	''
					drillDownCriteria['str8']				=	'zzzz'
					drillDownCriteria['str9']				=	''
					drillDownCriteria['str10']				=	'zzzz'
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
				
					break;
				
				// END OF SALES MODULE
				
				case 'invn/issue/components/Issue.swf':
					
					drillDownCriteria['str1']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str2']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str3']				=	''
					drillDownCriteria['str4']				=	'zzzz'
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
				
					break;
				
				case 'invn/receive/components/Receive.swf':
					
					drillDownCriteria['str1']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str2']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str3']				=	''
					drillDownCriteria['str4']				=	'zzzz'
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
				
					break;
				
				case 'invn/itemtransfer/components/ItemTransfer.swf':
					
					drillDownCriteria['str1']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str2']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str3']				=	''
					drillDownCriteria['str4']				=	'zzzz'
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
				
					break;
				
				case 'invn/storetransfer/components/StoreTransfer.swf':
					
					drillDownCriteria['str1']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str2']				=	drillrow.child('trans_no').toString();
					drillDownCriteria['str3']				=	''
					drillDownCriteria['str4']				=	'zzzz'
					drillDownCriteria['str5']				=	''
					drillDownCriteria['str6']				=	'zzzz'
					drillDownCriteria['dt1']    			= 	'01/01/1990';
					drillDownCriteria['dt2']    			= 	'12/12/2025';
				
					break;
				// END OF INVN MODULE
				
				
}
			// end of melt module
			return drillDownCriteria;
		}
	}
}