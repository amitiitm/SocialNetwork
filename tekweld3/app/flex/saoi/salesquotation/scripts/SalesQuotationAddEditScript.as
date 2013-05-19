import business.events.GetInformationEvent;
import business.events.GetRecordEvent;
import business.events.PreSaveEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.components.DataEntry;
import com.generic.customcomponents.GenDataGrid;
import com.generic.customcomponents.GenDateField;
import com.generic.customcomponents.GenDynamicComboBox;
import com.generic.events.AddEditEvent;
import com.generic.events.ButtonControlDetailEvent;
import com.generic.events.DetailEvent;
import com.generic.events.GenCheckBoxEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.genclass.URL;

import flash.net.URLRequest;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.ComboBox;
import mx.controls.DateField;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.formatters.DateFormatter;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import saoi.muduleclasses.CommonLinksServices;
import saoi.muduleclasses.CommonMooduleFunctions;
import saoi.muduleclasses.GenNotesAttachmentIcon;
import saoi.muduleclasses.MissingInfolViewer;
import saoi.muduleclasses.PrintPreview;
import saoi.muduleclasses.event.MissingInfoEvent;
import saoi.salesquotation.SalesQuotationModelLocator;

private var preSaveEvent:PreSaveEvent;
private var getInformationEvent:GetInformationEvent;
private var getInformationShippingEvent:GetInformationEvent;
private var item_detail:GetInformationEvent;
private var shipping_detail:GetInformationEvent;
[Bindable]
private var __localModel:SalesQuotationModelLocator = (SalesQuotationModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var shippingMethidsValue:String ;
[Bindable]
private var image_name:String;
private var __service:ServiceLocator = __genModel.services;
private var isOkOrderEntrySSave:Boolean	=	false;
private var customerContactValue:String ;
private var customer_contact:GetInformationEvent;
private var isCustomerChnage:Boolean    = false;
private var __responderPick:IResponder;
private var customer_phone:String = '';
private var selectUniqueArtworkVersionIndex:int = 0;
[Bindable]
private var isTermCreditCard:Boolean   =  false;
private var isMissingInfoSave:Boolean	=	false;
private var missingInfoWindow:MissingInfolViewer;
[Bindable]
private var screenViewMissingInfo:String = '';
private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var numericFormatterFourPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterThreePrecesion:GenNumberFormatter	=	new GenNumberFormatter();
private var numericFormatterWithoutPrecesion:GenNumberFormatter	=	new GenNumberFormatter();
[Bindable]
private var payment_profiles:XML;
[Bindable]
private var isPaymentProfileBlank:Boolean   =  true;
private var payment_info:XML		= new XML(<row>
													<card_type></card_type>	
													<credit_card_no></credit_card_no>
													<exp_month></exp_month>	
													<exp_year></exp_year>											
													<security></security>	
													<name_on_card></name_on_card>	
											  </row>);
private var paymentProfileCode:String = '';
private var paymentProfileCardNumber:String='';	


							
private function init():void
{
	numericFormatterWithoutPrecesion.precision	=	0;
	numericFormatterWithoutPrecesion.rounding = "nearest";
	
	numericFormatterThreePrecesion.precision	=	3;
	numericFormatterThreePrecesion.rounding = "nearest";
	
	numericFormatterFourPrecesion.precision		=	4;
	numericFormatterFourPrecesion.rounding = "nearest";
	
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	
	__localModel.trans_date = dfTrans_date.text	
	//getAccountPeriod();

}
private function dateFunc(item:Object, column:DataGridColumn):String
{
	var dateFormatter:DateFormatter = new DateFormatter();
	var date_format:String = GenModelLocator.getInstance().user.date_format.toLocaleUpperCase();
		
	if(date_format == null || date_format == "")
	{
		dateFormatter.formatString = 'MM/DD/YYYY H:NN:SS';
	}
	else
	{
		dateFormatter.formatString = 'MM/DD/YYYY H:NN:SS';
	}

	return dateFormatter.format(item[column.dataField].toString());
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
	
	return service;
}

private function getAccountPeriod():void
{
	if(dfTrans_date.text != '' && dfTrans_date.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('accountperiod', callbacks, dfTrans_date.text);
		getInformationEvent.dispatch(); 
	}
}

private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue	=	resultXml.child('code');
}

