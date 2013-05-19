package valueObjects
{
	import acct.bank.BankController;
	import acct.bank.BankModelLocator;
	import acct.bank.BankServices;
	import acct.bank.components.BankAddEdit;
	import acct.glacct.GLAccountController;
	import acct.glacct.GLAccountModelLocator;
	import acct.glacct.GLAccountServices;
	import acct.glacct.components.GLAccountAddEdit;
	import acct.glcategory.GLCategoryController;
	import acct.glcategory.GLCategoryModelLocator;
	import acct.glcategory.GLCategoryServices;
	import acct.glcategory.components.GLCategoryAddEdit;
	import acct.term.TermController;
	import acct.term.TermModelLocator;
	import acct.term.TermServices;
	import acct.term.components.TermAddEdit;
	
	import crm.account.AccountController;
	import crm.account.AccountModelLocator;
	import crm.account.AccountServices;
	import crm.account.components.AccountAddEdit;
	import crm.category.AccountCategoryController;
	import crm.category.AccountCategoryModelLocator;
	import crm.category.AccountCategoryServices;
	import crm.category.components.AccountCategoryAddEdit;
	import crm.opportunity.OpportunityController;
	import crm.opportunity.OpportunityModelLocator;
	import crm.opportunity.OpportunityServices;
	import crm.opportunity.components.OpportunityAddEdit;
	import crm.task.TaskController;
	import crm.task.TaskModelLocator;
	import crm.task.TaskServices;
	import crm.task.components.Task;
	import crm.task.components.TaskAddEdit;
	
	import cust.contact.ContactController;
	import cust.contact.ContactModelLocator;
	import cust.contact.ContactServices;
	import cust.contact.components.ContactAddEdit;
	import cust.customerpaymentprofile.CustomerPaymentProfileController;
	import cust.customerpaymentprofile.CustomerPaymentProfileModelLocator;
	import cust.customerpaymentprofile.CustomerPaymentProfileServices;
	import cust.customerpaymentprofile.components.CustomerPaymentProfileAddEdit;
	import cust.quickcustomer.QuickCustomerMasterController;
	import cust.quickcustomer.QuickCustomerMasterModelLocator;
	import cust.quickcustomer.QuickCustomerMasterServices;
	import cust.quickcustomer.components.QuickCustomerMasterAddEdit;
	
	import dinvn.location.LocationController;
	import dinvn.location.LocationModelLocator;
	import dinvn.location.LocationServices;
	import dinvn.location.components.LocationAddEdit;
	
	import invn.attribute.AttributeController;
	import invn.attribute.AttributeModelLocator;
	import invn.attribute.AttributeServices;
	import invn.attribute.components.AttributeAddEdit;
	import invn.category.ItemCategoryController;
	import invn.category.ItemCategoryModelLocator;
	import invn.category.ItemCategoryServices;
	import invn.category.components.ItemCategoryAddEdit;
	import invn.item.ItemController;
	import invn.item.ItemModelLocator;
	import invn.item.ItemServices;
	import invn.item.components.ItemAddEdit;
	
	import model.GenModelLocator;
	
	import mx.controls.Button;
	import mx.core.ClassFactory;
	
	import puoi.purchasepeople.PurchasePeopleController;
	import puoi.purchasepeople.PurchasePeopleModelLocator;
	import puoi.purchasepeople.PurchasePeopleServices;
	import puoi.purchasepeople.components.PurchasePeopleAddEdit;
	
	import saoi.reorder.ReOrderController;
	import saoi.reorder.ReOrderModelLocator;
	import saoi.reorder.ReOrderServices;
	import saoi.reorder.components.ReOrderAddEdit;
	import saoi.salespeople.SalesPeopleController;
	import saoi.salespeople.SalesPeopleModelLocator;
	import saoi.salespeople.SalesPeopleServices;
	import saoi.salespeople.components.SalesPeopleAddEdit;
	import saoi.sampleorder.SampleOrderController;
	import saoi.sampleorder.SampleOrderModelLocator;
	import saoi.sampleorder.SampleOrderServices;
	import saoi.sampleorder.components.SampleOrderAddEdit;
	import saoi.subsalesorder.SubSalesOrderController;
	import saoi.subsalesorder.SubSalesOrderModelLocator;
	import saoi.subsalesorder.SubSalesOrderServices;
	import saoi.subsalesorder.components.SubSalesOrderAddEdit;
	
	import stup.document.DocumentController;
	import stup.document.DocumentModelLocator;
	import stup.document.DocumentServices;
	import stup.document.components.DocumentAddEdit;
	import stup.menu.MenuController;
	import stup.menu.MenuModelLocator;
	import stup.menu.MenuServices;
	import stup.menu.components.MenuAddEdit;
	import stup.moodule.MooduleController;
	import stup.moodule.MooduleModelLocator;
	import stup.moodule.MooduleServices;
	import stup.moodule.components.MooduleAddEdit;
	import stup.role.RoleController;
	import stup.role.RoleModelLocator;
	import stup.role.RoleServices;
	import stup.role.components.RoleAddEdit;
	import stup.shipping.ShippingController;
	import stup.shipping.ShippingModelLocator;
	import stup.shipping.ShippingServices;
	import stup.shipping.components.ShippingAddEdit;
	import stup.user.UserController;
	import stup.user.UserModelLocator;
	import stup.user.UserServices;
	import stup.user.components.UserAddEdit;
	
	import vend.category.VendorCategoryController;
	import vend.category.VendorCategoryModelLocator;
	import vend.category.VendorCategoryServices;
	import vend.category.components.VendorCategoryAddEdit;
	import vend.vendor.VendorController;
	import vend.vendor.VendorModelLocator;
	import vend.vendor.VendorServices;
	import vend.vendor.components.VendorAddEdit;

	public class LookupVO
	{
		// For verify data version
		public var lookup:XML = new XML();
		// For data
		public var customer:XML = new XML();
		public var customerpaymentprofile:XML = new XML();
		public var term:XML = new XML();
		public var salesperson:XML = new XML();
		public var externalsalesperson:XML = new XML();
		public var purchaseperson:XML = new XML();
		public var customercategory:XML = new XML();
		public var accountperiod:XML = new XML();
		public var customershipping:XML = new XML();
		public var shipping:XML = new XML();
		public var diamondcategory:XML = new XML();
		public var diamondlot:XML = new XML();
		public var glaccount:XML = new XML();
		public var bank:XML = new XML();
		public var location:XML = new XML();
		public var glcategory:XML = new XML();
		public var glbankaccount:XML = new XML();
		public var vendorcategory:XML = new XML();
		public var vendor:XML = new XML();
		public var item:XML = new XML();
		public var itemgroup:XML = new XML();
		public var itemcategory:XML = new XML();
		public var companystore:XML = new XML();
		public var crmaccountcategory:XML = new XML();
		public var crmaccount:XML = new XML();
		public var crmcontact:XML = new XML();
		public var crmtask:XML = new XML();
		public var crmopportunity:XML = new XML();
		public var user:XML = new XML();
		public var catalogattribute:XML = new XML();
		public var catalogattributevalue:XML = new XML();
		public var document:XML = new XML();
		public var userstoreaccess:XML = new XML();
		public var lab:XML = new XML();
		public var catalogorderstatus:XML = new XML();
		public var role:XML = new XML();
		public var menu:XML = new XML();
		public var moodule:XML = new XML();
		public var meltingretailer:XML = new XML();
		public var meltingstagemaster:XML = new XML();
		public var labor:XML = new XML();
		public var workbagstages:XML = new XML();
		public var setupitem:XML = new XML();
		public var accessoriesitem:XML = new XML();
		public var assembleitem:XML   = new XML();
		public var design:XML = new XML();
		
		public function setData(lookupName:String, aXML:XML):void
		{
			switch(lookupName.toLocaleLowerCase())
			{
			    case 'customer':
					customer = aXML;
			        break;
			    case 'term':
					term = aXML;
			        break;
			    case 'salesperson':
					salesperson = aXML;
			        break;
			    case 'externalsalesperson':
					externalsalesperson = aXML;
			        break;    
			    case 'purchaseperson':
					purchaseperson = aXML;
			        break;    
			    case 'customercategory':
					customercategory = aXML;
			        break;
			    case 'accountperiod':
					accountperiod = aXML;
			        break;
			    case 'customershipping':
					customershipping = aXML;
			        break;
			    case 'vendorcategory':
					vendorcategory = aXML;
			        break;
			    case 'vendor':
					vendor = aXML;
			        break;
			    case 'shipping':
					shipping = aXML;
			        break;
			    case 'diamondcategory':
					diamondcategory = aXML;
			        break;
			    case 'diamondlot':
					diamondlot = aXML;
			        break;
			    case 'glaccount':
					glaccount = aXML;
			        break;
				case 'bank':
					bank = aXML;
			        break;
			    case 'location':
					location = aXML;
			        break;  
			    case 'glcategory':
					glcategory = aXML;
			        break;
			    case 'glbankaccount':
					glbankaccount = aXML;
			        break;
			    case 'item':
					item = aXML;
			        break;
			    case 'itemgroup':
					itemgroup = aXML;
			        break;
			    case 'itemcategory':
					itemcategory = aXML;
			        break;
			    case 'companystore':
					companystore = aXML;
			        break;   
			    case 'crmaccountcategory':
			   		crmaccountcategory = aXML;
			        break;
			    case 'crmaccount':
			    	crmaccount = aXML;
			        break;
			    case 'crmcontact':
			    	crmcontact = aXML;
			        break;
			    case 'crmtask':
			    	crmtask = aXML;
			        break;
			    case 'crmopportunity':
			    	crmopportunity = aXML;
			        break;
			    case 'user':
			    	user = aXML;
			        break;
			    case 'catalogattribute':
			    	catalogattribute = aXML;
			        break;
			    case 'catalogattributevalue':
			    	catalogattributevalue = aXML;
			        break;
			    case 'document':
			    	document = aXML;
			        break;
			    case 'userstoreaccess':
			    	userstoreaccess = aXML;
			        break;
			    case 'lab':
			    	lab = aXML;
			        break;
			    case 'catalogorderstatus':
			    	catalogorderstatus = aXML;
			        break;
			    case 'role':    
			        role = aXML;
			        break;
			    case 'menu':    
			        menu = aXML;
			        break;
			   	case 'moodule':    
			        moodule = aXML;
			        break; 
			     case 'meltingretailer':    
			        meltingretailer = aXML;
			        break;
				case 'meltingstagemaster':    
			        meltingstagemaster = aXML;
			        break;
			    case 'labor':    
			        labor = aXML;
			        break;
			    case 'workbagstages':    
			        workbagstages = aXML;
			        break;  
				case 'setupitem':    
			        setupitem = aXML;
			        break; 
				case 'accessoriesitem':
					accessoriesitem = aXML;
					break; 
				case 'assembleitem':
					assembleitem = aXML;
					break;
				case 'design':
					design = aXML;
					break;	
			    default:
			        break;
			}
		}

		public function getData(lookupName:String):XML
		{
			var xml:XML = new XML();
			var __lookupObj:LookupVO = GenModelLocator.getInstance().lookupObj;
			
			switch(lookupName.toLocaleLowerCase())
			{
			    case 'customer':
					xml = __lookupObj.customer;
			        break;
			    case 'term':
					xml = __lookupObj.term;
			        break;
			    case 'salesperson':
					xml = __lookupObj.salesperson;
			        break;
			    case 'externalsalesperson':
					xml = __lookupObj.externalsalesperson;
			        break;    
			    case 'purchaseperson':
					xml = __lookupObj.purchaseperson;
			        break;    
			    case 'customercategory':
					xml = __lookupObj.customercategory;
			        break;
			    case 'accountperiod':
					xml = __lookupObj.accountperiod;
			        break;
			    case 'customershipping':
					xml = __lookupObj.customershipping;
			        break;
			    case 'vendorcategory':
					xml = __lookupObj.vendorcategory;
			        break;
			    case 'vendor':
					xml = __lookupObj.vendor;
			        break;
			    case 'shipping':
					xml = __lookupObj.shipping;
			        break;
			    case 'diamondcategory':
					xml = __lookupObj.diamondcategory;
			        break;
			    case 'diamondlot':
					xml = __lookupObj.diamondlot;
			        break;
				case 'glaccount':
					xml = __lookupObj.glaccount;
			        break;
				case 'bank':
					xml = __lookupObj.bank;
			        break;      
			    case 'location':
					xml = __lookupObj.location;
			        break;    
			    case 'glcategory':
					xml = __lookupObj.glcategory;
					break;   
				case 'glbankaccount':
					xml = __lookupObj.glbankaccount;
					break; 	           
				case 'item':
					xml = __lookupObj.item;
			        break;
				case 'itemgroup':
					xml = __lookupObj.itemgroup;
			        break;
			    case 'itemcategory':
					xml = __lookupObj.itemcategory;
			        break;
			    case 'companystore':
					xml = __lookupObj.companystore;
			        break;   
			    case 'crmaccountcategory':
					xml = __lookupObj.crmaccountcategory;
			        break;   
			    case 'crmaccount':
					xml = __lookupObj.crmaccount;
			        break;
			    case 'crmcontact':
					xml = __lookupObj.crmcontact;
			        break;
			    case 'crmtask':
					xml = __lookupObj.crmtask;
			        break;
			    case 'crmopportunity':
					xml = __lookupObj.crmopportunity;
			        break;
			    case 'user':
					xml = __lookupObj.user;
			        break;
			    case 'catalogattribute':
					xml = __lookupObj.catalogattribute;
			        break;
			    case 'catalogattributevalue':
					xml = __lookupObj.catalogattributevalue;
			        break;
			    case 'document':
					xml = __lookupObj.document;
			        break;
			    case 'userstoreaccess':
					xml = __lookupObj.userstoreaccess;
			        break;
			    case 'lab':
					xml = __lookupObj.lab;
			        break;
			    case 'catalogorderstatus':
					xml = __lookupObj.catalogorderstatus;
			        break;
			    case 'role':
					xml = __lookupObj.role;
			        break;
			    case 'menu':
					xml = __lookupObj.menu;
			        break;
			  	case 'moodule':
					xml = __lookupObj.moodule;
			        break;  
			    case 'meltingretailer':    
			        xml = __lookupObj.meltingretailer;
			        break;
			    case 'meltingstagemaster':    
			        xml = __lookupObj.meltingstagemaster;
			        break;   
			    case 'labor':    
			        xml = __lookupObj.labor;
			        break;  
			     case 'workbagstages':    
			        xml = __lookupObj.workbagstages;
			        break;
			    case 'setupitem':    
			        xml = __lookupObj.setupitem;
			        break;
			    case 'accessoriesitem':
			     xml = __lookupObj.accessoriesitem;
			     break; 
			     case 'assembleitem':
			     xml = __lookupObj.assembleitem;
			     break;
				 case 'design':
					 xml = __lookupObj.design;
					 break;
			    default:
					xml = new XML();
			        break;
			}
			return xml;
		}

		/*.......................For Quick Add Records from the lookup  06 may 2011.................*/	
		private var _lookupName:String;
		[Bindable]
		public var isQuickAddActive:Boolean	=	false;
		public var refereshBtn:Button;// we have to fire referesh of LookupRecordSearch if any new record  added
		public var isRecordAdded:Boolean	=	false; // we have to fire referesh of LookupRecordSearch if any new record  added
		public var findTextInput:Object		=	null;
		public var labelField:String = '';
		public var labelValue:String = '';
		
		
		public function set lookupName(name:String):void
		{
			_lookupName	=	name;
		}
		public function get lookupName():String
		{
			return _lookupName;
		}
			
		public function getMasterInfo(lookupName:String):Object
		{
			var obj:Object	=	new Object();
			
			switch(lookupName.toLocaleLowerCase())
			{
				
				case 'customerpaymentprofile':
				
				obj.serviceClassFactory			=	 new ClassFactory(CustomerPaymentProfileServices);
				obj.addEditClassFactory			=	 new ClassFactory(CustomerPaymentProfileAddEdit) ;
				obj.controllerClassFactory		=	 new ClassFactory(CustomerPaymentProfileController) ;
				obj.modelLocatorClassFactory	=	 new ClassFactory(CustomerPaymentProfileModelLocator) ;
				obj.modulePath					=	"cust/customerpaymentprofile/components/CustomerPaymentProfile.swf";
				obj.title						=	"Customer Payment Profile";
				obj.width						=	650;
				obj.height						=	500;
				
				break;
				
				case 'customer':
					
					obj.serviceClassFactory			=	 new ClassFactory(QuickCustomerMasterServices);
					obj.addEditClassFactory			=	 new ClassFactory(QuickCustomerMasterAddEdit) ;
					obj.controllerClassFactory		=	 new ClassFactory(QuickCustomerMasterController) ;
					obj.modelLocatorClassFactory	=	 new ClassFactory(QuickCustomerMasterModelLocator) ;
					obj.modulePath					=	"cust/quickcustomer/components/QuickCustomerMaster.swf";
					obj.title						=	"Customer";
					obj.width						=	900;
					obj.height						=	500;
					break;
			
				case 'customercontact':
					
					obj.serviceClassFactory			=	 new ClassFactory(ContactServices);
					obj.addEditClassFactory			=	 new ClassFactory(ContactAddEdit) ;
					obj.controllerClassFactory		=	 new ClassFactory(ContactController) ;
					obj.modelLocatorClassFactory	=	 new ClassFactory(ContactModelLocator) ;
					obj.modulePath					=	"cust/contact/components/Contact.swf";
					obj.title						=	"Contact";
					obj.width						=	900;
					obj.height						=	500;
					break;
			     case 'noninventoryitem':
						
					obj.serviceClassFactory			=	 new ClassFactory(ItemServices);
					obj.addEditClassFactory			=	 new ClassFactory(ItemAddEdit) ;
					obj.controllerClassFactory		=	 new ClassFactory(ItemController) ;
					obj.modelLocatorClassFactory	=	 new ClassFactory(ItemModelLocator) ;
					obj.modulePath					=	"invn/item/components/Item.swf";
					obj.title						=	"Item";
					obj.width						=	1050;
					obj.height						=	500;
			        	
			        break;
				 case 'inventoryitem':
					 
					 obj.serviceClassFactory		=	 new ClassFactory(ItemServices);
					 obj.addEditClassFactory		=	 new ClassFactory(ItemAddEdit) ;
					 obj.controllerClassFactory		=	 new ClassFactory(ItemController) ;
					 obj.modelLocatorClassFactory	=	 new ClassFactory(ItemModelLocator) ;
					 obj.modulePath					=	"invn/item/components/Item.swf";
					 obj.title						=	"Item";
					 obj.width						=	1050;
					 obj.height						=	500;
					 
					 break;
			     
			     
			     case 'itemcategory':
						
						obj.serviceClassFactory			=	 new ClassFactory(ItemCategoryServices);
						obj.addEditClassFactory			=	 new ClassFactory(ItemCategoryAddEdit) ;
						obj.controllerClassFactory		=	 new ClassFactory(ItemCategoryController) ;
						obj.modelLocatorClassFactory	=	 new ClassFactory(ItemCategoryModelLocator) ;
						obj.modulePath					=	"invn/category/components/ItemCategory.swf";
						obj.title						=	"ItemCategory";
						obj.width						=	900;
						obj.height						=	500;
			        	
			        	break;
			     
			     case 'catalogattribute':
						
						obj.serviceClassFactory			=	 new ClassFactory(AttributeServices);
						obj.addEditClassFactory			=	 new ClassFactory(AttributeAddEdit) ;
						obj.controllerClassFactory		=	 new ClassFactory(AttributeController) ;
						obj.modelLocatorClassFactory	=	 new ClassFactory(AttributeModelLocator) ;
						obj.modulePath					=	"invn/attribute/components/Attribute.swf";
						obj.title						=	"Attribute";
						obj.width						=	900;
						obj.height						=	500;
			        	
			        	break;   
			        	
			       case 'shipping':
						
						obj.serviceClassFactory			=	 new ClassFactory(ShippingServices);
						obj.addEditClassFactory			=	 new ClassFactory(ShippingAddEdit) ;
						obj.controllerClassFactory		=	 new ClassFactory(ShippingController) ;
						obj.modelLocatorClassFactory	=	 new ClassFactory(ShippingModelLocator) ;
						obj.modulePath					=	"stup/shipping/components/Shipping.swf";
						obj.title						=	"Shipping";
						obj.width						=	900;
						obj.height						=	500;
			        	
			        	break;  
			       case 'term':
						obj.serviceClassFactory			=	 new ClassFactory(TermServices);
						obj.addEditClassFactory			=	 new ClassFactory(TermAddEdit) ;
						obj.controllerClassFactory		=	 new ClassFactory(TermController) ;
						obj.modelLocatorClassFactory	=	 new ClassFactory(TermModelLocator) ;
						obj.modulePath					=	"acct/term/components/Term.swf";
						obj.title						=	"Term";
						obj.width						=	900;
						obj.height						=	500;
			        	
			        	break;
				   case 'document':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(DocumentServices);
					   obj.addEditClassFactory			=	 new ClassFactory(DocumentAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(DocumentController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(DocumentModelLocator) ;
					   obj.modulePath					=	"stup/document/components/Document.swf";
					   obj.title						=	"Document";
					   obj.width						=	900;
					   obj.height						=	500;
					   
					   break;
				   case 'menu':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(MenuServices);
					   obj.addEditClassFactory			=	 new ClassFactory(MenuAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(MenuController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(MenuModelLocator) ;
					   obj.modulePath					=	"stup/menu/components/Menu.swf";
					   obj.title						=	"Menu";
					   obj.width						=	900;
					   obj.height						=	500;
					
				   case 'role':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(RoleServices);
					   obj.addEditClassFactory			=	 new ClassFactory(RoleAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(RoleController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(RoleModelLocator) ;
					   obj.modulePath					=	"stup/role/components/Role.swf";
					   obj.title						=	"Role";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break;  
				   case 'moodule':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(MooduleServices);
					   obj.addEditClassFactory			=	 new ClassFactory(MooduleAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(MooduleController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(MooduleModelLocator) ;
					   obj.modulePath					=	"stup/moodule/components/Moodule.swf";
					   obj.title						=	"Moodule";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break;
				   case 'user':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(UserServices);
					   obj.addEditClassFactory			=	 new ClassFactory(UserAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(UserController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(UserModelLocator) ;
					   obj.modulePath					=	"stup/user/components/User.swf";
					   obj.title						=	"User";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break;
				   case 'vendor':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(VendorServices);
					   obj.addEditClassFactory			=	 new ClassFactory(VendorAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(VendorController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(VendorModelLocator) ;
					   obj.modulePath					=	"vend/vendor/components/Vendor.swf";
					   obj.title						=	"Vendor";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break;  
				   case 'vendor':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(VendorServices);
					   obj.addEditClassFactory			=	 new ClassFactory(VendorAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(VendorController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(VendorModelLocator) ;
					   obj.modulePath					=	"stup/vendor/components/Vendor.swf";
					   obj.title						=	"Vendor";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break;
				   case 'crmaccount':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(AccountServices);
					   obj.addEditClassFactory			=	 new ClassFactory(AccountAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(AccountController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(AccountModelLocator) ;
					   obj.modulePath					=	"crm/account/components/Account.swf";
					   obj.title						=	"Account";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break;
				 /*  case 'crmcontact':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(crm.contact.ContactServices);
					   obj.addEditClassFactory			=	 new ClassFactory(crm.contact.components.ContactAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(crm.contact.ContactController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(crm.contact.ContactModelLocator) ;
					   obj.modulePath					=	"crm/contact/components/Contact.swf";
					   obj.title						=	"Contact";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break;*/
				   case 'crmaccountcategory':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(AccountCategoryServices);
					   obj.addEditClassFactory			=	 new ClassFactory(AccountCategoryAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(AccountCategoryController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(AccountCategoryModelLocator) ;
					   obj.modulePath					=	"crm/category/components/AccountCategory.swf";
					   obj.title						=	"AccountCategory";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break;
				   case 'crmopportunity':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(OpportunityServices);
					   obj.addEditClassFactory			=	 new ClassFactory(OpportunityAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(OpportunityController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(OpportunityModelLocator) ;
					   obj.modulePath					=	"crm/opportunity/components/Opportunity.swf";
					   obj.title						=	"Opportunity";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break;
				   case 'crmtask':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(TaskServices);
					   obj.addEditClassFactory			=	 new ClassFactory(TaskAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(TaskController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(TaskModelLocator) ;
					   obj.modulePath					=	"crm/task/components/Task.swf";
					   obj.title						=	"Task";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break;
				 
				   case 'glcategory':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(GLCategoryServices);
					   obj.addEditClassFactory			=	 new ClassFactory(GLCategoryAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(GLCategoryController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(GLCategoryModelLocator) ;
					   obj.modulePath					=	"acct/glcategory/components/GlCategory.swf";
					   obj.title						=	"GlCategory";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break; 
				   
				   case 'glaccount':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(GLAccountServices);
					   obj.addEditClassFactory			=	 new ClassFactory(GLAccountAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(GLAccountController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(GLAccountModelLocator) ;
					   obj.modulePath					=	"acct/glacct/components/GLAccount.swf";
					   obj.title						=	"GLAccount";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break; 
				   case 'bank':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(BankServices);
					   obj.addEditClassFactory			=	 new ClassFactory(BankAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(BankController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(BankModelLocator) ;
					   obj.modulePath					=	"acct/bank/components/Bank.swf";
					   obj.title						=	"Bank";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break; 
				   case 'bank':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(BankServices);
					   obj.addEditClassFactory			=	 new ClassFactory(BankAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(BankController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(BankModelLocator) ;
					   obj.modulePath					=	"acct/bank/components/Bank.swf";
					   obj.title						=	"Bank";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break;
				   case 'setupitem':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(ItemServices);
					   obj.addEditClassFactory			=	 new ClassFactory(ItemAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(ItemController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(ItemModelLocator) ;
					   obj.modulePath					=	"invn/item/components/Item.swf";
					   obj.title						=	"Item";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break;
				   case 'accessoriesitem':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(ItemServices);
					   obj.addEditClassFactory			=	 new ClassFactory(ItemAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(ItemController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(ItemModelLocator) ;
					   obj.modulePath					=	"invn/item/components/Item.swf";
					   obj.title						=	"Item";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break; 
				   case 'assembleitem':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(ItemServices);
					   obj.addEditClassFactory			=	 new ClassFactory(ItemAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(ItemController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(ItemModelLocator) ;
					   obj.modulePath					=	"invn/item/components/Item.swf";
					   obj.title						=	"Item";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break; 
				   case 'vendorcategory':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(VendorCategoryServices);
					   obj.addEditClassFactory			=	 new ClassFactory(VendorCategoryAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(VendorCategoryController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(VendorCategoryModelLocator) ;
					   obj.modulePath					=	"vend/category/components/VendorCategory.swf";
					   obj.title						=	"VendorCategory";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break;
				   case 'salesperson':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(SalesPeopleServices);
					   obj.addEditClassFactory			=	 new ClassFactory(SalesPeopleAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(SalesPeopleController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(SalesPeopleModelLocator) ;
					   obj.modulePath					=	"saoi/salespeople/components/SalesPeople.swf";
					   obj.title						=	"SalesPeople";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break; 
				   case 'externalsalesperson':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(SalesPeopleServices);
					   obj.addEditClassFactory			=	 new ClassFactory(SalesPeopleAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(SalesPeopleController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(SalesPeopleModelLocator) ;
					   obj.modulePath					=	"saoi/salespeople/components/SalesPeople.swf";
					   obj.title						=	"SalesPeople";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break; 
				   case 'location':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(LocationServices);
					   obj.addEditClassFactory			=	 new ClassFactory(LocationAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(LocationController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(LocationModelLocator) ;
					   obj.modulePath					=	"dinvn/location/components/Location.swf";
					   obj.title						=	"Location";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break;
				   case 'purchaseperson':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(PurchasePeopleServices);
					   obj.addEditClassFactory			=	 new ClassFactory(PurchasePeopleAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(PurchasePeopleController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(PurchasePeopleModelLocator) ;
					   obj.modulePath					=	"puoi/purchasepeople/components/PurchasePeople.swf";
					   obj.title						=	"PurchasePeople";
					   obj.width						=	900;
					   obj.height						=	500;   
					   
					   break;
				   case 'suborders':
					   
					   obj.serviceClassFactory			=	 new ClassFactory(SubSalesOrderServices);
					   obj.addEditClassFactory			=	 new ClassFactory(SubSalesOrderAddEdit) ;
					   obj.controllerClassFactory		=	 new ClassFactory(SubSalesOrderController) ;
					   obj.modelLocatorClassFactory		=	 new ClassFactory(SubSalesOrderModelLocator) ;
					   obj.modulePath					=	"saoi/subsalesorder/components/SubSalesOrder.swf";
					   obj.title						=	"Sub Record";
					   obj.width						=	900;
					   obj.height						=	700;   
					   
					   break;
			     
			    default:
			   			obj.serviceClassFactory			=	 new ClassFactory();
						obj.addEditClassFactory			=	 new ClassFactory() ;
						obj.controllerClassFactory		=	 new ClassFactory() ;
						obj.modelLocatorClassFactory	=	 new ClassFactory() ;
						obj.modulePath					=	"";
						obj.title						=	"";
						obj.width						=	750;
						obj.height						=	400;
			        break;
			}
			return obj;
		}
	
	
	}
	
}
