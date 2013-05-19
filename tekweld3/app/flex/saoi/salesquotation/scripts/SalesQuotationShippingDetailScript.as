import business.events.GetInformationEvent;
import business.events.RecordStatusEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.customcomponents.GenDataGrid;
import com.generic.customcomponents.GenDateField;
import com.generic.customcomponents.GenTextInput;
import com.generic.events.DetailAddEditEvent;
import com.generic.genclass.URL;

import flash.events.Event;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.DateField;
import mx.controls.Label;
import mx.core.Application;
import mx.formatters.NumberFormatter;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import saoi.muduleclasses.CalculateEstimateShipDateAndPackages;
import saoi.muduleclasses.CommonArtworkXml;
import saoi.muduleclasses.CommonMooduleFunctions;
import saoi.muduleclasses.PacketsPopWindow;
import saoi.muduleclasses.event.MissingInfoEvent;
import saoi.salesquotation.SalesQuotationModelLocator;
import saoi.sampleorder.SampleOrderModelLocator;
import saoi.muduleclasses.ApplicationConstant;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:SalesQuotationModelLocator = (SalesQuotationModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var shippingMethidsValue:String ;
private var shipping_detail:GetInformationEvent;
private var __responderEstimateShipDate:IResponder;
private var __service:ServiceLocator = __genModel.services;
private var catalotg_item_id:String  = '';
private var packetsPopWindow:PacketsPopWindow;

[Embed("com/generic/assets/ups_logo.jpg")]
private const upsshippingButtonIcon:Class;
[Embed("com/generic/assets/fedex_logo.jpg")]
private const fedexshippingButtonIcon:Class;
[Embed("com/generic/assets/add.png")]
private const addButtonIcon:Class;
[Embed("com/generic/assets/add_disabled.png")]
private const add_disabledButtonIcon:Class;

[Embed("com/generic/assets/delete.png")]
private const deleteButtonIcon:Class;

[Embed("com/generic/assets/delete_disabled.png")]
private const delete_disabledButtonIcon:Class;

[Bindable]
private var btnShipMethodClass:Class;
private var commonartworkXml:CommonArtworkXml   			= new CommonArtworkXml();

private function init():void
{
	/*if(__localModel.order_type.toUpperCase()=='F')
	{
		cbPreProduction.visible	= true;
	}
	else
	{
		cbPreProduction.visible	= false;
	}
	*/
	setShippingLogo();
	dcCustomer_shipping_id.filterKeyValue  = __localModel.customer_id;
}
private function getShippingDetail():void
{
	if(dcCustomer_shipping_id.dataValue != null && dcCustomer_shipping_id.dataValue != '')
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(shippingDetailHandler, null);
		getInformationEvent			=	new GetInformationEvent('customer_shipping_details', callbacks, dcCustomer_shipping_id.dataValue);
		getInformationEvent.dispatch();
	}
	
}
private function shippingDetailHandler(resultXml:XML):void
{
	if(resultXml.children().length()>0)
	{
		tiShip_nm.text 			= resultXml.children()[0].name.toString();
		tiShip_address1.text 	= resultXml.children()[0].address1.toString();
		tiShip_address2.text 	= resultXml.children()[0].address2.toString();
		tiShip_city.text 		= resultXml.children()[0].city.toString();
		tiShip_fax1.text 		= resultXml.children()[0].fax1.toString();
		tiShip_phone1.text 		= resultXml.children()[0].phone1.toString();
		tiShip_state.text 		= resultXml.children()[0].state.toString();
		tiShip_zip.text 		= resultXml.children()[0].zip.toString();
		tiShip_country.text 	= resultXml.children()[0].country.toString();
		tiAccountNo.text 		= resultXml.children()[0].account_number.toString();
		
		if(tiShip_zip.dataValue!='' && tiShip_country.dataValue!='')
		{
			getDefaultShipping();
		}
	}
	else
	{
		tiShip_nm.text 			= '';
		tiShip_address1.text 	= '';
		tiShip_address2.text 	= '';
		tiShip_city.text 		= '';
		tiShip_fax1.text 		= '';
		tiShip_phone1.text 		= '';
		tiShip_state.text 		= '';
		tiShip_zip.text 		= '';
		tiShip_country.text 	= '';
		tiAccountNo.text 		= '';
	}
}

