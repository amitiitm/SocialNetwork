import business.events.GetInformationEvent;
import business.events.PreSaveEvent;
import business.events.RecordStatusEvent;

import com.generic.events.AddEditEvent;
import com.generic.genclass.GenNumberFormatter;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;
import mx.rpc.IResponder;

import saoi.assignedartwork.AssignedArtworkModelLocator;
import saoi.assignedartwork.components.AssignedArtwork;
import saoi.assignedartwork.components.PopUpViewer;
import saoi.muduleclasses.MissingInfolViewer;
import saoi.muduleclasses.event.MissingInfoEvent;

private var preSaveEvent:PreSaveEvent;
private var numericFormatter:GenNumberFormatter 				= 	new GenNumberFormatter();
private var getInformationEvent:GetInformationEvent;
private var getInformationShippingEvent:GetInformationEvent;
private var item_detail:GetInformationEvent;
[Bindable]
private var __localModel:AssignedArtworkModelLocator = (AssignedArtworkModelLocator)(GenModelLocator.getInstance().activeModelLocator);
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
private var shipping_detail:GetInformationEvent;
private var isMissingInfoSave:Boolean	=	false;
private var optionXmlAfterSave:XML;
private var missingInfoWindow:PopUpViewer;
private var saveXml:XML;

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
}
								
private function init():void
{	
	numericFormatter.precision = 2;
	numericFormatter.rounding = "nearest";
	
	__localModel.trans_date = dfTrans_date.text	
	getAccountPeriod();
	
	dtlItem.bcdp.visible			= false;
	dtlItem.bcdp.includeInLayout	= false;
	tnDetail.selectedIndex			= 1;
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
		
		getCustomerShipping();
		__localModel.customer_id			= dcCustomer_id.dataValue;
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
	__localModel.customerShipping = resultXml;	
}

private function setValue(customerXml:XML):void
{
	dcShipping_code.dataValue = customerXml.children().child('shipping_code').toString();
	dcShipping_code.labelValue = customerXml.children().child('shipping_code').toString();
	dcTerm_code.dataValue = customerXml.children().child('term_code').toString();
	dcTerm_code.labelValue = customerXml.children().child('term_code').toString();
	

}
private function setShippingMethods():void
{
	if(dcShipping_code.text != '' && dcShipping_code.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getShippingDetailHandler, null);
		shipping_detail	=	new GetInformationEvent('fetch_shipvia_methods', callbacks, dcShipping_code.dataValue);
		shipping_detail.dispatch(); 
	}
}
private function getShippingDetailHandler(resultXml:XML):void
{
	dcShippingMethods.dataProvider	= resultXml.children();
	dcShippingMethods.dataValue		= '';
}
private function setShippingMethodToolTip():void
{
	if(dcShipping_code.text != '' && dcShipping_code.text != null)
	{
		dcShippingMethods.toolTip	= dcShippingMethods.selectedItem.ship_method_description.toString();
	}
}

//--------------------------------------------------------------------------------

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	getAccountPeriod();
	
	dcCustomer_id.enabled				=	true;
	__localModel.trans_date 			= dfTrans_date.text
	__localModel.trans_no				= '';
	__localModel.customer_id			= dcCustomer_id.dataValue;
	__localModel.ext_ref_no				= tiCustomer_po_id.text;
}
override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{
	var recordXml:XML					= event.recordXml;
	__localModel.ext_ref_no				= recordXml.sales_order.ext_ref_no.toString();
	__localModel.customer_id			= dcCustomer_id.dataValue;
}
private function isVersionFileAttach():Boolean
{
	var dgXml:XML = dtlArtwork.dgDtl.rows.copy();
	
	var returnValue:Boolean = false;
	for(var i:int = 0 ; i < dgXml.children().length(); i++)
	{
		var artwotkVersion:String  = dgXml.children()[i]['artwork_version'].toString();
		
		if(artwotkVersion.toUpperCase().search('VERSION')>=0)
		{
			returnValue = true;
			break;
		}
	}
	return returnValue;
}
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var returnValue:int	= -1 ;
	if(isArtworkVersionUnique())
	{
		returnValue  = 0;
	}
	else
	{
		Alert.show("Artwork Version Should Not Repeat");
		tnDetail.selectedIndex	= 1;
		dtlArtwork.dgDtl.selectedIndex  = selectUniqueArtworkVersionIndex;
		return -1;
	}
	if(cbArtworkComplete.dataValue=='Y' && (!isAllQueryAnswered()) )
	{
		Alert.show("Answer all queries before saving.");
		isMissingInfoSave   		 = false;
		return -1;
	}
	if(cbArtworkComplete.dataValue=='Y' && (!(isVersionFileAttach())))
	{
		Alert.show("Upload One Version File Before Ready For Internal Proofing Done.");
		return -1;
	}
	if(isMissingInfoSave)
	{
		isMissingInfoSave = false;
		returnValue =  0;
	}
	else if(isAllQueryAnswered())
	{
		openMissingInfoScreen();
		return -1;
	}
	
	return returnValue; 
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

private function openMissingInfoScreen():void
{
	missingInfoWindow 			 = PopUpViewer(PopUpManager.createPopUp(this,PopUpViewer,true));
	missingInfoWindow.x			 = ((Application.application.width/2)-(missingInfoWindow.width/2));
	missingInfoWindow.y			 = ((Application.application.height/2)-(missingInfoWindow.height/2));
	missingInfoWindow.orderDetail = new XML(<orderDetail>
											<missinginfo></missinginfo>
											<screenview></screenview>
												<checkboxdata>
												<cbartworkcomplete_flag>{cbArtworkComplete.dataValue}</cbartworkcomplete_flag>	
												</checkboxdata>
											</orderDetail>);
	
	missingInfoWindow.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,missingInfoSave);
}
private function missingInfoSave(event:MissingInfoEvent):void
{
	var xmlMissingInfo:XML					= event.xml;
	isMissingInfoSave   					= true;
	cbArtworkComplete.dataValue 			= 	xmlMissingInfo.cbartworkcomplete_flag.toString() ;
	
	preSaveEvent = new PreSaveEvent();
	preSaveEvent.dispatch();
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