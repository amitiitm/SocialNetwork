import business.events.RecordStatusEvent;

import com.generic.genclass.URL;

import flash.events.DataEvent;
import flash.filesystem.File;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.DataGrid;
import mx.events.DataGridEvent;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.http.HTTPService;

import saoi.muduleclasses.event.MissingInfoEvent;
import saoi.orderreceive.OrderReceiveModelLocator;
import saoi.orderreceive.components.ArtworkGridComboBoxRenderer;

[Bindable]
private var __localModel:OrderReceiveModelLocator 			= (OrderReceiveModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator 						= GenModelLocator.getInstance();
[Bindable]
private var _attachmentXml:XML;
private var urlObj:URL							=	new URL();
private var urlartworkUploadUrl:String  		=	urlObj.getURL(__genModel.services.getHTTPService("artworkUploadUrl").url.toString());
private var _request:URLRequest 				= new URLRequest(urlartworkUploadUrl);
private var current_uploading_index:int = 0

public function set attachmentXml(attachmentXml:XML):void
{
	this._attachmentXml = attachmentXml;
	dgAttachment.dataProvider = this._attachmentXml.children();
}

public function get attachmentXml():XML
{
	return _attachmentXml;
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

private function btnUploadHandler():void
{
	if(XMLList(XMLList(dgAttachment.dataProvider).(attachment_type != '')).length() == 0)
	{
		Alert.show('Please select atleast 1 Attachment type');
		return
	}
	
	CursorManager.setBusyCursor();
	this.parentDocument.enabled  = false;
	
	for (var i:Number = 0; i < XMLList(dgAttachment.dataProvider).length(); i++)
	{
		if(XMLList(dgAttachment.dataProvider)[i]['attachment_type'].toString() != '')
		{
			var _variables:URLVariables = 	 new URLVariables();
			_variables.file_name 		= 	 XMLList(dgAttachment.dataProvider)[i]['name'].toString();
			
			_request.method 			= 	URLRequestMethod.POST;
			_request.data 				= 	_variables;	
			
			var file:File = new File(XMLList(dgAttachment.dataProvider)[i]['attachment_path'].toString());
			
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,handleResponseCompleteData);
			file.upload(_request);
		}
	}
}

private function handleResponseCompleteData(event:DataEvent):void
{
	var result:String = event.data.toString();
	current_uploading_index += 1;
	
	if(result=='Attachment Upload Successfull')
	{
		var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent('MODIFY');
		recordStatusEvent.dispatch();
	}
	else
	{}
	
	if(current_uploading_index == XMLList(XMLList(dgAttachment.dataProvider).(attachment_type != '')).length())
	{
		Alert.show('Attachments uploaded');
		CursorManager.removeBusyCursor();
		this.parentDocument.enabled  = true;
	}
}

private function btnCloseClickHandler():void
{
	if(current_uploading_index == 0)
	{
		Alert.show('Please first upload the attachments');
		return
	}
	
	var sales_order_artwork_xml:XML = new XML(<sales_order_artworks/>);
	
	for (var i:Number = 0; i < XMLList(dgAttachment.dataProvider).length(); i++)
	{
		if(XMLList(dgAttachment.dataProvider)[i]['attachment_type'].toString() != '')
		{
			var artwork_line_xml:XML = new XML(<sales_order_artwork/>);
			
			artwork_line_xml.artwork_file_name = XMLList(dgAttachment.dataProvider)[i]['name'].toString()
			artwork_line_xml.artwork_version   = XMLList(dgAttachment.dataProvider)[i]['attachment_type'].toString()
			artwork_line_xml.comment		   = XMLList(dgAttachment.dataProvider)[i]['artwork_comment'].toString()
			artwork_line_xml.trans_flag		   = 'A'
			sales_order_artwork_xml.appendChild(artwork_line_xml);
		}
	}
	
	var missingInfoEvent:MissingInfoEvent = new MissingInfoEvent(MissingInfoEvent.MissingInfoEvent_Type,sales_order_artwork_xml);
	this.dispatchEvent(missingInfoEvent);
	
	PopUpManager.removePopUp(this);
}

private function updateGridDataprovider(event:DataGridEvent):void
{
	//Alert.show(ArtworkGridComboBoxRenderer(DataGrid(event.currentTarget).itemEditorInstance).updated_value)
}