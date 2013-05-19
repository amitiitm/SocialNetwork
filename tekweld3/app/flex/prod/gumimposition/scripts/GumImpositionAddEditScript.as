import business.events.GetInformationEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.customcomponents.GenButton;
import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;
import com.generic.genclass.URL;
import com.generic.genclass.Utility;

import flash.events.Event;
import flash.events.MouseEvent;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.Spacer;
import mx.core.Application;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import prod.gumimposition.GumImpositionModelLocator;
import prod.gumimposition.components.GumImposition;
import prod.gumimposition.components.ImpositionFileUpload;

import saoi.muduleclasses.PrintObject;
import saoi.muduleclasses.event.MissingInfoEvent;


[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:GumImpositionModelLocator =  GumImpositionModelLocator(__genModel.activeModelLocator);
private var __generateDoc:IResponder;
private var __service:ServiceLocator = __genModel.services;
private var oldValueDocCode:String;
private var newValueDocCode:String
private var docCode_status:GetInformationEvent;
private var __refreshList:IResponder;


[Embed("com/generic/assets/btn_print_pick_slip.png")]
private const printpickslipButtonIcon:Class;
[Embed("com/generic/assets/btn_upload_imposition.png")]
private const uploadimpostionsheetButtonIcon:Class;
[Embed("com/generic/assets/btn_generate_doc.png")]
private const generatedocButtonIcon:Class;


private function init():void
{
	 addOptionBar();
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

private function genrateDocClickHandler(event:MouseEvent):void
{
	if(inbox.selectedRows.children().length()>0)
	{
			var generateDoc:HTTPService = dataService(__service.getHTTPService("getDocNo"));
			__generateDoc = new mx.rpc.Responder(generateIndigoResultHandler,generateIndigoFaultHandler);
			var token:AsyncToken = generateDoc.send(inbox.selectedRows.copy());
			token.addResponder(__generateDoc);
	}
	else
	{
		Alert.show("Please select Record");
	}
}
private function generateIndigoResultHandler(event:ResultEvent):void
{
	var DocNo:String  = event.result.toString();
	setDocNo(DocNo);
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}
public function generateIndigoFaultHandler(event:FaultEvent):void
{
	Alert.show("Doc#"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}
private function handleInboxItemFocusOut(event:InboxEvent):void
{
 	var oldValue:String 	= event.oldValues["imposition_flag"].toString();
	oldValueDocCode			= event.oldValues["doc_code"].toString();
	newValueDocCode  		= event.newValues["doc_code"].toString();
	
	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["imposition_flag"] = 'Y';
	}
	else
	{
		inbox.focusedRow["imposition_flag"] = 'N';
		inbox.focusedRow["doc_code"] = oldValueDocCode;
	}
	
	if(oldValueDocCode!=newValueDocCode)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getDocCodeStatusHandler, null);
		docCode_status	=	new GetInformationEvent('check_valid_indigo_no', callbacks, null,newValueDocCode);
		docCode_status.dispatch(); 
	}
	else
	{
		// no change in indigo code 
	}
}
private function getDocCodeStatusHandler(resultXml:XML):void
{
	var status:String = resultXml.children()[0].toString();
	if(status=='Exist')
	{
		inbox.focusedRow["doc_code"]	= oldValueDocCode;
		inbox.editBar.record			= inbox.editBar.record;
		Alert.show("Doc # alredy exist");
	}
	else
	{
		
	}	
}
private function setDocNo(number:String):void
{
	for(var i:int=0; i <inbox.selectedRows.children().length();i++)
	{
		if(inbox.selectedRows.children()[i].select_yn == 'Y')
		{
			inbox.selectedRows.children()[i].doc_code	= number;
		}
	}
	inbox.editBar.record		= inbox.editBar.record;
}
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var retValue:int = 0;
	
	for(var i:int=0; i<inbox.dgDtl.dataProvider.length; i++)
	{
		if(inbox.dgDtl.dataProvider[i]["select_yn"] == "Y")
		{
			if(inbox.dgDtl.dataProvider[i]["doc_code"] == '')
			{
				retValue = -1;
				Alert.show("Please Enter DOC #");
				break
			}						
		}	
	}
	return retValue;
}
private function addOptionBar():void
{
	var hb:HBox    = new HBox();
	hb.setStyle('horizontalGap' , 10);
	
	var sp:Spacer  = new Spacer();
	sp.width     =   2;
	
	var btnPrintPickSlip:Button        				= new Button();
	btnPrintPickSlip.label							= "PRINT PICK SLIP";
	btnPrintPickSlip.height							= 20;
	//btnPrintPickSlip.setStyle('icon' , printpickslipButtonIcon);
	btnPrintPickSlip.styleName						= "promoButton";
	btnPrintPickSlip.addEventListener(MouseEvent.CLICK,genratePickSlipHandler);


	var btnIndigo:Button        					= new Button();
	btnIndigo.height								= 20;
	btnIndigo.label				   					= "GENERATE DOC #";
	//btnIndigo.setStyle('icon' , generatedocButtonIcon);
	btnIndigo.styleName								= "promoButton";
	btnIndigo.addEventListener(MouseEvent.CLICK,genrateDocClickHandler);
	

	
	
	var btnUpload:Button        					= new Button();
	btnUpload.label									= "UPLOAD IMPOSITION SHEET";
	btnUpload.height								= 20;
	//btnUpload.setStyle('icon' , uploadimpostionsheetButtonIcon);
	btnUpload.styleName								= "promoButton";
	btnUpload.addEventListener(MouseEvent.CLICK,uploadImpositionFileClickHandler);
	
	var space:Spacer	 = new Spacer();
	space.width			 = 200;
	
	hb.addChild(space);
	
	//hb.addChild(btnPrintPickSlip);
	hb.addChild(btnIndigo);
	hb.addChild(btnUpload);
	
	
	GumImposition(this.parentDocument).bcp.addChildAt(hb,7);
}
private function genratePickSlipHandler(event:MouseEvent):void
{
	new PrintObject().genratePickSlipHandler(inbox);
}
private function uploadImpositionFileClickHandler(event:Event):void
{
	if(inbox.selectedRows.children().length()>0)
	{
		if(isSameDocCodeSelected())
		{
			if(getIndigoCode()!='')
			{
				var impositionFileUpload:ImpositionFileUpload 			= ImpositionFileUpload(PopUpManager.createPopUp(this,ImpositionFileUpload,true));
				impositionFileUpload.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,missingInfoEventListner);
				impositionFileUpload.x= ((Application.application.width/2)-(impositionFileUpload.width/2));
				impositionFileUpload.y= ((Application.application.height/2)-(impositionFileUpload.height/2));
				impositionFileUpload.xml = new XML(inbox.selectedRows.copy());
				impositionFileUpload.indigo_code = getIndigoCode();
			}
			else
			{
				Alert.show("Please Genrate Doc #");
			}
		}
		else
		{
			Alert.show("Please select Record with same doc #");
		}
		
		
	}
	else
	{
		Alert.show("Please select Record");
	}
	
}
private function isSameDocCodeSelected():Boolean
{
	var returnValue:Boolean	= true;
	
	var type:String	= inbox.selectedRows.children()[0].doc_code.toString();
	
	for(var i:int=1;i<inbox.selectedRows.children().length();i++)
	{
		var type_options:String	= inbox.selectedRows.children()[i].doc_code.toString();
		if(type.toUpperCase()!=type_options.toUpperCase())
		{
			returnValue	= false;
		}
	}
	return returnValue;
}
private function getIndigoCode():String
{
	var returnValue:String	= '';
	if(inbox.selectedRows.children().length()>0)
	{
		returnValue =  inbox.selectedRows.children()[0].doc_code.toString();
	}
	return returnValue;
}
public function  missingInfoEventListner(event:MissingInfoEvent):void
{
	var xml:XML   				= XML(event.xml);
	if(xml.children().length()>0)
	{
		if(xml.print_ready_flag.toString()=='Y')
		{
			refreshHandler();
		}
	}
	else
	{
		
	}
	
	
}
private function refreshHandler():void
{
	CursorManager.setBusyCursor();
	Application.application.enabled  = false;
	
	var refresh:HTTPService = dataService(__service.getHTTPService("getList"));
	__refreshList = new mx.rpc.Responder(refreshResultHandler,refreshFaultHandler);
	var token:AsyncToken = refresh.send(__localModel.viewObj.selectedView);
	token.addResponder(__refreshList);	
}


private function refreshResultHandler(event:ResultEvent):void
{
	var resultXML:XML;
	var utilityObj:Utility	=	new Utility();
	resultXML 				= 	utilityObj.getDecodedXML((XML)(event.result));
	__localModel.listObj.rows = new XML(resultXML);   	
	__localModel.listObj.filteredList = new XML(resultXML);
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}
public function refreshFaultHandler(event:FaultEvent):void
{
	Alert.show("Refreshorder"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}