private function getCustomerDetails():void
{
	tiCustomerCode.dataValue		= dcCustomer_id.labelValue;
	
	if(dcCustomer_id.text != "" && dcCustomer_id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(customerDetailsHandler, null);
		
		getInformationEvent			=	new GetInformationEvent('customerdetail', callbacks, dcCustomer_id.dataValue, "I");
		getInformationEvent.dispatch();
		
		__localModel.customer_id	= dcCustomer_id.dataValue;
	}
	else
	{
		
		tiCustomer_phone.dataValue			   = '';
		dcExternalSales_person_code.dataValue  = dcExternalSales_person_code.defaultDataValue;
		dcExternalSales_person_code.labelValue = dcExternalSales_person_code.defaultLabelValue;
		dcSales_person_code.dataValue  		   = dcSales_person_code.defaultDataValue;
		dcSales_person_code.labelValue 		   = dcSales_person_code.defaultLabelValue;
		
		resetItem();
		resetBilling();
		resetEmail();
		resetStatus();
		
		
		
	}
	isCustomerChnage=true;
	__localModel.customer_id				= dcCustomer_id.dataValue;
	__localModel.customer_code				= dcCustomer_id.labelValue;
	dcCustomer_Contact_id.filterKeyValue  	= dcCustomer_id.dataValue;
}
private function resetStatus():void
{
	/*tiAccount_status.dataValue 				= 	tiAccount_status.defaultValue;
	tiAccount_reason.dataValue				=   tiAccount_reason.defaultValue;
	tiInventory_status.dataValue			=   tiInventory_status.defaultValue;
	tiAcknowledgmentStatus.dataValue		=   tiAcknowledgmentStatus.defaultValue;
	tiShippingStatus.dataValue				=   tiShippingStatus.defaultValue;
	tiCurrent_status.dataValue				=   tiCurrent_status.defaultValue;*/
	taMissingInfo.dataValue					=   taMissingInfo.defaultValue;
}
private function resetItem():void
{
	var tempXml:XML			= dtlLine.dgDtl.rows.copy();
	for(var i:int=0;i<tempXml.children().length();i++)
	{
		dtlLine.deleteRow(0);
	}
}
private function resetEmail():void
{
	tiAccounts.dataValue 				= 	tiAccounts.defaultValue;
	tiShipping.dataValue 				= 	tiShipping.defaultValue;
	tiPurchase.dataValue				=	tiPurchase.defaultValue;
	tiCorrespondense.dataValue			=	tiCorrespondense.defaultValue;
	tiArt_work.dataValue				=	tiArt_work.defaultValue;
}
private function resetBilling():void
{
	tiName.dataValue			= tiName.defaultValue;
	tiBill_address1.dataValue	= tiBill_address1.defaultValue;
	tiBill_address2.dataValue	= tiBill_address2.defaultValue;
	tiBill_city.dataValue		= tiBill_city.defaultValue;
	tiBill_country.dataValue	= tiBill_country.defaultValue;
	tiBill_fax1.dataValue		= tiBill_fax1.defaultValue;
	tiBill_phone1.dataValue		= tiBill_phone1.defaultValue;
	tiBill_state.dataValue		= tiBill_state.defaultValue;
	tiBill_zip.dataValue		= tiBill_zip.defaultValue;
	setBillingAddressIntoShipping();
}

private function getCustomerShipping():void
{
		var callbacksShipping:IResponder	=	new mx.rpc.Responder(customerShippingDetailsHandler, null);
		
		getInformationShippingEvent			=	new GetInformationEvent('customer_specific_shippings', callbacksShipping, dcCustomer_id.dataValue);
		getInformationShippingEvent.dispatch();  
}

