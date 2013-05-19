// ActionScript file
import business.events.FetchRecordWithDetailSelectEvent;
import business.events.InitializeFetchRecordsWithDetailEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.customcomponents.GenTextInput;
import com.generic.events.FetchRecordEvent;
import com.generic.events.GenComponentEvent;
import com.generic.genclass.GenObject;
import com.generic.genclass.URL;

import flash.events.Event;
import flash.events.KeyboardEvent;

import model.GenModelLocator;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.DataGridEvent;
import mx.events.ScrollEvent;
import mx.events.ScrollEventDirection;
import mx.formatters.DateFormatter;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import valueObjects.DetailEditVO;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var initializeFetchRecordsWithDetailEvent:InitializeFetchRecordsWithDetailEvent;
private var fetchRecordWithDetailSelectEvent:FetchRecordWithDetailSelectEvent;
private var filterdRows:XML;

private var rootNode:String;
private var __detailEditObj:DetailEditVO;
private var genObj:GenObject

private function creationCompleteHandler():void
{
	this.setFocus();
	this.addEventListener(GenComponentEvent.VALUE_UPDATE_COMPLETE_EVENT,genComponentSaveCompleteHandler);
	
	var callbacks:IResponder = new mx.rpc.Responder(callbackInitializeFetchRecords, null);
	initializeFetchRecordsWithDetailEvent = new InitializeFetchRecordsWithDetailEvent(dgFetchDtl,callbacks);
	initializeFetchRecordsWithDetailEvent.dispatch(); 
	
	__detailEditObj			=	__genModel.activeModelLocator.detailEditObj;
	
	rootNode				= 	__detailEditObj.genDataGrid.rootNode;
	genObj 					= 	new GenObject();
}
private function callbackInitializeFetchRecords(str:String):void
{
	switch(str)
	{
		case 'STRUCTURE COMPLETED':
				createSearchInputs()
		break
		case 'DATA COMPLETED':
				filterdRows		=	dgFetchDtl.rows;
		break
	}
	
}
private function createSearchInputs():void
{
	var structure:XML	=	dgFetchDtl.structure
	var tiSearch:GenTextInput;
	for(var i:int = 0 ; i < structure.children().length()	;	i++)
	{
		if( structure.children()[i].@visible.toString()	==	'true')
		{
			tiSearch			=	new GenTextInput();
			tiSearch.name		=	structure.children()[i].@data.toString();
			tiSearch.dataType	=	structure.children()[i].@sortDataType.toString();

			/*when we focus out then text autometically set down to integer value because of code in GenTextInputScript 
			to resolve this problem we have done this*/
			if(structure.children()[i].@sortDataType.toString() == 'N')
			{
				var maxValue:String    =	'.' 
				if(structure.children()[i].@columnPrecision.toString()!= '' &&  Number(structure.children()[i].@columnPrecision.toString()) > 0)
				{
					for(var k:int = 0; k < Number(structure.children()[i].@columnPrecision.toString()) ; k++)
					{
						maxValue	=	maxValue + '9'  //we can take any integer value we have taken '9'
					}
					
					tiSearch.maxValue = Number(maxValue); //here maxValue is used just to set precesion value after focus out
				}
				else
				{
					tiSearch.maxValue = 1;
				}
			}


			tiSearch.width		=	Number(structure.children()[i].@width.toString());
			tiSearch.height		=	20;
			tiSearch.setStyle('textAlign' , structure.children()[i].@textAlign);
			tiSearch.addEventListener(KeyboardEvent.KEY_UP,filterRows);
			hbSearchBox.addChild(tiSearch);
		}
	}
	
	var arr:Array	=	hbSearchBox.getChildren();
	
	var lastChild:GenTextInput	=	GenTextInput( hbSearchBox.getChildAt(arr.length -1));
	lastChild.percentWidth		=	100;
}
private function filterRows(event:Event):void
{
	var scrollPosition:Number	=	dgFetchDtl.horizontalScrollPosition;
	
	var searchedRows:XML = new XML('<'+ filterdRows.localName().toString()+ '/>')
	
	var tempList:XMLList	=	new XMLList();
	tempList				=	filterdRows.children();

	var arr:Array			=	hbSearchBox.getChildren();
	var filerKey:String ;
	var filterValue:String; 
	
	for(var i:int=0 ; i< arr.length; i++)
	{
		if(GenTextInput(arr[i]).text != '')
		{
			filerKey		=	arr[i].name;
			filterValue		=	arr[i].text;
			
			if(GenTextInput(arr[i]).dataType == "D")
			{
				tempList 		= 	tempList.(dateFunc(String(child(filerKey))).substr(0,filterValue.length).toUpperCase()	==	filterValue.toUpperCase())	
			}
			else
			{
				tempList 		= 	tempList.(String(child(filerKey)).substr(0,filterValue.length).toUpperCase()	==	filterValue.toUpperCase())
			}
				
		
		}
	}
	if(tempList.children().length() > 0)
	{
		searchedRows.appendChild(tempList);
		dgFetchDtl.rows	=	searchedRows;
	}
	else
	{
		dgFetchDtl.rows	=	new XML('<'+ filterdRows.localName().toString()+ '/>')
		//dgFetchDtl.rows	=	filterdRows
	}
	
	dgFetchDtl.horizontalScrollPosition	=	scrollPosition
	scrollDataGrid(dgFetchDtl.horizontalScrollPosition);	
	
}
private function changeColumnSizeHandler(event:DataGridEvent):void
{
	GenTextInput(hbSearchBox.getChildByName(dgFetchDtl.columns[event.columnIndex].dataField.toString())).width	=	dgFetchDtl.columns[event.columnIndex].width;
}
private function onScroll(event:ScrollEvent):void 
{
	if(event.direction == ScrollEventDirection.HORIZONTAL)
	{
		var invisibleColumns:int = dgFetchDtl.horizontalScrollPosition
		scrollDataGrid(invisibleColumns)
	}
}
private function handleResize(event:Event):void
{
	scrollDataGrid(dgFetchDtl.horizontalScrollPosition)
}
private function scrollDataGrid(invisibleColumns:int):void 
{
	var ary:Array = hbSearchBox.getChildren()
	
	if(ary.length > 0)
	{
		for(var i:int=0; i<invisibleColumns; i++)
		{
			ary[i].visible = false
			ary[i].width = 0
		}
		
		for(var j:int=invisibleColumns; j < dgFetchDtl.columns.length; j++)
		{
			ary[j].visible = true
			ary[j].width = dgFetchDtl.columns[j].width
		}
		var lastChild:GenTextInput	=	GenTextInput(hbSearchBox.getChildAt(ary.length -1));
		lastChild.percentWidth		=	100;
	}
}
private function selectButtonClickHandler():void
{
	fetchRecordWithDetailSelectEvent	=	new FetchRecordWithDetailSelectEvent(filterdRows);
	fetchRecordWithDetailSelectEvent.dispatch();
	closeHandler();
}
private function itemFocusOutEventHandler(event:Event):void
{
	if(__detailEditObj.isFetchSingleSelected)
	{ 
		if(String(dgFetchDtl.selectedRow.child('select_yn')).toUpperCase()	==	'Y')
		{
			var currentSelectedRowId:int;
			currentSelectedRowId		=	int(dgFetchDtl.selectedRow.child('id').toString())
			
			var selectedChildList:XMLList	=	null;
			
			selectedChildList	=	filterdRows.children().(child('select_yn').toString().toUpperCase() == 'Y')
			
			//unselect previous selected
			for(var i:int = 0 ; i< selectedChildList.length() ; i++)
			{
				if(int(XML(selectedChildList[i]).child('id').toString()) !=	currentSelectedRowId)
				{
					selectedChildList[i].select_yn		=	'N'
				}
			}
		}		
	}
}
private function closeHandler():void
{
	__genModel.activeModelLocator.addEditObj.addEditContainer.dispatchEvent(new FetchRecordEvent(FetchRecordEvent.FETCHWINDOWCANCEL_EVENT));
	PopUpManager.removePopUp(this)
}

