import business.events.GetInformationEvent;
import business.events.PreSaveEvent;
import business.events.RecordStatusEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.components.DataEntry;
import com.generic.customcomponents.GenDateField;
import com.generic.customcomponents.GenDynamicComboBox;
import com.generic.events.AddEditEvent;
import com.generic.events.ButtonControlDetailEvent;
import com.generic.events.FetchRecordEvent;
import com.generic.events.GenCheckBoxEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.genclass.GenValidator;
import com.generic.genclass.TabPage;
import com.generic.genclass.URL;

import flash.desktop.NativeDragManager;
import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.events.NativeDragEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.utils.setTimeout;

import model.GenModelLocator;

import mx.binding.utils.BindingUtils;
import mx.collections.ArrayCollection;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.ComboBox;
import mx.controls.Label;
import mx.controls.LinkButton;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.core.FlexGlobals;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.formatters.DateFormatter;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import saoi.muduleclasses.ApplicationConstant;
import saoi.muduleclasses.CommonArtworkXml;
import saoi.muduleclasses.CommonMooduleFunctions;
import saoi.muduleclasses.GenNotesAttachmentIcon;
import saoi.muduleclasses.OrderTrail;
import saoi.muduleclasses.ValidatePoPopUp;
import saoi.muduleclasses.event.MissingInfoEvent;
import saoi.orderreceive.OrderReceiveModelLocator;
import saoi.orderreceive.components.OrderReceiveMutipleArtworkDetail;
import saoi.salesorder.SalesOrderModelLocator;
import saoi.salesorder.components.SalesOrder;

private var preSaveEvent:PreSaveEvent;
private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
private var getInformationShippingEvent:GetInformationEvent;
private var getDefaultSetupEvent:GetInformationEvent;
private var item_detail:GetInformationEvent;
private var shipping_detail:GetInformationEvent;
private var customer_contact:GetInformationEvent;
private var shippingMethidsValue:String ;
private var customerContactValue:String ;
[Bindable]
private var __localModel:OrderReceiveModelLocator = (OrderReceiveModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var main_image_name:String;
[Bindable]
private var reorderEnable:Boolean = true;
[Bindable]
private var optionEnable:Boolean = true;
[Bindable]
private var artworkEnable:Boolean = true;
private var resultXmlFromItem:XML = new XML();
private var optionXmlAfterSave:XML;
private var saveXml:XML;
private var __service:ServiceLocator = __genModel.services;
private var selectUniqueArtworkVersionIndex:int = 0;
private var isCustomerChnage:Boolean    = false;
private var __responderPick:IResponder;
private var fetch_order_type:String = '';
private var orderTrailViewer:OrderTrail;
private var customer_phone:String = '';

private var multipleArtwork:OrderReceiveMutipleArtworkDetail
private var nativeProcess:NativeProcess = new NativeProcess();
[Binadable]
private var attachmentXml:XML

private var outputData:String = '';
private var has_expired_date_flag:String = 'N';
private var commonartworkXml:CommonArtworkXml   			= new CommonArtworkXml(); 

private function init():void
{
	enableReorderComponent();
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	
	__localModel.trans_date = dfTrans_date.text;
	
	if(NativeProcess.isSupported)
	{
		this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragIn);
		this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop);	
	}
	
	//getAccountPeriod();
}

/////////////////////    -------------- Drag Drop Related Work  -------------------- ///////////////////////////////

private function onDragIn(event:NativeDragEvent):void
{
	NativeDragManager.acceptDragDrop(this);
}

private function onDrop(event:NativeDragEvent):void
{
	event.allowedActions.allowLink = true;
	event.preventDefault();
	
	var nativeProcessInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
	
	try
	{
		nativeProcessInfo.executable 	=	new File("C:/Program Files/Diaspark/OutlookDragDropSetup/OutlookDLLCall.exe");	
	}
	catch(ex:Error)
	{
		nativeProcessInfo.executable    =	new File("C:/Program Files (x86)/Diaspark/OutlookDragDropSetup/OutlookDLLCall.exe");
	}
	
	nativeProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA,onOutputData)
	nativeProcess.addEventListener(ProgressEvent.STANDARD_ERROR_DATA,onErrorData)
	
	CursorManager.setBusyCursor();
	
	try
	{
		outputData = ''
		nativeProcess.start(nativeProcessInfo);
	}
	catch(e:Error)
	{
		Alert.show(e.message)
	}
}