private function customerDetailsHandler(resultXml:XML):void
{
	__localModel.defaultSetupChargeXml  		= XML(resultXml.children()[0].default_setup_lines).copy();
	setValue(resultXml);
	setBillingAddress(resultXml);
}
private function customerShippingDetailsHandler(resultXml:XML):void
{
	//__localModel.customerShipping = resultXml;	
}
private function setBillingAddress(customerXml:XML):void
{
	tiName.dataValue			= customerXml.children().child('name').toString();
	tiBill_address1.dataValue	= customerXml.children().child('bill_address1').toString();
	tiBill_address2.dataValue	= customerXml.children().child('bill_address2').toString();
	tiBill_city.dataValue		= customerXml.children().child('bill_city').toString();
	tiBill_country.dataValue	= customerXml.children().child('bill_country').toString();
	tiBill_fax1.dataValue		= customerXml.children().child('bill_fax').toString();
	tiBill_phone1.dataValue		= customerXml.children().child('bill_phone').toString();
	tiBill_state.dataValue		= customerXml.children().child('bill_state').toString();
	tiBill_zip.dataValue		= customerXml.children().child('bill_zip').toString();
	
	setBillingAddressIntoShipping();
	
}
private function setValue(customerXml:XML):void
{
	dcCustomer_Contact_id.labelValue		= customerXml.children().child('contact_name').toString();
	dcCustomer_Contact_id.dataValue			= customerXml.children().child('contact_name').toString();
	tiCustomer_phone.dataValue			    = customerXml.children().child('phone1').toString();
	customer_phone						  	= customerXml.children().child('phone1').toString();
	
	tiAccounts.dataValue 					= 	customerXml.children().child('account_dept_email').toString();
	tiShipping.dataValue 					= 	customerXml.children().child('shipping_dept_email').toString();
	tiPurchase.dataValue					=	 customerXml.children().child('purchase_dept_email').toString();
	tiCorrespondense.dataValue				=	 customerXml.children().child('corr_dept_email').toString();
	tiArt_work.dataValue					=	 customerXml.children().child('artwork_dept_email').toString();
	
	dcSales_person_code.dataValue			= customerXml.children().child('salesperson_code').toString();
	dcSales_person_code.labelValue			= customerXml.children().child('salesperson_code').toString();
	dcExternalSales_person_code.dataValue	= customerXml.children().child('externalsalesperson_code').toString();
	dcExternalSales_person_code.labelValue	= customerXml.children().child('externalsalesperson_code').toString();
	
	
	__localModel.default_customer_third_party_account_number = customerXml.children().child('default_customer_third_party_account_number').toString();
	__localModel.default_customer_bill_transportation_to	 = customerXml.children().child('default_customer_bill_transportation_to').toString();
	__localModel.default_customer_shipping_code				 = customerXml.children().child('default_customer_shipping_code').toString();

	
	if(customerXml.children().child('business_phone').toString()!='')
	{
		tiCustomer_phone.dataValue			= customerXml.children().child('business_phone').toString();
	}

}
private function setScreenView(data:XML):void
{
	var sourceScreen:String	 = data.row[0].toString();
	if(sourceScreen.toUpperCase()=='PICKORDER' || sourceScreen.toUpperCase()=='ASSIGNEDORDER')
	{
		screenViewMissingInfo               = 'ASSIGNEDORDER';
	}
	else if (sourceScreen.toUpperCase()=='QCORDER')
	{
		cbOrderEnterCompleted.visible			= false;
		cbOrderEnterCompleted.includeInLayout 	= false;
		screenViewMissingInfo              	 	= 'QCORDER';
	}
	__genModel.objectFromDrilldown = new XML(<rows></rows>);
}
//--------------------------------------------------------------------------------
override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	
	var recordXml:XML		= event.recordXml;
	
	__localModel.default_customer_third_party_account_number = recordXml.children()[0].default_customer_third_party_account_number.toString();
	__localModel.default_customer_bill_transportation_to	 = recordXml.children()[0].default_customer_bill_transportation_to.toString();
	__localModel.default_customer_shipping_code				 = recordXml.children()[0].default_customer_shipping_code.toString();

	__localModel.defaultSetupChargeXml   					 = XML(recordXml.children()[0].default_setup_lines).copy();
	dcCustomer_id.enabled	=	false;
	
	if(__genModel.objectFromDrilldown.children().length()>0)
	{
		setScreenView(__genModel.objectFromDrilldown);
	}
	customer_phone							= recordXml.sales_order.cust_phone.toString();
	dcCustomer_Contact_id.filterKeyValue  	= dcCustomer_id.dataValue;
	__localModel.trans_date 				= dfTrans_date.text
	__localModel.order_type					= cbOrder_type.dataValue;
	__localModel.trans_no  					= 	tiTrans_no.text;
	__localModel.ext_ref_no					=	tiCustomer_po_id.text;
	__localModel.customer_id				= dcCustomer_id.dataValue;
	__localModel.customer_code				= dcCustomer_id.labelValue;

	if(dtlLine.dgDtl.dataProvider.length > 0)
	{
		dtlLine.dgDtl.selectedIndex = 0
	}

	changeImage();
	if(recordXml.sales_order.term_code.toString()=="CC")
	{
		isTermCreditCard = true;
	}
	else
	{
		isTermCreditCard = false;
	}
	
	
	var genNotesAttachmentIcon:GenNotesAttachmentIcon  = new GenNotesAttachmentIcon();
	genNotesAttachmentIcon.changeIcon(__localModel,DataEntry(this.parentDocument));
	setBillingAddressIntoShipping();
	
	__localModel.ext_ref_date   				= dfCustomer_po_date.dataValue;
	setShippingObject();
	dtlShippings.bcdp.btnEditVisible  = (dtlShippings.dgDtl.rows.children().length()>0)? false:true;
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	__localModel.default_customer_third_party_account_number = '';
	__localModel.default_customer_bill_transportation_to	 = '';
	__localModel.default_customer_shipping_code				 = '';
	__localModel.defaultSetupChargeXml						 = new XML();
	
	reSetShippingObject();
	paymentProfileCode  			      = '';
	paymentProfileCardNumber			  = '';
	__localModel.order_type				  = cbOrder_type.dataValue;
	setBillingAddressIntoShipping();
	getAccountPeriod();
	dcCustomer_id.enabled				=	true;
	__localModel.trans_date 			= dfTrans_date.text
	__localModel.trans_no				= tiTrans_no.text;
	__localModel.ext_ref_no				= tiCustomer_po_id.text;
	__localModel.customer_id			= dcCustomer_id.dataValue;
	__localModel.customer_code			= dcCustomer_id.labelValue;
	customer_phone						= '';
	changeImage()
	__localModel.ext_ref_date   		= dfCustomer_po_date.dataValue;
	
	var genNotesAttachmentIcon:GenNotesAttachmentIcon  = new GenNotesAttachmentIcon();
	genNotesAttachmentIcon.changeIcon(__localModel,DataEntry(this.parentDocument));
	dtlShippings.bcdp.btnEditVisible  = (dtlShippings.dgDtl.rows.children().length()>0)? false:true;
}

private function changeImage():void
{
	if(dtlLine.dgDtl.selectedRow != null)
	{
		image_name = dtlLine.dgDtl.selectedRow["image_thumnail"]
	}
	else
	{
		image_name = null
	}
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	setMissingInfo();
	var returnValue:int = 0;
	
	var tempXml:XMLList  = XMLList(dtlShippings.dgDtl.rows.children().(trans_flag=='A'));
	var dgXml:XML		 = new XML("<" + dtlShippings.rootNode + "/>")
	dgXml.appendChild(tempXml);
	
	
	if(dgXml.children().length()!=1)
	{
		Alert.show("At least one shipping is required.");
		return -1;
	}
	if(isMissingInfoSave)
	{
		isMissingInfoSave = false;
		returnValue =0;
	}
	else
	{
		openMissingInfoScreen();
		return -1;
	}
	cbNewOrder_flag.dataValue = 'N';
	return returnValue;
}
private function setMissingInfo():void
{
	var missing_info:String = '';
	if(isOptionSet()!='')
	{
		missing_info = missing_info.concat("Following Options are not selected ;\n");
		missing_info = missing_info.concat(isOptionSet()+"\n\n");
	}
	taMissingInfo.text  = missing_info;
}

