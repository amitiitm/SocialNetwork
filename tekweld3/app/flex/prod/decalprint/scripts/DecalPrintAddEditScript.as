import business.events.PreSaveEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.customcomponents.GenButton;
import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;
import com.generic.genclass.URL;

import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.FileReference;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.navigateToURL;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.Spacer;
import mx.events.CloseEvent;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import prod.decalprint.DecalPrintModelLocator;
import prod.decalprint.components.DecalPrint;


[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:DecalPrintModelLocator =  DecalPrintModelLocator(__genModel.activeModelLocator);
public  var fileRefDown:FileReference = new FileReference();

[Embed("com/generic/assets/btn_download_imposition.png")]
private const downloadImpositionButtonIcon:Class;
[Embed("com/generic/assets/btn_view_imposition_file.png")]
private const viewImpositionButtonIcon:Class;
[Embed("com/generic/assets/btn_view_proofs.png")]
private const viewProofButtonIcon:Class;
[Embed("com/generic/assets/btn_print_indigo_slip.png")]
private const printIndigoSlipButtonIcon:Class;


private var __service:ServiceLocator = __genModel.services;
private var __refreshList:IResponder;
private var __responder:IResponder;
private var isMissingInfoSave:Boolean	=	false;
private var preSaveEvent:PreSaveEvent;
private var btnPrintIndigoSlip:Button
private var urlReq:URLRequest;
private var urlLdr:URLLoader;

private function handleInboxItemFocusOut(event:InboxEvent):void
{
	var oldValue:String = event.oldValues["print_flag"].toString();
	var indigo_code:String	= inbox.focusedRow["indigo_code"].toString();
	
	if(event.newValues["select_yn"] == 'Y')
	{
		//inbox.focusedRow["accept_yn"] = 'Y';
		if(event.object.id == 'accept_yn')
		{
			if(event.newValues["accept_yn"] == 'Y')
			{
				inbox.focusedRow["print_flag"] = 'Y';
				inbox.focusedRow["reject_yn"] = "";
				setAccept();
				
			}
			else
			{
				inbox.focusedRow["print_flag"] = 'N';
				inbox.focusedRow["reject_yn"] = "Y";
				inbox.focusedRow["accept_yn"] = "N";
				setReject();
			
			} 
		}
		else if(event.object.id == 'reject_yn')
		{
			if(event.newValues["reject_yn"] == 'Y')
			{
				inbox.focusedRow["print_flag"] = 'N';
				inbox.focusedRow["accept_yn"] = "";
				setReject();
			}
			else
			{
				inbox.focusedRow["print_flag"] = 'Y';
				inbox.focusedRow["accept_yn"] = "Y";
				inbox.focusedRow["reject_yn"] = "N";
				setAccept();
			} 
		}
		else if(event.object.id == 'select_yn')
		{
			setRecord(indigo_code,"Y");
			inbox.focusedRow["reject_yn"] = "";
		}
		
	}
	else
	{
		inbox.focusedRow["accept_yn"] = "";
		inbox.focusedRow["reject_yn"] = "";
		inbox.focusedRow["print_flag"] = oldValue;
		setRecord(indigo_code,"N");
	}  	
}
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	if(inbox.selectedRows.children().length()<=0)
	{
		return -1;
	}
	var retValue:int = 0;
	
	for(var i:int=0; i<inbox.dgDtl.dataProvider.length; i++)
	{
		if(inbox.dgDtl.dataProvider[i]["select_yn"] == "Y")
		{
			if(inbox.dgDtl.dataProvider[i]["reason"] == '' && inbox.dgDtl.dataProvider[i].reject_yn.toString() == "Y")
			{
				retValue = -1;
				Alert.show("Enter Job rejection reason.");
				break
			}						
		}	
	}
	
	if(isMissingInfoSave)
	{
		isMissingInfoSave = false;
		retValue =0;
	}
	else
	{
		Alert.show("Do You Want to print indigo slip ?","Indigo Slip",Alert.YES | Alert.NO,this,discardChangeEvent,null,Alert.YES);
		return -1;
	}

	return retValue;
}
private function discardChangeEvent(event:CloseEvent):void
{
	if(event.detail == Alert.YES)
	{
		btnPrintIndigoSlip.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
	}
	else
	{
		
	}
	isMissingInfoSave	=	true;
	preSaveEvent = new PreSaveEvent();
	preSaveEvent.dispatch();
}
private function setRecord(indigo_code:String,value:String):void
{
	for(var i:int=0; i<inbox.dgDtl.rows.children().length(); i++)
	{
		if(inbox.dgDtl.rows.children()[i]["indigo_code"].toString() == indigo_code)
		{
			inbox.dgDtl.rows.children()[i].select_yn  = value;
			inbox.dgDtl.rows.children()[i].accept_yn  = value;
		}	
	}
}
private function setAccept():void
{
	for(var i:int=0; i<inbox.dgDtl.rows.children().length(); i++)
	{
		if(inbox.dgDtl.rows.children()[i]["select_yn"].toString() == 'Y')
		{
			inbox.dgDtl.rows.children()[i].accept_yn  = "Y";
			inbox.dgDtl.rows.children()[i].reject_yn  = "N";
		}	
	}
}
private function setReject():void
{
	for(var i:int=0; i<inbox.dgDtl.rows.children().length(); i++)
	{
		if(inbox.dgDtl.rows.children()[i]["select_yn"].toString() == 'Y')
		{
			inbox.dgDtl.rows.children()[i].reject_yn  = "Y";
			inbox.dgDtl.rows.children()[i].accept_yn  = "N";
		}	
	}
}
private function isSameTypeSelected():Boolean
{
	var returnValue:Boolean	= true;
	
	var indigo_code:String	= inbox.selectedRows.children()[0].indigo_code.toString();
	
	for(var i:int=1;i<inbox.selectedRows.children().length();i++)
	{
		var indigo_code_temp:String	= inbox.selectedRows.children()[i].indigo_code.toString();
		if(indigo_code.toUpperCase()!=indigo_code_temp.toUpperCase())
		{
			returnValue	= false;
		}
	}
	return returnValue;
}
private function addOptionBar():void
{
	var hb:HBox    = new HBox();
	hb.setStyle('horizontalGap' , 10);
	
	var sp:Spacer  = new Spacer();
	sp.width     =   2;	
	
	
	var btnIndigo:Button        		= new Button();
	btnIndigo.height							= 20;
	btnIndigo.label						= "VIEW IMPOSITION FILE";
	btnIndigo.styleName					= "promoButton";
	//btnIndigo.setStyle('icon' , viewImpositionButtonIcon);
	btnIndigo.addEventListener(MouseEvent.CLICK,viewClickHandler);
	
	var btnUpload:Button        		= new Button();
	btnUpload.height					= 20;
	btnUpload.label						= "DOWNLOAD IMPOSITION FILE";
	btnUpload.styleName					= "promoButton";
	//btnUpload.setStyle('icon' , downloadImpositionButtonIcon);
	btnUpload.addEventListener(MouseEvent.CLICK,downloadFileClickHandler);
	
	var btnViewProof:Button        			= new Button();
	btnViewProof.height						= 20;
	btnViewProof.label						= "VIEW PROOF";
	btnViewProof.styleName					= "promoButton";
	//btnViewProof.setStyle('icon' , viewProofButtonIcon);
	btnViewProof.addEventListener(MouseEvent.CLICK,viewProofClickHandler);
	
	
	btnPrintIndigoSlip        				= new Button();
	btnPrintIndigoSlip.height				= 20;
	btnPrintIndigoSlip.label				= "PRINT INDIGO SLIP";
	btnPrintIndigoSlip.styleName					= "promoButton";
	//btnPrintIndigoSlip.setStyle('icon' , printIndigoSlipButtonIcon);
	btnPrintIndigoSlip.addEventListener(MouseEvent.CLICK,PrintIndigoSlipClickHandler);
	
	var space:Spacer  = new Spacer();
	space.width 	  = 200;
	
	hb.addChild(space); 
	hb.addChild(btnViewProof);
	hb.addChild(btnIndigo);
	hb.addChild(btnUpload);
	hb.addChild(btnPrintIndigoSlip);
	
	
	DecalPrint(this.parentDocument).bcp.addChildAt(hb,7);
}
private function PrintIndigoSlipClickHandler(event:MouseEvent):void
{
	if(inbox.selectedRows.children().length()>0)
	{
		var http:HTTPService = dataService(__service.getHTTPService("printIndigoSlip"));
		__responder = new mx.rpc.Responder(printIndigoSlipResultHandler,printIndigoSlipFaultHandler);
		var tempXml:XML   = new XML(<params><indigo_code>{inbox.selectedRows.children()[0].indigo_code.toString()}</indigo_code></params>);
		var token:AsyncToken = http.send(tempXml);
		token.addResponder(__responder);
	}
	else
	{
		Alert.show("Please Select Records");
	}

	
}
private function printIndigoSlipResultHandler(event:ResultEvent):void
{
	var resultXml:XML		= XML(event.result);
	
	if(resultXml.name() == "errors")
	{
		if(resultXml.children().length() > 0) 
		{
			var message:String = '';
			
			for(var i:uint = 0; i < resultXml.children().length(); i++) 
			{
				message += resultXml.children()[i] + "\n";
			}
			Alert.show(message);
		} 
	}
	else
	{
		var fileName:String  = resultXml.children()[0].toString();
		var url:String  	 =	__genModel.path.report_print+fileName;
		var _requestViewUrl:URLRequest = new URLRequest(url);
		navigateToURL(_requestViewUrl); 
	}
}
private function printIndigoSlipFaultHandler(event:FaultEvent):void
{
	Alert.show("printIndigoSlip"+event.fault.faultDetail);
}
private function getParamXml():XML
{
	var tempXml:XML	= new XML(<params></params>);
	for(var i:int=0;i<inbox.selectedRows.children().length();i++)
	{
		var id:String	    = inbox.selectedRows.children()[i].id.toString();
		var childXml:XML	= new XML('<id>'+id+'</id>');
		tempXml.appendChild(childXml.copy());
	}
	return tempXml;
}
private function viewProofClickHandler(event:MouseEvent):void
{
	if(inbox.selectedRows.children().length()>=1)
	{
		if(isSameTypeSelected())
		{
			var viewProof:HTTPService = dataService(__service.getHTTPService("viewProof"));
			__refreshList = new mx.rpc.Responder(viewproofResultHandler,viewproofFaultHandler);
			var token:AsyncToken = viewProof.send(getParamXml());
			token.addResponder(__refreshList);	
		}
		else
		{
			Alert.show("Please Select Record with same indigo # ");
		}
	}
	else
	{
		Alert.show("Please Select Record");
	}
}
private function viewproofResultHandler(event:ResultEvent):void
{
	var resultXml:XML		= XML(event.result);
	
	if(resultXml.name() == "errors")
	{
		if(resultXml.children().length() > 0) 
		{
			var message:String = '';
			
			for(var i:uint = 0; i < resultXml.children().length(); i++) 
			{
				message += resultXml.children()[i] + "\n";
			}
			Alert.show(message);
		} 
	}
	else
	{
		var fileName:String  = resultXml.children()[0].toString();
		//var url:String  	 =	__genModel.path.attachment+fileName;
		var url:String  	 =	__genModel.path.report_print+fileName;
		var _requestViewUrl:URLRequest = new URLRequest(url);
		navigateToURL(_requestViewUrl); 
	}
}
private function viewproofFaultHandler(event:FaultEvent):void
{
	Alert.show("viewproofinprint"+event.fault.faultDetail);
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
	service.showBusyCursor		= true;	
	
	return service;
}
private function getFileName():String
{
	var returnValue:String  = '';
	if(inbox.selectedRows.children().length()>0)
	{
		returnValue		= inbox.selectedRows.children()[0].imposition_file_name.toString();
		return returnValue;
	}
	else
	{
		return returnValue;
	}
}
private function viewClickHandler(event:MouseEvent):void
{
	if(getFileName()=='')
	{
		Alert.show("Please Select Job");
	}
	else
	{
		var url:String  =	__genModel.path.attachment+getFileName();
		var _requestViewUrl:URLRequest = new URLRequest(url);
		navigateToURL(_requestViewUrl); 
	}
}
private function downloadFileClickHandler(event:MouseEvent):void
{
	if(getFileName()=='')
	{
		Alert.show("Please Select Job");
	}
	else
	{
		/*var urlObj:URL	=	new URL();
		var url:String  =	__genModel.path.attachment+getFileName();
		var _request:URLRequest = new URLRequest(url);             
		_request.method = URLRequestMethod.GET;
		fileRefDown.addEventListener(Event.OPEN,openHandler);
		fileRefDown.addEventListener(Event.COMPLETE,downloadCompletehandler);
		try
		{
			fileRefDown.download(_request);
		}
		catch (error:Error)
		{
			Alert.show("Unable to download file.");
		}*/
		urlReq = new URLRequest(__genModel.path.attachment+getFileName());
		urlLdr = new URLLoader();
		urlLdr.dataFormat = URLLoaderDataFormat.BINARY;
		urlLdr.addEventListener(Event.COMPLETE, completeHandler);
		urlLdr.addEventListener(Event.OPEN, doEvent);
		urlLdr.addEventListener(HTTPStatusEvent.HTTP_STATUS, doEvent);
		urlLdr.addEventListener(IOErrorEvent.IO_ERROR, doEvent);
		urlLdr.addEventListener(ProgressEvent.PROGRESS, doEvent);
		urlLdr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, doEvent);
		urlLdr.load(urlReq);
	}
}
private function doEvent(evt:Event):void 
{			
}
private function completeHandler(event:Event):void
{
	var file_type:String    = inbox.selectedRows.children()[0].imposition_file_type.toString();
	var folder_path:String  = __genModel.masterData.child('indigo_file_path').child(file_type.toLowerCase()).value.toString();
	var loader:URLLoader = URLLoader(event.target);
	var file1:File 	= new File().resolvePath(folder_path+getFileName());
	var fileStream1:FileStream = new FileStream();
	fileStream1.addEventListener(IOErrorEvent.IO_ERROR,onStreamWriteError);
	try
	{
		fileStream1.open(file1, FileMode.WRITE);
		fileStream1.writeBytes(loader.data);
	} 
	catch(error:Error) 
	{
		Alert.show(error.errorID+error.message);
	}
	
	fileStream1.addEventListener(Event.COMPLETE, fileClosed);
	fileStream1.close();
}
private function onStreamWriteError(event:IOErrorEvent):void
{
	Alert.show(event.errorID+event.toString())
}
private function openHandler(event:Event):void
{
	//Alert.show("downlaod start");
}
private function fileClosed(event:Event):void
{
	Alert.show("File Save Successfully");
}

private function downloadCompletehandler(event:Event):void
{
	Alert.show("Download Complete");
}

