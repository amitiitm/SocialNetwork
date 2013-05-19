import business.events.GetInformationEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.components.DataEntry;
import com.generic.events.AddEditEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.genclass.TabPage;
import com.generic.genclass.URL;
import com.generic.genclass.Utility;

import flash.utils.Timer;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.Label;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.formatters.DateFormatter;
import mx.managers.CursorManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import saoi.muduleclasses.GenNotesAttachmentIcon;
import saoi.orderrevertstage.OrderRevertstageModelLocator;
import saoi.orderrevertstage.components.OrderRevertstage;

private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
private var getInformationShippingEvent:GetInformationEvent;
private var item_detail:GetInformationEvent;
[Bindable]
private var __localModel:OrderRevertstageModelLocator = (OrderRevertstageModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
private var image_name:String;

[Bindable]
private var main_image_name:String;

[Bindable]
private var reorderEnable:Boolean = true;
[Bindable]
private var optionEnable:Boolean = true;
private var selectUniqueArtworkVersionIndex:int=0;
public var refreshTimer:Timer  = new Timer(__genModel.screenRefreshTimeInterval);
public var remainTimer:Timer  = new Timer(1000);
private var __refreshList:IResponder;
private var __service:ServiceLocator = __genModel.services;
[Bindable]
public var remainingTime:int=(__genModel.screenRefreshTimeInterval)/1000;
private var shipping_detail:GetInformationEvent;

private var optionXmlAfterSave:XML;

private var saveXml:XML;
private var screenName:String = '';

[Bindable]
private var orderStages:XML	 = new XML(<rows><row><label></label><value></value></row></rows>);
/* private function setAccountNo():void
{
	if(dcShipping_code.selectedItem.code == 'THIRDPARTY')
	{
		tiAccountNo.enabled = true;
	}
	else
	{
		tiAccountNo.dataValue = '';
		tiAccountNo.enabled = false;
	}
}
 */
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
public function setMainImage(resultXml:XML):void
{

	if(resultXml.image_thumnail!='')
	main_image_name = resultXml.image_thumnail;
	else
	main_image_name = '';
	
}
							

private function init():void
{
	screenName = __genModel.tabMain.selectedChild.label;
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	
	__localModel.trans_date = dfTrans_date.text	
	getAccountPeriod();
	//setReorder();
	
	var refreshLabel:Label  = new Label();
	refreshLabel.name		= "refreshLabel";
	refreshLabel.text		= "refresh within "+remainingTime.toString()+" sec.";
	refreshLabel.height     = 20;
	refreshLabel.setStyle("color","#356DCC");
	refreshLabel.setStyle("fontSize",11);
	refreshLabel.setStyle("fontWeight","bold");
	
	OrderRevertstage(this.parentDocument).bcpList.addChild(refreshLabel);
	refreshTimer.addEventListener(TimerEvent.TIMER,refreshTimerPickHandler);
	remainTimer.addEventListener(TimerEvent.TIMER,remainTimerPickHandler);
	//refreshTimer.start();
	//remainTimer.start();

}
private function refreshTimerPickHandler(event:TimerEvent):void
{
	var tabpage:TabPage =  new TabPage();
	var index:int = tabpage.searchTabPage(screenName);
	if(index>0)
	{
		refreshPickHandler();
		remainingTime = (__genModel.screenRefreshTimeInterval)/1000;
	}
	else
	{
		refreshTimer.stop();
		remainTimer.stop();
	}
	
}
public function dataService(service:HTTPService):HTTPService
{
	var urlObj:URL	=	new URL();
	service.url		=	urlObj.getURL(service.url);
	service.resultFormat 		= "e4x";					
	service.method 				= "POST";
	service.useProxy			= false;
	service.contentType			="application/xml";
	service.requestTimeout	 	= 1800
	
	return service;
}


private function refreshPickHandler():void
{
	/*CursorManager.setBusyCursor();
	
	var refresh:HTTPService = dataService(__service.getHTTPService("getList"));
	__refreshList = new mx.rpc.Responder(refreshResultHandler,refreshFaultHandler);
	var token:AsyncToken = refresh.send(__localModel.viewObj.selectedView);
	token.addResponder(__refreshList);	*/
}


private function refreshResultHandler(event:ResultEvent):void
{
	var resultXML:XML;
	var utilityObj:Utility	=	new Utility();
	resultXML 				= 	utilityObj.getDecodedXML((XML)(event.result));
	
	__localModel.listObj.rows = new XML(resultXML);   	
	__localModel.listObj.filteredList = new XML(resultXML);
	CursorManager.removeBusyCursor();
}
public function refreshFaultHandler(event:FaultEvent):void
{
	Alert.show("OrderRevertstage"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
}

private function remainTimerPickHandler(event:TimerEvent):void
{
	Label(OrderRevertstage(this.parentDocument).bcpList.getChildByName("refreshLabel")).text =	"refresh within "+remainingTime.toString()+" sec."; ;
	remainingTime = remainingTime - 1;	
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
	if(dcCustomer_id.text != "" && dcCustomer_id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(customerDetailsHandler, null);
		
		getInformationEvent			=	new GetInformationEvent('customerdetail', callbacks, dcCustomer_id.dataValue, "I");
		getInformationEvent.dispatch();
		
		getCustomerShipping();
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
}
private function customerShippingDetailsHandler(resultXml:XML):void
{
	//__localModel.customerShipping = resultXml;	
}

private function setValue(customerXml:XML):void
{
	//dcShipping_code.dataValue = customerXml.children().child('shipping_code').toString();
	//dcTerm_code.dataValue = customerXml.children().child('term_code').toString();
	
	/* tiAccounts.dataValue = customerXml.children().child('account_dept_email').toString();
	tiShipping.dataValue 		= customerXml.children().child('shipping_dept_email').toString();
	tiPurchase.dataValue	=	 customerXml.children().child('purchase_dept_email').toString();
	tiCorrespondense.dataValue=	 customerXml.children().child('corr_dept_email').toString();
	tiArt_work.dataValue	=	 customerXml.children().child('artwork_dept_email').toString();
	cbPPRequired_flag.dataValue	= customerXml.children().child('paper_proof_flag').toString(); */

}
private function setShippingMethods():void
{
	/* if(dcShipping_code.dataValue != '' && dcShipping_code.dataValue != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getShippingDetailHandler, null);
		shipping_detail	=	new GetInformationEvent('fetch_shipvia_methods', callbacks, dcShipping_code.dataValue);
		shipping_detail.dispatch(); 
	} */
}
private function getShippingDetailHandler(resultXml:XML):void
{
	//dcShippingMethods.dataProvider	= resultXml.children();
	//dcShippingMethods.dataValue		= '';
}
private function setShippingMethodToolTip():void
{
	/* if(dcShipping_code.dataValue != '' && dcShipping_code.dataValue != null)
	{
		dcShippingMethods.toolTip	= dcShippingMethods.selectedItem.ship_method_description.toString();
	} */
}
//--------------------------------------------------------------------------------
override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	var recordXml:XML		= event.recordXml;
	saveXml					= event.recordXml.copy();
	
	if(recordXml.sales_order.trans_type.toString()!='E')
	{
		hbRef.visible = false;
		hbRef.includeInLayout = false;
	}
	else
	{
		hbRef.visible = true;
		hbRef.includeInLayout = true;
	}
	dcCustomer_id.enabled	=	false;
	
	
	
	var stageLength:int	= orderStages.children().length();
	for(var i:int=0;i<stageLength;i++)
	{
		delete orderStages.child('row')[0];
	}
	
	var tempXml:XML	= XML(recordXml.sales_order.values);
	for(var i:int=0;i<tempXml.children().length();i++)
	{
		var tempChild:XMLList  = new XMLList(<row></row>);
		tempChild.label    = tempXml.children()[i].toString();
		tempChild.value    = tempXml.children()[i].toString();
		orderStages.appendChild(tempChild);
	}
	if(orderStages.children().length()<1)
	{
		orderStages = new XML(<rows><row><label></label><value></value></row></rows>);
	}
	//dcOrder_Revert_status.filterKeyValue = '\''+tiOrderStatus.dataValue+ '\'' +',' + '\''+tiArtwork_status.dataValue+'\'';
	
	setRevertOrderStage(orderStages);
	
	__localModel.artwork_dept_email	= recordXml.sales_order.artwork_dept_email.toString();
	__localModel.trans_no  = recordXml.sales_order.trans_no.toString();
	__localModel.ext_ref_no = recordXml.sales_order.ext_ref_no.toString();
	__localModel.trans_date = dfTrans_date.text
	
	var genNotesAttachmentIcon:GenNotesAttachmentIcon  = new GenNotesAttachmentIcon();
	genNotesAttachmentIcon.changeIcon(__localModel,DataEntry(this.parentDocument));
}
private function setRevertOrderStage(xml:XML):void
{
	cbOrder_Revert_status.dataProvider  = xml.children();
}
override protected function resetObjectEventHandler():void   //on add buttton press,
{

	getAccountPeriod();

	dcCustomer_id.enabled	=	true;
	//cbOrder_type.enabled	=	true;
	
	__localModel.trans_date = dfTrans_date.text
	__localModel.trans_no	= '';
	__localModel.ext_ref_no	= '';
	__localModel.artwork_dept_email	= '';
	
	var genNotesAttachmentIcon:GenNotesAttachmentIcon  = new GenNotesAttachmentIcon();
	genNotesAttachmentIcon.changeIcon(__localModel,DataEntry(this.parentDocument));
}


override protected function preSaveEventHandler(event:AddEditEvent):int
{
	/* if(isArtworkVersionUnique())
	{
		return 0 ;
	}
	else
	{
		Alert.show("Artwork Version Should Not Repeat");
		//tnDetail.selectedIndex	= 0;
		//dtlArtwork.dgDtl.selectedIndex  = selectUniqueArtworkVersionIndex;
		return -1;
	} */
	return 0;
}
/* private function isArtworkVersionUnique():Boolean
{
	var dgXml:XMLList  = dtlArtwork.dgDtl.rows.(trans_flag='A');
	var returnValue:Boolean = true;
	for(var i:int = 0 ; i < dgXml.children().length()-1; i++)
	{
		var artwotkVersion1:String  = dgXml.children()[i]['artwork_version'].toString();
		var artwotkVersion2:String  = dgXml.children()[i+1]['artwork_version'].toString();
		if(artwotkVersion1.toUpperCase()==artwotkVersion2.toUpperCase())
		{
			returnValue = false;
			selectUniqueArtworkVersionIndex = i;
			break;
		}
	}
	return returnValue;
}	 */