private function isOptionSet():String
{
	var returnStr:String = '';
	
	var dgItemXml:XML = dtlLine.dgDtl.rows;
	
	for(var i:int = 0 ; i < dgItemXml.children().length(); i++)
	{
		var option_description:String 	= dgItemXml.children()[i]['option_description'].toString();
		
		if(option_description!='')
		{
			var missing_info:String         = checkMissingOptions(option_description);
			if(missing_info!='')
			{
				returnStr  						= returnStr +"Following Options are Missing in Item Line"+(i+1)+"\n"+missing_info+"\n\n";
			}
		}
		
	}
	
	return returnStr;
	
}
private function checkMissingOptions(options_descriptions:String):String
{
	var returnStr:String = '';
	var params:Array = options_descriptions.split(";");
	
	for (var i:int=0;i<params.length-1;i++)
	{
		var paramElement:String  	= params[i].toString();
		var colonIndex:int			= paramElement.indexOf(":");
		var code:String 			= paramElement.substr(0,colonIndex);
		var code_value:String 		= paramElement.substr(colonIndex+1,paramElement.length);
		
		if(code_value=='')
		{
				returnStr  = returnStr+code+";"
		}
	}
	
	return returnStr;
}

private function openMissingInfoScreen():void
{
	missingInfoWindow 			 = MissingInfolViewer(PopUpManager.createPopUp(this,MissingInfolViewer,true));
	missingInfoWindow.x			 = ((Application.application.width/2)-(missingInfoWindow.width/2));
	missingInfoWindow.y			 = ((Application.application.height/2)-(missingInfoWindow.height/2));
	missingInfoWindow.orderDetail = new XML(<orderDetail>
											<missinginfo>{taMissingInfo.text}</missinginfo>
											<screenview>{screenViewMissingInfo}</screenview>
											<order_type>SAMPLE</order_type>
												<checkboxdata>
												<orderentrycomplete_flag>{cbOrderEnterCompleted.dataValue}</orderentrycomplete_flag>	
												<artworkattached_flag></artworkattached_flag>	
												</checkboxdata>
											</orderDetail>);
	
	missingInfoWindow.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,missingInfoSave);
}
private function missingInfoSave(event:MissingInfoEvent):void
{
	var xmlMissingInfo:XML					= event.xml;
	isMissingInfoSave   					= true;
	cbOrderEnterCompleted.dataValue 		= 	xmlMissingInfo.orderentrycomplete_flag.toString() ;
	//cbArtworkAttched.dataValue				=	xmlMissingInfo.artworkattached_flag.toString();
	preSaveEvent = new PreSaveEvent();
	preSaveEvent.dispatch();
}
private function setOtherDeptEmail():void
{
	tiAccounts.text		= tiCorrespondense.text;
	tiShipping.text		= tiCorrespondense.text;
	tiPurchase.text		= tiCorrespondense.text;
	tiArt_work.text		= tiCorrespondense.text;
}
private function clickFinishOrder():void
{
	preSaveEvent = new PreSaveEvent();
	preSaveEvent.dispatch();
}

private function setNextTabSelected(index:int,focusComponent:UIComponent):void
{
	tnDetail.selectedIndex	= index+1;
	focusComponent.setFocus();
}
private function alertListner(event:CloseEvent):void
{
	if(event.detail == Alert.YES)
	{
		cbOrderEnterCompleted.dataValue = 'Y';
	}
	isOkOrderEntrySSave  = true;
	preSaveEvent = new PreSaveEvent();
	preSaveEvent.dispatch();
}

private function setCustomerContactvalueSave():void
{
	//tiCustomer_conatctsavevalue.dataValue  = dcCustomerContact.dataValue;
}
private function setCustomerContact():void
{
	if(dcCustomer_id.dataValue != '' && dcCustomer_id.dataValue != null)
	{
		Application.application.enabled = false;
		CursorManager.setBusyCursor();
		
		var callbacks:IResponder = new mx.rpc.Responder(setCustomerContactDetailHandler, null);
		customer_contact		 =	new GetInformationEvent('fetch_customer_contact', callbacks, dcCustomer_id.dataValue);
		customer_contact.dispatch(); 
	}
}
private function setCustomerContactDetailHandler(resultXml:XML):void
{
	//dcCustomerContact.dataProvider	= resultXml.children();
	if(isCustomerChnage==true)
	{
		//setDefaultContact(dcCustomerContact);
	}
	Application.application.enabled = true;
	CursorManager.removeBusyCursor();
}
public  function setDefaultContact(cb:GenDynamicComboBox):void
{
	var index:int  = -1;
	for(var i:int =0; i<XMLList(cb.dataProvider).length();i++)
	{
		var contact:String		= XMLList(cb.dataProvider)[i].contact_name.toString();
		var defaultValue:String = XMLList(cb.dataProvider)[i].default_contact_flag.toString();
		if(defaultValue.toUpperCase()=='Y')
		{
			index = i;
			break;
		}
	}
	if(index>=0)
	{
		cb.dataValue	 						= contact;
	}
	isCustomerChnage  = false;
	
} 

