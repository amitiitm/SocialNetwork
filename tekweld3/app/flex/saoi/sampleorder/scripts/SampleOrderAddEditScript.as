import business.events.GetInformationEvent;
import business.events.GetRecordEvent;
import business.events.PreSaveEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.components.DataEntry;
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
import saoi.muduleclasses.OptionsSetupChargeCalculation;
import saoi.muduleclasses.UpdateEstimateShipAndInhandDateFunctions;
import saoi.muduleclasses.event.MissingInfoEvent;
import saoi.sampleorder.SampleOrderModelLocator;

private var preSaveEvent:PreSaveEvent;
private var getInformationEvent:GetInformationEvent;
private var getInformationShippingEvent:GetInformationEvent;
private var item_detail:GetInformationEvent;
private var shipping_detail:GetInformationEvent;
[Bindable]
private var __localModel:SampleOrderModelLocator = (SampleOrderModelLocator)(GenModelLocator.getInstance().activeModelLocator);
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
private var commonMooduleFunctions:CommonMooduleFunctions 				=   new CommonMooduleFunctions();
private var commonLinksServices:CommonLinksServices						=   new CommonLinksServices();
private var optionsSetupChargeCalculation:OptionsSetupChargeCalculation	= 	new OptionsSetupChargeCalculation();
private var sourceScreen:String= '';	

