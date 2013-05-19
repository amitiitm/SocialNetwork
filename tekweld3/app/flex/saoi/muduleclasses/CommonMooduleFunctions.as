package saoi.muduleclasses
{
	import business.commands.GetMenuCommand;
	import business.events.GetInformationEvent;
	import business.events.GetRecordEvent;
	
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.components.DataEntry;
	import com.generic.components.Detail;
	import com.generic.customcomponents.GenButton;
	import com.generic.customcomponents.GenDataGrid;
	import com.generic.customcomponents.GenDateField;
	import com.generic.customcomponents.GenTextInput;
	import com.generic.events.DetailEvent;
	import com.generic.events.GenTextInputEvent;
	import com.generic.genclass.GenNumberFormatter;
	import com.generic.genclass.TabPage;
	import com.generic.genclass.URL;
	
	import flash.media.Video;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import model.GenModelLocator;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.DateField;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import saoi.muduleclasses.event.MissingInfoEvent;
	
	import valueObjects.ApplicationVO;
	
	public class CommonMooduleFunctions
	{
		public var __genModel:GenModelLocator ;
		public var __localModel:Object;
		public var __services:ServiceLocator;
		
		private var cardNo:Object;
		private var dtlSetup:Object;
		private var selectedOptionsCode:String;
		private var main_item_qty:String;
		private var getInformationEvent:GetInformationEvent;
		
		private var default_method:String;
		
		// for shipping api
		private var shipping_code:Object;
		private var tiship_amt:Object;
		private var tiShipMethod:Object;
		private var tiShipMethodCode:Object;
		private var dfEstimatedInhandDate:Object;
		private var dfEstimatedShipDate:Object;
		private var lblShipAmountFormula:Object;
		private var dfShip_date:Object;
		private var dfInhand_date:Object;
		private var lblApiCalling:Object
		private var cbBillingTransportationTo:Object
		private var order_type:String;
		private var resultXmlFromItem:XML;
		private var dgpackets:Object;
		private var defaultCall:Boolean;
		private var tiShipZip:Object;
		private var tiShipCountry:Object;
		private var tiShipState:Object;
		private var screenComponents:UIComponent;
		private var tiQty:Object;
		
		private var shippingMethodXml:XML= new XML();
		
		// for item options code services 
		
		private var dtlSetupGrid:Object;
		private var isAdd:Boolean;
		private var myCamera:MyCamera;
		
		
		private var __responder:IResponder;
		private var numericFormatter:GenNumberFormatter 						= 	new GenNumberFormatter();
		
		public function CommonMooduleFunctions()
		{
			__genModel	= GenModelLocator.getInstance();
			__localModel= __genModel.activeModelLocator;
			__services	= __genModel.services;
			
			numericFormatter.precision = 2;
			numericFormatter.rounding = "nearest";
		}
		
		public function dataService(service:HTTPService):HTTPService
		{
			var urlObj:URL				=	new URL();
			service.url					=	urlObj.getURL(service.url);
			service.resultFormat 		= "e4x";					
			service.method 				= "POST";
			service.useProxy			= false;
			service.contentType			="application/xml";
			service.requestTimeout	 	= 1800
			service.showBusyCursor		= true;
			
			return service;
		}
		
		public function drilldownToSendToCustomerScreen(param:String):void
		{
			if(param != '' && param != null)
			{
				__genModel.drillObj.drillrow							=	new XML(<rows><trans_no>{param}</trans_no></rows>);
				__localModel.listObj.drilldown_component_code 			= 	"saoi/sendmultipleartworktocustomer/components/SendMultipleArtworkToCustomer.swf";
				
				
				var tabpage:TabPage										=	new TabPage();
				tabpage.openDrillDownPage(__localModel.listObj.drilldown_component_code);
			}
			else
			{
				Alert.show("Please Select Order");
			}
		}
		
		public function drilldownToIncompleteArtworkScreen(obj:Object):void
		{
			if(obj.dataValue != '' && obj.dataValue != null)
			{
				__genModel.drillObj.drillrow							=	new XML(<rows><trans_no>{obj.dataValue}</trans_no></rows>);
				__localModel.listObj.drilldown_component_code 			= 	"saoi/assignedartwork/components/AssignedArtwork.swf";
				
				var tabpage:TabPage										=	new TabPage();
				tabpage.openDrillDownPage(__localModel.listObj.drilldown_component_code);
			}
			else
			{
				Alert.show("Please Select Order");
			}
		}
		
		private function isPermissionForScreen(asPath:String):Boolean
		{
			var returnValue:Boolean	= true;
			
			var tempXmlList:XMLList	=	new XMLList(<temp/>)
			tempXmlList.appendChild(XMLList(__genModel.applicationObject.menu.rolepermission.(component_cd.toString() == asPath)).copy());
			
			for(var i:int =0 ; i<tempXmlList.children().length();i++)
			{
				var create_permission:String		= tempXmlList.children()[i].create_permission.toString();
				var modify_permission:String		= tempXmlList.children()[i].modify_permission.toString();
				var view_permission:String			= tempXmlList.children()[i].view_permission.toString();
				if(view_permission!='Y' )
				{
					returnValue		= false;
					break;
				}
			}
			return returnValue;
		}
		
		public function drilldownToCustomerScreen(obj:Object):void
		{
			if(obj.dataValue != '' && obj.dataValue != null)
			{
				__genModel.drillObj.drillrow							=	new XML(<rows><customer_code>{obj.labelValue}</customer_code></rows>);
				var mainPath:String										= 	"cust/customer/components/CustomerMaster.swf";
				var quickPath:String									= 	"cust/quickcustomer/components/QuickCustomerMaster.swf";
				
				if(isPermissionForScreen(mainPath))
				{
					__localModel.listObj.drilldown_component_code 			= 	mainPath
					var tabpage:TabPage										=	new TabPage();
					tabpage.openDrillDownPage(__localModel.listObj.drilldown_component_code);
				}
				else
				{
					__localModel.listObj.drilldown_component_code 			= 	quickPath;
					var tabpage:TabPage										=	new TabPage();
					tabpage.openDrillDownPage(__localModel.listObj.drilldown_component_code);
				}
				
			}
			else
			{
				Alert.show("Please Select Customer");
			}
		}
		public function drilldownToCustomerCouponScreen(obj:Object):void
		{
			if(obj.dataValue != '' && obj.dataValue != null)
			{
				__genModel.drillObj.drillrow							=	new XML(<rows><coupon_code>{obj.labelValue}</coupon_code></rows>);
				var mainPath:String										= 	"saoi/discountcoupons/components/DiscountCoupons.swf";
				
				__localModel.listObj.drilldown_component_code 			= 	mainPath
				var tabpage:TabPage										=	new TabPage();
				tabpage.openDrillDownPage(__localModel.listObj.drilldown_component_code);
				
			}
			else
			{
				Alert.show("Please Select Customer Coupon");
			}
		}
		
		
		public function drilldownToCustomerContact(contact:Object,customer:Object):void
		{
			if(contact.dataValue != '' && contact.dataValue != null)
			{
				var contact_name:String =  contact.dataValue;
				var index:int 			= contact_name.length;
				for(var i:int=0;i<contact_name.length;i++)
				{
					var char:String = contact_name.charAt(i);
					if(char==" ")
					{
						index = i;
						break;
					}
				}
				
				var first_name:String 	=  contact.labelValue.substring(0,index);
				var last_name:String 	=  contact.labelValue.substring(index,contact_name.length);
				
				__genModel.drillObj.drillrow							=	new XML(<rows><first_name>{first_name}</first_name><last_name>{last_name}</last_name><customer_code>{customer.labelValue}</customer_code></rows>);
				__localModel.listObj.drilldown_component_code 			= 	"cust/contact/components/Contact.swf";
				
				var tabpage:TabPage										=	new TabPage();
				tabpage.openDrillDownPage(__localModel.listObj.drilldown_component_code);
			}
			else
			{
				Alert.show("Please Select Customer Contact");
			}
		}
		public function openItemDetail(resultXmlFromItem:XML,screenComponent:DataEntry,image_name:String=''):void
		{
			var itemDetailWindow:ItemDetailViewer = ItemDetailViewer(PopUpManager.createPopUp(screenComponent,ItemDetailViewer,true));
			itemDetailWindow.x= ((Application.application.width/2)-(itemDetailWindow.width/2));
			itemDetailWindow.y= ((Application.application.height/2)-(itemDetailWindow.height/2));
			itemDetailWindow.itemDetail = new XML(<item_detail>
														<item_xml>{resultXmlFromItem}</item_xml>
														<image_name>{image_name}</image_name>
													</item_detail>);
		}
		
		public function authenticateCreditCardNoAndCardType(cardNo:Object,cardType:Object):void
		{
			if(cardNo.dataValue!='' && cardNo.dataValue!=null && (cardNo.dataValue).length>12)
			{
				this.cardNo									= cardNo;
				var validateCreditCard:HTTPService 			= dataService(__services.getHTTPService("validateCreditCard"));
				var __responderValidateCardNo:IResponder 	= new mx.rpc.Responder(validateCardNoResultHandler,validateCardNoFaultHandler);
				
				var token:AsyncToken = validateCreditCard.send(new XML(	<params>
																			<credit_card_no>{cardNo.dataValue}</credit_card_no>
																			<card_type>{cardType.dataValue}</card_type>
																		</params>));
				token.addResponder(__responderValidateCardNo);
				
			}
			else
			{
				Alert.show("Card No "+cardNo.dataValue+" is not Valid");
				cardNo.dataValue ='';
			}
		}
		public function validateCardNoResultHandler(event:ResultEvent):void
		{
			
			var result:String = event.result.toString();
			if(result.toUpperCase()=='TRUE')
			{
				
			}
			else
			{
				Alert.show("Card No "+this.cardNo.dataValue+" is not Valid");
				this.cardNo.dataValue  = '';
			}
		}
		public function validateCardNoFaultHandler(event:FaultEvent):void
		{
			Alert.show("ValidateCardNo"+event.fault.faultDetail);
			
			this.cardNo.dataValue  = '';
		}
		public function openPaymentGatwayPage():void
		{
			var urlObj:URL				=	new URL();
			var url:String 				=	urlObj.getURL(__services.getHTTPService("getPaymentUrl").url);
			var _requestUrl:URLRequest  = new URLRequest(url);
			navigateToURL(_requestUrl);
		}
		
		public function orderTrackerPopUp():void
		{
			var record:XML							= __localModel.addEditObj.record;
			if(record!=null)
			{
				var orderId:String  				= record.children()[0].id.toString();
				if(orderId!='' && orderId!=null)
				{
					var orderTrackViewer:OrderTrackingViewer 				= OrderTrackingViewer(PopUpManager.createPopUp(__localModel.addEditObj.addEditContainer,OrderTrackingViewer,true));
					orderTrackViewer.x										= ((Application.application.width/2)-(orderTrackViewer.width/2));
					orderTrackViewer.y										= ((Application.application.height/2)-(orderTrackViewer.height/2));
					orderTrackViewer.orderDetail 							= new XML(<order_detail>
																					<id>{orderId}</id>
																				</order_detail>);
				}
				else
				{
					Alert.show("Please select or Save Order");
				}
				
			}
			else
			{
				Alert.show("Please select or Save Order");
			}
			
		}
		
		public function checkForOptionsCharge(dtlSetup:Object,oldOptionsValue:String,newOptionsValue:String,customer_code:String,selectedOptionsCode:String,main_item_qty:String):void
		{
			if(oldOptionsValue != null && newOptionsValue != null && customer_code != null && customer_code != '')
			{
				var callbacks:IResponder	=	new mx.rpc.Responder(OptionsDetailsHandler, null);
				getInformationEvent			=	new GetInformationEvent('fetch_setup_charge_for_item_option_value', callbacks, oldOptionsValue,newOptionsValue,customer_code);
				getInformationEvent.dispatch();
			}
			else
			{
				Alert.show("Please Select Customer and Option");
			}
			this.dtlSetup   			= dtlSetup;
			this.selectedOptionsCode	= selectedOptionsCode;
			this.main_item_qty			= main_item_qty;
		}
		private function OptionsDetailsHandler(resultXml:XML):void
		{
			if(resultXml.children().length()>0)                  // means setup charge is associated with givan options value
			{
				
				var old_option_sales_order_line:XML  = XML(resultXml.old_option_sales_order_line);
				var new_option_sales_order_line:XML  = XML(resultXml.new_option_sales_order_line);
				
				if(old_option_sales_order_line.children().length()>0)
				{
					// delete from setup grid
					for(var i:int=0;i<old_option_sales_order_line.children().length();i++)
					{
						removeSetupItem(old_option_sales_order_line.children()[i].catalog_item_code.toString());
					}
					
				}
				if(new_option_sales_order_line.children().length()>0)
				{
					for(var i:int=0;i<new_option_sales_order_line.children().length();i++)
					{
						if(!isExistSetupItemCharge(new_option_sales_order_line.children()[i].catalog_item_code.toString()))
						{
							var xml:XML   				= this.dtlSetup.dgDtl.rows;         
							if(selectedOptionsCode.toUpperCase()=='IMPRINTCOLOR2' || selectedOptionsCode.toUpperCase()=='IMPRINTCOLOR3')
							{
								new_option_sales_order_line.children()[i].item_qty  = main_item_qty;
								new_option_sales_order_line.children()[i].item_amt	= (Number(new_option_sales_order_line.children()[i].item_price.toString())* Number(new_option_sales_order_line.children()[i].item_qty.toString())).toString();
							}
							xml.appendChild(new_option_sales_order_line.children()[i].copy());
							this.dtlSetup.dgDtl.rows    = xml.copy();
							this.dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_ADDEDIT_COMPLETE));             // for amount total
						}
						else if(selectedOptionsCode.toUpperCase()=='IMPRINTCOLOR2' || selectedOptionsCode.toUpperCase()=='IMPRINTCOLOR3')
						{
							var catalog_item_code:String		=  new_option_sales_order_line.children()[i].catalog_item_code.toString();
							
							var dgXml:XMLList  					= this.dtlSetup.dgDtl.rows.(trans_flag='A');
							for(var j:int=0;j<dgXml.children().length();j++)
							{
								var catalog_item_code_setup_grid:String 	= dgXml.children()[j].catalog_item_code.toString(); 
								if(catalog_item_code==catalog_item_code_setup_grid)
								{
									dgXml.children()[j].item_qty   = main_item_qty;
									dgXml.children()[j].item_amt   = (Number(dgXml.children()[j].item_price.toString())* Number(dgXml.children()[j].item_qty.toString())).toString();
								}
							}
							var tempXml:XML		    			= 		XML(dgXml).copy();
							dtlSetup.dgDtl.rows			  		=    	tempXml;                // for show update value
							this.dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_ADDEDIT_COMPLETE));             // for amount total
						}
					}
				}
				
			}
			__genModel.isLockScreen  = false;
			CursorManager.removeBusyCursor();
		}
		private function removeSetupItem(options_catalog_item_code:String):void
		{
			var index:int = -1;
			var dgXml:XMLList  = this.dtlSetup.dgDtl.rows.(trans_flag='A');
			
			for(var i:int=0;i<dgXml.children().length();i++)
			{
				var catalog_item_code:String = dgXml.children()[i].catalog_item_code.toString(); 
				if(catalog_item_code==options_catalog_item_code)
				{
					index = i;
					break;
				}
			}
			if(index>=0)
			{
				dtlSetup.deleteRow(index);
				this.dtlSetup.dispatchEvent(new DetailEvent(DetailEvent.DETAIL_REMOVE_ROW));  // for amount total
			}
			
		}
		private function isExistSetupItemCharge(options_catalog_item_code:String):Boolean
		{
			var returnValue:Boolean 	= false;
			var dgXml:XMLList  			= this.dtlSetup.dgDtl.rows.(trans_flag='A');
			for(var i:int=0;i<dgXml.children().length();i++)
			{
				var catalog_item_code:String = dgXml.children()[i].catalog_item_code.toString(); 
				if(catalog_item_code==options_catalog_item_code)
				{
					returnValue = true;
					break;
				}
			}
			return returnValue;
		}
		private function getItemId():String
		{
			if(resultXmlFromItem.children().length()>0)
			{
				return resultXmlFromItem.id.toString();
			}
			else
			{
				return '';
			}
		}
		private function getShipDate():String
		{
			if(this.dfShip_date.dataValue!='')
			{
				return this.dfShip_date.dataValue;
			}
			else
			{
				return this.dfEstimatedShipDate.dataValue;
			}
		}
		private function getInhandDate():Object
		{
			if(this.dfShip_date.dataValue!='')
			{
				return this.dfInhand_date;
			}
			else
			{
				return this.dfEstimatedInhandDate;
			}
		}
		public function getShippingMethods():void
		{
			var tempXml:XML					= new XML(<params>
														<zip_code>{this.tiShipZip.dataValue}</zip_code>
														<country>{this.tiShipCountry.dataValue}</country>
														<shipping_code>{this.shipping_code.dataValue}</shipping_code>
														<state>{this.tiShipState.dataValue}</state>
														<packagexml>{getPackageXml()}</packagexml>
														<estimated_ship_date>{getShipDate()}</estimated_ship_date>
														<catalog_item_id>{getItemId()}</catalog_item_id>
														<company_id>{__genModel.user.id}</company_id>
											  </params>);
			
			this.lblApiCalling.visible		= 	true; 
			__genModel.isLockScreen			=   true;
			this.screenComponents.parentDocument.enabled	=   false;
			this.screenComponents.parentDocument.setStyle('disabledOverlayAlpha',0);
			
			var send:HTTPService  = dataService(__services.getHTTPService("getShippingmethodsFromApi"));
			__responder 			= new mx.rpc.Responder(getShippingmethodsFromApiResultHandler,getShippingmethodsFromApiFaultHandler);
			
			var token:AsyncToken 	= send.send(new XML(tempXml));
			token.addResponder(__responder);
		}
		private function getShippingmethodsFromApiFaultHandler(event:FaultEvent):void
		{
			this.lblApiCalling.visible		= 	false; 
			this.screenComponents.parentDocument.enabled	=   true;
			this.screenComponents.parentDocument.setStyle('disabledOverlayAlpha',.5);
			__genModel.isLockScreen			=   false;
			Alert.show(event.fault.faultDetail+"getShippingmethodsFromApi");
		}
		private function getShippingmethodsFromApiResultHandler(event:ResultEvent):void
		{
			this.lblApiCalling.visible		= false;
			__genModel.isLockScreen			=   false;
			this.screenComponents.parentDocument.enabled	=   true;
			this.screenComponents.parentDocument.setStyle('disabledOverlayAlpha',.5);
			var resultXml:XML			= XML(event.result);
			
			if(resultXml.name() == "errors")
			{
				if(resultXml.children().length() > 0) 
				{
					var message:String = '';
					
					for(var i:uint = 0; i < resultXml.children().length(); i++) 
					{
						message += resultXml.children()[i] + "\n";
					}
					Alert.show(message);
					resetObjects();
				} 
			}
			else
			{
				this.shippingMethodXml			= resultXml; 
				
				if(this.defaultCall)
				{
					setDefaultMethod();
				}
				else
				{
					var shippingApiPopUp:ShippingApiPopUp = ShippingApiPopUp(PopUpManager.createPopUp(this.screenComponents,ShippingApiPopUp,true));
					shippingApiPopUp.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,missingInfoEventListner);
					shippingApiPopUp.x 					  = ((Application.application.width/2)-(shippingApiPopUp.width/2));
					shippingApiPopUp.y 					  = ((Application.application.height/2)-(shippingApiPopUp.height/2))+25;   // 25 for api calling
					shippingApiPopUp.itemDetail 		  = new XML(this.shippingMethodXml.copy());
				}
			}
		}
		
		private function setDefaultMethod():void
		{
			if(this.default_method!='' && this.default_method!=null)
			{
				var resultXml:XML		= this.shippingMethodXml.copy();
				
				for(var j:int=0;j<resultXml.children().length();j++)
				{
					var xmllist:XMLList	= XMLList(resultXml.children()[j]).copy();
					if(xmllist.child('service_code').toString() ==	this.default_method)
					{
						if(cbBillingTransportationTo.dataValue=='Shipper (TEKWELD)')
						{
							if(shipping_code.dataValue==ApplicationConstant.SHIPPING_PROVIDER_USPS && order_type=='P')
							{
								this.tiship_amt.dataValue 			 = this.tiship_amt.defaultValue;
								this.lblShipAmountFormula.text       = '';
							}
							else
							{
								this.tiship_amt.dataValue 			 = xmllist.price.toString();
								this.lblShipAmountFormula.text       = xmllist.negotiated_charge.toString()+' + '+xmllist.insured_charge.toString()+' + '+numericFormatter.format((20 * Number(xmllist.negotiated_charge.toString())/100).toString());

							}
						}
						else
						{
							this.tiship_amt.dataValue 			 = this.tiship_amt.defaultValue;
							this.lblShipAmountFormula.text       = '';
						}
						
						this.tiShipMethod.dataValue 		 	 = xmllist.service_name.toString();
						this.tiShipMethodCode.dataValue			 = xmllist.service_code.toString();
						
						var delivery_date:String			 	 = xmllist.delivery_date.toString();
						
						getInhandDate().dataValue			 	 =	delivery_date;
						
						/*if(shipping_code.dataValue=='UPS')          // in this we get actual inhand date 
						{
							getInhandDate().dataValue			 =	delivery_date;
						}
						else
						{
							var deliveryDays:Number				 = 7;                       // for ground service
							if(delivery_date!='')
							{
								deliveryDays					 = getNoOfdays(delivery_date,new GenDateField().currentDate());
							}
							getInhandDate().dataValue 			 = addDaysToDate(getShipDate(),deliveryDays);
							
						}*/
					}
				}
			}
		}
		private function addDaysToDate(date:String,days:Number):String
		{
			var now:Date 						 = new Date(date);
			now.date 							+= days;
			
			var df:GenDateField					= new GenDateField();
			return DateField.dateToString(now,df.databaseDateFormat);
			
		}
		private function getNoOfdays(date1:String, date2:String):Number
		{
			var dateFirst:Date 						 		= new Date(date1);
			var dateSecond:Date 						 	= new Date(date2);
			var one_day:Number = 1000 * 60 * 60 * 24;	
			var date1_ms:Number = dateFirst.getTime();
			var date2_ms:Number = dateSecond.getTime();
			var difference_ms:Number = Math.abs(date1_ms - date2_ms)
			return Math.round(difference_ms/one_day);
		}                           																									 																													 																																																																																 																			
		public function openShippingApiMethods(screenComponent:UIComponent,shipping_code:Object,zip_code:Object,country:Object,tiship_amt:Object,tiShipMethod:Object,dfEstimatedInhandDate:Object,dfEstimatedShipDate:Object,dfShip_date:Object,dfInhand_date:Object,tiState:Object,lblShipAmountFormula:Object,lblApiCalling:Object,cbBillingTransportationTo:Object,tiShipMethodCode:Object,dgPackets:Object,order_type:String,resultXmlFromItem:XML,tiQty:Object,defaultCall:Boolean):void
		{
			if(shipping_code.dataValue.toUpperCase() == ApplicationConstant.SHIPPING_PROVIDER_FEDEX || shipping_code.dataValue.toUpperCase()==ApplicationConstant.SHIPPING_PROVIDER_UPS || shipping_code.dataValue == ApplicationConstant.SHIPPING_PROVIDER_USPS)
			{
				this.tiShipZip				= zip_code;
				this.tiShipCountry			= country;
				this.tiShipState			= tiState;
				this.shipping_code			= shipping_code;
				this.tiship_amt   			= tiship_amt;
				this.lblShipAmountFormula	= lblShipAmountFormula;
				this.tiShipMethod 			= tiShipMethod;
				this.dfEstimatedInhandDate	= dfEstimatedInhandDate;
				this.dfEstimatedShipDate	= dfEstimatedShipDate;
				this.dfShip_date			= dfShip_date;
				this.dfInhand_date			= dfInhand_date;
				this.lblApiCalling			= lblApiCalling;
				this.cbBillingTransportationTo	= cbBillingTransportationTo;
				this.tiShipMethodCode			= tiShipMethodCode;
				this.order_type				= order_type;
				this.resultXmlFromItem		= resultXmlFromItem;
				this.dgpackets				= dgPackets;
				this.defaultCall			= defaultCall;
				this.default_method			= getShipMethodCodeValue();
				this.screenComponents		= screenComponent;
				this.screenComponents.setStyle('disabledOverlayAlpha',0);
				this.tiQty					= tiQty;
				
				if(zip_code.dataValue!='' && zip_code.dataValue!=null && country.dataValue!='' && country.dataValue!=null && shipping_code.dataValue!='' && shipping_code.dataValue!=null  && tiState.dataValue!='' && tiState.dataValue!=null && getPackageXml().children().length()>0 && Number(tiQty.dataValue)>0)
				{
					this.lblApiCalling.visible	= true;	
					getShippingMethods();
				}
				else
				{
					resetObjects();
					if(!this.defaultCall)
					{
						Alert.show("Enter Packages ,Destination Address 's State ,  Zip Code , Country and Shipping Provider");
					}
				}
			}
		}
		public function  missingInfoEventListner(event:MissingInfoEvent):void
		{
			this.lblApiCalling.visible	= false;	
			var xml:XML   				= XML(event.xml);
			if(xml.children().length()>0)
			{
				if(cbBillingTransportationTo.dataValue=='Shipper (TEKWELD)')
				{
					if(shipping_code.dataValue==ApplicationConstant.SHIPPING_PROVIDER_USPS && order_type=='P')
					{
						this.tiship_amt.dataValue 			 = this.tiship_amt.defaultValue;
						this.lblShipAmountFormula.text       = '';
					}
					else
					{
						this.tiship_amt.dataValue 			= xml.children()[0].price.toString();
						this.lblShipAmountFormula.text      = xml.children()[0].negotiated_charge.toString()+' + '+xml.children()[0].insured_charge.toString()+' + '+numericFormatter.format((20 * Number(xml.children()[0].negotiated_charge.toString())/100).toString());
					}
				}
				else
				{
					this.tiship_amt.dataValue 			 = this.tiship_amt.defaultValue;
					this.lblShipAmountFormula.text       = '';
				}
				this.tiShipMethod.dataValue 			 = xml.children()[0].service_name.toString();
				this.tiShipMethodCode.dataValue			 = xml.children()[0].service_code.toString();
				
				var delivery_date:String			 	 = xml.children()[0].delivery_date.toString();
				
				getInhandDate().dataValue			 	 =	delivery_date;
				/*if(shipping_code.dataValue=='UPS' || shipping_code.dataValue=='FEDEX')          // in this we get actual inhand date 
				{
					
				}
				else
				{
					var deliveryDays:Number				 = 7;                       // for ground service
					if(delivery_date!='')
					{
						deliveryDays					 = getNoOfdays(delivery_date,);
					}
					getInhandDate().dataValue 			 = addDaysToDate(getShipDate(),deliveryDays);
					
				}*/
			}
			else
			{
				resetObjects();
			}
			
			
		}
		private function resetObjects():void
		{
			this.tiship_amt.dataValue 		= this.tiship_amt.defaultValue;
			this.tiShipMethod.dataValue		= this.tiShipMethod.defaultValue
			this.tiShipMethodCode.dataValue	= this.tiShipMethodCode.defaultValue;
			getInhandDate().dataValue		= getInhandDate().defaultValue;
			this.lblShipAmountFormula.text	= '';
			this.lblApiCalling.visible		= false;
			this.lblShipAmountFormula.text  = '';
		}
		
		
		public function setOtherArtwotkFinalFlag(artwork_type:String,artwotkDetail:Object):void
		{
			var dgXml:XML		= XML(artwotkDetail.dgDtl.rows.(trans_flag='A'));
			
			for(var i:int = 0 ; i < dgXml.children().length(); i++)
			{
				var artwotkVersion:String   = dgXml.children()[i]['artwork_version'].toString();
				
				var searchIndex:int			= artwotkVersion.toUpperCase().search(artwork_type.toUpperCase());
				if(searchIndex<0)
				{
					dgXml.children()[i].final_artwork_flag  = 'N';
				}
			}
			
			artwotkDetail.dgDtl.rows		= dgXml.copy();
		}
		public function openScreenFromMenu(moodule_id:int , button:Object ,xml:XML=null):void
		{
			var btnId:String = button.id.toString()
			var __applicationObject:ApplicationVO = __genModel.applicationObject;
			
			var module_id:int =	moodule_id;
			var selectedModule:String = 'moodule_id == "' + module_id.toString() + '"' 	
			var menuItems:XMLList = __applicationObject.menu.rolepermission.(moodule_id == module_id.toString())		
			
			//Alert.show(menuItems.toString());
			
			var filteredMenu:XML = new GetMenuCommand().changeMenuXMLFormat(menuItems)
			var selectedMenuXml:XML = new XML(<rows/>);
			selectedMenuXml.appendChild(new XMLList(filteredMenu.row.row.(@code == btnId)));
			__genModel.context = 0
			__genModel.triggerSource = "MENU"
			__genModel.applicationObject.selectedMenuItem = selectedMenuXml.children()[0];
			if(xml!=null)
			{
				__genModel.objectFromDrilldown   = xml;
			}
			var tabpage:TabPage	=	new TabPage();
			
			tabpage.openTabpage(selectedMenuXml.children()[0].@name, selectedMenuXml.children()[0].@component_cd);
		}
		
		public function setDisableOptions(vbMain:VBox,optionXml:XML):void
		{
			new DrawItemsOptionsFunctions().drawItemOptionsForDisableOptions(vbMain,optionXml);
			/*vbMain.removeAllChildren();
			
			for(var i:int=0;i<optionXml.children().length();i++)
			{
				var hbox:HBox 									= new HBox();
				hbox.percentWidth	  							= 100;
				hbox.height 		 							= 22;
				hbox.name         								= 'hb'+i;	
				hbox.setStyle('verticalAlign','middle');
				
				
				// attribute code
				var tiAttributeName:Label						= new Label();
				tiAttributeName.text 							= optionXml.children()[i].catalog_attribute_code.toString();
				tiAttributeName.width							= 100;
				tiAttributeName.tabEnabled						= false;
				tiAttributeName.setStyle('textAlign','right');
				tiAttributeName.setStyle('borderStyle','none');
				
				// for attribute code values
				var gcbAttributeValue:ComboBox					= new ComboBox();
				gcbAttributeValue.id							=	 i.toString();
				gcbAttributeValue.tabEnabled					= true;
				//gcbAttributeValue.addEventListener(ListEvent.CHANGE , comboboxChangeHandler);
				gcbAttributeValue.width     					= 150;
				gcbAttributeValue.height						= 20;
				//gcbAttributeValue.enabled						= !dcCustomer_id.viewOnlyFlag
				
				gcbAttributeValue.dataProvider					= optionXml.children()[i].catalog_attribute_value_code.toString();
				gcbAttributeValue.labelField					= 'catalog_attribute_value_code';
				
				var tiRemarksValue:GenTextInput					= new GenTextInput();
				tiRemarksValue.id								= i.toString()
				tiRemarksValue.text 							= optionXml.children()[i].remarks.toString();;
				tiRemarksValue.width							= 200;
				tiRemarksValue.tabEnabled						= true;
				//tiRemarksValue.addEventListener(GenTextInputEvent.ITEMCHANGED_EVENT,remarksItemChnageHandler);
				
				hbox.addChildAt(tiAttributeName,0);
				hbox.addChildAt(gcbAttributeValue,1);
				hbox.addChildAt(tiRemarksValue,2);
				
				vbMain.addChildAt(hbox,i);
			}
			if(vbMain.numChildren>0)                 // in this case no options r exist 
			{
				changeVisibilityOfOtherDisableoptions(vbMain); 
			}*/
		}
		private function changeVisibilityOfOtherDisableoptions(vbMain:VBox):void
		{
			new OptionsVisiblityFunctions().changeVisibilityOfOtherDisableoptions(vbMain);
			/*var hboxFirst:HBox 							= HBox(vbMain.getChildByName('hb'+0));      // IMPRINT OPTIONS SHOULD BE FIRST OPTIONS
			var catalog_attribute_code:String	 		= Label(hboxFirst.getChildAt(0)).text;
			var comboBoxValue:ComboBox  				= ComboBox(hboxFirst.getChildAt(1));
			
			
			if(catalog_attribute_code=='IMPRINTTYPE')
			{
				if(comboBoxValue.selectedIndex<0 || comboBoxValue.selectedItem.toString()=='' )
				{
					for(var i:int=1;i<vbMain.getChildren().length;i++)
					{
						var hbox:HBox 								= HBox(vbMain.getChildByName('hb'+i));
						hbox.visible								= false;
						hbox.includeInLayout						= false;
						ComboBox(hbox.getChildAt(1)).selectedIndex	= -1;
						
					}
				}
				else if(comboBoxValue.selectedItem.toString()=='DECAL')
				{
					for(var i:int=1;i<vbMain.getChildren().length;i++)
					{
						var hbox:HBox 							= HBox(vbMain.getChildByName('hb'+i));
						hbox.visible							= true;
						hbox.includeInLayout					= true;
						
						var catalog_attribute_code:String	 	= Label(hbox.getChildAt(0)).text;
						
						if(catalog_attribute_code	=='IMPRINTCOLOR1' || catalog_attribute_code	=='IMPRINTCOLOR2' || catalog_attribute_code	=='IMPRINTCOLOR3')
						{
							hbox.visible   								= false;
							hbox.includeInLayout						= false;
							ComboBox(hbox.getChildAt(1)).selectedIndex	= -1;
						}
					}
				}
				else if(comboBoxValue.selectedItem.toString()=='DIRECT'  || comboBoxValue.selectedItem.toString()=='DIGITEK')
				{
					for(var i:int=1;i<vbMain.getChildren().length;i++)
					{
						var hbox:HBox 							= HBox(vbMain.getChildByName('hb'+i));
						hbox.visible							= true;
						hbox.includeInLayout					= true;
						
						var catalog_attribute_code:String	 	= Label(hbox.getChildAt(0)).text;
						if(catalog_attribute_code =='DECAL')
						{
							hbox.visible   						= false;
							hbox.includeInLayout				= false;
							ComboBox(hbox.getChildAt(1)).selectedIndex	= -1;
						}
					}
				}
				else
				{
					for(var i:int=1;i<vbMain.getChildren().length;i++)
					{
						var hbox:HBox 							= HBox(vbMain.getChildByName('hb'+i));
						hbox.visible							= true;
						hbox.includeInLayout					= true;
						
						var catalog_attribute_code:String	 	= Label(hbox.getChildAt(0)).text;
						if(catalog_attribute_code =='DECAL' || catalog_attribute_code	=='IMPRINTCOLOR1' || catalog_attribute_code	=='IMPRINTCOLOR2' || catalog_attribute_code	=='IMPRINTCOLOR3')
						{
							hbox.visible   						= false;
							hbox.includeInLayout				= false;
							ComboBox(hbox.getChildAt(1)).selectedIndex	= -1;
						}
					}
				}
			}
			else
			{
				// normal flow
				for(var i:int=0;i<vbMain.getChildren().length;i++)
				{
					var hbox:HBox 							= HBox(vbMain.getChildByName('hb'+i));
					hbox.visible							= true;
					hbox.includeInLayout					= true;
				}
			}*/
			
		}
		public function captureImage(container:UIComponent,xmlParam:XML):void
		{
			if(xmlParam.children().length()==1)
			{
				myCamera    =  MyCamera(PopUpManager.createPopUp(container,MyCamera,true));
				myCamera.x	=  ((Application.application.width/2)-(myCamera.width/2));
				myCamera.y	=  ((Application.application.height/2)-(myCamera.height/2));
				myCamera.xml=  xmlParam;
			}
			else
			{
				Alert.show("Please Select One Record");
			}
		}
		public function setPaperProofDone(artworkapprovedbycust_flag:String,dtlArtwork:Object):void
		{
			if(artworkapprovedbycust_flag!='')
			{
				dtlArtwork.bcdp.btnEditVisible 		= false;
			}
			else
			{
				dtlArtwork.bcdp.btnEditVisible 		= true;
			}
		}
		public function givemsgBeforeCancelAthorizeAmount():void
		{
			var record:XML				= __localModel.addEditObj.record;
			
			if(record!=null && !__genModel.activeModelLocator.addEditObj.editStatus)
			{
				Alert.show("Authorization of Amount is about to be Cancel. Are you sure?","Cancel Authorize Amount",Alert.YES | Alert.NO,__localModel.addEditObj.addEditContainer,alertCacelAmountListener,null,Alert.OK)
			}
			else
			{
				Alert.show("Please Save Record Before Cancel Authorize Payment");
			}
		}
		private function alertCacelAmountListener(event:CloseEvent):void
		{
			switch (event.detail)
			{
				case Alert.YES:
					cancelAuthorizeAmount();
					break;
				case Alert.NO:
					
					break;
			}
		}
		public function cancelAuthorizeAmount():void
		{
			var record:XML					= __localModel.addEditObj.record;
			if(record!=null)
			{
				var orderId:String  		= record.children()[0].id.toString();
				if(orderId!='' && orderId!=null)
				{
					var tempXml:XML			= new XML(<params>
														<sales_order_id>{orderId}</sales_order_id>
													  </params>);
					
					var resend:HTTPService  = dataService(__services.getHTTPService("cancelAuthorizePayment"));
					__responder 			= new mx.rpc.Responder(cancelAuthorizePaymentResultHandler,cancelAuthorizePaymentFaultHandler);
					
					var token:AsyncToken 	= resend.send(new XML(tempXml));
					token.addResponder(__responder);	
					
					__genModel.isLockScreen   = true;
				}
			}
			else
			{
				Alert.show("Please save record");
			}
		}
		private function cancelAuthorizePaymentFaultHandler(event:FaultEvent):void
		{
			__genModel.isLockScreen   = false;
			
			Alert.show(event.fault.faultDetail);
		}
		private function cancelAuthorizePaymentResultHandler(event:ResultEvent):void
		{
			__genModel.isLockScreen   = false;
			
			var resultXml:XML				 = XML(event.result);
			
			if(resultXml.name() == "errors")
			{
				if(resultXml.children().length() > 0) 
				{
					var message:String = '';
					
					for(var i:uint = 0; i < resultXml.children().length(); i++) 
					{
						message += resultXml.children()[i] + "\n";
					}
					Alert.show(message);
				} 
			}
			else
			{
				Alert.show(resultXml.toString());
				var getRecordEvent:GetRecordEvent = new GetRecordEvent(int(__localModel.addEditObj.record.children()[0].id.toString()),null,false);
				getRecordEvent.dispatch();
			}
		}
		
		public function setInhandDate(screenComponent:UIComponent,shipping_code:Object,zip_code:Object,country:Object,tiship_amt:Object,tiShipMethod:Object,dfEstimatedInhandDate:Object,dfEstimatedShipDate:Object,dfShip_date:Object,dfInhand_date:Object,ticatalog_item_id:String,tiQty:Object,sales_order_id:String,tiState:Object,lblShipAmountFormula:Object,lblApiCalling:Object,cbBillingTransportationTo:Object,tiShipMethodCode:Object):void
		{
			this.shipping_code			= shipping_code;
			this.tiship_amt   			= tiship_amt;
			this.lblShipAmountFormula	= lblShipAmountFormula;
			this.tiShipMethod 			= tiShipMethod;
			this.dfEstimatedInhandDate	= dfEstimatedInhandDate;
			this.dfEstimatedShipDate	= dfEstimatedShipDate;
			this.dfShip_date			= dfShip_date;
			this.dfInhand_date			= dfInhand_date;
			this.lblApiCalling			= lblApiCalling;	
			this.cbBillingTransportationTo	= cbBillingTransportationTo;
			this.tiShipMethodCode		= tiShipMethodCode;
			this.screenComponents		= screenComponent;
			this.screenComponents.setStyle('disabledOverlayAlpha',0);
			
			if(zip_code.dataValue!='' && zip_code.dataValue!=null && country.dataValue!='' && country.dataValue!=null && shipping_code.dataValue!='' && shipping_code.dataValue!=null && tiState.dataValue!='' && tiState.dataValue!=null)
			{
				var tempXml:XML				= new XML(<params>
																					<zip_code>{zip_code.dataValue}</zip_code>
																					<country>{country.dataValue}</country>
																					<shipping_code>{shipping_code.dataValue}</shipping_code>
																					<state>{tiState.dataValue}</state>
																					<estimated_ship_date>{getShipDate()}</estimated_ship_date>
																					<ship_method_code>{getShipMethodCodeValue()}</ship_method_code>
																					<catalog_item_id>{ticatalog_item_id}</catalog_item_id>
																					<company_id>{__genModel.user.id}</company_id>
																				  </params>);
				getInhnadDateFromApi(tempXml);
			}
			else
			{
				resetObjects();
				Alert.show("Enter Destination Address 's State ,  Zip Code , Country and Shipping Provider");
			}
		}
		
		public function getInhnadDateFromApi(paramxml:XML):void
		{
			this.lblApiCalling.visible		= 	true; 
			__genModel.isLockScreen			=   true;
			this.screenComponents.enabled	=   false;
			
			var send:HTTPService  			= 	dataService(__services.getHTTPService("getInhandDate"));
			__responder 					= 	new mx.rpc.Responder(getInhandDateResultHandler,getInhandDateFaultHandler);
			
			var token:AsyncToken 			= 	send.send(paramxml);
			token.addResponder(__responder);
		}
		private function getInhandDateResultHandler(event:ResultEvent):void
		{
			this.lblApiCalling.visible		=	false;		
			__genModel.isLockScreen			= 	false;
			this.screenComponents.enabled	=   true;
			
			var resultXml:XML				 = XML(event.result);
			if(resultXml.name() == "errors")
			{
				if(resultXml.children().length() > 0) 
				{
					var message:String = '';
					
					for(var i:uint = 0; i < resultXml.children().length(); i++) 
					{
						message += resultXml.children()[i] + "\n";
					}
					Alert.show(message);
					resetObjects();
				} 
			}
			else
			{
				getInhandDate().dataValue	= resultXml.toString();
				if(dfShip_date.dataValue=='')
				{
					dfInhand_date.dataValue = '';
				}
			}
			
		}
		
		public function getInhandDateFaultHandler(event:FaultEvent):void
		{
			this.lblApiCalling.visible		=	false;		
			__genModel.isLockScreen			= 	false;
			this.screenComponents.enabled	=   true;
			
			Alert.show("getInhandDate"+event.fault.faultDetail);
			
		}
		private function getShipMethodCodeValue():String
		{
			if(tiShipMethodCode.dataValue=='')
			{
				if(shipping_code.dataValue==ApplicationConstant.SHIPPING_PROVIDER_FEDEX)
				{
					return ApplicationConstant.DEFAULT_SHIPPING_METHOD_FEDEX;
				}
				else if(shipping_code.dataValue==ApplicationConstant.SHIPPING_PROVIDER_USPS)
				{
					return ApplicationConstant.DEFAULT_SHIPPING_METHOD_USPS
				}
				else
				{
					return ApplicationConstant.DEFAULT_SHIPPING_METHOD_UPS
				}
			}
			else
			{
				return tiShipMethodCode.dataValue;
			}
		}
		private function getPackageXml():XML
		{
			var column1Price:Number	 = 0.00;
			if(this.order_type=='S' || this.order_type=='E' || this.order_type=='F')
			{
				column1Price	  	 = Number(resultXmlFromItem.ltm_price.catalog_item_prices.catalog_item_price.column1.toString());
			}
			
			var tempXml:XML			= dgpackets.rows.copy();
			for(var i:int=0;i<tempXml.children().length();i++)
			{
				tempXml.children()[i].insured_charge  = numericFormatter.format(Number(tempXml.children()[i].pcs_per_carton.toString())* column1Price);
			}
			return tempXml;
		}
		
		public function orderQueriesRemoveAddButton(orderEntryCompletedFlag:String,dtlQueries:Detail):void
		{
			if(orderEntryCompletedFlag=='Y')
			{
				dtlQueries.bcdp.btnEditVisible  = false;
			}
			else
			{
				dtlQueries.bcdp.btnEditVisible  = true;
			}
		}
		
		
		[Embed("com/generic/assets/ups_logo.jpg")]
		private const upsshippingButtonIcon:Class;
		[Embed("com/generic/assets/fedex_logo.jpg")]
		private const fedexshippingButtonIcon:Class;
		[Embed("com/generic/assets/usps.jpg")]
		private const uspsshippingButtonIcon:Class;
		
		
		public function setShippingLogo(shipping_code:String,btnShipMethod:GenButton):void
		{
			if(shipping_code.toUpperCase() 		== ApplicationConstant.SHIPPING_PROVIDER_FEDEX)
			{
				btnShipMethod.visible				= true;
				btnShipMethod.setStyle("icon",fedexshippingButtonIcon);
			}
			else if(shipping_code.toUpperCase() == ApplicationConstant.SHIPPING_PROVIDER_UPS)
			{
				btnShipMethod.visible				= true;
				btnShipMethod.setStyle("icon",upsshippingButtonIcon);
			}
			else if(shipping_code.toUpperCase() == ApplicationConstant.SHIPPING_PROVIDER_USPS)
			{
				btnShipMethod.visible				= true;
				btnShipMethod.setStyle("icon",uspsshippingButtonIcon);
			}
			else
			{
				btnShipMethod.visible				= false;
				btnShipMethod.setStyle("icon",upsshippingButtonIcon);
			}
		}
		public function getMainImageName(dcItemId:Object,vbMain:VBox,base_image_name:String):String
		{
			var returnValue:String   = '';
			
			if(dcItemId.dataValue!='')
			{
				returnValue 						= base_image_name;
				
				var color_code_option:String    	= dcItemId.labelValue+'-COLORS';
				var imprinttype_value:String		= getOptionsValue(ApplicationConstant.ITEM_IMPRINTTYPE,vbMain);
				var color_code_option_value:String	= getOptionsValue(color_code_option,vbMain);
				
				if(imprinttype_value!='' && color_code_option_value!='' )
				{
					returnValue  = dcItemId.labelValue+'-'+imprinttype_value+'-'+color_code_option_value+'.jpg';
				}
			}
			
			return returnValue;
			
		}
		public function getOptionsValue(option_code:String,vbMain:VBox):String
		{
			var returnvalue:String  = '';
			for(var i:int=0;i<vbMain.getChildren().length;i++)
			{
				var hbox:HBox 						= HBox(vbMain.getChildByName('hb'+i));
				var catalog_attribute_code:String 	= Label(hbox.getChildAt(0)).text;
				var comboBoxValue:ComboBox 	 		= ComboBox(hbox.getChildAt(1));
				var catalog_attribute_value_code:String = '';
				if(comboBoxValue.selectedIndex<0)
				{
					catalog_attribute_value_code  = '';
				}
				else
				{
					catalog_attribute_value_code = comboBoxValue.selectedItem.code.toString();
				}
				
				if(catalog_attribute_code==option_code)
				{
					returnvalue	= catalog_attribute_value_code;
					break;
				}		
			}
			return returnvalue;
		}
		public function getMainImageNameForDisableOptions(dcItemId:Object,vbMain:VBox,base_image_name:String):String
		{
			var returnValue:String   = '';
			
			if(dcItemId.dataValue!='')
			{
				returnValue 						= base_image_name;
				
				var color_code_option:String    	= dcItemId.labelValue+'-COLORS';
				var imprinttype_value:String		= getDisableOptionsValue(ApplicationConstant.ITEM_IMPRINTTYPE,vbMain);
				var color_code_option_value:String	= getDisableOptionsValue(color_code_option,vbMain);
				
				if(imprinttype_value!='' && color_code_option_value!='' )
				{
					returnValue  = dcItemId.labelValue+'-'+imprinttype_value+'-'+color_code_option_value+'.jpg';
				}
			}
			
			return returnValue;
			
		}
		public function getDisableOptionsValue(option_code:String,vbMain:VBox):String
		{
			var returnvalue:String  = '';
			for(var i:int=0;i<vbMain.getChildren().length;i++)
			{
				var hbox:HBox 						= HBox(vbMain.getChildByName('hb'+i));
				var catalog_attribute_code:String 	= Label(hbox.getChildAt(0)).text;
				var comboBoxValue:ComboBox 	 		= ComboBox(hbox.getChildAt(1));
				var catalog_attribute_value_code:String = '';
				if(comboBoxValue.selectedIndex<0)
				{
					catalog_attribute_value_code  = '';
				}
				else
				{
					catalog_attribute_value_code = comboBoxValue.selectedItem.toString();
				}
				
				if(catalog_attribute_code==option_code)
				{
					returnvalue	= catalog_attribute_value_code;
					break;
				}		
			}
			return returnvalue;
		}
		public function openInvoiceScreen(dgInvoices:GenDataGrid):void
		{
			var selectedXml:XML									=   XML(dgInvoices.selectedItem).copy();
			if(selectedXml.children().length()>0)
			{
				__genModel.drillObj.drillrow					=	XML(dgInvoices.selectedItem)
				var __localModel:Object   						=   __genModel.activeModelLocator;
				__localModel.listObj.drilldown_component_code 	= "saoi/salesinvoice/components/SalesInvoice.swf"	
				var tabpage:TabPage	=	new TabPage();
				tabpage.openDrillDownPage(__localModel.listObj.drilldown_component_code);
			}
			else
			{
				
			}
			
		}
	}  // end of class
}  // end of package