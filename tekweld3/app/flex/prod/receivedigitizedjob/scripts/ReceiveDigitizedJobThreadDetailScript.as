import business.events.GetInformationEvent;
import business.events.RecordStatusEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.customcomponents.GenTextInput;
import com.generic.events.DetailAddEditEvent;
import com.generic.genclass.URL;

import flash.events.DataEvent;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.net.navigateToURL;
import flash.utils.setTimeout;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.events.DataGridEvent;
import mx.events.ValidationResultEvent;
import mx.formatters.NumberFormatter;
import mx.managers.CursorManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.validators.EmailValidator;

import prod.productionorder.ProductionOrderModelLocator;
import prod.receivedigitizedjob.ReceiveDigitizedJobModelLocator;

private var __sendToCustomer:IResponder;
private var numericFormatter:NumberFormatter = new NumberFormatter();
private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:ReceiveDigitizedJobModelLocator = (ReceiveDigitizedJobModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var _filterdRows:XML;
[Bindable]
private function set filterdRows(aXML:XML):void
{
	_filterdRows	=	aXML;
}

private function get filterdRows():XML
{
	return _filterdRows;
}

override protected function resetObjectEventHandler():void
{
	//setThreadDetail();
	dgThreads.rows = __localModel.threadXml.copy();
	
	if(hbSearchBox.getChildren().length<=0)
	{
		setTimeout(createSearchInputs,1000);
	}
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	cbCategory.dataValue = cbCategory.defaultValue
	cbComapny.dataValue = cbComapny.defaultValue
	
	dgThreads.rows = __localModel.threadXml.copy();
	
	//setThreadDetail();
	
	if(hbSearchBox.getChildren().length<=0)
	{
		setTimeout(createSearchInputs,1000);
	}
}

private function setThreadDetail():void
{
	if(cbComapny.dataValue!='' && cbCategory.dataValue!='')
	{
		dgThreads.rows = __localModel.threadXml.copy();
		
		var callbacks:IResponder = new mx.rpc.Responder(getThreadDetailHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('fetch_thread_colors', callbacks, cbComapny.dataValue,cbCategory.dataValue);
		getInformationEvent.dispatch();
	}
	else
	{
		
	}
}

private function getThreadDetailHandler(resultXml:XML):void
{
	filterdRows						= 	(XML)(resultXml);
}

private function itemFocusOutEventHandler(event:Event):void
{
	/*if(gdColorDetail.selectedRow.select_yn == 'Y')
	{
		if(XMLList(dgThreads.rows.children().(child('color_number').toString() == gdColorDetail.selectedRow.color_number)).length() == 0)
		{
			var rowXml:XML = new XML(<sales_order_thread/>);
			rowXml.thread_company = cbComapny.dataValue;
			rowXml.thread_category = cbCategory.dataValue;
			rowXml.color_number		= gdColorDetail.selectedRow.color_number
			rowXml.color_card_sequence = gdColorDetail.selectedRow.color_card_sequence
			
			dgThreads.rows.appendChild(rowXml.copy());
		}
	}
	
	for(var i:int = 0 ; i< selectedChildList.length() ; i++)
	{
		var rowXml = new XML(<sales_order_thread/>);
		rowXml.thread_company = cbComapny.dataValue;
		rowXml.thread_category = cbCategory.dataValue;
		rowXml.color_number		= selectedChildList[i].color_number
		rowXml.color_card_sequence = selectedChildList[i].color_card_sequence
		
		rowsXml.appendChild(rowXml);
	}
	
	if(String(gdColorDetail.selectedRow.child('select_yn')).toUpperCase()	==	'Y')
	{
		var currentSelectedRowCardNumber:String;
		var currentSelectedRowColorCardSequence:String;
		currentSelectedRowCardNumber		=	gdColorDetail.selectedRow.child('color_number').toString();
		currentSelectedRowColorCardSequence	=	gdColorDetail.selectedRow.child('color_card_sequence').toString();
		
		var selectedChildList:XMLList		=	null;
		
		selectedChildList					=	gdColorDetail.rows.children().(child('select_yn').toString().toUpperCase() == 'Y')
		
		//unselect previous selected
		for(var i:int = 0 ; i< selectedChildList.length() ; i++)
		{
			if((XML(selectedChildList[i]).child('color_number').toString() !=	currentSelectedRowCardNumber)|| (XML(selectedChildList[i]).child('color_card_sequence').toString() !=	currentSelectedRowColorCardSequence))
			{
				selectedChildList[i].select_yn		=	'N'
			}
		}
	}
	tiColorCode.dataValue				= 	gdColorDetail.selectedRow.child('color_number').toString();
	tiColorCardSequence.dataValue		= 	gdColorDetail.selectedRow.child('color_card_sequence').toString();*/
}

private function selectRow():void
{		 
	if(gdColorDetail.selectedRow.select_yn == 	 'Y')
	{
		gdColorDetail.selectedRow.select_yn = 	 'N'
	}
	else
	{
		gdColorDetail.selectedRow.select_yn = 	 'Y'
	}
	
	gdColorDetail.dispatchEvent(new DataGridEvent(DataGridEvent.ITEM_FOCUS_OUT));
	
	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("MODIFY");
	recordStatusEvent.dispatch();
}
private function createSearchInputs():void
{
	var structure:XML	=	gdColorDetail.structure.copy();
	var tiSearch:GenTextInput;
	for(var i:int = 0 ; i < structure.children().length()	;	i++)
	{
		if( structure.children()[i].@visible.toString()	==	'true')
		{
			tiSearch		=	new GenTextInput();
			tiSearch.name	=	structure.children()[i].@data.toString();
			tiSearch.width	=	Number(structure.children()[i].@width.toString());
			tiSearch.height	=	20;
			tiSearch.setStyle('textAlign' , structure.children()[i].@textAlign);
			tiSearch.addEventListener(KeyboardEvent.KEY_UP,filterLookup);
			hbSearchBox.addChild(tiSearch);
		}
	}
}
private function filterLookup(event:Event):void
{
	var searchedRows:XML = new XML('<'+ filterdRows.localName().toString()+ '/>')
	
	var tempList:XMLList	=	new XMLList();
	tempList				=	filterdRows.children();
	var arr:Array			=	hbSearchBox.getChildren();
	for(var i:int=0 ; i< arr.length; i++)
	{
		if(GenTextInput(arr[i]).text != '')
		{
			tempList = tempList.(String(child(arr[i].name)).substr(0,GenTextInput(arr[i]).text.length).toUpperCase()	==	GenTextInput(arr[i]).text.toUpperCase())	
		}
	}
	if(tempList.children().length() > 0)
	{
		searchedRows.appendChild(tempList);
		gdColorDetail.rows	=	searchedRows;
	}
	else
	{
		gdColorDetail.rows	=	new XML('<'+ filterdRows.localName().toString()+ '/>')
	}
	
}
private function changeColumnSizeHandler(event:DataGridEvent):void
{
	GenTextInput(hbSearchBox.getChildByName(gdColorDetail.columns[event.columnIndex].dataField.toString())).width	=	gdColorDetail.columns[event.columnIndex].width;
}

override protected function preSaveRowEventHandler(event:DetailAddEditEvent):int
{
	var selectedChildList:XMLList		=	gdColorDetail.rows.children().(child('select_yn').toString().toUpperCase() == 'Y')
	
	for(var i:int = 0 ; i< selectedChildList.length() ; i++)
	{
		if(XMLList(dgThreads.rows.children().(child('color_number').toString() == selectedChildList[i].color_number)).length() == 0)
		{
			var rowXml:XML = new XML(<sales_order_thread/>);
			rowXml.thread_company = cbComapny.dataValue;
			rowXml.thread_category = cbCategory.dataValue;
			rowXml.color_number		= selectedChildList[i].color_number
			rowXml.color_card_sequence = selectedChildList[i].color_card_sequence
			
			dgThreads.rows.appendChild(rowXml.copy());
		}
	}
	
	__localModel.threadXml = dgThreads.rows.copy();
	
	return 0;
}