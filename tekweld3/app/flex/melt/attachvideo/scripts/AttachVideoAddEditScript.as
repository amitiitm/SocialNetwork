import business.events.GetInformationEvent;
import business.events.PreSaveEvent;
import business.events.RecordStatusEvent;

import com.generic.components.FlvComponent;
import com.generic.events.AddEditEvent;
import com.generic.events.GenUploadButtonEvent;
import com.generic.genclass.GenValidator;
import com.generic.genclass.TabPage;

import flash.net.URLRequest;
import flash.net.navigateToURL;

import melt.attachvideo.AttachVideoModelLocator;
import melt.attachvideo.components.AttachVideo;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.CursorManager;

import valueObjects.AddEditVO;

private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:AttachVideoModelLocator = (AttachVideoModelLocator)(__genModel.activeModelLocator);

private var recordStatusEvent:RecordStatusEvent;
private var salt:String;
private var flvComp:FlvComponent;
private var videoPath:String;
private var packet_no:String;

[Embed(source='../../../com/generic/assets/nextbutton.JPG')]
public var nextEnable:Class;

private function init():void
{
	AttachVideo(this.parentDocument).bcpList.btnAdd.enabled=false;
}

private function handleUploadEvent(event:GenUploadButtonEvent):void
{
	CursorManager.setBusyCursor();
	Application.application.enabled = false;

	tiVideoFileName.text = event.fileName;
}

private function handleDownloadCompleteEvent(event:GenUploadButtonEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;

	Alert.show("Upload completed !")
	
	tiVideoFileName.text = event.downloadedObj.toString() + ".flv";
	
	addPlayer(videoPath + event.downloadedObj.toString()+".flv");
	
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
	packet_no  = event.recordXml.children()['trans_no'].toString();
	videoPath = __genModel.path.video;
	
	videoUrlLink.label="";
	salt = event.recordXml.children()[0]['salt'].toString();
	if(tiVideoFileName.text != "")
	{
		videoUrlLink.label="Customer's View";
	}
	
	addPlayer(videoPath + tiVideoFileName.text);
	tiCurrent_melting_stage_code.dataValue	=	"ATTACHVIDEO"
	
}



private function addPlayer(url:String):void
{
	vbPlayer.removeAllChildren();
	flvComp	=	new FlvComponent();
	flvComp.height				=	285;
	flvComp.width				=	444; 
	vbPlayer.addChild(flvComp);
	
	if(tiVideoFileName.dataValue != "")
	{
		flvComp.url = url;	
	}
	else
	{
		flvComp.url = "";
	}
	
}


public function nextClickHandler():void
{
	var genValidator:GenValidator = new GenValidator();
	var __addEditObj:AddEditVO = __genModel.activeModelLocator.addEditObj;
	var preSaveEvent:PreSaveEvent = new PreSaveEvent();
	
	
	if(!(genValidator.runCustomValidator(__addEditObj.validators) >= 0))
	{
		return;
	}
	else
	{
		preSaveEvent.dispatch();
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
	tabpage.openDrillDownPage("melt/metalanalysis/components/MetalAnalysis.swf");
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var returnValue:int = 0;
	
	var filename:Array  = tiVideoFileName.dataValue.split(".");
	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("SAVE");
			
	if(filename[0].toString() !=  packet_no)
	{
		Alert.show("File name should be same as Packet No.");
		returnValue = -1;
	}
	else
	{
		recordStatusEvent.dispatch();
		openNextPage();
		returnValue = 0;
	}
	return returnValue;
	
}