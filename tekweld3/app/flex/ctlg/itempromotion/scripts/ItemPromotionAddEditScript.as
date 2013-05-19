import business.events.RecordStatusEvent;
import business.events.RefreshEvent;
import business.events.SaveRecordEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.events.AddEditEvent;
import com.generic.genclass.TreeFormatter;

import ctlg.itempromotion.components.ItemPromotionDetail;
import ctlg.itempromotion.components.ItemPromotionLayout;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.getQualifiedClassName;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.TextInput;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
[Bindable]
private var tempSelectedTemplate:TextInput;
private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
private var recordStatusEvent:RecordStatusEvent;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
private var treeXML:XML ;
private var allGroupXml:XML; 
private var encodedTreeXml:XML;

private var isExecutedFirst:Boolean	=	false;

private function openTemplatesClickHandler():void
{
	recordStatusEvent = new RecordStatusEvent("MODIFY")
	recordStatusEvent.dispatch();
		
	var itemPromotionTemplateObj:ItemPromotionLayout	=	ItemPromotionLayout(PopUpManager.createPopUp(this,ItemPromotionLayout,true))
	itemPromotionTemplateObj.setSelectedLayout(tiCurentTemplate.text);
	tempSelectedTemplate								=	itemPromotionTemplateObj.tiSelectedTemplate;
	itemPromotionTemplateObj.btnInstall.addEventListener(MouseEvent.CLICK , templateClickHandler)
}
private function templateClickHandler(event:MouseEvent):void
{
	if(tiCurentTemplate.text.toString() != tempSelectedTemplate.text.toString())
	{
				tiCurentTemplate.text	=	tempSelectedTemplate.text;
				handleTemplateChange();
	}			
	
}
private function handleTemplateChange():void
{
	switch(tiCurentTemplate.text.toString())
	{
		case 't13':
		case '':
		
		vsLayout.selectedChild	=	t13;
		break;
		
		case 't1':
		
		vsLayout.selectedChild	=	t1;	
		break;
		
		//default: Alert.show('template does not exist');
	}
}
private function btnEditImageClickHandler(event:Event):void
{
	if(getQualifiedClassName(event.target).toString() != 'mx.controls::Button')
	{
		return;
	}
	recordStatusEvent = new RecordStatusEvent("MODIFY")
	recordStatusEvent.dispatch();

	if(treeXML	== XML(undefined) || treeXML	== null)
	{
		Alert.show("Please wait for a moment, data initialization in progress !")
		//itemPromotionEditPage.itemCatagories			=	treeXML;
		return;
	}

	var itemPromotionEditPage:ItemPromotionDetail	=	ItemPromotionDetail(PopUpManager.createPopUp(this,ItemPromotionDetail,true))
	
	itemPromotionEditPage.itemCatagories			=	treeXML.copy();

	switch(event.target.name.toString())
	{
		case 'image1':
			
			itemPromotionEditPage.tiImageName	=	tiImage1Name
			itemPromotionEditPage.tiImageLink	=	tiImage1Link
		break;
		case 'image2':
			itemPromotionEditPage.tiImageName	=	tiImage2Name
			itemPromotionEditPage.tiImageLink	=	tiImage2Link
		break;
		case 'image3':
			
			itemPromotionEditPage.tiImageName	=	tiImage3Name
			itemPromotionEditPage.tiImageLink	=	tiImage3Link
		break;
		case 'image4':
			
			itemPromotionEditPage.tiImageName	=	tiImage4Name
			itemPromotionEditPage.tiImageLink	=	tiImage4Link
		break; 
		//default: Alert.show('clicked Image handler not present');

	}
	
	itemPromotionEditPage.setRow();
}

private function creationCompleteHandler():void
{
	
	getEncodedTree();
	getGroups();
}

private function getEncodedTree():void
{
	var callbacksGetEncodedTree:IResponder = new mx.rpc.Responder(getEncodedTreeResultHandler, faultHandler);
	var __getEncodedTreeService:HTTPService;
	
	__getEncodedTreeService = __locator.getHTTPService("getEncodedTree");
	dataService(__getEncodedTreeService);

	var token:AsyncToken = __getEncodedTreeService.send(new XML);
	token.addResponder(callbacksGetEncodedTree);
}
private function getEncodedTreeResultHandler(event:ResultEvent):void
{
	if(XML(event.result).children().length() > 0)
	{
		encodedTreeXml	=	XML(XML(XML(event.result).children()[0]).elements)
	} 
		
	if(isExecutedFirst)
	{
		 var treeFormatterObj:TreeFormatter = new TreeFormatter();
		treeXML 			= 	treeFormatterObj.decode(encodedTreeXml,allGroupXml); //here treeXML will have decoded tree
    	isExecutedFirst		=	false	
    }
	else
	{
		isExecutedFirst	=	true
	}	
}
private function getGroups():void
{
	var callbacksGetGroups:IResponder = new mx.rpc.Responder(getGroupsResultHandler, faultHandler);
	var __getGroupService:HTTPService;
	
	__getGroupService = __locator.getHTTPService("getGroups");
	dataService(__getGroupService);

	var token:AsyncToken = __getGroupService.send(new XML);
	token.addResponder(callbacksGetGroups);
} 
public function getGroupsResultHandler(event:ResultEvent):void
{
		allGroupXml	=	XML(event.result)
		
		if(isExecutedFirst)
		{
			 var treeFormatterObj:TreeFormatter = new TreeFormatter();
			treeXML 			= 	treeFormatterObj.decode(encodedTreeXml,allGroupXml); //here treeXML will have decoded tree
	    	isExecutedFirst		=	false	
	    }
		else
		{
			isExecutedFirst	=	true
		}
}

private function faultHandler(event:FaultEvent):void
{
	
}
private function dataService(service:HTTPService):HTTPService
{
	service.resultFormat = "e4x";
	service.method = "POST";
	service.useProxy = false;
	service.contentType="application/xml";

	return service;
}
override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	handleTemplateChange();
}

private function handlePublishClick():void
{
	var saveRecordEvent:SaveRecordEvent = new SaveRecordEvent();
	saveRecordEvent.dispatch()
	
	var refreshEvent:RefreshEvent = new RefreshEvent();
	refreshEvent.dispatch();
}