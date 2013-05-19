import business.events.GetInformationEvent;

import com.generic.components.FlvComponent;
import com.generic.events.AddEditEvent;

import melt.packettransaction.PacketTransactionModelLocator;
import melt.packettransaction.components.PacketTransaction;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.rpc.IResponder;

private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:PacketTransactionModelLocator = (PacketTransactionModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var flvComp:FlvComponent;

private function init():void
{
	PacketTransaction(this.parentDocument).bcpList.btnAdd.enabled=false;
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	tiTrans_no.enabled = false;
	
	if(event.recordXml.children()[0]['returnpacket'].toString() == "Y")
	{
		tiVideo_File_Name.dataValue = event.recordXml.children()[0]['return_pkt_video_file_name'].toString();
		addPlayer(__genModel.path.video + event.recordXml.children()[0]['return_pkt_video_file_name'].toString())
	}
	else 
	{
		if(tiVideo_File_Name.text != "")
		{
			addPlayer(__genModel.path.video + tiVideo_File_Name.text);	
		}
		else
		{
			addPlayer();
		}
	}
	
}

override protected function resetObjectEventHandler():void
{
	//tiTrans_no.enabled = true;
	getAccountPeriod();
}

private function getAccountPeriod():void
{
	if(dfTrans_date.text != '' && dfTrans_date.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent	= new GetInformationEvent('accountperiod', callbacks, dfTrans_date.text);
		getInformationEvent.dispatch();
	}
	
}

private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue = resultXml.child('code');
}

private function addPlayer(url:String = ""):void
{
	vbPlayer.removeAllChildren();
	flvComp	=	new FlvComponent();
	flvComp.height				=	285;
	flvComp.width				=	444; 
	vbPlayer.addChild(flvComp);
	
	if(url != "")
	{
		flvComp.url = url;
	}
	else
	{
		flvComp.url = "";
	}
}