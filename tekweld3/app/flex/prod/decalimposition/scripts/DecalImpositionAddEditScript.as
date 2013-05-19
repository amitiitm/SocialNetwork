import business.events.GetInformationEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.customcomponents.GenButton;
import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;
import com.generic.genclass.URL;
import com.generic.genclass.Utility;

import flash.events.Event;
import flash.events.MouseEvent;

import flashx.textLayout.elements.BreakElement;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.CheckBox;
import mx.controls.Spacer;
import mx.core.Application;
import mx.events.ListEvent;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import prod.decalimposition.DecalImpositionModelLocator;
import prod.decalimposition.components.DecalImposition;
import prod.decalimposition.components.ImpositionFileUpload;

import saoi.muduleclasses.PrintObject;
import saoi.muduleclasses.event.MissingInfoEvent;

private var indigoCode_status:GetInformationEvent;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:DecalImpositionModelLocator =  DecalImpositionModelLocator(__genModel.activeModelLocator);
private var __generateIndigo:IResponder;
private var __uploadImpostionFile:IResponder;
private var __getOptionData:IResponder;
private var __service:ServiceLocator = __genModel.services;
private var oldValueIndigoCode:String;
private var newValueIndigoCode:String
private var __refreshList:IResponder;

[Embed("com/generic/assets/btn_clear.png")]
private const clearButtonIcon:Class;
[Embed("com/generic/assets/btn_white.png")]
private const whiteButtonIcon:Class;
[Embed("com/generic/assets/btn_metallic.png")]
private const metallicButtonIcon:Class;
[Embed("com/generic/assets/btn_print_pick_slip.png")]
private const printpickslipButtonIcon:Class;
[Embed("com/generic/assets/btn_upload_imposition.png")]
private const uploadimpostionsheetButtonIcon:Class;
[Embed("com/generic/assets/btn_generate_indigo.png")]
private const generateindigoButtonIcon:Class;



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
private function init():void
{
	
	addOptionBar();
	
}
private function whiteButtonHandler(event:Event):void
{
	var optionData:String = (event.target).name.toString();
	var getOptionData:HTTPService = dataService(__service.getHTTPService("getOptionData"));
	__getOptionData = new mx.rpc.Responder(getOptionDataResultHandler,getOptionDataFaultHandler);
	var token:AsyncToken = getOptionData.send(new XML(<options>{optionData}</options>));
	token.addResponder(__getOptionData);
	CursorManager.setBusyCursor();
	Application.application.enabled = false;
}