private function setShipAmountEnablity():void
{
	/*if(dcShipping_code.dataValue == 'THIRDPARTY')
	{
		tiAmount.enabled			= false;
	}
	else if(dcShipping_code.dataValue == 'TRUCKING' &&  cbBillingTransportationTo.dataValue=='Shipper (TEKWELD)')
	{
		tiAmount.enabled			= true;
	}
	else
	{
		tiAmount.enabled			= false;
	}*/
}
private function setAccountNo():void
{
	/*tiAmount.dataValue 				= tiAmount.defaultValue;*/
	tiShipMethod.dataValue			= tiShipMethod.defaultValue;
	tiShipMethodCode.dataValue		= tiShipMethodCode.defaultValue;
	tiAccountNo.dataValue			= tiAccountNo.defaultValue;	
	
	setShippingLogo();
	setShippingMethodDetail();
	setShipAmountEnablity();
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
protected override function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	lblApiCalling.visible		= false;
	var recordXml:XML					= event.rowXml;
	
	setShippingLogo();
	chnageBillingTransportationTo('R');
}
override protected function resetObjectEventHandler():void
{
	lblApiCalling.visible		= false;
	/*tiQty.dataValue		= __localModel.main_item_qty;
	getEstimateShipDate(tiQty.dataValue);*/
	setShippingLogo();
	chnageBillingTransportationTo('O');
}