private function onOutputData(evt:ProgressEvent):void
{ 
	outputData += nativeProcess.standardOutput.readUTFBytes(nativeProcess.standardOutput.bytesAvailable);
	CursorManager.removeBusyCursor();
	
	try
	{
		attachmentXml = XML(outputData);
		multipleArtwork  = OrderReceiveMutipleArtworkDetail(PopUpManager.createPopUp(this,OrderReceiveMutipleArtworkDetail,true));
		multipleArtwork.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,orderReceiveMutipleArtworkDetailCloseHandler)
		
		multipleArtwork.x= ((FlexGlobals.topLevelApplication.width/2)-(multipleArtwork.width/2));
		multipleArtwork.y= ((FlexGlobals.topLevelApplication.height/2)-(multipleArtwork.height/2));
		multipleArtwork.attachmentXml = attachmentXml;
	}
	catch(error:Error)
	{
		//Alert.show('error');
	}
	//nativeProcess.exit();
} 

private function orderReceiveMutipleArtworkDetailCloseHandler(event:MissingInfoEvent):void
{
	var gridXml:XML = new XML(<sales_order_artworks/>);
	gridXml.appendChild(dtlArtwork.dgDtl.rows.children());
	gridXml.appendChild(event.xml.children());
	
	dtlArtwork.dgDtl.rows = gridXml;
}

private function onErrorData(evt:ProgressEvent):void
{ 
	var errorData:String = nativeProcess.standardError.readUTFBytes(nativeProcess.standardError.bytesAvailable);
	CursorManager.removeBusyCursor();
	Alert.show(errorData);
	//nativeProcess.exit();
}

