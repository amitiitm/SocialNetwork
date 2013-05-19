import business.events.GetInformationEvent;
import business.events.RecordStatusEvent;

import com.generic.components.FlvComponent;
import com.generic.customcomponents.GenDateField;
import com.generic.events.AddEditEvent;
import com.generic.events.GenUploadButtonEvent;

import flash.net.URLRequest;
import flash.net.navigateToURL;

import melt.returnpacket.ReturnPacketModelLocator;
import melt.returnpacket.components.ReturnPacket;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.CursorManager;

private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:ReturnPacketModelLocator = (ReturnPacketModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var recordStatusEvent:RecordStatusEvent;
private var salt:String;
private var flvComp:FlvComponent;
private var videoPath:String;

private function init():void
{
	ReturnPacket(this.parentDocument).bcpList.btnAdd.enabled=false;
}

private function handleUploadEvent(event:GenUploadButtonEvent):void
{
	CursorManager.setBusyCursor();
	Application.application.enabled = false;

	tiReturnVideoFileName.text = event.fileName;
}

private function handleDownloadCompleteEvent(event:GenUploadButtonEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;

	Alert.show("Upload completed !")
	
	tiReturnVideoFileName.text = event.downloadedObj.toString() + ".flv";
	
	addPlayer(videoPath + event.downloadedObj.toString()+".flv");
	
	//videoUrlLink.label="http://select.melting.diasparkonline.com:5005/#type=CUST&value="+salt;
	videoUrlLink.label="Customer's View";
	recordStatusEvent = new RecordStatusEvent("MODIFY");
	recordStatusEvent.dispatch();

}

private function openVideo():void
{
	navigateToURL(new URLRequest("http://select.melting.diasparkonline.com:5005/#type=CUST&value="+salt));
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	tiMelting_packet_request_id.dataValue = event.recordXml.children()['melting_packet_request_id'].toString();
	
	if(event.recordXml.children()[0]['ship_date'].toString() == "")
	{
		dfShip_date.dataValue = new GenDateField().currentDate();	
	}
	
	videoPath = __genModel.path.video;
	
	videoUrlLink.label="";
	salt = event.recordXml.children()[0]['salt'].toString();
	if(tiReturnVideoFileName.text != "")
	{
		//videoUrlLink.label="http://select.melting.diasparkonline.com:5005/#type=CUST&value="+salt;
		videoUrlLink.label="Customer's View";
	}
	
	
	addPlayer(videoPath + tiReturnVideoFileName.text);
	tiCurrent_melting_stage_code.dataValue	=	"RETURNPACKET"
	
}
private function addPlayer(url:String):void
{
	vbPlayer.removeAllChildren();
	flvComp	=	new FlvComponent();
	flvComp.height				=	285;
	flvComp.width				=	444; 
	vbPlayer.addChild(flvComp);
	
	if(tiReturnVideoFileName.text != "")
	{
		flvComp.url = url;	
	}
	else
	{
		flvComp.url = "";
	}
}