private function getContactDetails():void
{
	if(dcCustomer_Contact_id.text != "" && dcCustomer_Contact_id.text != null && dcCustomer_id.text != "" && dcCustomer_id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(contactDetailsHandler, null);
		
		getInformationEvent			=	new GetInformationEvent('fetch_customer_contact_detail', callbacks,dcCustomer_id.dataValue, dcCustomer_Contact_id.dataValue);
		getInformationEvent.dispatch();
	}
	else
	{
		//Alert.show("Please Select Customer and Contact");
	}
}
private function contactDetailsHandler(resultXml:XML):void
{
	if(resultXml.children().length()>0 && resultXml.children()[0].child('business_phone').toString()!='')
	{
		tiCustomer_phone.dataValue			= resultXml.children()[0].child('business_phone').toString();
	}
	else
	{
		tiCustomer_phone.dataValue			= customer_phone;
	}
}

private function openCustomerScreen():void
{
	var commonMooduleFunctions:CommonMooduleFunctions	= new CommonMooduleFunctions();
	commonMooduleFunctions.drilldownToCustomerScreen(dcCustomer_id);
}
private function openCustomerContact():void
{
	var commonMooduleFunctions:CommonMooduleFunctions	= new CommonMooduleFunctions();
	commonMooduleFunctions.drilldownToCustomerContact(dcCustomer_Contact_id,dcCustomer_id);
}
private function openPaymentGatway():void
{
	var commonMooduleFunctions:CommonMooduleFunctions	= new CommonMooduleFunctions();
	commonMooduleFunctions.openPaymentGatwayPage();
}
private function openOrderTracker():void
{
	var commonMooduleFunctions:CommonMooduleFunctions	= new CommonMooduleFunctions();
	commonMooduleFunctions.orderTrackerPopUp();
}


private function discount_perChange():void
{
	var _gross_amt:Number = Number(tiItem_amt.text);
	if (_gross_amt >= 0)
	{
		var _dis_per:Number = parseFloat(tiDiscount_per.text);
		var _dis_amt:Number;
		
		if (_dis_per == 0 || String(_dis_per) == 'NaN' || String(_dis_per) == '')
		{
			_dis_amt = 0;
			tiDiscount_per.text = numericFormatterThreePrecesion.format(String(0.00));
		}
		else
		{
			_dis_amt = Number(numericFormatter.format(_gross_amt * _dis_per / 100));
		} 
		tiDiscount_amt.text = numericFormatter.format(String(_dis_amt));
		tiDiscount_per.text = numericFormatterThreePrecesion.format(tiDiscount_per.text);				
		setNetAmount(); 
	}
}
private function discount_amtChange():void
{
	var _gross_amt:Number = Number(tiItem_amt.text);
	if (_gross_amt >= 0)
	{
		var _dis_amt:Number = parseFloat(tiDiscount_amt.text);
		if (_dis_amt == 0 || String(_dis_amt) == 'NaN')
		{
			tiDiscount_per.text = String(0.00);
		}
		else
		{
			tiDiscount_per.text = numericFormatterThreePrecesion.format(String(Number(_dis_amt / _gross_amt * 100)));
		} 
		tiDiscount_amt.text	 = numericFormatter.format(tiDiscount_amt.text);
		setNetAmount(); 
	}
}
private function tax_perChange():void
{
	//numericFormatter.precision = 4;
	//var _gross_amt:Number 	= Number(tiTaxable_amt.text);
	var _gross_amt:Number 	= Number(tiItem_amt.text);
	if (_gross_amt >= 0)
	{
		var _tax_per:Number = parseFloat(tiTax_per.text);
		var _tax_amt:Number;
		if (_tax_per == 0 || String(_tax_per) == 'NaN' || String(_tax_per) == '')
		{
			_tax_amt = 0;
			tiTax_per.text = numericFormatterFourPrecesion.format(String(0));
		}
		else
		{
			_tax_amt = Number(numericFormatterFourPrecesion.format(_gross_amt *_tax_per / 100));
		} 
		tiTax_amt.text = numericFormatterFourPrecesion.format(String(_tax_amt));
		//numericFormatter.precision = 3;
		tiTax_per.text = numericFormatterThreePrecesion.format(tiTax_per.text);
		setNetAmount(); 
		
	}
}

private function tax_amtChange():void
{
	var _tax_amt:Number 	= parseFloat(tiTax_amt.text);
	//var _gross_amt:Number 	= Number(tiTaxable_amt.text);
	var _gross_amt:Number 	= Number(tiItem_amt.text);
	if (_tax_amt == 0 || String(_tax_amt) == 'NaN')
	{
		tiTax_per.text = String(0.000);
	}
	else
	{
		tiTax_per.text = numericFormatterThreePrecesion.format(String(Number(_tax_amt / _gross_amt * 100)));
	}
	//numericFormatter.precision = 4;
	tiTax_amt.text = numericFormatterFourPrecesion.format(tiTax_amt.text);
	//numericFormatter.precision = 2;
	setNetAmount(); 
}