/////////////////////    -------------- Drag Drop Related Work  -------------------- ///////////////////////////////

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
private function changePaperProofFlag():void
{
	if(cbPPRequired_flag.dataValue.toUpperCase() 		== 'N')
		__localModel.paper_proof_flag	= false;
	else if(cbPPRequired_flag.dataValue.toUpperCase()	== 'Y')
		__localModel.paper_proof_flag	= true;
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
		Alert.show("Please Select Customer and Contact");
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

private function getCustomerDetails():void
{
	if(dcCustomer_id.text != "" && dcCustomer_id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(customerDetailsHandler, null);
		
		getInformationEvent			=	new GetInformationEvent('customerdetail', callbacks, dcCustomer_id.dataValue, "I");
		getInformationEvent.dispatch();
	}
	else
	{
		tiCustomer_phone.dataValue		= '';
		lblCustomerName.text		    = '';
	}
	
	isCustomerChnage                		= true;
	__localModel.customer_id				= dcCustomer_id.dataValue;
	__localModel.customer_code				= dcCustomer_id.labelValue;
	dcCustomer_Contact_id.filterKeyValue  	= dcCustomer_id.dataValue;
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
}
private function setValue(customerXml:XML):void
{
	
	dcCustomer_Contact_id.labelValue		= customerXml.children().child('contact_name').toString();
	dcCustomer_Contact_id.dataValue			= customerXml.children().child('contact_name').toString();
	
	dcTerm_code.dataValue 					= customerXml.children().child('term_code').toString();
	dcTerm_code.labelValue					= customerXml.children().child('term_code').toString();
	//dcCustomerContact.dataValue				= customerXml.children().child('contact1').toString();
	tiCustomer_phone.dataValue				= customerXml.children().child('phone1').toString();
	customer_phone							= customerXml.children().child('phone1').toString();
	tiAccounts.dataValue 					= customerXml.children().child('account_dept_email').toString();
	tiShipping.dataValue 					= customerXml.children().child('shipping_dept_email').toString();
	tiPurchase.dataValue					= customerXml.children().child('purchase_dept_email').toString();
	tiCorrespondense.dataValue				= customerXml.children().child('corr_dept_email').toString();
	tiArt_work.dataValue					= customerXml.children().child('artwork_dept_email').toString();
	__localModel.artwork_dept_email			= customerXml.children().child('artwork_dept_email').toString();
	
	cbPPRequired_flag.defaultValue			= customerXml.children().child('paper_proof_flag').toString();
	cbPPRequired_flag.dataValue				= customerXml.children().child('paper_proof_flag').toString();
	//tiAccount_status.dataValue				= customerXml.children().child('class_name').toString();
	
	dcSales_person_code.dataValue			= customerXml.children().child('salesperson_code').toString();
	dcSales_person_code.labelValue			= customerXml.children().child('salesperson_code').toString();
	dcExternalSales_person_code.dataValue	= customerXml.children().child('externalsalesperson_code').toString();
	dcExternalSales_person_code.labelValue	= customerXml.children().child('externalsalesperson_code').toString();
	
	if(customerXml.children().child('business_phone').toString()!='')
	{
		tiCustomer_phone.dataValue			= customerXml.children().child('business_phone').toString();
	}
}
private function resetFinalArtworkId():void
{
	var tempXml:XML	 = dtlArtwork.dgDtl.rows.copy(); 
	for(var i:int=0;i<tempXml.children().length();i++)
	{
		if(tiTrans_no.dataValue=='')
		{
			tempXml.children()[i].id  = '';
		}
	}
	dtlArtwork.dgDtl.rows  = tempXml;
}
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var returnValue:int = 0;
	resetFinalArtworkId();
	if(cbOrder_type.dataValue=='E')
	{
		if(tiRef_trans_no.dataValue=='')
		{
			Alert.show("Enter Ref. Order# to proceed with Re-ordering.");
			return -1;
		}
		if(cbReorderType.dataValue=='')
		{
			Alert.show("Enter Reorder Type to proceed with Order.");
			return -1;
		}
		if(has_expired_date_flag=='Y' && String(cbReorderType.dataValue).toUpperCase()!=ApplicationConstant.REORDER_TYPE_CHANGEWITHARTWORK)
		{
			Alert.show("Select Reorder Type as "+ApplicationConstant.REORDER_TYPE_CHANGEWITHARTWORK);
			return -1;
		}
	}
	//if(cbOrder_type.dataValue!='P' && !isCustomerPOAttach())
	if(!isCustomerPOAttach())
	{
		Alert.show("Customer PO is required. Please attach customer's PO with the order.");
		return -1;
	}
	if(cbBlankOrder_flag.dataValue=='Y' && cbPPRequired_flag.dataValue=='Y')
	{
		Alert.show("Paper Proof is not required in blank order.");
		return -1;
	}
	var tempXml:XMLList  = XMLList(dtlArtwork.dgDtl.rows.children().(trans_flag=='A'));
	var dgXml:XML		 = new XML("<" + dtlArtwork.rootNode + "/>")
	dgXml.appendChild(tempXml);
	if(cbOrder_type.dataValue=='P' && (dgXml.children().length()!=1))
	{
		Alert.show("artwork can't be other than customer po");
		return -1;
	}
	if(cbOrder_type.dataValue!='P' && !isArtworkVersionUnique())
	{
		Alert.show("Artwork/PO Type Should Not Repeat");
		dtlArtwork.dgDtl.selectedIndex  = selectUniqueArtworkVersionIndex;
		return -1;
	}
	//addDeleteArtWorkintoArtworkGridForSave();
	setPaperProofStatus();
	//setartworkFinalFlag();
	//setOrderType();
	setReorderType();
	return returnValue;
	
}
private function setartworkFinalFlag():void
{
	if(cbOrder_type.dataValue.toUpperCase()=='E' && cbReorderType.dataValue.toUpperCase()==ApplicationConstant.REORDER_TYPE_NORMAL)
	{
		var xml:XML  = XML(dtlArtwork.dgDtl.rows.children().(trans_flag=='A'));
		for(var i:int=0;i<xml.children().length();i++)
		{
			xml.children()[i].final_artwork_flag = 'Y';
		}
	}
	else
	{
		var xml:XML  = XML(dtlArtwork.dgDtl.rows.children().(trans_flag=='A'));
		for(var i:int=0;i<xml.children().length();i++)
		{
			xml.children()[i].final_artwork_flag = 'N';
		}
	}
}
private function addDeleteArtWorkintoArtworkGridForSave():void
{
	/*if(dtlArtworkDelete.rows.children().length()>0)
	{
		var trans_flag:String  = dtlArtworkDelete.rows.children()[0].trans_flag;
		if(trans_flag=='D')
		{
			dtlArtwork.dgDtl.rows.appendChild(dtlArtworkDelete.rows.children().copy());
		}
	}*/
}
private function setReorderType():void
{
	/*if(cbOrder_type.dataValue=='E' && cbChnage_Required.dataValue=='Y'&& cbPPRequired_flag.dataValue=='Y')
	{
		cbReorderType.dataValue  = 'CHANGE WITH PROOF';
	}
	else if(cbOrder_type.dataValue=='E' && cbPPRequired_flag.dataValue=='Y')
	{
		cbReorderType.dataValue  = 'NORMAL WITH PROOF';
	}
	else if(cbOrder_type.dataValue=='E')
	{
		cbReorderType.dataValue  = 'NORMAL';
	}*/
}
private function isArtworkVersionUnique():Boolean
{
	var tempXml:XMLList  = XMLList(dtlArtwork.dgDtl.rows.children().(trans_flag=='A'));
	var dgXml:XML		 = new XML("<" + dtlArtwork.rootNode + "/>")
	dgXml.appendChild(tempXml);
	
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
private function isCustomerPOAttach():Boolean
{
	var tempXml:XMLList  = XMLList(dtlArtwork.dgDtl.rows.children().(trans_flag=='A'));
	var dgXml:XML		 = new XML("<" + dtlArtwork.rootNode + "/>")
	dgXml.appendChild(tempXml);
	
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
private function setPaperProofStatus():void
{
	if(cbPPRequired_flag.dataValue =='Y')
	{
		tiPaper_proof_status.dataValue	= "PAPER PROOF REQUIRED";
	}
	else
	{
		tiPaper_proof_status.dataValue	= "NO PROOF REQUIRED";
	}
}
override protected function resetObjectEventHandler():void   //on add buttton press,
{
	dcCustomer_id.enabled			=	true;
	cbOrder_type.enabled			=   true;
	cbPPRequired_flag.visible		=   true;
	setEnableDisableOfBlankOrderFlag(true);
	
	
	btnGetData.enabled				= true;
	cbReorderType.enabled			= false
	cbChnage_Required.enabled	    = false;
	artworkEnable					= true;
	customer_phone					= '';
	__localModel.trans_date 		= dfTrans_date.text
	__localModel.trans_no			= tiTrans_no.text;
	__localModel.ext_ref_no			= tiCustomer_po_id.text;
	__localModel.artwork_dept_email	= tiArt_work.text;
	__localModel.customer_id		= dcCustomer_id.dataValue;
	main_image_name					= '';
	
	tiVrtualRefItemId.dataValue		= tiVrtualRefItemId.defaultValue;
	
	resultXmlFromItem			= new XML();
	
	getAccountPeriod();
	
	var genNotesAttachmentIcon:GenNotesAttachmentIcon  = new GenNotesAttachmentIcon();
	genNotesAttachmentIcon.changeIcon(__localModel,DataEntry(this.parentDocument));
	
}
private function uploadArtwork():void
{
	
	dtlArtwork.dgDtl.selectedIndex	 = getArtworkIndex();
	__localModel.selectedButtonLabel = 'UploadArtwork' ;
	dtlArtwork.bcdp.dispatchEvent(new ButtonControlDetailEvent(ButtonControlDetailEvent.EDIT_ROW_EVENT));
}
private function uploadCustPO():void
{
	dtlArtwork.dgDtl.selectedIndex	 = getCustPOIndex();
	__localModel.selectedButtonLabel = 'UploadPO';
	dtlArtwork.bcdp.dispatchEvent(new ButtonControlDetailEvent(ButtonControlDetailEvent.EDIT_ROW_EVENT));
}
private function getArtworkIndex():int
{
	var dgXml:XML  = XML(dtlArtwork.dgDtl.rows.children().(trans_flag=='A'));
	var returnValue:int = -1;
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		var artwotkVersion:String  = dgXml.children()[i]['artwork_version'].toString();
		if(artwotkVersion.toUpperCase().search('CUSTOMER ART')>=0)
		{
			returnValue = i;
			break;
		}
	}
	return returnValue;
	
}
private function getCustPOIndex():int
{
	var dgXml:XML  = XML(dtlArtwork.dgDtl.rows.children().(trans_flag=='A'));
	var returnValue:int = -1;
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		var artwotkVersion:String  = dgXml.children()[i]['artwork_version'].toString();
		if(artwotkVersion.toUpperCase().search('CUSTOMER PO')>=0)
		{
			returnValue = i;
			break;
		}
	}
	return returnValue;
	
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
		setDefaultContact(resultXml.children().copy());
	}
}
public  function setDefaultContact(xmllist:XMLList):void
{
	var contact:String;
	var index:int  = -1;
	for(var i:int =0; i<xmllist.length();i++)
	{
		contact                	= xmllist[i].contact_name.toString();
		var defaultValue:String =xmllist[i].default_contact_flag.toString();
		if(defaultValue.toUpperCase()=='Y')
		{
			index = i;
			break;
		}
	}
	if(index>=0)
	{
		//dcCustomerContact.dataValue	= contact;
	}
	isCustomerChnage  = false;
	
}
private function setEnableDisableOfBlankOrderFlag(flag:Boolean=true):void
{
	if(cbOrder_type.dataValue=='S')
	{
		if(cbBlankOrder_flag.dataValue=='Y')
		{
			if(flag)
			{
				cbBlankOrder_flag.dataValue			= cbBlankOrder_flag.defaultValue;
			}
			cbBlankOrder_flag.enabled  			= false;
		}
		else
		{
			cbBlankOrder_flag.enabled  			= true;
		}
	}
	else
	{
		if(flag)
		{
			cbBlankOrder_flag.dataValue			= cbBlankOrder_flag.defaultValue;
		}
		cbBlankOrder_flag.enabled  			= false;
	}
}
override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	__localModel.customer_id				= dcCustomer_id.dataValue;
	__localModel.customer_code				= dcCustomer_id.labelValue;
	dcCustomer_Contact_id.filterKeyValue	= dcCustomer_id.dataValue;
	cbOrder_type.enabled					= false;
	dcCustomer_id.enabled					= false;
	cbReorderType.enabled					= false
	btnGetData.enabled 						= false;
	setEnableDisableOfBlankOrderFlag(false);
	
	
	if(cbOrder_type.dataValue=='E')
	{
		cbPPRequired_flag.enabled   = false;
		cbChnage_Required.enabled 	= true;
	}
	else
	{
		cbPPRequired_flag.enabled   = true;
		cbChnage_Required.enabled 	= false;
	}
	
	var recordXml:XML						= event.recordXml;
	saveXml									= event.recordXml.copy();
	
	__localModel.trans_date					= dfTrans_date.text
	__localModel.trans_no  					= recordXml.sales_order.trans_no.toString();
	__localModel.ext_ref_no					= recordXml.sales_order.ext_ref_no.toString();
	__localModel.artwork_dept_email			= recordXml.sales_order.artwork_dept_email.toString();
	
	var genNotesAttachmentIcon:GenNotesAttachmentIcon  = new GenNotesAttachmentIcon();
	genNotesAttachmentIcon.changeIcon(__localModel,DataEntry(this.parentDocument));
}
private function setCustomerContactvalueSave():void
{
	//tiCustomer_conatctsavevalue.dataValue  = dcCustomerContact.dataValue;
}
private function setOrderTypeChnage():void
{
	resetOrderDetail();
	
	if(cbOrder_type.dataValue=='P')
	{
		artworkEnable  = false;
	}
	else
	{
		artworkEnable  = true;
	}
	if(cbOrder_type.dataValue=='E' || cbOrder_type.dataValue=='S')
	{
		btnGetData.enabled 			= true;
	}
	else
	{
		btnGetData.enabled 			= false;
	}
	if(cbOrder_type.dataValue=='E')
	{
		//cbPPRequired_flag.visible   = false;
		//cbPPRequired_flag.dataValue	= 'N';
		//btnGetData.enabled 			= true;
		cbReorderType.enabled		= true
		cbChnage_Required.enabled 	= true;
	}
	else
	{
		//cbPPRequired_flag.visible   = true;
		//cbPPRequired_flag.dataValue = cbPPRequired_flag.defaultValue ;
		//btnGetData.enabled 			= false;
		cbReorderType.enabled		= false;
		cbChnage_Required.enabled 	= false;
		
	}
	setEnableDisableOfBlankOrderFlag(true);
	
}
private function enableReorderComponent():void
{
	if(cbOrder_type.dataValue=='E')
	{
		cbPPRequired_flag.visible   = false;
		cbPPRequired_flag.includeInLayout   = false;
		cbPPRequired_flag.dataValue	= 'N';
		//btnGetData.enabled 			= true;
		cbReorderType.enabled		= true
		cbChnage_Required.enabled 	= true;
	}
	else
	{
		cbPPRequired_flag.visible   = true;
		cbPPRequired_flag.includeInLayout   = true;
		//btnGetData.enabled 			= false;
		cbReorderType.enabled		= false;
		cbReorderType.dataValue		= cbReorderType.defaultValue;
		cbChnage_Required.enabled 	= false;
	}
}

