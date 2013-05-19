import com.generic.events.AddEditEvent;

import melt.shippacketsend.ShipPacketSendModelLocator;
import melt.shippacketsend.components.ShipPacketSend;

import model.GenModelLocator;

[Bindable]
private var __localModel:ShipPacketSendModelLocator = (ShipPacketSendModelLocator)(GenModelLocator.getInstance().activeModelLocator);

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var recordXml:XML;
private var melting_transaction_id:String

private function init():void
{
	ShipPacketSend(this.parentDocument).bcpList.btnAdd.enabled=false;
	//tiCurrent_melting_stage_code.dataValue = "SHIPPACKETSEND";
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	
	tiCurrent_melting_stage_code.dataValue	=	"SHIPPACKETSEND"
}