private function ship_amtChange():void
{
	var dgXml:XMLList  = dtlShippings.dgDtl.rows.(trans_flag='A');
	
	var total_ship_amt:Number = 0.00;
	
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		var temp:Number	= Number(numericFormatter.format(dgXml.children()[i]['ship_amt'].toString()));
		total_ship_amt = total_ship_amt + temp;
	}
	tiShipAmount.dataValue	= total_ship_amt.toString();
	setNetAmount(); 
	
	
	//
	dtlShippings.bcdp.btnEditVisible  = (dtlShippings.dgDtl.rows.children().length()>0)? false:true;
}
private function reSetShippingObject():void
{
	__localModel.shippingObject.ship_method_code =	'';
	__localModel.shippingObject.shipping_code    =  '';
	__localModel.shippingObject.ship_method		 =  '';
	
	__localModel.shippingObject.ship_state		 =  '';
	__localModel.shippingObject.ship_zip		 =  '';
	__localModel.shippingObject.ship_country	 =  '';
	
}
private function setShippingObject():void
{
	__localModel.shippingObject.ship_method_code =	GenDataGrid(dtlShippings.dgDtl).rows.children()[0]['ship_method_code'].toString()
	__localModel.shippingObject.shipping_code    =  GenDataGrid(dtlShippings.dgDtl).rows.children()[0]['shipping_code'].toString()
	__localModel.shippingObject.ship_method		 =  GenDataGrid(dtlShippings.dgDtl).rows.children()[0]['ship_method'].toString()
	
	__localModel.shippingObject.ship_state		 =  GenDataGrid(dtlShippings.dgDtl).rows.children()[0]['ship_state'].toString()
	__localModel.shippingObject.ship_zip		 =  GenDataGrid(dtlShippings.dgDtl).rows.children()[0]['ship_zip'].toString()
	__localModel.shippingObject.ship_country	 =  GenDataGrid(dtlShippings.dgDtl).rows.children()[0]['ship_country'].toString()
		
}