private function setAccountNo():void
{
	if(dcShipping_code.labelValue == 'THIRDPARTY')
	{
		tiAccountNo.enabled = true;
	}
	else
	{
		tiAccountNo.dataValue = '';
		tiAccountNo.enabled = false;
	}
	setShippingMethods();
}
private function setShippingMethods():void
{
	if(dcShipping_code.text != '' && dcShipping_code.text	!= null)
	{
		shippingMethidsValue	= dcShippingMethods.dataValue;
		var callbacks:IResponder = new mx.rpc.Responder(getShippingDetailHandler, null);
		shipping_detail	=	new GetInformationEvent('fetch_shipvia_methods', callbacks, dcShipping_code.dataValue);
		shipping_detail.dispatch(); 
	}
}
private function getShippingDetailHandler(resultXml:XML):void
{
	dcShippingMethods.dataProvider	= resultXml.children();
	dcShippingMethods.dataValue		= shippingMethidsValue;
}
private function setShippingMethodToolTip():void
{
	if(dcShipping_code.text != '' && dcShipping_code.text != null)
	{
		dcShippingMethods.toolTip	= dcShippingMethods.selectedItem.ship_method_description.toString();
	}
}

							
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
	//dtlShippingsHeader.dgDtl.doubleClickEnabled	= false;
	//getAccountPeriod();

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
		resetShipping();
		resetBilling();
		resetEmail();
		resetStatus();
		
		
		
	}
	isCustomerChnage=true;
	__localModel.customer_id				= dcCustomer_id.dataValue;
	__localModel.customer_code				= dcCustomer_id.labelValue;
	//vbMain.removeAllChildren();
	dcCustomer_Contact_id.filterKeyValue  	= dcCustomer_id.dataValue;
	dcPaymentProfle_code.filterKeyValue     = dcCustomer_id.dataValue;
}
private function resetStatus():void
{
	tiAccount_status.dataValue 				= 	tiAccount_status.defaultValue;
	tiAccount_reason.dataValue				=   tiAccount_reason.defaultValue;
	tiInventory_status.dataValue			=   tiInventory_status.defaultValue;
	tiAcknowledgmentStatus.dataValue		=   tiAcknowledgmentStatus.defaultValue;
	tiShippingStatus.dataValue				=   tiShippingStatus.defaultValue;
	tiCurrent_status.dataValue				=   tiCurrent_status.defaultValue;
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
private function resetShipping():void
{
	dcShipping_code.dataValue 			= 	dcShipping_code.defaultDataValue;
	dcShipping_code.labelValue 			= 	dcShipping_code.defaultLabelValue;
	
	var tempXml:XML			= dtlShippings.dgDtl.rows.copy();
	for(var i:int=0;i<tempXml.children().length();i++)
	{
		dtlShippings.deleteRow(0);
	}
}
private function getCustomerShipping():void
{
		var callbacksShipping:IResponder	=	new mx.rpc.Responder(customerShippingDetailsHandler, null);
		
		getInformationShippingEvent			=	new GetInformationEvent('customer_specific_shippings', callbacksShipping, dcCustomer_id.dataValue);
		getInformationShippingEvent.dispatch();  
}

private function customerDetailsHandler(resultXml:XML):void
{
	setValue(resultXml);
	setBillingAddress(resultXml);
}
private function customerShippingDetailsHandler(resultXml:XML):void
{
	__localModel.customerShipping = resultXml;	
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
	__localModel.default_customer_third_party_account_number = customerXml.children().child('default_customer_third_party_account_number').toString();
	__localModel.default_customer_bill_transportation_to	 = customerXml.children().child('default_customer_bill_transportation_to').toString();
	__localModel.default_customer_shipping_code				 = customerXml.children().child('default_customer_shipping_code').toString();

	//tiCustomer_conatctsavevalue.dataValue	= customerXml.children().child('contact1').toString();
	//dcCustomerContact.dataValue				= customerXml.children().child('contact1').toString();
	tiCustomer_phone.dataValue			= customerXml.children().child('phone1').toString();
	customer_phone						= customerXml.children().child('phone1').toString();
	dcShipping_code.dataValue 			= 	customerXml.children().child('shipping_code').toString();
	dcShipping_code.labelValue 			= 	customerXml.children().child('shipping_code').toString();
	
	setShippingMethods();                    // data in shipping methods on customer ship via set by default 
	
	dcTerm_code.dataValue 				= 	customerXml.children().child('term_code').toString();
	dcTerm_code.labelValue 				= 	customerXml.children().child('term_code').toString();
	
	tiAccounts.dataValue 				= 	customerXml.children().child('account_dept_email').toString();
	tiShipping.dataValue 				= 	customerXml.children().child('shipping_dept_email').toString();
	tiPurchase.dataValue				=	 customerXml.children().child('purchase_dept_email').toString();
	tiCorrespondense.dataValue			=	 customerXml.children().child('corr_dept_email').toString();
	tiArt_work.dataValue				=	 customerXml.children().child('artwork_dept_email').toString();
	__localModel.artwork_dept_email		= 	 customerXml.children().child('artwork_dept_email').toString();
	//cbPPRequired_flag.dataValue			= 	customerXml.children().child('paper_proof_flag').toString();
	//tiAccount_status.dataValue			= 	customerXml.children().child('class_name').toString();
	
	dcSales_person_code.dataValue			= customerXml.children().child('salesperson_code').toString();
	dcSales_person_code.labelValue			= customerXml.children().child('salesperson_code').toString();
	dcExternalSales_person_code.dataValue	= customerXml.children().child('externalsalesperson_code').toString();
	dcExternalSales_person_code.labelValue	= customerXml.children().child('externalsalesperson_code').toString();
	
	if(customerXml.children().child('business_phone').toString()!='')
	{
		tiCustomer_phone.dataValue			= customerXml.children().child('business_phone').toString();
	}

}
private function setScreenView():void
{
	//sourceScreen = data.row[0].toString();
	if(sourceScreen.toUpperCase()=='PICKORDER' || sourceScreen.toUpperCase()=='ASSIGNEDORDER')
	{
		cbOrderEnterCompleted.visible			= true;
		cbOrderEnterCompleted.includeInLayout 	= true;
		//cbArtworkAttched.visible				= false;
		//cbArtworkAttched.includeInLayout		= false;
		cbCustPoAttached.visible				= false;
		cbCustPoAttached.includeInLayout        = false;
		cbQualityCheckCompleted.visible			= false;
		cbQualityCheckCompleted.includeInLayout	= false;
		//cbArtworkFinished.visible				= false;
		//cbArtworkFinished.includeInLayout		= false;
		cbReassignedToOrderEntry.visible		= false;
		hbAssignUser.visible					= false;
		__localModel.artwork_view				= false;
		screenViewMissingInfo               	= 'ASSIGNEDORDER';
	}
	else if (sourceScreen.toUpperCase()=='QCORDER')
	{
		cbReassignedToOrderEntry.visible		= true;
		cbReassignedToOrderEntry.includeInLayout= true;
		//hbAssignUser.visible					= true;
		cbQualityCheckCompleted.visible			= true;
		cbQualityCheckCompleted.includeInLayout = true;
		//cbArtworkAttched.visible				= false;
		//cbArtworkAttched.includeInLayout		= false;
		cbCustPoAttached.visible				= false;
		cbCustPoAttached.includeInLayout        = false;
		cbOrderEnterCompleted.visible			= false;
		cbOrderEnterCompleted.includeInLayout 	= false;
		//cbArtworkFinished.visible				= false;
		//cbArtworkFinished.includeInLayout		= false;
		__localModel.artwork_view				= false;
		tnDetail.selectedChild  				= vbStatus;
		screenViewMissingInfo              		= 'QCORDER';	
	}
	else
	{
		cbOrderEnterCompleted.visible			= false;
		cbOrderEnterCompleted.includeInLayout 	= false;
		//cbArtworkAttched.visible				= false;
		//cbArtworkAttched.includeInLayout		= false;
		cbCustPoAttached.visible				= false;
		cbCustPoAttached.includeInLayout        = false;
		cbQualityCheckCompleted.visible			= false;
		cbQualityCheckCompleted.includeInLayout	= false;
		//cbArtworkFinished.visible				= false;
		//cbArtworkFinished.includeInLayout		= false;
		cbReassignedToOrderEntry.visible		= false;
		hbAssignUser.visible					= false;
		screenViewMissingInfo					= '';
	}
	//__genModel.objectFromDrilldown 				= new XML(<rows></rows>);
}
//--------------------------------------------------------------------------------
override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	
	var recordXml:XML		= event.recordXml;
	dcCustomer_id.enabled	=	false;
	/*if(recordXml.sales_order.payment_authorize_flag.toString()=='Y')
	{
		vbAthorizeInfoTemp.enabled			= false;
		setMissingInfo();
	}
	else
	{
		vbAthorizeInfoTemp.enabled			= true;
		setMissingInfo();
	}*/
	var data:XML 							=  __genModel.objectFromDrilldown.copy();
	if(data.children().length()>0)
	{
		sourceScreen 						= data.row[0].toString();
		__genModel.objectFromDrilldown 		= new XML(<rows></rows>);
	}
	setScreenView();
	customer_phone							= recordXml.sales_order.cust_phone.toString();
	__localModel.artwork_dept_email		    = recordXml.sales_order.artwork_dept_email.toString();
	dcCustomer_Contact_id.filterKeyValue  	= dcCustomer_id.dataValue;
	dcPaymentProfle_code.filterKeyValue		= dcCustomer_id.dataValue;
	__localModel.order_type					= cbOrder_type.dataValue;
	__localModel.trans_date 				= dfTrans_date.text
	__localModel.trans_no  					= 	tiTrans_no.text;
	__localModel.ext_ref_no					=	tiCustomer_po_id.text;
	__localModel.customer_id				= dcCustomer_id.dataValue;
	__localModel.customer_code				= dcCustomer_id.labelValue;
	__localModel.default_customer_third_party_account_number = recordXml.children()[0].default_customer_third_party_account_number.toString();
	__localModel.default_customer_bill_transportation_to	 = recordXml.children()[0].default_customer_bill_transportation_to.toString();
	__localModel.default_customer_shipping_code				 = recordXml.children()[0].default_customer_shipping_code.toString();

	
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
	if((recordXml.sales_order.qc_off_flag.toString()=='Y' &&  recordXml.sales_order.orderqcstatus_flag.toString()=='N') || (recordXml.sales_order.qc_off_flag.toString()=='N' &&  recordXml.sales_order.orderqcstatus_flag.toString()=='Y') )
	{
		lbtnResendAck.visible			= true;
	}
	else
	{
		lbtnResendAck.visible			= false;
	}
	
	var genNotesAttachmentIcon:GenNotesAttachmentIcon  = new GenNotesAttachmentIcon();
	genNotesAttachmentIcon.changeIcon(__localModel,DataEntry(this.parentDocument));
	
	if(cbNext_Day_Flag.dataValue.toUpperCase() 		== 'N')
		__localModel.next_day_flag	= false;
	else if(cbNext_Day_Flag.dataValue.toUpperCase()	== 'Y')
		__localModel.next_day_flag	= true;
	
	__localModel.ext_ref_date   		= dfCustomer_po_date.dataValue;
	
	dcPaymentProfle_code.dataValue 	= paymentProfileCode;
	dcPaymentProfle_code.labelValue = paymentProfileCardNumber;
	
	changePaperProofFlag();
	setBillingAddressIntoShipping();
	setReAssignFlagVisiblity(recordXml.copy());
	setVisiblityOfAthorizeButton(recordXml.copy());
	setShippingBalanceQty();
	setParamforEstimate();
	__localModel.isShipInfoBaseChange	= false;
	commonMooduleFunctions.orderQueriesRemoveAddButton(cbOrderEnterCompleted.dataValue,dtlQueries);
	dtlShippings.bcdp.btnEditVisible  = (dtlShippings.dgDtl.rows.children().length()>0)? false:true;
}
private function setshippingMethodsvalue(value:String):void
{
	dcShippingMethods.dataValue	= value;
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	paymentProfileCode  			      = '';
	paymentProfileCardNumber			  = '';
	__localModel.default_customer_third_party_account_number = '';
	__localModel.default_customer_bill_transportation_to	 = '';
	__localModel.default_customer_shipping_code				 = '';
	__localModel.order_type				    = cbOrder_type.dataValue;
	getAccountPeriod();
	dcCustomer_id.enabled				=	true;
	lbtnResendAck.visible				= false;
	//vbAthorizeInfoTemp.enabled			= true;
	__localModel.trans_date 			= dfTrans_date.text
	__localModel.trans_no				= tiTrans_no.text;
	__localModel.ext_ref_no				= tiCustomer_po_id.text;
	__localModel.customer_id			= dcCustomer_id.dataValue;
	__localModel.customer_code			= dcCustomer_id.labelValue;
	customer_phone						= '';
	changeImage()
	changeNextDayFlag();
	changePaperProofFlag();
	__localModel.ext_ref_date   		= dfCustomer_po_date.dataValue;
	setBillingAddressIntoShipping();
	
	var genNotesAttachmentIcon:GenNotesAttachmentIcon  = new GenNotesAttachmentIcon();
	genNotesAttachmentIcon.changeIcon(__localModel,DataEntry(this.parentDocument));
	
	setReAssignFlagVisiblity(<rows><row></row></rows>);
	setVisiblityOfAthorizeButton(<rows><row></row></rows>);
	setShippingBalanceQty();
	setParamforEstimate();
	__localModel.isShipInfoBaseChange	= false;
	commonMooduleFunctions.orderQueriesRemoveAddButton(cbOrderEnterCompleted.dataValue,dtlQueries);
	dtlShippings.bcdp.btnEditVisible  = (dtlShippings.dgDtl.rows.children().length()>0)? false:true;
	sourceScreen		= '';
	setScreenView();
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
private function isCustomerPOAttach():Boolean
{
	var dgXml:XMLList  = dtlArtwork.dgDtl.rows.(trans_flag='A');
	var returnValue:Boolean = false;
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		var artwotkVersion:String  = dgXml.children()[i]['artwork_version'].toString();
		if(artwotkVersion.toUpperCase().search('CUSTOMER PO')>=0)
		{
			returnValue = true;
			break;
		}
	}
	return returnValue;
}
private function isArtworkVersionUnique():Boolean
{
	var dgXml:XMLList  = dtlArtwork.dgDtl.rows.(trans_flag='A');
	var returnValue:Boolean = true;
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		var currentVersion:String  	= dgXml.children()[i]['artwork_version'].toString();
		for(var j:int = i+1 ; j < dgXml.children().length(); j++)
		{
			var artwotkVersion:String  	= dgXml.children()[j]['artwork_version'].toString();
			if(currentVersion.toUpperCase()	==	artwotkVersion.toUpperCase())
			{
				returnValue = false;
				selectUniqueArtworkVersionIndex = i;
				break;
			}
			
		}
	}
	return returnValue;
}
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	setMissingInfo();
	var returnValue:int = 0;
	if(isShippingQtyExceedLimit())
	{
		Alert.show("Total shipping qty is greater than total item qty ");
		tnDetail.selectedIndex	= 0;
		return  -1;
	}
	if(!isCustomerPOAttach())
	{
		Alert.show("Customer PO is required. Please attach customer's PO with the order.");
		return -1;
	}
	var tempXml:XML	= XML(dtlArtwork.dgDtl.rows.(trans_flag=='A')).copy();
	if((tempXml.children().length()!=1))
	{
		Alert.show("artwork can't be other than customer po");
		return -1;
	}
	var shipXml:XML	= XML(dtlShippings.dgDtl.rows.(trans_flag=='A')).copy();
	if(shipXml.children().length()>1)
	{
		Alert.show("Shipping can not be more than one.");
		return -1;
	}
	if(!isArtworkVersionUnique())
	{
		Alert.show("Artwork/PO Type Should Not Repeat");
		tnDetail.selectedIndex	= 6;
		dtlArtwork.dgDtl.selectedIndex  = selectUniqueArtworkVersionIndex;
		return -1;
	}
	if(cbReassignedToOrderEntry.dataValue=='Y' && dcAssignUser.dataValue=='')
	{
		Alert.show("Select user to reassign.");
		return -1;
	}
	if(__localModel.isShipInfoBaseChange)
	{
		Alert.show("Please recalculate estimate shipping date.");
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
	if(cbQualityCheckCompleted.dataValue=='Y' && (!isAllQueryAnswered()) )
	{
		Alert.show("Answer all queries before saving.");
		cbQualityCheckCompleted.dataValue   = 'N';
		isMissingInfoSave   		     	= false;
		return -1;
	}
	if(cbOrderEnterCompleted.dataValue=='Y' && (!isAllQueryAnswered()) )
	{
		Alert.show("Answer all queries before saving.");
		cbOrderEnterCompleted.dataValue  = 'N';
		isMissingInfoSave   		     = false;
		return -1;
	}
	setAccountingStatus();
	setShippingStatus();
	setPaperProofStatus();
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
	if(isShippingSet()!='')
	{
		missing_info = missing_info.concat( isShippingSet()+ "\n\n");
	}
	if(!isPaymentInfoSet())
	{
		missing_info = missing_info.concat("Payment Info Missing ;\n\n");
	}
	/*if(!isLogoSet())
	{
		missing_info = missing_info.concat("Logo Missing ;\n\n");
	}*/
	taMissingInfo.text  = missing_info;
}
private function isLogoSet():Boolean
{
	var returnStr:Boolean = false;
	if(tiLogoField.dataValue=='')
	{
		returnStr  = false;
	}
	else
	{
		returnStr  = true;
	}
	return returnStr;
}
private function isPaymentInfoSet():Boolean
{
	if(cbPaymentAuthorize_flag.dataValue=='Y')
	{
		return true;
	}
	else
	{
		var returnStr:Boolean = false;
		if(dcTerm_code.dataValue.toUpperCase()=='CC' && dcPaymentProfle_code.dataValue =='' && cbPaymentAuthorize_flag.dataValue=='N'  && Number(tiNetAmount.dataValue)>0)
		{
			returnStr  = false;
		}
		else
		{
			returnStr  = true;
		}
		return returnStr;
	}
	
}