private function getOptionDataResultHandler(event:ResultEvent):void
{
	var resultXML:XML;
	var utilityObj:Utility	=	new Utility();
	resultXML 				= 	utilityObj.getDecodedXML((XML)(event.result));
	
	__localModel.listObj.rows = new XML(resultXML);   	
	__localModel.listObj.filteredList = new XML(resultXML);
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}
public function getOptionDataFaultHandler(event:FaultEvent):void
{
	Alert.show("OptionData#"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}
private function genrateIndigoClickHandler(event:MouseEvent):void
{
	if(inbox.selectedRows.children().length()>0)
	{
		if(isSameTypeSelected())
		{
			var generateIndigo:HTTPService 			= dataService(__service.getHTTPService("getIndigoNo"));
			__generateIndigo 						= new mx.rpc.Responder(generateIndigoResultHandler,generateIndigoFaultHandler);
			var token:AsyncToken 					= generateIndigo.send(inbox.selectedRows.copy());
			token.addResponder(__generateIndigo);
		}
		else
		{
			Alert.show("Select jobs of same type.");
		}
	}
	else
	{
		Alert.show("Please select Record");
	}
	
}
private function isSameTypeSelected():Boolean
{
	var returnValue:Boolean	= true;
	
	var type:String	= inbox.selectedRows.children()[0].catalog_attribute_value_code.toString();
	
	for(var i:int=1;i<inbox.selectedRows.children().length();i++)
	{
		var type_options:String	= inbox.selectedRows.children()[i].catalog_attribute_value_code.toString();
		if(type.toUpperCase()!=type_options.toUpperCase())
		{
			returnValue	= false;
		}
	}
	return returnValue;
}
private function isSameIndigoCodeSelected():Boolean
{
	var returnValue:Boolean	= true;
	
	var type:String	= inbox.selectedRows.children()[0].indigo_code.toString();
	
	for(var i:int=1;i<inbox.selectedRows.children().length();i++)
	{
		var type_options:String	= inbox.selectedRows.children()[i].indigo_code.toString();
		if(type.toUpperCase()!=type_options.toUpperCase())
		{
			returnValue	= false;
		}
	}
	return returnValue;
}

private function generateIndigoResultHandler(event:ResultEvent):void
{
	var indigoNo:String  = event.result.toString();
	setIndigoNo(indigoNo);
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}
public function generateIndigoFaultHandler(event:FaultEvent):void
{
	Alert.show("Indigo#"+event.fault.faultDetail);
	
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}
private function uploadImpositionFileClickHandler(event:Event):void
{
	if(inbox.selectedRows.children().length()>0)
	{
		if(isSameIndigoCodeSelected())
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
				Alert.show("Generate Indigo# to proceed.");
			}
		}
		else
		{
			Alert.show("Select same type jobs.");
		}
		
		
	}
	else
	{
		Alert.show("Please select Record");
	}
	
}
private function getIndigoCode():String
{
	var returnValue:String	= '';
	if(inbox.selectedRows.children().length()>0)
	{
		returnValue =  inbox.selectedRows.children()[0].indigo_code.toString();
	}
	return returnValue;
}
private function isIndigoNoSetInSelectedRow():Boolean
{
	var returnValue:Boolean	= true;
	for(var i:int = 0;i<inbox.selectedRows.children().length();i++)
	{
		if(inbox.selectedRows.children().indigo_code.toString()=='')
		{
			returnValue	= false;
			break;
		}
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

private function handleInboxItemFocusOut(event:InboxEvent):void
{
	var indigo_code:String	= inbox.focusedRow["indigo_code"].toString();
	/*if(indigo_code!='')
	{
		if(event.newValues["select_yn"] == 'Y')
		{
			setRecord(indigo_code,"Y");
		}
		else
		{
			setRecord(indigo_code,"N");
		}
	}*/
	
 	var oldValue:String = event.oldValues["imposition_flag"].toString();

	/*if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["imposition_flag"] = 'Y';
	}
	else
	{
		inbox.focusedRow["imposition_flag"] = 'N';
		inbox.focusedRow["indigo_code"] = '';
	}*/
	/*oldValueIndigoCode	= event.oldValues["indigo_code"].toString();
 	newValueIndigoCode  = event.newValues["indigo_code"].toString();
	if(oldValueIndigoCode!=newValueIndigoCode)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getIndigoCodeStatusHandler, null);
		indigoCode_status	=	new GetInformationEvent('check_valid_indigo_no', callbacks, newValueIndigoCode);
		indigoCode_status.dispatch(); 
	}
	else
	{
		// no change in indigo code 
	}*/
	
}
private function getIndigoCodeStatusHandler(resultXml:XML):void
{
	var status:String = resultXml.children()[0].toString();
	if(status=='Exist')
	{
		inbox.focusedRow["indigo_code"]	= oldValueIndigoCode;
		inbox.editBar.record			= inbox.editBar.record;
		Alert.show("indigo # alredy exist");
	}
	else
	{
		
	}	
}
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var retValue:int = 0;
	
	for(var i:int=0; i<inbox.dgDtl.dataProvider.length; i++)
	{
		if(inbox.dgDtl.dataProvider[i]["select_yn"] == "Y")
		{
			if(inbox.dgDtl.dataProvider[i]["indigo_code"] == '')
			{
				retValue = -1;
				Alert.show("Please Enter INDIGO #");
				break
			}						
		}	
	}
	return retValue;
}
private function setIndigoNo(number:String):void
{
	for(var i:int=0; i <inbox.selectedRows.children().length();i++)
	{
		if(inbox.selectedRows.children()[i].select_yn == 'Y')
		{
			inbox.selectedRows.children()[i].indigo_code	= number;
		}
	}
	inbox.editBar.record		= inbox.editBar.record;
}
private function setRecord(indigo_code:String,value:String):void
{
	for(var i:int=0; i<inbox.dgDtl.rows.children().length(); i++)
	{
		if(inbox.dgDtl.rows.children()[i]["indigo_code"].toString() == indigo_code)
		{
			inbox.dgDtl.rows.children()[i].select_yn  = value;
		}	
	}
}

private function addOptionBar():void
{
	var hb:HBox    = new HBox();
	hb.setStyle('horizontalGap' , 10);
	
	var sp:Spacer  = new Spacer();
	sp.width     =   2;
	
	var btnIndigo:Button        		= new Button();
	btnIndigo.height							= 20;
	btnIndigo.label						= "GENERATE INDIGO #";
	btnIndigo.styleName					= "promoButton";
	//btnIndigo.setStyle('icon' , generateindigoButtonIcon);
	btnIndigo.addEventListener(MouseEvent.CLICK,genrateIndigoClickHandler);
	
	var btnUpload:Button        		= new Button();
	btnUpload.height					= 20;
	btnUpload.label						= "UPLOAD IMPOSITION SHEET";
	btnUpload.styleName					= "promoButton";
	//btnUpload.setStyle('icon' , uploadimpostionsheetButtonIcon);
	btnUpload.addEventListener(MouseEvent.CLICK,uploadImpositionFileClickHandler);
	
	var btnWhite:Button        			= new Button();
	btnWhite.label		   	   			= "WHITE";
	btnWhite.name							= "White";
	btnWhite.height							= 20;
	btnWhite.styleName					= "promoButton";
	//btnWhite.setStyle('icon' , whiteButtonIcon);
	btnWhite.addEventListener(MouseEvent.CLICK,whiteButtonHandler);
	
	var btnClear:Button        			= new Button();
	btnClear.height							= 20;
	btnClear.name							= "CLEAR";
	btnClear.label		   	   				= "Clear";
	btnClear.styleName					= "promoButton";
	//btnClear.setStyle('icon' , clearButtonIcon);
	btnClear.addEventListener(MouseEvent.CLICK,whiteButtonHandler);
	
	var btnMetalic:Button        		= new Button();
	btnMetalic.label		   	   		= "METALLIC";
	btnMetalic.name							= "Metallic";
	btnMetalic.height						= 20;
	btnMetalic.styleName					= "promoButton";
	//btnMetalic.setStyle('icon' , metallicButtonIcon);
	btnMetalic.addEventListener(MouseEvent.CLICK,whiteButtonHandler);
	
	var btnPrintPickSlip:Button        			= new Button();
	btnPrintPickSlip.height							= 20;
	btnPrintPickSlip.label						= "PRINT PICK SLIP";
	//btnPrintPickSlip.setStyle('icon' , printpickslipButtonIcon);
	btnPrintPickSlip.styleName					= "promoButton";
	btnPrintPickSlip.addEventListener(MouseEvent.CLICK,genratePickSlipHandler);
	
	
	
	var space:Spacer	 = new Spacer();
	space.width			 = 200;
	
	hb.addChild(space);
	hb.addChild(btnClear);
	hb.addChild(btnWhite);
	hb.addChild(btnMetalic);
	//hb.addChild(space);
	//hb.addChild(btnPrintPickSlip);
	hb.addChild(btnIndigo);
	hb.addChild(btnUpload);
	
	
	DecalImposition(this.parentDocument).bcp.addChildAt(hb,7);
}
private function genratePickSlipHandler(event:MouseEvent):void
{
	new PrintObject().genratePickSlipHandler(inbox);
}