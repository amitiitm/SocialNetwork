package valueObjects
{
	import flash.utils.getQualifiedClassName;
	import mx.controls.Alert;
	
	public class InformationCriteria
	{
		private var criteria:XML;
		
		public function InformationCriteria() {}

		public function getCriteria(action:String, value1:Object=null, value2:Object=null, value3:Object=null, value4:Object=null, value5:Object=null,value6:Object=null,value7:Object=null, value8:Object=null, value9:Object=null,value10:Object=null):XML
		{
			var action:String 	= 	action;
			var string1:String 	= 	String(value1);
			var string2:String 	= 	String(value2);
			var string3:String 	= 	String(value3);
			var string4:String 	= 	String(value4);
			var string5:String 	=	String(value5);
			var string6:String 	=	String(value6);
			var string7:String 	= 	String(value7);
			var string8:String 	= 	String(value8);
			var string9:String 	=	String(value9);
			var string10:String =	String(value10);

			switch(action.toLocaleLowerCase())
			{
				case 'get_coupons_details':
				criteria = new XML(	<params>
										<action>{action.toLocaleLowerCase()}</action>
										<customer_id>{string1}</customer_id>
										<coupon_code>{string2}</coupon_code>
										<catalog_item_id>{string3}</catalog_item_id>
									</params>)
				break;
				case 'void_bounce_info':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<ref_trans_type>{string1}</ref_trans_type>
											<ref_trans_no>{string2}</ref_trans_no>
											<bank_id>{string3}</bank_id>
											<check_no>{string4}</check_no>
											<fetch_type>{string5}</fetch_type>
										</params>)
				break;
				case 'accessories_item_detail':
				criteria = new XML(	<params>
										<action>{action.toLocaleLowerCase()}</action>
										<catalog_item_id>{string1}</catalog_item_id>
									</params>);
				break;
				case 'customer_shipping_details':
				criteria = new XML(	<params>
										<action>{action.toLocaleLowerCase()}</action>
										<shipping_id>{string1}</shipping_id>
									</params>);
				break;
				case 'fetch_thread_colors':
				criteria = new XML(	<params>
										<action>{action.toLocaleLowerCase()}</action>
										<thread_company>{string1}</thread_company>
										<thread_category>{string2}</thread_category>
									</params>);
				break;
				case 'preview_artwork_ack':
				criteria = new XML(	<params>
										<action>{action.toLocaleLowerCase()}</action>
										<artwork_id>{string1}</artwork_id>
									</params>);
				break;
				case 'create_customer_profile':
				criteria = new XML(	<params>
										<action>{action.toLocaleLowerCase()}</action>
										<customer_id>{string1}</customer_id>
									</params>);
				break;
				case 'get_customer_payment_profile':
				criteria = new XML(	<params>
										<action>{action.toLocaleLowerCase()}</action>
										<customer_id>{string1}</customer_id>
									</params>);
				break;
				
				case 'authorize_customer_payment':
				criteria = new XML(	<params>
										<action>{action.toLocaleLowerCase()}</action>
										<sales_order_id>{string1}</sales_order_id>
										<customer_payment_profile_code>{string2}</customer_payment_profile_code>
										<customer_profile_code>{string3}</customer_profile_code>
										<amount>{string4}</amount>
										<user_id>{string5}</user_id>
									</params>);
				break;
			
				case 'delete_customer_payment_profile':
				criteria = new XML(	<params>
										<action>{action.toLocaleLowerCase()}</action>
										<customer_id>{string1}</customer_id>
										<customer_payment_profile_code>{string2}</customer_payment_profile_code>
									</params>);
				break;
				
				case 'create_customer_payment_profile':
				criteria = new XML(	<params>
										<action>{action.toLocaleLowerCase()}</action>
										<customer_id>{string1}</customer_id>
										<card_type>{string2}</card_type>
										<credit_card_no>{string3}</credit_card_no>
										<expiration_month>{string4}</expiration_month>
										<expiration_year>{string5}</expiration_year>
									</params>);
				break;
				case 'shippingmethods':
				criteria = new XML(	<params>
										<action>{action.toLocaleLowerCase()}</action>
										<zip_code>{string1}</zip_code>
										<country>{string2}</country>
										<shipping_code>{string3}</shipping_code>
										<catalog_item_id>{string4}</catalog_item_id>
										<qty>{string5}</qty>
										<trans_no>{string6}</trans_no>
										<state>{string7}</state>
										<estimated_ship_date>{string8}</estimated_ship_date>
									</params>);
				break;
				case 'fetch_setup_charge_for_item_option_code':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<catalog_attribute_code>{string1}</catalog_attribute_code>
											<customer_id>{string2}</customer_id>
										</params>);
				break;
				case 'fetch_setup_charge_for_item_option_value':
				criteria = new XML(	<params>
										<action>{action.toLocaleLowerCase()}</action>
										<old_catalog_attribute_value_code>{string1}</old_catalog_attribute_value_code>
										<new_catalog_attribute_value_code>{string2}</new_catalog_attribute_value_code>
										<customer_id>{string3}</customer_id>
									</params>);
				break;
				case 'fetch_customer_contact_detail':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<customer_id>{string1}</customer_id>
											<contact_name>{string2}</contact_name>
										</params>);
					break;
				case 'check_valid_indigo_no':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<indigo_code>{string1}</indigo_code>
											<doc_code>{string2}</doc_code>
										</params>);
					break;
				case 'fetch_customer_contact':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<customer_id>{string1}</customer_id>
										</params>);
					break;
				
				case 'fetch_default_change_with_proof_setup_item':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<customer_id>{string1}</customer_id>
										</params>);
					break;
				case 'fetch_default_setup_item':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<customer_id>{string1}</customer_id>
										</params>);
					break;
				case 'fetch_default_rush_setup_item':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<customer_id>{string1}</customer_id>
										</params>);
					break;
				
				case 'fetch_cust_specific_setup_item_price':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<id>{string1}</id>
											<customer_id>{string2}</customer_id>
										</params>);
					break;
				case 'fetch_invn_and_setup_item':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
										</params>);
					break;
				case 'fetch_shipvia_methods':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<code>{string1}</code>
										</params>);
					break;
				case 'show_shipped_order_dtls':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<id>{string1}</id>
											<trans_no>{string2}</trans_no>
											<ref_virtual_line_id>{string3}</ref_virtual_line_id>
										</params>);
					break;
				case 'item_detail_sample_order':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<id>{string1}</id>
											<customer_id>{string2}</customer_id>
											<blank_good_flag>{string3}</blank_good_flag>
										</params>);
					break;
				case 'item_column_detail':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<id>{string1}</id>
										</params>);
					break;
				case 'item_detail':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<id>{string1}</id>
											<customer_id>{string2}</customer_id>
											<ref_type>{string3}</ref_type>
											<ref_trans_no>{string4}</ref_trans_no>
										</params>);
					break;
				case 'item_detail_sales_quotation':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<id>{string1}</id>
											<customer_id>{string2}</customer_id>
										</params>);
					break;
				
				case 'customer_specific_shippings':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<id>{string1}</id>
										</params>);
					break;
				//////////////////////
				
			    case 'checkvalidity':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<value>{string1}</value>
											<lookup_name>{string2}</lookup_name>
											 /* here data_field is the field name where to search in table for validity*/
											<data_field>{string3}</data_field> 
											/* here field2 is the field name in table whose value is  required in return in tag data_value.*/
											<field2>{string4}</field2>
											<filter_key_name>{string5}</filter_key_name>
											<filter_key_value>{string6}</filter_key_value>
										</params>);
   	 				break;
			    case 'limitedlookup':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<value>{string1}</value>
											<lookup_name>{string2}</lookup_name>
											<filter_key_name>{string3}</filter_key_name>
											<filter_key_value>{string4}</filter_key_value>
											
										</params>);
										/* <data_field>{string3}</data_field> */
   	 				break;			    
			    case 'termchange':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<code>{string1}</code>
											<trans_date>{string2}</trans_date>
										</params>);
   	 				break;
			    
			    case 'accountperiod':
  	 				criteria = new XML(	<params>
  	 										<action>{action.toLocaleLowerCase()}</action>
   											<id>{string1}</id>
   				 						</params>)

					 break;
					 
			     case 'customershippings':
					criteria = new XML(	<params>
			  		 						<action>{action.toLocaleLowerCase()}</action>
											<id>{string1}</id>
										</params>);	 
					break;
					
				case 'companystoreinfo':
					criteria = new XML(	<params>
			  		 						<action>{action.toLocaleLowerCase()}</action>
											<id>{string1}</id>
										</params>);	 
					break;	
					
			     case 'customerdetail':
					criteria = new XML(	<params>
			    							<action>{action.toLocaleLowerCase()}</action>
			    							<id>{string1}</id>
			    							<trans_type>{string2}</trans_type>
			    						</params>)
			    	break;
			    	
			    case 'customerdetail_bycode':
					criteria = new XML(	<params>
			    							<action>{action.toLocaleLowerCase()}</action>
			    							<code>{string1}</code>
			    							<trans_type>{string2}</trans_type>
			    						</params>)
			    	break;	 
					// now no need to send trans_type

				case 'customerinfo':
			    	criteria = new XML(	<params>
			    							<action>{action.toLocaleLowerCase()}</action>
			    							<id>{string1}</id>
			    						</params>)
					 break;

				case 'vendorinfo':
			    	criteria = new XML(	<params>
			    							<action>{action.toLocaleLowerCase()}</action>
			    							<id>{string1}</id>
			    						</params>)
					 break; 	 	 
			 	
			 	case 'paymentbank':
		    	case 'depositbank':
		    	case 'transferbank':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<trans_date>{string1}</trans_date>
											<bank_id>{string2}</bank_id>
										</params>)
					break;

		    	case 'iteminfo':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<item_id>{string1}</item_id>
											<trans_date>{string2}</trans_date>
											<trans_type>{string3}</trans_type>
											<trans_id>{string4}</trans_id>
										</params>)
					break;

		    	case 'packetinfo':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<packet_code>{string1}</packet_code>
											<trans_date>{string2}</trans_date>
											<stock_check>{string3}</stock_check>
										</params>)
					break;
				
		    	case 'packetinfovalidate':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<packet_code>{string1}</packet_code>
											<item_code>{string2}</item_code>
											<stock_check>{string3}</stock_check>
										</params>)
					break;

		    	case 'batchinfo':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<batch_code>{string1}</batch_code>
											<trans_date>{string2}</trans_date>
											<stock_check>{string3}</stock_check>
										</params>)
					break;
				

		    	case 'diamondlotinfo':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<diamond_lot_id>{string1}</diamond_lot_id>
										</params>)
					break;

		    	case 'diamondpacketinfo':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<diamond_packet_no>{string1}</diamond_packet_no>
											<stock_check>{string3}</stock_check>
										</params>)
					break;
				
		    	case 'diamondpacketinfovalidate':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<diamond_packet_no>{string1}</diamond_packet_no>
											<lot_number>{string2}</lot_number>
											<stock_check>{string3}</stock_check>
										</params>)
					break;
				
				case 'paymenttypechange':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<bank_id>{string1}</bank_id>
											<payment_type>{string2}</payment_type>
										</params>)
					break;
				
				case 'bankchangepaym':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<bank_id>{string1}</bank_id>
										</params>)
					break;	

			     case 'vendordetail':
					criteria = new XML(	<params>
			    							<action>{action.toLocaleLowerCase()}</action>
			    							<id>{string1}</id>
			    							<trans_type>{string2}</trans_type>
			    						</params>)
			    	break; 
			     case 'packetlabelinfo':
					criteria = new XML(	<params>
			    							<action>{action.toLocaleLowerCase()}</action>
			    						</params>)
			    	break; 	
			    	
			     case 'generate_packet_code':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
			    						</params>)
			    	break; 	
			    	
			     case 'item_category_attributes_info':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<id>{string1}</id>
			    						</params>)
			    	break; 	
			    case 'similaritems':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<id>{string1}</id>
			    						</params>)
			    	break; 		
			    	
			    case 'get_unassigned_menus':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<role_id>{string1}</role_id>
			    						</params>)
			    	break; 		
			    	
			    case 'get_menu_role_permissions':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<id>{string1}</id>
			    						</params>)
			    	break; 		

			    case 'get_assigned_user_role_list':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
			    						</params>)
			    	break; 		

			    case 'jewelry_unit_conversion':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
			    						</params>)
			    	break; 		
			    	
				case 'jewelry_detail':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<item_id>{string1}</item_id>
										</params>);
										
					break;
					
				case 'labor':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<id>{string1}</id>
										</params>);
										
					break;
				
				case 'spo_details':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<trans_no>{string1}</trans_no>
										</params>);
										
					break;
				
				case 'item_detail_for_spo_workbag':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<id>{string1}</id>
										</params>);
										
					break;
					
				case 'spo_repair_details':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<trans_no>{string1}</trans_no>
										</params>);
										
					break;
				case 'workbag_details':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<trans_no>{string1}</trans_no>
										</params>);
										
					break;
				case 'meltingpacketinfo':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<trans_no>{string1}</trans_no>
										</params>);
										
					break;		
				case 'bominfo':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<item_id>{string1}</item_id>
											<fetch_type>{string2}</fetch_type>
											<type>{string3}</type>
											<type_id>{string4}</type_id>
											<customer_sku_no>{string5}</customer_sku_no>
										</params>)
					break;
				case 'batchbominfo':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<batch_code>{string1}</batch_code>
											<fetch_type>{string2}</fetch_type>
											<type>{string3}</type>
											<type_id>{string4}</type_id>
											<customer_sku_no>{string5}</customer_sku_no>
										</params>)
					break;	
				case 'bomtransaction':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<item_id>{string1}</item_id>
											<customer_sku_no>{string2}</customer_sku_no>
											<fetch_type>{string3}</fetch_type>
										</params>)
					break;			
				case 'item_auto_number':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<category_id>{string1}</category_id>
										</params>)
					break;		
				case 'stonewtinfo':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<stone_type>{string1}</stone_type>
											<shape>{string2}</shape>
											<size>{string3}</size>
											<cut>{string4}</cut>
										</params>)
					break;
				case 'metalinfo':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<metal_id>{string1}</metal_id>
										</params>)
					break;	
				case 'metalpacketinfo':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<packet_code>{string1}</packet_code>
											<stock_check>{string3}</stock_check>
										</params>)
					break;				
				case 'metalpacketinfovalidate':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<metal_packet_code>{string1}</metal_packet_code>
											<metal_code>{string2}</metal_code>
											<stock_check>{string3}</stock_check>
										</params>)
					break;	
				 case 'salesperson':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<salesperson_id>{string1}</salesperson_id>
											<salesperson_code>{string2}</salesperson_code>
										</params>);
   	 				break;
   	 			case 'user':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<user_id>{string1}</user_id>
											<user_code>{string2}</user_code>
										</params>);
   	 				break;
   	 			case 'attribute_info':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<attribute_id>{string1}</attribute_id>
											<attribute_code>{string2}</attribute_code>
										</params>);
   	 				break;	
   	 			case 'workbag_stages':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<stage_code>{string1}</stage_code>
										</params>);
   	 				break;
   	 			case 'catalog_attribute_value_lookup':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<user_id>{string1}</user_id>
											<company_id>{string2}</company_id>
										</params>);
   	 				break;
   	 			case 'user_lookup':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<user_id>{string1}</user_id>
											<company_id>{string2}</company_id>
										</params>);
   	 				break;
   	 			case 'role_lookup':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<user_id>{string1}</user_id>
											<company_id>{string2}</company_id>
										</params>);
   	 				break;
				   case 'catalog_attribute_value_lookup':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<user_id>{string1}</user_id>
											<company_id>{string2}</company_id>
										</params>);
					break;
				case 'attribute_info':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<attribute_id>{string1}</attribute_id>
											<attribute_code>{string2}</attribute_code>
										</params>);
					break;	
				case 'bank_check_info':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<type>{string1}</type>
											<payment_type>{string2}</payment_type>
										</params>)
					break;
				case 'paymentbankinbox':
					criteria = new XML(	<params>
											<action>{action.toLocaleLowerCase()}</action>
											<trans_date>{string1}</trans_date>
											<bank_code>{string2}</bank_code>
										</params>)
					break;
				
				default:
					criteria = null;
					Alert.show('InformationCriteria(VO): Please provide valid action  '+action)
					
					break;
			}

			return criteria;
		}
	}
}