private function other_amtChange():void
{
	var _gross_amt:Number 	= Number(tiItem_amt.text);
	if (_gross_amt >= 0)
	{
		var _other_amt:Number 	= parseFloat(tiOther_amt.text);
		if (String(_other_amt) == 'NaN' || String(_other_amt) == '') 
		{
			tiOther_amt.text = numericFormatter.format(String(0.00));
		}
		tiOther_amt.text = numericFormatter.format(tiOther_amt.text);
		setNetAmount(); 
	}
}
private function setNetAmount():void
{
	var _gross_amt:Number 	= Number(tiItem_amt.text);
	
	if (_gross_amt >= 0)
	{
		var _dis_amt:Number  = Number(numericFormatter.format(tiDiscount_amt.text));
		var _ship_amt:Number = Number(numericFormatter.format(tiShipAmount.text));
		//var _ins_amt:Number  = Number(numericFormatter.format(tiInsurance_amt.text));
		var _sal_tax:Number  = Number(numericFormatter.format(tiTax_amt.text));
		var _other_amt:Number = parseFloat(numericFormatter.format(tiOther_amt.text));
		
		if (String(_other_amt) == 'NaN' || String(_other_amt) == '') 
		{
			tiOther_amt.text = String(0.00);
		} 
		/*tiNet_amt.text = numericFormatter.format(String(_gross_amt + _ship_amt - _dis_amt + _ins_amt + _sal_tax + _other_amt)); */
		tiNetAmount.text = numericFormatter.format(String(_gross_amt + _ship_amt - _dis_amt  + _sal_tax + _other_amt));
	} 
	
}
private function setItemAmount(event:DetailEvent):void
{
	// for line amount
	var dgSetupXml:XMLList  = dtlLine.dgDtl.rows.(trans_flag='A');
	var total_line_amt:Number = 0.00;
	for(var i:int = 0 ; i < dgSetupXml.children().length(); i++)
	{
		var temp:Number	= Number(dgSetupXml.children()[i]['item_amt'].toString());
		total_line_amt 	= total_line_amt + temp;
	}
	
	var total_amount:Number  = total_line_amt;
	
	tiItem_amt.dataValue     = numericFormatter.format(total_amount);
	
	
	discount_perChange();
	tax_perChange();
	
	
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
private function setExteRefDate():void
{
	__localModel.ext_ref_date   = dfCustomer_po_date.dataValue;
}
private function rushTypeChnagehandler():void
{
	if(dcCustomer_id.dataValue!='')
	{
		//removeDefaultRushSetupItemFromSetupGrid();
		
		if(cbRushType.dataValue !='')
		{
			//addDefaultRushChargeToSetupGrid();
			cbRushOrder.dataValue	= 'Y';
		}
		else
		{
			cbRushOrder.dataValue	= 'N';
		}
	}
	else
	{
		cbRushType.dataValue =''
		Alert.show("Please Select Customer");
	}
	
}
private function setBillingAddressIntoShipping():void
{
	__localModel.billing_address.bill_name	= tiName.dataValue;
	__localModel.billing_address.address1 	= tiBill_address1.dataValue;
	__localModel.billing_address.address2	= tiBill_address2.dataValue;
	__localModel.billing_address.city		= tiBill_city.dataValue;
	__localModel.billing_address.state		= tiBill_state.dataValue;
	__localModel.billing_address.zip		= tiBill_zip.dataValue;
	__localModel.billing_address.country	= tiBill_country.dataValue;
	__localModel.billing_address.phone1		= tiBill_phone1.dataValue;
	__localModel.billing_address.phone2		= tiBill_phone1.dataValue;
	__localModel.billing_address.fax		= tiBill_fax1.dataValue;
	
}
private function sendEstimateToCustomer():void
{
	new CommonLinksServices().sendQuotationToCustomer();
}
private function previewEstimate():void
{
	new PrintPreview().printPreview();
}

private function resetShippingComponents():void
{
	var gridXml:XML = dtlLine.dgDtl.rows;
	
	for(var i:int = 0; i < dtlLine.dgDtl.rows.children().length();i++)
	{
		gridXml.children()[i]['column1_shipping_flag'] = 'N'
		gridXml.children()[i]['column1_ship_amt'] = '0.00'
			
		gridXml.children()[i]['column2_shipping_flag'] = 'N'
		gridXml.children()[i]['column2_ship_amt'] = '0.00'
		
		gridXml.children()[i]['column3_shipping_flag'] = 'N'
		gridXml.children()[i]['column3_ship_amt'] = '0.00'
		
		gridXml.children()[i]['column4_shipping_flag'] = 'N'
		gridXml.children()[i]['column4_ship_amt'] = '0.00'
			
		gridXml.children()[i]['column5_shipping_flag'] = 'N'
		gridXml.children()[i]['column5_ship_amt'] = '0.00'
			
		gridXml.children()[i]['column6_shipping_flag'] = 'N'
		gridXml.children()[i]['column6_ship_amt'] = '0.00'
			
		gridXml.children()[i]['column7_shipping_flag'] = 'N'
		gridXml.children()[i]['column7_ship_amt'] = '0.00'
			
		gridXml.children()[i]['column8_shipping_flag'] = 'N'
		gridXml.children()[i]['column8_ship_amt'] = '0.00'
			
		gridXml.children()[i]['column9_shipping_flag'] = 'N'
		gridXml.children()[i]['column9_ship_amt'] = '0.00'
			
		gridXml.children()[i]['column10_shipping_flag'] = 'N'
		gridXml.children()[i]['column10_ship_amt'] = '0.00'
			
		
		gridXml.children()[i]['column11_shipping_flag'] = 'N'
		gridXml.children()[i]['column11_ship_amt'] = '0.00'
		
		gridXml.children()[i]['column12_shipping_flag'] = 'N'
		gridXml.children()[i]['column12_ship_amt'] = '0.00'
		
		gridXml.children()[i]['column13_shipping_flag'] = 'N'
		gridXml.children()[i]['column13_ship_amt'] = '0.00'
		
		gridXml.children()[i]['column14_shipping_flag'] = 'N'
		gridXml.children()[i]['column14_ship_amt'] = '0.00'
		
		gridXml.children()[i]['column15_shipping_flag'] = 'N'
		gridXml.children()[i]['column15_ship_amt'] = '0.00'
			
		
		gridXml.children()[i]['net_amt1'] = numericFormatter.format(Number(gridXml.children()[i]['column1_amt'].toString()) +
											Number(gridXml.children()[i]['setup_amt_item_dependable1'].toString()) +
											Number(gridXml.children()[i]['setup_amt1'].toString()) +
											Number(gridXml.children()[i]['accessory_amt1'].toString()) +
											Number(gridXml.children()[i]['column1_ship_amt'].toString())) 
		
		gridXml.children()[i]['net_amt2'] = numericFormatter.format(Number(gridXml.children()[i]['column2_amt'].toString()) +
											Number(gridXml.children()[i]['setup_amt_item_dependable2'].toString()) +
											Number(gridXml.children()[i]['setup_amt2'].toString()) +
											Number(gridXml.children()[i]['accessory_amt2'].toString()) +
											Number(gridXml.children()[i]['column2_ship_amt'].toString())) 
			
		gridXml.children()[i]['net_amt3'] = numericFormatter.format(Number(gridXml.children()[i]['column3_amt'].toString()) +
											Number(gridXml.children()[i]['setup_amt_item_dependable3'].toString()) +
											Number(gridXml.children()[i]['setup_amt3'].toString()) +
											Number(gridXml.children()[i]['accessory_amt3'].toString()) +
											Number(gridXml.children()[i]['column3_ship_amt'].toString())) 
			
		gridXml.children()[i]['net_amt4'] = numericFormatter.format(Number(gridXml.children()[i]['column4_amt'].toString()) +
											Number(gridXml.children()[i]['setup_amt_item_dependable4'].toString()) +
											Number(gridXml.children()[i]['setup_amt4'].toString()) +
											Number(gridXml.children()[i]['accessory_amt4'].toString()) +
											Number(gridXml.children()[i]['column4_ship_amt'].toString())) 
			
		gridXml.children()[i]['net_amt5'] = numericFormatter.format(Number(gridXml.children()[i]['column5_amt'].toString()) +
											Number(gridXml.children()[i]['setup_amt_item_dependable5'].toString()) +
											Number(gridXml.children()[i]['setup_amt5'].toString()) +
											Number(gridXml.children()[i]['accessory_amt5'].toString()) +
											Number(gridXml.children()[i]['column5_ship_amt'].toString())) 
			
		gridXml.children()[i]['net_amt6'] = numericFormatter.format(Number(gridXml.children()[i]['column6_amt'].toString()) +
											Number(gridXml.children()[i]['setup_amt_item_dependable6'].toString()) +
											Number(gridXml.children()[i]['setup_amt6'].toString()) +
											Number(gridXml.children()[i]['accessory_amt6'].toString()) +
											Number(gridXml.children()[i]['column6_ship_amt'].toString())) 
			
		gridXml.children()[i]['net_amt7'] = numericFormatter.format(Number(gridXml.children()[i]['column7_amt'].toString()) +
											Number(gridXml.children()[i]['setup_amt_item_dependable7'].toString()) +
											Number(gridXml.children()[i]['setup_amt7'].toString()) +
											Number(gridXml.children()[i]['accessory_amt7'].toString()) +
											Number(gridXml.children()[i]['column7_ship_amt'].toString())) 
			
		gridXml.children()[i]['net_amt8'] = numericFormatter.format(Number(gridXml.children()[i]['column8_amt'].toString()) +
											Number(gridXml.children()[i]['setup_amt_item_dependable8'].toString()) +
											Number(gridXml.children()[i]['setup_amt8'].toString()) +
											Number(gridXml.children()[i]['accessory_amt8'].toString()) +
											Number(gridXml.children()[i]['column8_ship_amt'].toString())) 
			
		gridXml.children()[i]['net_amt9'] = numericFormatter.format(Number(gridXml.children()[i]['column9_amt'].toString()) +
											Number(gridXml.children()[i]['setup_amt_item_dependable9'].toString()) +
											Number(gridXml.children()[i]['setup_amt9'].toString()) +
											Number(gridXml.children()[i]['accessory_amt9'].toString()) +
											Number(gridXml.children()[i]['column9_ship_amt'].toString())) 
			
		gridXml.children()[i]['net_amt10'] = numericFormatter.format(Number(gridXml.children()[i]['column10_amt'].toString()) +
											Number(gridXml.children()[i]['setup_amt_item_dependable10'].toString()) +
											Number(gridXml.children()[i]['setup_amt10'].toString()) +
											Number(gridXml.children()[i]['accessory_amt10'].toString()) +
											Number(gridXml.children()[i]['column10_ship_amt'].toString())) 
		
		gridXml.children()[i]['net_amt11'] = numericFormatter.format(Number(gridXml.children()[i]['column11_amt'].toString()) +
											Number(gridXml.children()[i]['setup_amt_item_dependable11'].toString()) +
											Number(gridXml.children()[i]['setup_amt11'].toString()) +
											Number(gridXml.children()[i]['accessory_amt11'].toString()) +
											Number(gridXml.children()[i]['column11_ship_amt'].toString())) 
		
		gridXml.children()[i]['net_amt12'] = numericFormatter.format(Number(gridXml.children()[i]['column12_amt'].toString()) +
											Number(gridXml.children()[i]['setup_amt_item_dependable12'].toString()) +
											Number(gridXml.children()[i]['setup_amt12'].toString()) +
											Number(gridXml.children()[i]['accessory_amt12'].toString()) +
											Number(gridXml.children()[i]['column12_ship_amt'].toString())) 
		
		gridXml.children()[i]['net_amt13'] = numericFormatter.format(Number(gridXml.children()[i]['column13_amt'].toString()) +
											Number(gridXml.children()[i]['setup_amt_item_dependable13'].toString()) +
											Number(gridXml.children()[i]['setup_amt13'].toString()) +
											Number(gridXml.children()[i]['accessory_amt13'].toString()) +
											Number(gridXml.children()[i]['column13_ship_amt'].toString())) 
		
		gridXml.children()[i]['net_amt14'] = numericFormatter.format(Number(gridXml.children()[i]['column14_amt'].toString()) +
											Number(gridXml.children()[i]['setup_amt_item_dependable14'].toString()) +
											Number(gridXml.children()[i]['setup_amt14'].toString()) +
											Number(gridXml.children()[i]['accessory_amt14'].toString()) +
											Number(gridXml.children()[i]['column14_ship_amt'].toString())) 
		
		gridXml.children()[i]['net_amt15'] = numericFormatter.format(Number(gridXml.children()[i]['column15_amt'].toString()) +
											Number(gridXml.children()[i]['setup_amt_item_dependable15'].toString()) +
											Number(gridXml.children()[i]['setup_amt15'].toString()) +
											Number(gridXml.children()[i]['accessory_amt15'].toString()) +
											Number(gridXml.children()[i]['column15_ship_amt'].toString()))	
		
		
	}
}

private function setActivityDateLavelFunction():void
{
	while(true)
	{
		if(dgActivityLines.columns.length>0)
		{
			DataGridColumn(dgActivityLines.columns[0]).labelFunction = dateFunc;
			break;
		}
	}
	
}

private function isShippingAddButtonEnable():Boolean
{
	var tempXml:XML  = dtlShippings.dgDtl.rows.copy()
	if(tempXml.children().length()>0)
	{
		return false;
	}
	else
	{
		return true;
	}
}