private function handleBtnGetDataClick(event:Event):void
{
	if(cbOrder_type.dataValue=='S')
	{
		dtlEditLine.fetchDetailDataServiceID = "fetch_estimates";
		dtlEditLine.fetchDetailFormatServiceID="fetchEstimateFormat";
	}
	else
	{
		dtlEditLine.fetchDetailDataServiceID = "fetch_orders";
		dtlEditLine.fetchDetailFormatServiceID="fetchRecordFormat";
	}
	
	dtlEditLine.bcdp.dispatchEvent(new ButtonControlDetailEvent(ButtonControlDetailEvent.FETCH_RECORDS_EVENT));
}
private function createMapping():void
{
	var mappingArrCol:ArrayCollection = new ArrayCollection();
	
	//mappingArrCol.addItem({source: 'trans_bk',				target: 'trans_bk',				isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'trans_no',				target: 'trans_no',				isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'trans_bk',				target: 'trans_bk',				isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'trans_date',			target: 'trans_date',			isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'order_id',				target: 'order_id',				isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'order_type',			target: 'order_type',			isPrimaryKey:'N',	updatable:'N'})
	mappingArrCol.addItem({source: 'ref_virtual_line_id',	target: 'ref_virtual_line_id',	isPrimaryKey:'Y',	updatable:'N'})	
	
	//id, transFlag , serialNo will be added in FetchRecordSelectCommand because it is commmon in all screens
	dtlEditLine.fetchMapingArrCol	=	mappingArrCol;
}
override protected function fetchRecordSelectCompleteEventHandler(event:FetchRecordEvent):void   //on add buttton press,
{	
	var id:String  				= dtlEditLine.dgDtl.rows.purchase_memo_line.order_id.toString();
	fetch_order_type  			= dtlEditLine.dgDtl.rows.purchase_memo_line.order_type.toString();
	tiRef_type.dataValue		= fetch_order_type;
	tiVrtualRefItemId.dataValue = dtlEditLine.dgDtl.rows.purchase_memo_line.ref_virtual_line_id.toString();
	
	if(id!='' || id!==null )
	{
		if(cbOrder_type.dataValue=="S")
		{
			setHeatdeDetailFromSelectedEstimate(dtlEditLine.dgDtl.rows.copy());
			return;
		}
		
		var callbacks:IResponder = new mx.rpc.Responder(getOrderDetailHandler, null);
		item_detail	=	new GetInformationEvent('show_shipped_order_dtls', callbacks, id,null,tiVrtualRefItemId.dataValue);
		item_detail.dispatch();
	}
	else
	{
		Alert.show("Please select valid record"+dtlEditLine.dgDtl.rows.toXMLString());
	}	
}
private function getOrderDetailHandler(result:XML):void
{
	resetOrderDetail();
	setHeatdeDetailFromSelectedOrder(result);
	setArtworkFromOrder(result);
	has_expired_date_flag  = XML(result.children()[0].catalog_items).children()[0].has_expired_date_flag.toString();
}
private function resetOrderDetail():void
{
	resetHeatdeDetailFromSelectedOrder();
	resetArtworkFromOrder();
}
private function resetArtworkFromOrder():void
{
	var remainingXml:XML		= new XML("<"+dtlArtwork.rootNode+"/>");
	
	var tempXml:XML				= dtlArtwork.dgDtl.rows.copy();
	for(var i:int=0 ; i<tempXml.children().length();i++)
	{
		var artwork_type:String = tempXml.children()[i].artwork_version.toString();
		var findIndex:int		= artwork_type.toUpperCase().search(ApplicationConstant.ARTWORK_TYPE_CUSTOMER_PO);
		if(findIndex>=0)
		{
			remainingXml.appendChild(tempXml.children()[i]);
		}
		dtlArtwork.deleteRow(0);
	}
	
	dtlArtwork.dgDtl.rows  = remainingXml.copy();	
}
private function setArtworkFromOrder(result:XML):void
{
	var xml:XMLList  		= XMLList(result.sales_order.sales_order_artworks);	
	var tempXml:XML			= dtlArtwork.dgDtl.rows.copy();
	
	for(var i:int=0;i<xml.children().length();i++)
	{
		if(xml.children()[i].final_artwork_flag.toString()=='Y')
		{
			//xml.children()[i].id = '';
			xml.children()[i].final_artwork_flag = 'N';
			xml.children()[i].select_yn 		 = 'N';
			xml.children()[i].comment 		 	 = ApplicationConstant.REORDER_COMMENT+tiRef_trans_no.dataValue;
			tempXml.appendChild(xml.children()[i]);
		}
	}
	dtlArtwork.dgDtl.rows	= tempXml.copy();
}
private function resetHeatdeDetailFromSelectedOrder():void
{
	tiRef_trans_no.dataValue  				=		tiRef_trans_no.defaultValue;
	tiRef_po_no.dataValue					= 		tiRef_po_no.defaultValue;
	tiRef_trans_bk.dataValue				= 		tiRef_trans_bk.defaultValue;
	cbReorderType.dataValue					=		cbReorderType.defaultValue; 
	//dtlEditLine.dgDtl.rows					= 		new XML('<'+dtlEditLine.rootNode+'></'+dtlEditLine.rootNode+'>');
}
private function setHeatdeDetailFromSelectedOrder(result:XML):void
{
	var xml:XMLList  						= 		XMLList(result.sales_order);
	tiRef_trans_no.dataValue  				=		xml.trans_no.toString();
	tiRef_trans_bk.dataValue				=       xml.trans_bk.toString();
	tiLogoField.dataValue					= 		xml.logo_name.toString();
	//tiRef_po_no.dataValue					= 		xml.ext_ref_no.toString();
}
private function setHeatdeDetailFromSelectedEstimate(result:XML):void
{
	var xml:XMLList  						= 		XMLList(result.children()[0]);
	tiRef_trans_no.dataValue  				=		xml.trans_no.toString();
	tiRef_trans_bk.dataValue				=       xml.trans_bk.toString();
	
}
private function setReorderTypeChnages():void
{
	/*if(String(cbReorderType.dataValue).toUpperCase()=='NORMAL')
	{
		cbPPRequired_flag.dataValue   = 'N';
	}
	else if(String(cbReorderType.dataValue).toUpperCase()=='NORMAL WITH PROOF')
	{
		cbPPRequired_flag.dataValue   = 'Y';
	}
	else if(String(cbReorderType.dataValue).toUpperCase()=='CHANGE WITH PROOF')
	{
		cbPPRequired_flag.dataValue   = 'Y';
	}*/
}
private function viewArtwork():void
{
	var index:int = -1;
	var dgXml:XML  = XML(dtlArtwork.dgDtl.rows.children().(trans_flag=='A'));
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var artwork_version:String = dgXml.children()[i].artwork_version.toString(); 
		if(artwork_version.toUpperCase().search('CUSTOMER ART')>0)
		{
			index = i;
			break;
		}
	}
	if(index>=0)
	{
		var file_name:String = dgXml.children()[index].artwork_file_name.toString();
		viewFileHandler(file_name);
	}
	else
	{
		Alert.show("Please upload Artwork");
	}
	
}
private function viewPO():void
{
	var index:int = -1;
	var dgXml:XML  = XML(dtlArtwork.dgDtl.rows.children().(trans_flag=='A'));
	for(var i:int=0;i<dgXml.children().length();i++)
	{
		var artwork_version:String = dgXml.children()[i].artwork_version.toString(); 
		if(artwork_version.toUpperCase().search('CUSTOMER PO')>=0)
		{
			index = i;
			break;
		}
	}
	if(index>=0)
	{
		var file_name:String = dgXml.children()[index].artwork_file_name.toString();
		viewFileHandler(file_name);
	}
	else
	{
		Alert.show("Please upload PO");
	}	
}
private function viewFileHandler(file_name:String):void
{
	var url:String  =	__genModel.path.attachment+file_name;
	var _requestViewUrl:URLRequest = new URLRequest(url);
	navigateToURL(_requestViewUrl); 
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
private  function openShippingAddress():void
{
	__localModel.ext_ref_no			= tiCustomer_po_id.text;
}

private function viewOriginalOrder():void
{
	var ref_type:String    = tiRef_type.dataValue;
	if(tiRef_trans_no.dataValue!=null && tiRef_trans_no.dataValue!='' )
	{
		__genModel.drillObj.drillrow							=	new XML(<rows><trans_no>{tiRef_trans_no.dataValue}</trans_no></rows>);
		/*if(fetch_order_type=='Re-Order')
		{
			__localModel.listObj.drilldown_component_code 		= 	"saoi/reorder/components/ReOrder.swf";
		}
		else if(fetch_order_type=='Estimate')
		{
			__localModel.listObj.drilldown_component_code 		= 	"saoi/salesquotation/components/SalesQuotation.swf";
		}
		else
		{
			__localModel.listObj.drilldown_component_code 		= 	"saoi/salesorder/components/SalesOrder.swf";
		}*/
		if(tiRef_type.dataValue=='E')
		{
			__localModel.listObj.drilldown_component_code 		= 	"saoi/reorder/components/ReOrder.swf";
		}
		else if(tiRef_type.dataValue=='S'||tiRef_type.dataValue=='F')
		{
			__localModel.listObj.drilldown_component_code 		= 	"saoi/salesorder/components/SalesOrder.swf";
		}
		else if(tiRef_type.dataValue=='P')
		{
			__localModel.listObj.drilldown_component_code 		= 	"saoi/sampleorder/components/SampleOrder.swf";
		}
		else if(tiRef_type.dataValue=='V')
		{
			__localModel.listObj.drilldown_component_code 		= 	"saoi/virtualorder/components/VirtualOrder.swf";
		}
		else if(tiRef_type.dataValue=='Q')
		{
			__localModel.listObj.drilldown_component_code 		= 	"saoi/salesquotation/components/SalesQuotation.swf";
		}
		
		var tabpage:TabPage										=	new TabPage();
		tabpage.openDrillDownPage(__localModel.listObj.drilldown_component_code);
	}
	else
	{
		Alert.show("please select Original Order");
	}
	
}
private function viewDetailOrder():void
{
	if(!__genModel.activeModelLocator.addEditObj.editStatus && tiTrans_no.dataValue!='')
	{
		
		__genModel.drillObj.drillrow							=	new XML(<rows><trans_no>{tiTrans_no.dataValue}</trans_no></rows>);
		
		if(cbOrder_type.dataValue=='E')
		{
			__localModel.listObj.drilldown_component_code 		= 	"saoi/reorder/components/ReOrder.swf";
		}
		else if(cbOrder_type.dataValue=='S'||cbOrder_type.dataValue=='F')
		{
			__localModel.listObj.drilldown_component_code 		= 	"saoi/salesorder/components/SalesOrder.swf";
		}
		else if(cbOrder_type.dataValue=='P')
		{
			__localModel.listObj.drilldown_component_code 		= 	"saoi/sampleorder/components/SampleOrder.swf";
		}
		else if(cbOrder_type.dataValue=='V')
		{
			__localModel.listObj.drilldown_component_code 		= 	"saoi/virtualorder/components/VirtualOrder.swf";
		}
		
		var tabpage:TabPage										=	new TabPage();
		tabpage.openDrillDownPage(__localModel.listObj.drilldown_component_code);
	}
	else
	{
		Alert.show("To view order in detail screen, save order and then click on order# link.");
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
private function viewOrderTrail():void
{
	if(tiRef_trans_no.dataValue!='')
	{
		orderTrailViewer 				= OrderTrail(PopUpManager.createPopUp(this,OrderTrail,true));
		orderTrailViewer.x				= ((Application.application.width/2)-(orderTrailViewer.width/2));
		orderTrailViewer.y				= ((Application.application.height/2)-(orderTrailViewer.height/2));
		orderTrailViewer.orderDetail 	= new XML(<order_detail>
													<trans_no>{tiRef_trans_no.dataValue}</trans_no>
												</order_detail>);
	}
	else
	{
		Alert.show("Please Select Original Order");
	}
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



// PASSWORD VALIDATION

private function validatePassword():void
{
	if(cbRushType.dataValue ==ApplicationConstant.RUSH_TYPE1 || cbRushType.dataValue ==ApplicationConstant.RUSH_TYPE2)
	{
		rushTypeChnagehandler();
	}
	else
	{
		var validatePoPopUp:ValidatePoPopUp			= ValidatePoPopUp(PopUpManager.createPopUp(this,ValidatePoPopUp,true));
		validatePoPopUp.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,validatePasswordMissingInfoEventListner);
		validatePoPopUp.x							= ((Application.application.width/2)-(validatePoPopUp.width/2));
		validatePoPopUp.y							= ((Application.application.height/2)-(validatePoPopUp.height/2));
	}
	
}
private function validatePasswordMissingInfoEventListner(event:MissingInfoEvent):void
{
	var resultXml:XML   = event.xml.copy();
	if(resultXml.children()[0].toString()=='VALID')
	{
		rushTypeChnagehandler();
	}
	else
	{
		cbRushType.dataValue  = cbRushType.oldValue;
	}
}