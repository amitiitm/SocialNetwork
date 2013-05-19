import com.generic.customcomponents.GenDateField;
import com.generic.events.AddEditEvent;

import melt.printcheck.PrintCheckModelLocator;
import melt.printcheck.components.PrintCheck;

import model.GenModelLocator;

import mx.controls.Alert;

import valueObjects.ModeVO;

[Bindable]
private var __localModel:PrintCheckModelLocator = (PrintCheckModelLocator)(GenModelLocator.getInstance().activeModelLocator);

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var recordXml:XML;
private var melting_transaction_id:String

private function init():void
{
	PrintCheck(this.parentDocument).bcpList.btnAdd.enabled=false;
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	tiMelting_packet_request_id.dataValue = event.recordXml.children()['melting_packet_request_id'].toString();
	tiCheck_amt.text = tiOffer_amt.text;
	
	if(event.recordXml.children()[0]['check_date'].toString() == "")
	{
		dfCheckDate.dataValue = new GenDateField().currentDate();	
	}

	tiCurrent_melting_stage_code.dataValue	=	"PRINTCHECK";
	tiOpen_check.dataValue = "Y";
	tiEncashed_check.dataValue  = "N";
	
	recordXml = event.recordXml;
	
	if(__genModel.activeModelLocator.documentObj.selectedMode.toString() == ModeVO.LIST_MODE)
	{
		melting_transaction_id = recordXml.children()[0]['id'].toString();
		recordXml.children()[0]['id']='';
	}
	
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	recordXml.children()[0]['id'] = melting_transaction_id;
	
	return 0;	
}