private function isOptionSet():String
{
	var returnStr:String = '';
	
	var dgItemXml:XML = dtlLine.dgDtl.rows;
	
	for(var i:int = 0 ; i < dgItemXml.children().length(); i++)
	{
		var option_description:String 	= dgItemXml.children()[i]['missing_info_description'].toString();
		
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
private function isShippingSet():String
{
	var returnValue:String = '';
	
	var dgItemXml:XML = dtlLine.dgDtl.rows;
	var totalItemQty:Number = 0;
	for(var i:int = 0 ; i < dgItemXml.children().length(); i++)
	{
		totalItemQty = totalItemQty + Number(dgItemXml.children()[i]['item_qty'].toString());
	}
	
	var dgXml:XMLList  = dtlShippings.dgDtl.rows.(trans_flag='A');
	
	var total_qty:Number = 0;
	var remainQty:int	 = totalItemQty;
	
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		total_qty = total_qty + Number(dgXml.children()[i]['ship_qty'].toString());
	}
	
	remainQty   		=  totalItemQty - total_qty;
	
	if(dgXml.children().length()<=0 || remainQty >0 )
	{
		returnValue  = "Shipping info missing for "+remainQty+" Quantity\n\n";
	}
	
	
	//ship date, ship_method, inhand_date logic
	var ship_date_missing:String = '';
	var ship_method_missing:String='';
	var inhand_date_missing:String = '';
	for(var j:int = 0 ; j < dgXml.children().length(); j++)
	{
		if(dgXml.children()[j]['ship_date'].toString()=='' && dgXml.children()[j]['inhand_date'].toString()=='' && dgXml.children()[j]['estimated_ship_date'].toString()=='' && dgXml.children()[j]['estimated_arrival_date'].toString()=='' )
		{
			ship_date_missing 			= ship_date_missing+"Ship Date or Inhand Missing in "+(j+1)+" Line Of Shipping\n";
		}
		if(dgXml.children()[j]['shipping_code'].toString()=='UPS' ||  dgXml.children()[j]['shipping_code'].toString()=='FEDEX')
		{
			if(dgXml.children()[j]['ship_method'].toString()=='')
			{
				ship_method_missing 	  	= ship_method_missing+"Ship Method Missing in "+(j+1)+" Line Of Shipping\n";
			}
		}
		else if(dgXml.children()[j]['shipping_code'].toString()=='THIRDPARTY')
		{
			if(dgXml.children()[j]['shipvia_accountnumber'].toString()=='')
			{
				ship_method_missing 	  	= ship_method_missing+"Account # Missing in "+(j+1)+" Line Of Shipping\n";
			}
		}
		else
		{
			
		}
		/*if(dgXml.children()[j]['inhand_date'].toString()=='')
		{
		inhand_date_missing 	  	= inhand_date_missing+"Inhand Date Missing in "+(j+1)+" Line Of Shipping\n";
		}*/
	}
	
	if(ship_date_missing!='')
	{
		returnValue  = returnValue + ship_date_missing+"\n";
	}
	if(ship_method_missing!='')
	{
		returnValue  = returnValue + ship_method_missing+"\n";
	}
	if(inhand_date_missing!='')
	{
		returnValue  = returnValue + inhand_date_missing+"\n";
	}
	
	
	return returnValue;
	
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
												<custpoattached_flag>{cbCustPoAttached.dataValue}</custpoattached_flag>	
												<orderqcstatus_flag>{cbQualityCheckCompleted.dataValue}</orderqcstatus_flag>	
												
												<customer_checked_flag>{cbCustomerChecked.dataValue}</customer_checked_flag>	
												<contact_checked_flag>{cbContactChecked.dataValue}</contact_checked_flag>	
												<item_checked_flag>{cbItemChecked.dataValue}</item_checked_flag>	
												<quantity_checked_flag>{cbQuantityChecked.dataValue}</quantity_checked_flag>
												<imprint_checked_flag>{cbImprintChecked.dataValue}</imprint_checked_flag>
												<shipping_checked_flag>{cbShippingChecked.dataValue}</shipping_checked_flag>	
												<billing_checked_flag>{cbBillingChecked.dataValue}</billing_checked_flag>	
												<email_checked_flag>{cbEmailChecked.dataValue}</email_checked_flag>	
												<payment_checked_flag>{cbPaymentChecked.dataValue}</payment_checked_flag>
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
	cbCustPoAttached.dataValue				=	xmlMissingInfo.custpoattached_flag.toString();
	
	
	
	cbCustomerChecked.dataValue				=   xmlMissingInfo.customer_checked_flag.toString();
	cbContactChecked.dataValue				=   xmlMissingInfo.contact_checked_flag.toString();
	cbEmailChecked.dataValue				=   xmlMissingInfo.email_checked_flag.toString();
	cbItemChecked.dataValue					=   xmlMissingInfo.item_checked_flag.toString();
	cbQuantityChecked.dataValue				=   xmlMissingInfo.quantity_checked_flag.toString();
	cbImprintChecked.dataValue				=   xmlMissingInfo.imprint_checked_flag.toString();
	cbShippingChecked.dataValue				=   xmlMissingInfo.shipping_checked_flag.toString();
	cbBillingChecked.dataValue				=   xmlMissingInfo.billing_checked_flag.toString();
	cbPaymentChecked.dataValue				=   xmlMissingInfo.payment_checked_flag.toString();
	cbQualityCheckCompleted.dataValue		=	xmlMissingInfo.orderqcstatus_flag.toString();
	
	if(cbQualityCheckCompleted.dataValue=='Y')
	{
		cbReassignedToOrderEntry.dataValue	= 'N';
		dcAssignUser.dataValue				= '';
		dcAssignUser.labelValue				= '';
		tiUser_cd.dataValue					= '';
		hbAssignUser.visible				= false;
	}
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
private function setShippingStatus():void
{
	var dgItemXml:XML = dtlLine.dgDtl.rows;
	var totalItemQty:Number = 0;
	for(var i:int = 0 ; i < dgItemXml.children().length(); i++)
	{
		totalItemQty = totalItemQty + Number(dgItemXml.children()[i]['item_qty'].toString());
	}
	
	var dgXml:XML = dtlShippings.dgDtl.rows;
	var total_qty:Number = 0;
	for(var j:int = 0 ; j < dgXml.children().length(); j++)
	{
		total_qty = total_qty + Number(dgXml.children()[j]['ship_qty'].toString());
	}
	
	if(dgXml.children().length()<=0)
	{
		tiShippingStatus.dataValue = "NEED SHIP INFO";
	}
	else if(totalItemQty != total_qty)
	{
		tiShippingStatus.dataValue = "PARTIAL SHIP INFO RECEIVED";
	}
	else if(totalItemQty == total_qty)
	{
		tiShippingStatus.dataValue	= "SHIP INFO RECEIVED";
	}
}
private function isShippingQtyExceedLimit():Boolean
{
	var return_value:Boolean	= false;
	
	var dgItemXml:XMLList = dtlLine.dgDtl.rows.(trans_flag='A');
	var totalItemQty:Number = 0;
	for(var i:int = 0 ; i < dgItemXml.children().length(); i++)
	{
		totalItemQty = totalItemQty + Number(dgItemXml.children()[i]['item_qty'].toString());
	}
	
	var total_qty:Number = 0;
	var dgXml:XMLList  = dtlShippings.dgDtl.rows.(trans_flag='A');
	for(var j:int = 0 ; j < dgXml.children().length(); j++)
	{
		total_qty = total_qty + Number(dgXml.children()[j]['ship_qty'].toString());
	}
	
	if(totalItemQty<total_qty)
	{
		return_value  = true;
	}
	return return_value;
}
private function setAccountingStatus():void
{
	/*if(tiNameOnCard.dataValue !=''&& tiCardNO.dataValue !=''&& tiCvvNO.dataValue !='' && tiExp_Month.dataValue!=''&& tiExp_Year.dataValue != '' )
	{
	tiAccount_status.dataValue	= "CLEAR";
	}
	else
	{
	tiAccount_status.dataValue	= "PAYMENT HOLD";
	}*/
	if(dcTerm_code.dataValue.toUpperCase()=="CC")
	{
		tiAccount_status.dataValue	= "CREDIT CARD";
	}
	else
	{
		tiAccount_status.dataValue	= "TERMS";
	}
}
private function setPaperProofStatus():void
{
	/*if(cbPPRequired_flag.dataValue =='Y')
	{
		tiPaper_proof_status.dataValue	= "PAPER PROOF REQUIRED";
	}
	else
	{
		tiPaper_proof_status.dataValue	= "NO PROOF REQUIRED";
	}*/
}
private function setReassignFlag(event:GenCheckBoxEvent):void
{
	var source:String  = event.target.id.toString();
	if(source.toUpperCase()	== 'CBREASSIGNEDTOORDERENTRY')
	{
		if(cbReassignedToOrderEntry.dataValue=='Y')
		{
			cbQualityCheckCompleted.dataValue	= 'N';
			dcAssignUser.dataValue				= '';
			hbAssignUser.visible				= true;
		}
		else
		{
			dcAssignUser.dataValue					= '';
			hbAssignUser.visible				= false;
		}
	}
	else if(source.toUpperCase()	== 'CBQUALITYCHECKCOMPLETED')
	{
		if(cbQualityCheckCompleted.dataValue	== 'Y')
		{
			cbReassignedToOrderEntry.dataValue		= 'N';
			dcAssignUser.dataValue					= '';
			hbAssignUser.visible					= false;
		}
		
	}
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
private  function openShippingAddress():void
{
	//dtlShippings.bcdp.dispatchEvent(new ButtonControlDetailEvent('editRowEvent'));
}
private function isItUnique(value:String,column_name:String,table_name:String,customer_id:String):void
{
	var unique:HTTPService = dataService(__service.getHTTPService("validateUniqueness"));
	__responderPick = new mx.rpc.Responder(uniqueCheckResultHandler,uniqueCheckFaultHandler);
	
	var token:AsyncToken = unique.send(new XML(	<params>
													<value>{value}</value>
													<column_name>{column_name}</column_name>
													<table_name>{table_name}</table_name>
													<customer_id>{customer_id}</customer_id>
												</params>));
	token.addResponder(__responderPick);	
}
public function uniqueCheckResultHandler(event:ResultEvent):void
{
	var result:XML = XML(event.result);
	
	if(result.toString()=='NotExist')
	{
		dtlShippings.bcdp.dispatchEvent(new ButtonControlDetailEvent('editRowEvent'));
	}
	else
	{
		Alert.show("Customer PO #"+tiCustomer_po_id.dataValue+" already Exist");
		tiCustomer_po_id.dataValue  = '';
	}
	
}
public function uniqueCheckFaultHandler(event:FaultEvent):void
{
	Alert.show("UniqueNess"+event.fault.faultDetail);
	tiCustomer_po_id.dataValue  = '';
}
private function clickFinishOrder():void
{
	preSaveEvent = new PreSaveEvent();
	preSaveEvent.dispatch();
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

private function setPaymentTerm(msg_flag:Boolean):void
{
	if(dcTerm_code.dataValue.toUpperCase()=="CC")
	{
		isTermCreditCard		= true;
	}
	else
	{
		isTermCreditCard		= false;
	}
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
		tiTax_per.text = numericFormatter.format(tiTax_per.text);
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
		tiTax_per.text = numericFormatter.format(String(Number(_tax_amt / _gross_amt * 100)));
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
	
	dtlShippings.bcdp.btnEditVisible  = (dtlShippings.dgDtl.rows.children().length()>0)? false:true;
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
private function updateShippingQty():void
{
	var total_qty:Number 	= 0;
	
	var dgXml:XML  	= dtlLine.dgDtl.rows.copy();
	
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		total_qty = total_qty + Number(dgXml.children()[i]['item_qty'].toString());
	}
	
	var tempShippingXml:XML   = dtlShippings.dgDtl.rows.copy();
	if(tempShippingXml.children().length()>0)
	{
		tempShippingXml.children().ship_qty  = total_qty;
	}
	
	dtlShippings.dgDtl.rows  = tempShippingXml;
	setIsShipInfoBaseChange();

}
private function setItemAmount(event:DetailEvent):void
{
	setShippingBalanceQty();
	
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
private function authenticateCreditCardFromAthorizeNet():void
{
	var record:XML													= __localModel.addEditObj.record;
	
	if(record!=null)
	{
		var sales_order_id:String									= __localModel.addEditObj.record.children()[0].id.toString();
		var customer_payment_profile_code:String					= dcPaymentProfle_code.dataValue;
		var customer_profile_code:String							= tiCustomer_profile_code.dataValue;
		var amount:Number											= Number(numericFormatter.format(tiNetAmount.dataValue));
		
		if(amount>0 && sales_order_id!='' && customer_payment_profile_code!='' && customer_profile_code!='')
		{
			var callbacks:IResponder	=	new mx.rpc.Responder(athenticateResultHandler, null);
			getInformationEvent			=	new GetInformationEvent('authorize_customer_payment', callbacks,sales_order_id,customer_payment_profile_code,customer_profile_code,amount,__genModel.user.userID);
			getInformationEvent.dispatch();
		}
		else
		{
			Alert.show("Please Fill Information for authorize payment Or Select Payment Profile");
		}
		
	}
	else
	{
		Alert.show("Please Save Record Before Authorize Payment");
	}
	
	
	
}

private function athenticateResultHandler(resultXml:XML):void
{
	var getRecordEvent:GetRecordEvent = new GetRecordEvent(int(__localModel.addEditObj.record.children()[0].id.toString()),null,false);
	getRecordEvent.dispatch();
	
	Alert.show(resultXml.toString());
	dcPaymentProfle_code.dataValue  = '';
	dcPaymentProfle_code.labelValue = '';
	paymentProfileCardNumber        = '';
	paymentProfileCode              = '';
	
}
private function changeNextDayFlag():void
{
	if(cbNext_Day_Flag.dataValue.toUpperCase() 		== 'N')
		__localModel.next_day_flag	= false;
	else if(cbNext_Day_Flag.dataValue.toUpperCase()	== 'Y')
		__localModel.next_day_flag	= true;
	
	setParamforEstimate();
	//setEstimatedDateByIncrement(cbNext_Day_Flag.dataValue.toUpperCase());
	
}
private function setEstimatedDateByIncrement(flag:String):void
{
	var dgXml:XMLList  = dtlShippings.dgDtl.rows.(trans_flag='A');
	
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		var estimated_ship_date:String  	=  dgXml.children()[i]['estimated_ship_date'].toString();
		var estimated_Inhand_date:String  	=  dgXml.children()[i]['estimated_arrival_date'].toString();
		
		var noofDays:Number					= getNoOfdays(estimated_ship_date,estimated_Inhand_date);
		
		var requested_ship_date:String  	=  dgXml.children()[i]['ship_date'].toString();
		if(estimated_ship_date!='' && estimated_ship_date!=null)
		{
			if(flag=='Y')
			{
				dgXml.children()[i]['estimated_ship_date']  		= addDaysToDate(estimated_ship_date,1);
				if(requested_ship_date=='')
				{
					dgXml.children()[i]['internal_ship_date'] 	 	= dgXml.children()[i]['estimated_ship_date'].toString();
				}
				else
				{
					dgXml.children()[i]['internal_ship_date'] 	 	= dgXml.children()[i]['ship_date'].toString();
				}
			}
			else
			{
				dgXml.children()[i]['estimated_ship_date']  		= addDaysToDate(estimated_ship_date,-1);
				if(requested_ship_date=='')
				{
					dgXml.children()[i]['internal_ship_date'] 	 	= dgXml.children()[i]['estimated_ship_date'].toString();
				}
				else
				{
					dgXml.children()[i]['internal_ship_date'] 	 	= dgXml.children()[i]['ship_date'].toString();
				}
			}
		}
		
		if(noofDays.toString()!='NaN')
		{
			var estimated_ship_date_now:String  						=  dgXml.children()[i]['estimated_ship_date'].toString();
			dgXml.children()[i]['estimated_arrival_date'] 	 			=  addDaysToDate(estimated_ship_date_now,noofDays);
			
			var requested_inhand_date:String  							=  dgXml.children()[i]['inhand_date'].toString();
			if(requested_inhand_date=='')
			{
				dgXml.children()[i]['internal_inhand_date'] 	 		= dgXml.children()[i]['estimated_arrival_date'].toString();
			}
			else
			{
				dgXml.children()[i]['internal_inhand_date'] 	 		= dgXml.children()[i]['inhand_date'].toString();
			}
		}
		
		
	}
	dtlShippings.dgDtl.rows  		= XML(dgXml).copy();
	dtlShippingsHeader.dgDtl.rows	= XML(dgXml).copy();
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
private function setQueryDateLavelFunction():void
{
	while(true)
	{
		if(dtlQueries.dgDtl.columns.length>0)
		{
			DataGridColumn(dtlQueries.dgDtl.columns[2]).labelFunction = dateFunc;
			break;
		}
	}
	
}
private function givemsgBeforeAthorizeAmount():void
{
	if(!__genModel.activeModelLocator.addEditObj.isRecordViewOnly)
	{
		paymentProfileCode  		= dcPaymentProfle_code.dataValue;
		paymentProfileCardNumber	= dcPaymentProfle_code.labelValue
		
		var record:XML				= __localModel.addEditObj.record;
		
		if(dcPaymentProfle_code.dataValue!='')
		{
			if(record!=null && !__genModel.activeModelLocator.addEditObj.editStatus)
			{
				Alert.show("Amount authorization is about to be done. Are you sure?","Authorize Order Amount",Alert.YES | Alert.NO,this,alertListener,null,Alert.OK)
			}
			else
			{
				Alert.show("Please Save Record Before Authorize Payment");
			}
		}
		else
		{
			Alert.show("Please select payment profile");
		}
	}
}

private function alertListener(event:CloseEvent):void
{
	switch (event.detail)
	{
		case Alert.YES:
			authenticateCreditCardFromAthorizeNet();
			break;
		case Alert.NO:
			
			break;
	}
}

private function changePaperProofFlag():void
{
	__localModel.paper_proof_flag	= false;
	setParamforEstimate();
}
private function isAllQueryAnswered():Boolean
{
	var tempXml:XMLList  = XMLList(dtlQueries.dgDtl.rows.children().(answer_flag=="N"));
	var dgXml:XML		 = new XML("<" + dtlQueries.rootNode + "/>")
	dgXml.appendChild(tempXml);
	
	var returnValue:Boolean = true;
	
	if(dgXml.children().length()>0)
	{
		returnValue         = false;
	}
	else
	{
		returnValue			= true;
	}
	return returnValue;
}
private function setPaymentprofileCode():void
{
	paymentProfileCode  		= dcPaymentProfle_code.dataValue;
	paymentProfileCardNumber	= dcPaymentProfle_code.labelValue
}
private function setReAssignFlagVisiblity(xml:XML):void
{
	var orderqcstatus_flag:String   	 = xml.children()[0].orderqcstatus_flag.toString();
	var orderentrycomplete_flag:String   = xml.children()[0].orderentrycomplete_flag.toString();
	
	if(orderqcstatus_flag =='Y')
	{
		cbReassignedToOrderEntry.visible         = false;
		cbReassignedToOrderEntry.includeInLayout = false;
		dcAssignUser.visible					 = false;
	}
}		
private function cancelAthorizeAmount():void
{
	if(!__genModel.activeModelLocator.addEditObj.isRecordViewOnly)
	{
		commonMooduleFunctions.givemsgBeforeCancelAthorizeAmount();
	}
	
}		
private function setVisiblityOfAthorizeButton(xml:XML):void
{
	var payment_authorize_flag:String = xml.children()[0].payment_authorize_flag.toString();
	var payment_release_flag:String   = xml.children()[0].payment_release_flag.toString();
	
	if(payment_authorize_flag =='Y')
	{
		btnAthorizePayment.visible		 		= false;
		dcTerm_code.enabled				  		= false;
		dcPaymentProfle_code.enabled	  		= false;
		dcPaymentProfle_code.includeInLayout	= false;
		btnCancelAthorizePayment.visible  		= true;
	}
	else if(payment_authorize_flag=='N')
	{
		btnAthorizePayment.visible		  		= true;
		dcTerm_code.enabled				  		= true;
		dcPaymentProfle_code.enabled	  		= true;
		dcPaymentProfle_code.includeInLayout	= true;
		btnCancelAthorizePayment.visible  		= false;
	}
	else
	{
		btnAthorizePayment.visible		 		= true;
		dcTerm_code.enabled				  		= true;
		dcPaymentProfle_code.enabled	  		= true;
		dcPaymentProfle_code.includeInLayout	= true;
		btnCancelAthorizePayment.visible  		= false;
	}
	setMissingInfo();
}
private function resendAcknowledgment():void
{
	commonLinksServices.resendAcknowledgment();
}

private function setShippingBalanceQty():void
{
	var total_qty:Number 	= 0;
	var remainQty:int	 	= 0;
	
	var dgItemXml:XMLList  	= dtlLine.dgDtl.rows.(trans_flag='A');
	
	for(var j:int = 0 ; j < dgItemXml.children().length(); j++)
	{
		remainQty = remainQty + Number(dgItemXml.children()[j]['item_qty'].toString());
	}
	
	__localModel.main_item_qty_total = remainQty.toString();
	
	var dgXml:XMLList  		= dtlShippings.dgDtl.rows.(trans_flag='A');
	
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		total_qty = total_qty + Number(dgXml.children()[i]['ship_qty'].toString());
	}
	
	remainQty   			=  remainQty -total_qty;
	
	if(remainQty<0)
	{
		remainQty			= 0;
	}
	
	__localModel.main_item_qty		 = remainQty.toString();
	
}
private function setIsShipInfoBaseChange():void
{
	if(dtlShippings.dgDtl.rows.children().length()>0)
	{
		__localModel.isShipInfoBaseChange	= true;
	}
}

private function setParamforEstimate():void
{
	__localModel.ext_ref_date		= dfCustomer_po_date.dataValue;
	__localModel.cbRushType 		= cbRushType.dataValue;
	__localModel.cbNextDayFlag		= cbNext_Day_Flag.dataValue;
	__localModel.cbPaperProof		= '';
	__localModel.cbBlankOrderFlag  	= 'N';
}
private function updateEstimateShipAndInhandDate():void
{
	var updateEstimateShipAndInhandDateFunctions:UpdateEstimateShipAndInhandDateFunctions  = new UpdateEstimateShipAndInhandDateFunctions();
	updateEstimateShipAndInhandDateFunctions.updateShippingInfo(cbOrder_type,dcCustomer_id,dfCustomer_po_date,cbNext_Day_Flag,cbRushType,'N','',__localModel.main_item_qty_total,dtlShippings,'N');
}