protected override function preSaveRowEventHandler(event:DetailAddEditEvent):int
{
	setInternalShipdate();
	setInternalInhanddate();
	
	/*if(dfEstimaedShip_date.dataValue==''&& dfShip_date.dataValue=='' )
	{
		Alert.show("Enter either Requested Ship Date or Estimated Ship Date.");
		return -1;
	}
	else
	{
		return 0;
	}*/
	return 0;
}
private function setEstimateArrivalDate():void
{

}
private function setRequestedInhandDate():void
{
	if(!__genModel.activeModelLocator.addEditObj.isRecordViewOnly)
	{
		if(__genModel.isLockScreen)
		{
			Alert.show('In Progrss ! please try again');
			return;
		}
		else
		{
			if(dcShipping_code.dataValue=='UPS' || dcShipping_code.dataValue=='FEDEX')
			{
			//	var commonFunctions:CommonMooduleFunctions  = new CommonMooduleFunctions();
			//	commonFunctions.setInhandDate(this,dcShipping_code,tiShip_zip,tiShip_country,tiAmount,tiShipMethod,dfArrivalShip_date,dfEstimaedShip_date,dfShip_date,dfInhand_date,__localModel.catalotg_item_id,tiQty,__localModel.trans_no,tiShip_state,lblShipAmountFormula,lblApiCalling,cbBillingTransportationTo,tiShipMethodCode);
			}
			else
			{
				
			}
		}
	}
}
private function getEstimateShipDateResultHandler(event:ResultEvent):void
{
	var result:XML								= XML(event.result);
	
	/*for(var row:int=0;row<dgPackets.rows.children().length();row++)
	{
		dgPackets.deleteRow(row);
	}
	
	var packages:XML							= XML(result.sales_order_shipping_packages);
	
	for(var i:int=0;i<packages.children().length();i++)
	{
		packages.children()[i].company_id	= __genModel.user.id;
		packages.children()[i].updated_by	= __genModel.user.userID;
		packages.children()[i].created_by	= __genModel.user.userID;
		packages.children()[i].id			= '';
		packages.children()[i].lock_version	= 0;
	}
	
	dgPackets.rows								= packages.copy();*/
	
	var date:String 							= result.estimated_ship_date.toString();
	if(__localModel.paper_proof_flag && __localModel.next_day_flag)
	{
		//dfEstimaedShip_date.dataValue   		= addDaysToDate(date,2);
	}
	else if(__localModel.paper_proof_flag || __localModel.next_day_flag)
	{
		//dfEstimaedShip_date.dataValue			= addDaysToDate(date,1);
	}
	else
	{
		//dfEstimaedShip_date.dataValue			= date;
	}
	var recordStatusEvent:RecordStatusEvent     = new RecordStatusEvent("MODIFY");
	recordStatusEvent.dispatch();
	
	Application.application.enabled  = true;
	CursorManager.removeBusyCursor();
	getDefaultShipping();										// now we have to pass ship date for arrival date time&transact api
	
}
private function getEstimateShipDateFaultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.faultDetail);
	
	/*for(var i:int=0;i<dgPackets.rows.length();i++)
	{
		dgPackets.deleteRow(i);
	}
	dgPackets.rows								= new XML(<sales_order_shipping_packages></sales_order_shipping_packages>);
*/	
	Application.application.enabled  = true;
	CursorManager.removeBusyCursor();
}
private function addDaysToDate(date:String,days:Number):String
{
	var now:Date 						 = new Date(date);
	now.date 							+= days;
	
	var df:GenDateField					= new GenDateField();
	return DateField.dateToString(now,df.databaseDateFormat);
	
}
private function getEstimateShipDate(qty:String):void
{
	//var calculateEstimateShipDateAndPackages:CalculateEstimateShipDateAndPackages  = new CalculateEstimateShipDateAndPackages();
	//calculateEstimateShipDateAndPackages.getEstimateDateAndPackages(this,dcShipping_code,tiShip_zip,tiShip_country,tiAmount,tiShipMethod,dfArrivalShip_date,dfEstimaedShip_date,dfShip_date,dfInhand_date,tiShip_state,lblShipAmountFormula,lblApiCalling,cbBillingTransportationTo,tiShipMethodCode,dgPackets,__localModel.order_type,__localModel.resultXmlFromItem,tiQty,false,__localModel.customer_id,__localModel.ext_ref_date,__localModel.cbNextDayFlag,__localModel.cbRushType,__localModel.cbPaperProof,__localModel.catalotg_item_id,__localModel.main_item_qty_total);

	/*Application.application.enabled  = false;
	CursorManager.setBusyCursor();
	
	if(__localModel.ext_ref_date != '' && __localModel.ext_ref_date != null && __localModel.customer_id!=''&& __localModel.customer_id!=null)
	{
		var validateCreditCard:HTTPService  = dataService(__service.getHTTPService("getEstimatedShipDate"));
		__responderEstimateShipDate 		= new mx.rpc.Responder(getEstimateShipDateResultHandler,getEstimateShipDateFaultHandler);
		var token:AsyncToken = validateCreditCard.send(new XML(	<params>
																	<catalog_item_id>{__localModel.catalotg_item_id}</catalog_item_id>
																	<customer_id>{__localModel.customer_id}</customer_id>
																	<item_qty>{qty}</item_qty>
																	<ext_ref_date>{__localModel.ext_ref_date}</ext_ref_date>
																</params>));
		token.addResponder(__responderEstimateShipDate);
	}
	else
	{
		Alert.show("Please Select Customer and Customer PO Date");
		dfShip_date.dataValue  = '';
		
		focusManager.setFocus(dcShipping_code.tiLabelField);
		
		Application.application.enabled  = true;
		CursorManager.removeBusyCursor();
	}*/
}
private function openShippingApiMethoeds():void
{
	if(!__genModel.activeModelLocator.addEditObj.isRecordViewOnly)
	{
		if(__genModel.isLockScreen)
		{
			Alert.show('In Progrss ! please try again');
			return;
		}
		else
		{
				var commonFunctions:CommonMooduleFunctions  = new CommonMooduleFunctions();
				
				dgPackages.rows = new XML(<sales_order_shipping_packages>
											<sales_order_shipping_package>
												<carton_length>10</carton_length>
												<carton_width>10</carton_width>
												<carton_height>10</carton_height>
												<carton_wt>10</carton_wt>
												<pcs_per_carton>10</pcs_per_carton>
											</sales_order_shipping_package>
											</sales_order_shipping_packages>);
				
				var tiQty:GenTextInput = new GenTextInput();
				tiQty.dataValue = 10+'';
				var estimatedShipDate:GenDateField = new GenDateField();
				estimatedShipDate.dataValue = new GenDateField().currentDate(); 
				
				commonFunctions.openShippingApiMethods(this,dcShipping_code,tiShip_zip,tiShip_country,new GenTextInput(),tiShipMethod,new GenDateField(),estimatedShipDate,new GenDateField(),new GenDateField(),tiShip_state,new Label(),lblApiCalling,cbBillingTransportationTo,tiShipMethodCode,dgPackages,__localModel.order_type,__localModel.resultXmlFromItem,tiQty,false);
		}
	}
}
private function setShippingMethodDetail():void
{
	//tiAmount.dataValue  			= tiAmount.defaultValue;
	tiShipMethod.dataValue  		= tiShipMethod.defaultValue;
	getDefaultShipping();
}