private function selectRow():void
{
	CursorManager.setBusyCursor();
	this.enabled	=	false;
	
	reset();
	
	if(dgFetchDtl.selectedRow.select_yn == 	 'Y')
	{
		dgFetchDtl.selectedRow.select_yn = 	 'N';
		//vbDetail.getChildAt(0).dispatchEvent(new GenComponentEvent(GenComponentEvent.MAKE_DISABLE_EVENT,new XML(<root>Y</root>)))
	}
	else
	{
		dgFetchDtl.selectedRow.select_yn = 	 'Y'
		//vbDetail.getChildAt(0).dispatchEvent(new GenComponentEvent(GenComponentEvent.MAKE_DISABLE_EVENT,new XML(<root>N</root>)))
	}
	
	dgFetchDtl.dispatchEvent(new DataGridEvent(DataGridEvent.ITEM_FOCUS_OUT)); 
	
	if(dgFetchDtl.selectedRow.isAlreadyExist.toString()	==	"Y")
	{
		
		var rowXML:XML	=	XML(__detailEditObj.rows).children()[int(dgFetchDtl.selectedRow.isAppendAtPostion)]
		var _xml:XML	=	new XML('<' + rootNode + '/>');
		_xml.appendChild(rowXML.copy());
		
		populateComponent(_xml);//invisible components
		setDetail(_xml);	
	}
	else
	{
		if(dgFetchDtl.selectedRow.isAppend.toString()	==	"Y")
		{
			var row:XML	=	XML(__detailEditObj.rows).children()[int(dgFetchDtl.selectedRow.isAppendAtPostion)]
			var _xml:XML	=	new XML('<' + rootNode + '/>');
			_xml.appendChild(row.copy());
			
			populateComponent(_xml);//invisible components	
			setDetail(_xml);
			
		}
		else
		{
			var tempRow:XML		=	 getNewRow(dgFetchDtl.selectedRow);
			var _xml:XML		=	new XML('<' + rootNode + '/>')
			_xml.appendChild(tempRow.copy());
			populateComponent(_xml);
			
			
			var getBomService:HTTPService;
			var callbacksGetBom:IResponder = new mx.rpc.Responder(getBomDetailsHandler, faultHandler);
			var __locator:ServiceLocator = __genModel.services;
			getBomService = __locator.getHTTPService(__detailEditObj.transactionDetailServiceID);
			
			dataService(getBomService);
			
			var token:AsyncToken = getBomService.send(dgFetchDtl.selectedRow);
			token.addResponder(callbacksGetBom); 
	
		}
		
	}	
}
private function getBomDetailsHandler(event:ResultEvent):void
{
	var resultXML:XML	=	XML(event.result)
	
    if(resultXML.children().length() > 0)
	{  
		setDetail(resultXML);	
			
	}
	else
	{
		CursorManager.removeBusyCursor();
		this.enabled	=	true;	
		vbDetail.getChildAt(0).dispatchEvent(new GenComponentEvent(GenComponentEvent.MAKE_DISABLE_EVENT,new XML(<root>Y</root>)))
	}   

	var recordXML:XML	=	generateRecordXML();
		
	__detailEditObj.rows.appendChild(XML(recordXML.children()[0]));
	dgFetchDtl.selectedRow.isAppend			=	'Y';
	dgFetchDtl.selectedRow.isAppendAtPostion	=	__detailEditObj.rows.children().length() - 1;
				
}
private function setDetail(detailXML:XML):void
{
	vbDetail.getChildAt(0).dispatchEvent(new GenComponentEvent(GenComponentEvent.RETRIEVE_END_EVENT, detailXML));
	
	if(dgFetchDtl.selectedRow.select_yn == 	 'N')
	{
		vbDetail.getChildAt(0).dispatchEvent(new GenComponentEvent(GenComponentEvent.MAKE_DISABLE_EVENT,new XML(<root>Y</root>)))
	}
	else
	{
		vbDetail.getChildAt(0).dispatchEvent(new GenComponentEvent(GenComponentEvent.MAKE_DISABLE_EVENT,new XML(<root>N</root>)))
	}
	
	CursorManager.removeBusyCursor();
	this.enabled	=	true;	
}
private function genComponentSaveCompleteHandler(event:GenComponentEvent):void
{
	var recordXML:XML	=	generateRecordXML();
	var appendPosition:int	=	int(dgFetchDtl.selectedRow.isAppendAtPostion)
	XML(__detailEditObj.rows.children()[appendPosition]).setChildren(XML(recordXML.children()[0]).children())
}
private function dataService(service:HTTPService):HTTPService
{
	var urlObj:URL	=	new URL();
	service.url		=	urlObj.getURL(service.url.toString())
	
	service.resultFormat = "e4x";
	service.method = "POST";
	service.useProxy = false;
	service.contentType="application/xml";
	service.requestTimeout = 1800
	
	return service;
}
private function faultHandler(event:FaultEvent):void
{
	CursorManager.removeBusyCursor();
	this.enabled	=	true;
	Alert.show(event.fault.toString());
}
private function generateRecordXML():XML
{
	var tempXml:XML = genObj.generateRecordXML(__detailEditObj.genObjects);
	var tempRow:XML	= XML(tempXml.children()[0])
			
	tempRow.company_id		 = __genModel.user.default_company_id;

	if(tempRow[0]["id"] == '')
	{
		tempRow.created_by		 = __genModel.user.userID;
	}
	else
	{
		tempRow.updated_by	 	 = __genModel.user.userID;
	}	 
	
	return tempXml;
	 
}
private function populateComponent(xml:XML):void
{
	genObj.setRecord(__detailEditObj.genObjects, xml);
}
private function getNewRow(childXml:XML):XML
{
	var mappingArrCol:ArrayCollection	=	__detailEditObj.fetchMapingArrCol;
	var localName:String = rootNode.slice(0, rootNode.length - 1)
	
	var newRow:XML = new XML('<' + localName + '/>')
	var lsValue:String;
	
	for(var j:int=0; j < mappingArrCol.length; j++)
	{
		if(mappingArrCol.getItemAt(j).source == 'B')
		{
			//means we have to add blank field for this
			lsValue = '';
			var str:String = "<" + mappingArrCol.getItemAt(j).target + ">" + lsValue + "</" + mappingArrCol.getItemAt(j).target + ">"
			var tempChild:XML = new XML(str)
			newRow.appendChild(tempChild)
		}
		else
		{
			lsValue = childXml.child(mappingArrCol.getItemAt(j).source).toString();
			var str:String = "<" + mappingArrCol.getItemAt(j).target + ">" + lsValue + "</" + mappingArrCol.getItemAt(j).target + ">"
			var tempChild:XML = new XML(str)
			newRow.appendChild(tempChild)
		}
	}

	newRow.trans_flag = "A"
	newRow.id = "";
	newRow.serial_no = ""; 

	return newRow;
}
private function reset():void
{
	genObj.resetObjects(__detailEditObj.genObjects);
	vbDetail.getChildAt(0).dispatchEvent(new GenComponentEvent(GenComponentEvent.RESET_EVENT))
}
private function dateFunc(item:String):String
{
	var dateFormatter:DateFormatter = new DateFormatter();
	var date_format:String = __genModel.user.date_format.toLocaleUpperCase();
		
	if(date_format == null || date_format == "")
	{
		dateFormatter.formatString = 'MM/DD/YYYY';
	}
	else
	{
		dateFormatter.formatString = date_format;
	}

	return dateFormatter.format(item.toString());
}
private function detailKeyDownHandler(event:KeyboardEvent):void
{
	//it is needed otherwise keydown at application level will also work.

	var char:String 		= 	String.fromCharCode(event.charCode).toUpperCase();	
	
	if(event.ctrlKey &&  char != 'V')// we donot want to stop event when user press  ctrl + V(paste),so we cannot take ctrl + V as shortcust now 
	{
		event.stopImmediatePropagation();
		event.stopPropagation();
	}	
	
}