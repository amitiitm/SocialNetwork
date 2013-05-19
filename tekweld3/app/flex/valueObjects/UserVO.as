package valueObjects
{
	import mx.controls.Alert;
	
	[Bindable]
	public class UserVO
	{
		public var userID:int;
		public var company_id:int;
		public var company_cd:String;
		public var id:int;
		public var type_id:int;
		public var first_name:String;
		public var last_name:String;
		public var login:String;
		public var login_type:String;
		public var login_type_desc:String;
		public var last_moodule_id:String;
		public var company_name:String;
		public var complc_address1:String;
		public var complc_address2:String;
		public var complc_city:String;
		public var complc_state:String;
		public var complc_pin:String;
		public var complc_email:String;
		public var complc_emailcc:String;
		public var complc_phone:String;
		public var complc_fax:String;
		public var company_country:String;
		public var default_customer_id:String;
		public var default_vendor_id:String;
		public var date_format:String;
		public var total_logins:String;
		public var company_logo_file:String;
		public var organization_name:String;
		public var default_company_id:int;
		public var default_company_code:String;
		public var user_cd:String;
		public var default_menu_id:String;
		public var application_name:String;
		
		public function UserVO(aXML:XML)
		{
			login 				= aXML['user']['login'] ;
			login_type 			= aXML['user']['login_type'] ;
			type_id 			= aXML['user']['type_id'] ;
			first_name 			= aXML['user']['first_name'] ;
			last_name			= aXML['user']['last_name'] ;
			userID 				= aXML['user']['user_id'];
			user_cd				= aXML['user']['user_cd'];	
			last_moodule_id 	= aXML['user']['last_moodule_id']
 			date_format			= aXML['user']['date_format'].toString().toLocaleUpperCase()
 			total_logins		= aXML['user']['total_logins']
			company_id 			= aXML['user']['company_id']
			default_company_id  = aXML['user']['default_company_id']
			default_company_code  = aXML['user']['default_company_code']
			default_menu_id  	= aXML['user']['menu_id']

			id 			 		= aXML['company']['id'] ;
			company_name 		= aXML['company']['name']
			complc_address1 	= aXML['company']['address1']
			complc_address2 	= aXML['company']['address2']
			complc_city 		= aXML['company']['city']
			complc_state 		= aXML['company']['state']
			complc_fax 			= aXML['company']['fax']
			complc_phone 		= aXML['company']['phone']
			complc_email		= aXML['company']['email_to']
			complc_emailcc		= aXML['company']['email_cc']
			complc_pin 			= aXML['company']['zip']
 			company_cd			= aXML['company']['company_cd']
 			company_country		= aXML['company']['country']
			
			organization_name 	= aXML['company']['company_name']
			
			default_customer_id = aXML['company']['default_customer_id']
			default_vendor_id	= aXML['company']['default_vendor_id']
			
			company_logo_file	= aXML['company']['company_logo_file']
			application_name	= aXML['company']['application_name']	
			
 			login_type_desc	= getUserType(login_type)
		}
		
		public function getUserType(login_type:String):String 
		{
			var lsType_name:String ;	
		
			switch(login_type)
			{
			    case 'C':
			        lsType_name = 'Customer';
			        break;
			    case 'V':
			        lsType_name = 'Vendor';
			        break;
			    case 'G':
			        lsType_name = 'General';
			        break;
			    default:
			        break;
			}
			return lsType_name ;		
		}
	}
}