private function setShippingLogo():void
{
	new CommonMooduleFunctions().setShippingLogo(dcShipping_code.dataValue,btnShipMethod);
}
private function getDefaultShipping():void
{
	dgPackages.rows = new XML(<sales_order_shipping_packages>
	<sales_order_shipping_package>
	<carton_length>10</carton_length>
	<carton_width>10</carton_width>
	<carton_height>10</carton_height>
	<carton_wt>10</carton_wt>
	<pcs_per_carton>10</pcs_per_carton>
	</sales_order_shipping_package>
	</sales_order_shipping_packages>);
	
	var tiQty:GenTextInput = new GenTextInput();
	tiQty.dataValue = 10+'';
	var estimatedShipDate:GenDateField = new GenDateField();
	estimatedShipDate.dataValue = new GenDateField().currentDate();
	
	var commonFunctions:CommonMooduleFunctions  = new CommonMooduleFunctions();
	commonFunctions.openShippingApiMethods(this,dcShipping_code,tiShip_zip,tiShip_country,new GenTextInput(),tiShipMethod,new GenDateField(),estimatedShipDate,new GenDateField(),new GenDateField(),tiShip_state,new Label(),lblApiCalling,cbBillingTransportationTo,tiShipMethodCode,dgPackages,__localModel.order_type,__localModel.resultXmlFromItem,tiQty,true);
}
private function setInternalShipdate():void
{
	/*if(dfShip_date.dataValue!='')
	{
		dfInternal_ship_date.dataValue	= dfShip_date.dataValue;
	}
	else
	{
		dfInternal_ship_date.dataValue	= dfEstimaedShip_date.dataValue;
	}*/
}
private function setInternalInhanddate():void
{
	/*if(dfInhand_date.dataValue!='')
	{
		dfInternal_inhand_date.dataValue	= dfInhand_date.dataValue;
	}
	else
	{
		dfInternal_inhand_date.dataValue	= dfArrivalShip_date.dataValue;
	}*/
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
private function setBillingAddress():void
{
	var zip_old:String					= tiShip_zip.dataValue;
	var country_old:String				= tiShip_country.dataValue;
	var state_old:String				= tiShip_state.dataValue;
	
	if(cbCopyBillingAddress.dataValue=='Y')
	{
		tiShip_nm.dataValue				=   __localModel.billing_address.bill_name ;
		tiShip_address1.dataValue 		= 	__localModel.billing_address.address1 ;
		tiShip_address2.dataValue		= 	__localModel.billing_address.address2;
		tiShip_city.dataValue			=	__localModel.billing_address.city;
		tiShip_state.dataValue			=   __localModel.billing_address.state;
		tiShip_zip.dataValue			=	__localModel.billing_address.zip;
		tiShip_country.dataValue		=	__localModel.billing_address.country;
		tiShip_phone1.dataValue			=	__localModel.billing_address.phone1;
		tiShip_fax1.dataValue			= 	__localModel.billing_address.fax;
		if(tiShip_zip.dataValue!='' && tiShip_country.dataValue!='' && tiShip_state.dataValue!='' && (zip_old!=tiShip_zip.dataValue || country_old!=tiShip_country.dataValue || state_old!=tiShip_state.dataValue ))
		{
			getDefaultShipping();
		}
	}
}
private function cityItemChangeHandler():void
{
	tiShip_state.dataValue  = tiShip_state.defaultValue;
	tiShip_zip.dataValue	= tiShip_zip.defaultValue;
	setShippingMethodDetail();
}
private function stateItemChangeHandler():void
{
	tiShip_zip.dataValue	= tiShip_zip.defaultValue;
	setShippingMethodDetail();
}
private function chnageBillingTransportationTo(source:String):void
{
	if(source=='R')                             //  R for Retrive fucntion              
	{
		
	}
	else  // other 
	{
		tiAccountNo.dataValue		= tiAccountNo.defaultValue;
		//tiAmount.dataValue			= tiAmount.defaultValue;
		//lblShipAmountFormula.text	= '';
		getDefaultShipping();
	}
	if(cbBillingTransportationTo.dataValue=='Shipper (TEKWELD)')
	{
		tiAccountNo.enabled 		= false;
		//tiAmount.enabled			= false;
	}
	if(cbBillingTransportationTo.dataValue=='Shipper (TEKWELD)' && dcShipping_code.dataValue=='TRUCKING')
	{
		tiAccountNo.enabled 		= false;
		//tiAmount.enabled			= true;
	}
	if(cbBillingTransportationTo.dataValue=='Third Party' || cbBillingTransportationTo.dataValue== 'Receiver')
	{
		tiAccountNo.enabled 		= true;
		tiAccountNo.dataValue		= __localModel.default_customer_third_party_account_number;
	//	tiAmount.enabled			= false;
	}
	
	
}
private function setDefauiltThirdParty():void
{
	cbBillingTransportationTo.defaultValue  = __localModel.default_customer_bill_transportation_to;
	cbBillingTransportationTo.dataValue     = __localModel.default_customer_bill_transportation_to;
	tiAccountNo.dataValue					= __localModel.default_customer_third_party_account_number;
	dcShipping_code.dataValue				= __localModel.default_customer_shipping_code;
	dcShipping_code.labelValue				= __localModel.default_customer_shipping_code;
	
	chnageBillingTransportationTo('O');
}

[Bindable]
//private var eventTarget:Object = btnEdit;

private function editRowEventHandler(event:Event):void
{
	/*if(!__genModel.activeModelLocator.addEditObj.isRecordViewOnly)
	{
		eventTarget  = event.target;
		
		packetsPopWindow 			 = PacketsPopWindow(PopUpManager.createPopUp(this,PacketsPopWindow,true));
		packetsPopWindow.x			 = ((Application.application.width/2)-(packetsPopWindow.width/2));
		packetsPopWindow.y			 = ((Application.application.height/2)-(packetsPopWindow.height/2));
		packetsPopWindow.xml		 = new XML(<rows>
															<row>{eventTarget.id.toString()}</row>
															<row>{dgPackets.selectedRow}</row>
											   </rows>);
		
		packetsPopWindow.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,missingInfoSave);
		
	}*/
}
private function missingInfoSave(event:MissingInfoEvent):void
{
	var xmlMissingInfo:XML						= event.xml;
	
	var append_flag:String						= xmlMissingInfo.children()[0].toString();
	var rowXml:XML								= XML(XML(xmlMissingInfo.children()[1]).children()[0]);
	if(append_flag.toUpperCase()=='TRUE')
	{
	//	var tempXml:XML							= dgPackets.rows.copy();
	//	tempXml.appendChild(rowXml);
		//dgPackets.rows							= tempXml;
	}
	else
	{
		//dgPackets.selectedRow.setChildren(rowXml.children());
		//dgPackets.rows							= dgPackets.rows;
	}
	getDefaultShipping();
}
private function removeRowEventHandler():void
{
	/*if(!__genModel.activeModelLocator.addEditObj.isRecordViewOnly)
	{
		dgPackets.deleteRow(dgPackets.selectedIndex);
		
		var recordStatusEvent:RecordStatusEvent	 = new	RecordStatusEvent("MODIFY");
		recordStatusEvent.dispatch();
		
		getDefaultShipping();
	}*/
}
