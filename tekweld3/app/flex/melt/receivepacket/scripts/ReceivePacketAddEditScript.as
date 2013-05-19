import business.events.GetInformationEvent;
import business.events.PreSaveEvent;
import business.events.RecordStatusEvent;

import com.generic.events.AddEditEvent;
import com.generic.genclass.GenValidator;
import com.generic.genclass.TabPage;

import flash.events.TextEvent;

import melt.receivepacket.ReceivePacketModelLocator;
import melt.receivepacket.components.ReceivePacket;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.events.ValidationResultEvent;
import mx.formatters.NumberFormatter;
import mx.rpc.IResponder;

import valueObjects.AddEditVO;

private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:ReceivePacketModelLocator = (ReceivePacketModelLocator)(__genModel.activeModelLocator);

[Embed(source='../../../com/generic/assets/nextbutton.JPG')]
public var nextEnable:Class;
private var nextFlag:int;

private function init():void
{
	getAccountPeriod();
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	tiTrans_no.enabled = false;
	tiCurrent_melting_stage_code.dataValue	=	"RECEIVEPACKET"
		
	if(tiReceive_Tracking_no.dataValue != '')
	{
		tiReceive_Tracking_no.enabled = false;
	}
	
	if(dcReceived_Via.dataValue != '')
	{
		dcReceived_Via.enabled  = false;
	}
}

override protected function resetObjectEventHandler():void
{
	tiTrans_no.enabled = true;
	getAccountPeriod();
	dcReceived_Via.enabled = true;
	tiReceive_Tracking_no.enabled = true;
	ticountry.dataValue = 'USA';
	tiEmail.addEventListener(TextEvent.TEXT_INPUT,onTextInput);
	tiReTypeEmail.addEventListener(TextEvent.TEXT_INPUT,onTextInput);
	dcRetailer.enabled = true;
	dcReceived_Via.enabled = true;
}

private function getAccountPeriod():void
{
	if(dfTrans_date.dataValue != '' && dfTrans_date.dataValue != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent	= new GetInformationEvent('accountperiod', callbacks, dfTrans_date.dataValue);
		getInformationEvent.dispatch();
	}
}

private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue = resultXml.child('code');
}

private function checkReTypeEmail():void
{
	if(tiEmail.text != tiReTypeEmail.text)
	{
		tiReTypeEmail.text = "";
		tiEmail.text 	   = "";	
	}
	
	if(tiEmail.text == "")
		tiReTypeEmail.text = "";
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	
	var returnValue:int = 0;
	var emailValid:ValidationResultEvent = emailValidator.validate();
	
	if(emailValid.type == ValidationResultEvent.INVALID)
	{
		Alert.show("Customer email is not valid..!!")
		returnValue = -1;
	}
	
	if(tiEmail.text != tiReTypeEmail.text)
	{
		tiEmail.text = "";
		tiReTypeEmail.text = "";
		returnValue = -1;
	}
	
	nextFlag = returnValue;
	
	return returnValue;
	
}

public function nextClickHandler():void
{
	var genValidator:GenValidator = new GenValidator();
	var __addEditObj:AddEditVO = __genModel.activeModelLocator.addEditObj;
	var preSaveEvent:PreSaveEvent = new PreSaveEvent();
	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("SAVE");
	
	if(!(genValidator.runCustomValidator(__addEditObj.validators) >= 0))
	{
		return;
	}
	else
	{
		preSaveEvent.dispatch();
	}
	
	if(ReceivePacket(this.parentDocument).bcpDataEntry.btnSave.enabled)
	{
		if(nextFlag != -1)
		{
			recordStatusEvent.dispatch();
			openNextPage();
		}
	}
	else
	{
		if(tiTrans_no.dataValue != '')
		{
			openNextPage();
		}
	}
}

private function openNextPage():void
{
	var critriaXML:XML					=	new XML(<root>
														<trans_no>{tiTrans_no.dataValue}</trans_no>
														<trans_date>{dfTrans_date.dataValue}</trans_date>
													</root>)

	__genModel.drillObj.drillrow		=	critriaXML
	var tabpage:TabPage	=	new TabPage();
	tabpage.openDrillDownPage("melt/attachvideo/components/AttachVideo.swf");
}

private function onTextInput(event:flash.events.TextEvent):void
{
  if (event.text.length > 1)
    event.preventDefault();
}

private function getCustomerInfo():void
{
	if(tiTrans_no.dataValue != '')
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(getPacketInfoHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('meltingpacketinfo', callbacks, tiTrans_no.dataValue);
		getInformationEvent.dispatch();
	}
}

private function getPacketInfoHandler(resultXml:XML):void
{
	
	tiCustomer_Name.dataValue				 =  resultXml.children()['customer_name'].toString();
	tiaddress1.dataValue					 =	resultXml.children()['customer_address1'].toString();
	tiaddress2.dataValue	 				 =  resultXml.children()['customer_address2'].toString();
	ticity.dataValue						 =  resultXml.children()['customer_city'].toString();
	tistate.dataValue						 =  resultXml.children()['customer_state'].toString();
	tizip.dataValue							 =  resultXml.children()['customer_zip'].toString();
	ticountry.dataValue						 =  resultXml.children()['customer_country'].toString();
	tiphone1.dataValue						 =  resultXml.children()['customer_phone'].toString();
	tiEmail.dataValue						 = 	resultXml.children()['customer_email_id'].toString();
	tiReTypeEmail.dataValue					 =  resultXml.children()['customer_email_id'].toString();
	tiReceive_Tracking_no.dataValue 		 = 	resultXml.children()['receive_tracking_no'].toString();
	dcReceived_Via.dataValue				 = 	resultXml.children()['receive_ship_via'].toString();
	tiMelting_packet_request_id.dataValue	 = 	resultXml.children()['id'].toString();
	tiRetailerRef.dataValue					 = 	resultXml.children()['retailer_ref_no'].toString();
	dcRetailer.dataValue				 	 =  resultXml.children()['melting_retailer_id'].toString()
	
	if(dcRetailer.dataValue != '')
	{
		dcRetailer.enabled = false;
	}
	else
	{
		dcRetailer.enabled = true;		
	}
	
	if(dcReceived_Via.dataValue != '')
	{
		dcReceived_Via.enabled = false;
	}
	else
	{
		dcReceived_Via.enabled = true;
	}
}

