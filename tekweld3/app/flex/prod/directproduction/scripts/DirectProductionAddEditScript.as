import business.events.PreSaveEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.customcomponents.GenButton;
import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;
import com.generic.genclass.URL;
import com.generic.genclass.Utility;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.navigateToURL;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.Spacer;
import mx.core.Application;
import mx.events.CloseEvent;
import mx.managers.CursorManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import prod.directproduction.DirectProductionModelLocator;
import prod.directproduction.components.DirectProduction;

import saoi.muduleclasses.PrintObject;


[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:DirectProductionModelLocator =  DirectProductionModelLocator(__genModel.activeModelLocator);
public  var fileRefDown:FileReference = new FileReference();

[Embed("com/generic/assets/btn_view_film.png")]
private const viewFilmButtonIcon:Class;
[Embed("com/generic/assets/btn_download_film.png")]
private const downloadFilmButtonIcon:Class;
[Embed("com/generic/assets/btn_print_pick_slip.png")]
private const printpickslipButtonIcon:Class;
[Embed("com/generic/assets/btn_view_all.png")]
private const viewAllButtonIcon:Class;
[Embed("com/generic/assets/DocuColor.png")]
private const docucolorButtonIcon:Class;
[Embed("com/generic/assets/Indigo.png")]
private const indigoButtonIcon:Class;
[Embed("com/generic/assets/Direct.png")]
private const directButtonIcon:Class;
[Embed("com/generic/assets/Digitek.png")]
private const digitekButtonIcon:Class;
[Embed("com/generic/assets/Pad.png")]
private const padButtonIcon:Class;
[Embed("com/generic/assets/Embroidery.png")]
private const embroideryButtonIcon:Class;


private var __getOptionData:IResponder;
private var __service:ServiceLocator = __genModel.services;
private var isMissingInfoSave:Boolean	=	false;
private var preSaveEvent:PreSaveEvent;
private var btnPrintPickSlip:Button

private function handleInboxItemFocusOut(event:InboxEvent):void
{
	var oldValue:String = event.oldValues["direct_production_flag"].toString();

	var select:String = event.newValues.select_yn.toString();
	
	for(var i:int=0; i <inbox.dgDtl.rows.children().length();i++)
	{
		inbox.dgDtl.rows.children()[i].select_yn = 'N';
	}
	if(select.toUpperCase() == 'Y')
	{
		inbox.focusedRow["select_yn"] = 'Y';
	}
	
	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["direct_production_flag"] = 'Y';
		
	}
	else
	{
		inbox.focusedRow["direct_production_flag"] = 'N';
	}  	
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	if(inbox.selectedRows.children().length()<=0)
	{
		return -1;
	}
	var retValue:int = 0;
	
	if(isMissingInfoSave)
	{
		isMissingInfoSave = false;
		retValue =0;
	}
	else
	{
		Alert.show("Do You Want to print Pick slip ?","Pick Slip",Alert.YES | Alert.NO,this,discardChangeEvent,null,Alert.YES);
		return -1;
	}
	
	return retValue;
}
private function discardChangeEvent(event:CloseEvent):void
{
	if(event.detail == Alert.YES)
	{
		btnPrintPickSlip.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
	}
	else
	{
		
	}
	isMissingInfoSave	=	true;
	preSaveEvent = new PreSaveEvent();
	preSaveEvent.dispatch();
}
private function genratePickSlipHandler(event:MouseEvent):void
{
	new PrintObject().genratePickSlipHandler(inbox);
}
private function addOptionBar():void
{
	var hb:HBox    = new HBox();
	hb.setStyle('horizontalGap' , 10);
	
	var sp:Spacer  = new Spacer();
	sp.width     =   2;
	
	btnPrintPickSlip        						= new Button();
	btnPrintPickSlip.height							= 20;
	btnPrintPickSlip.label						= "PRINT PICK SLIP";
	btnPrintPickSlip.styleName					= "promoButton";
	//btnPrintPickSlip.setStyle('icon' , printpickslipButtonIcon);
	btnPrintPickSlip.addEventListener(MouseEvent.CLICK,genratePickSlipHandler);
	
	var btnView:Button        		= new Button();
	btnView.height							= 20;
	btnView.label						= "View Film File";
	//btnView.setStyle('icon' , viewFilmButtonIcon);
	btnView.styleName					= "promoButton";
	btnView.addEventListener(MouseEvent.CLICK,viewClickHandler);
	
	var btnViewAll:Button        			= new Button();
	btnViewAll.name								= "VIEWALL";
	btnViewAll.label								= "VIEWALL";
	btnViewAll.styleName					= "promoButton";
	btnViewAll.height							= 20;
	//btnViewAll.setStyle('icon' , viewAllButtonIcon);
	btnViewAll.addEventListener(MouseEvent.CLICK,OptionsButtonHandler);
	
	var btnDocuColor:Button        			= new Button();
	btnDocuColor.name							= "DOCUCOLOR";
	btnDocuColor..styleName					= "promoButton";
	btnDocuColor.label						= "DOCUCOLOR";
	btnDocuColor.height							= 20;
	//btnDocuColor.setStyle('icon' , docucolorButtonIcon);
	btnDocuColor.addEventListener(MouseEvent.CLICK,OptionsButtonHandler);
	
	var btnIndigo:Button        				= new Button();
	btnIndigo.height							= 20;
	btnIndigo.name								= "DECAL";
	btnIndigo.label								= "DECAL";
	btnIndigo.styleName					= "promoButton";
	//btnIndigo.setStyle('icon' , indigoButtonIcon);
	btnIndigo.addEventListener(MouseEvent.CLICK,OptionsButtonHandler);
	
	var btnDigitek:Button        			= new Button();
	btnDigitek.name								= "DIGITEK";
	btnDigitek.height							= 20;
	//btnDigitek.setStyle('icon' , digitekButtonIcon);
	btnDigitek.label							= "DIGITEK";
	btnDigitek.styleName					= "promoButton";
	btnDigitek.addEventListener(MouseEvent.CLICK,OptionsButtonHandler);
	
	var btnDirect:Button        				= new Button();
	btnDirect.name								= "DIRECT";
	btnDirect.height							= 20;
	btnDirect.label								= "DIRECT";
	btnDirect..styleName					= "promoButton";
	//btnDirect.setStyle('icon' , directButtonIcon);
	btnDirect.addEventListener(MouseEvent.CLICK,OptionsButtonHandler);
	
	var btnPad:Button        				= new Button();
	btnPad.height								= 20;
	btnPad.name									= "PAD";
	btnPad.label								= "PAD";
	btnPad.styleName					= "promoButton";
	//btnPad.setStyle('icon' , padButtonIcon);
	btnPad.addEventListener(MouseEvent.CLICK,OptionsButtonHandler);
	
	var btnEmbroidery:Button        			= new Button();
	btnEmbroidery.height						= 20;
	btnEmbroidery.name							= "EMBROIDERY";
	//btnEmbroidery.setStyle('icon' , embroideryButtonIcon);
	btnEmbroidery.label							= "EMBROIDERY";
	btnEmbroidery.styleName					= "promoButton";
	btnEmbroidery.addEventListener(MouseEvent.CLICK,OptionsButtonHandler);
	
	var space:Spacer	 = new Spacer();
	space.width			 = 150;
	
	hb.addChild(space);
	hb.addChild(btnPrintPickSlip);
	hb.addChild(btnViewAll);
	hb.addChild(btnDocuColor);
	hb.addChild(btnIndigo);
	hb.addChild(btnDirect);
	hb.addChild(btnPad);
	hb.addChild(btnDigitek);
	hb.addChild(btnEmbroidery);
	
	//hb.addChild(btnView);
	//hb.addChild(btnDownload);
	
	
	DirectProduction(this.parentDocument).bcp.addChildAt(hb,7);
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
private function OptionsButtonHandler(event:Event):void
{
	var optionData:String = Button(event.target).name.toString();
	if(optionData=='VIEWALL')
	{
		DirectProduction(this.parentDocument).bcp.btnRefresh.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
	}
	else
	{
		var getOptionData:HTTPService = dataService(__service.getHTTPService("getOptionData"));
		__getOptionData = new mx.rpc.Responder(getOptionDataResultHandler,getOptionDataFaultHandler);
		var token:AsyncToken = getOptionData.send(new XML(<options>{optionData}</options>));
		token.addResponder(__getOptionData);
		CursorManager.setBusyCursor();
		Application.application.enabled = false;
	}
	
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
private function getFileName():String
{
	var returnValue:String  = '';
	if(inbox.selectedRows.children().length()>0)
	{
		returnValue		= inbox.selectedRows.children()[0].artwork_file_name.toString();
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
		var urlObj:URL	=	new URL();
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
		}
	}
}
private function openHandler(event:Event):void
{
	//Alert.show("downlaod start");
}

private function downloadCompletehandler(event:Event):void
{
	Alert.show("Download Complete");
}