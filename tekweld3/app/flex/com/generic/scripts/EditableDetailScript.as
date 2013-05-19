import business.events.FetchRecordsEvent;
import business.events.FetchRecordsWithDetailEvent;
import business.events.RecordStatusEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.components.FetchCriteria;
import com.generic.events.ButtonControlDetailEvent;
import com.generic.events.EditableDetailEvent;
import com.generic.events.FetchCriteriaEvent;

import model.GenModelLocator;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.events.DataGridEvent;
import mx.events.ListEvent;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import valueObjects.DetailEditVO;
import valueObjects.ViewVO;

[Bindable]
public var updatableFlag:String = "false";

[Bindable]
public var checkBlankRowColumn:String = "";

[Bindable]
public var rootNode:String = "";

[Bindable]
public var formatServiceID:String = "";

[Bindable]
public var deletedRows:XML;

//fetch record releted
public var fetchDetailFormatServiceID:String = "";
public var fetchDetailDataServiceID:String = "";
public var fetchGetSelectedDetailServiceID:String = "";
public var transactionDetailServiceID:String	=	"";

public var dc_id:Object	=	null;
public var fetchMapingArrCol:ArrayCollection;
public var title:String = "";
private var fetchRecordsEvent:FetchRecordsEvent;
private var fetchRecordsWithDetailEvent:FetchRecordsWithDetailEvent;

public var _isFetchSingleSelected:Boolean			=	false;
public var _isFetchMultipalSelected:Boolean			=	true;
public var _isDetailRequired:Boolean				=	false;
public var _isOverrideDetail:Boolean				=	false;

private var recordStatusEvent:RecordStatusEvent;
public var recordStatusEnabled:Boolean = true;
[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

private var _viewOnlyFlag:Boolean = false
private var _initialEditableFlag:Boolean = true
private var _structure:XML;
//
public var DetailEditClass:Class;
[Bindable]
public var _btnFetchWithDetailVisible:Boolean=false;
[Bindable]
public var _btnFetchVisible:Boolean=true;

[Bindable]
public var _isFetchFromCriteria:Boolean=false;/*fetch records on the basis of criteria*/
public var fetchCriteriaXML:XML;	
public var fetchViewFormatID:String;
public var	isCriteriaOKHandlerAtScreenLevel:Boolean = false;

public function set isFetchFromCriteria(value:Boolean):void
{
	_isFetchFromCriteria	=	value	
}
public function get isFetchFromCriteria():Boolean
{
	return _isFetchFromCriteria;	
}
public function set btnFetchWithDetailVisible(value:Boolean):void
{
	if(value)
	{
		_btnFetchVisible	=	false;
		_btnFetchWithDetailVisible	=	true;	
	}
	
	
}
public function get btnFetchWithDetailVisible():Boolean
{
	return _btnFetchWithDetailVisible;
}
public function set btnFetchVisible(value:Boolean):void
{
	if(value)
	{
		_btnFetchVisible	=	true;
		_btnFetchWithDetailVisible	=	false;	
	}
}
public function get btnFetchVisible():Boolean
{
	return _btnFetchVisible;
}
//-----------------------------------------------------------------------------------
public function set isFetchMultipalSelected(value:Boolean):void
{
	_isFetchMultipalSelected	=	value;
	if(value)
	{
		isFetchSingleSelected	=	false;
	}
}

public function get isFetchMultipalSelected():Boolean
{
	return _isFetchMultipalSelected;
}

public function set isFetchSingleSelected(value:Boolean):void
{
	_isFetchSingleSelected	=	value;
	
	if(value)
	{
		isFetchMultipalSelected	=	false;
	}
}

public function get isFetchSingleSelected():Boolean
{
	return _isFetchSingleSelected;
}

public function set isOverrideDetail(value:Boolean):void
{
	_isOverrideDetail	=	value;
	
}

public function get isOverrideDetail():Boolean
{
	return _isOverrideDetail;
}

public function set isDetailRequired(value:Boolean):void
{
	_isDetailRequired	=	value;
	
}

public function get isDetailRequired():Boolean
{
	return _isDetailRequired;
}

public function set structure(aXML:XML):void
{
	_structure = aXML;
	dgDtl.structure = aXML;
}

public function get structure():XML
{
	return _structure;
}

public function set initialEditableFlag(aBoolean:Boolean):void //jeetu 21/01/2010 
{
 	_initialEditableFlag	=	true;
}

public function get initialEditableFlag():Boolean
{
 	return _initialEditableFlag
}

public function set dataValue(aXML:XML):void //jeetu 21/01/2010 
{
 	dgDtl.rows	=	aXML;
}

public function get dataValue():XML
{
 	return dgDtl.rows;
}

public function set viewOnlyFlag(aBoolean:Boolean):void
{
	_viewOnlyFlag = aBoolean
	
	if(initialEditableFlag)
 	{
	 	dgDtl.editable = !aBoolean	
	}
}

public function get viewOnlyFlag():Boolean
{
 	return _viewOnlyFlag
}

public function set fetchRecordFlag(isVisible:Boolean):void
{
	if(!isVisible)
	{
		_btnFetchVisible	=	false;
		_btnFetchWithDetailVisible	=	false;
	}
}

private function itemClickHandler(event:ListEvent):void
{
	var colname:String =  DataGridColumn(event.currentTarget.columns[event.columnIndex]).dataField.toString()
	dispatchEvent(new EditableDetailEvent(EditableDetailEvent.DETAIL_ITEM_CLICK, null, event, null));
}

private function itemFocusOutHandler(event:DataGridEvent):void
{
	if(recordStatusEnabled)
	{
		recordStatusEvent = new	RecordStatusEvent("MODIFY");
		recordStatusEvent.dispatch();
	}

	dispatchEvent(new EditableDetailEvent(EditableDetailEvent.DETAIL_ITEM_FOCUS_OUT,event,null,null));
}

private function removeRowHandler(event:ButtonControlDetailEvent):void
{
	deleteRow(dgDtl.selectedIndex);
}

// VD 14/03/2011
public function deleteRow(row:int):void
{
	if(!viewOnlyFlag)
	{
		if(row >= 0)
		{	
			var tempXml:XML;
			var dgDtlRow:XML = new XML(dgDtl.dataProvider[row]);
			var node:String = dgDtlRow.localName();
			var deleteChild:XML	=	new XML(dgDtlRow);
					
			deleteChild.trans_flag = "D";
					
			if(Number(deleteChild.child('id').toString()) > 0)
			{
				XML(dgDtl.deletedRows).appendChild(deleteChild);
			} 
					
			delete dgDtl.rows.child(node)[row];	
			tempXml	=  new XML(XML(dgDtl.rows).copy());
			dgDtl.rows	=	tempXml; 
					
			dispatchEvent(new EditableDetailEvent(EditableDetailEvent.DETAIL_REMOVE_ROW));
			
			if(recordStatusEnabled)
			{
				recordStatusEvent = new	RecordStatusEvent("MODIFY");
				recordStatusEvent.dispatch();
			}
		}
	} 
}
private var fetchCriteriaObj:FetchCriteria;
private function fetchRecordsHandler(event:ButtonControlDetailEvent):void
{
	if(!viewOnlyFlag)
	{
		if(isFetchFromCriteria)
		{
			getCriteriaFormat()
		}
		else
		{
			if(dc_id.dataValue != '' && dc_id.dataValue != null)
			{
				setFetchRecords();
				
			}
			else
			{
				Alert.show(dc_id.toolTip + ' is required');
			}
			
		}		
	}
}
private function setFetchRecords():void
{
	__genModel.activeModelLocator.detailEditObj = new DetailEditVO();

	__genModel.activeModelLocator.detailEditObj.genDataGrid						=	dgDtl	;
	__genModel.activeModelLocator.detailEditObj.selectedRow						=	dgDtl.selectedRow;
	
	
	__genModel.activeModelLocator.detailEditObj.title							=	title
	
	if(dc_id != null)
	{
		__genModel.activeModelLocator.detailEditObj.id							=	dc_id.dataValue;	
	}
	
	__genModel.activeModelLocator.detailEditObj.fetchDetailFormatServiceID		=	fetchDetailFormatServiceID;
	__genModel.activeModelLocator.detailEditObj.fetchDetailDataServiceID		=	fetchDetailDataServiceID;
	__genModel.activeModelLocator.detailEditObj.fetchMapingArrCol				=	fetchMapingArrCol;
	
	__genModel.activeModelLocator.detailEditObj.isFetchSingleSelected			=	isFetchSingleSelected;	
	__genModel.activeModelLocator.detailEditObj.fetchGetSelectedDetailServiceID	=	fetchGetSelectedDetailServiceID;
	
	__genModel.activeModelLocator.detailEditObj.isFetchMultipalSelected			=	isFetchMultipalSelected;	
	
	__genModel.activeModelLocator.detailEditObj.isDetailRequired				=	isDetailRequired;
	__genModel.activeModelLocator.detailEditObj.isOverrideDetail				=	isOverrideDetail;
	
	//when fetch records on the basis of criteria.
	__genModel.activeModelLocator.detailEditObj.isFetchFromCriteria				=	isFetchFromCriteria;
	__genModel.activeModelLocator.detailEditObj.fetchCriteriaXML				=	fetchCriteriaXML;
	
	fetchRecordsEvent = new FetchRecordsEvent();
	fetchRecordsEvent.dispatch();	
}
private function fetchRecordsWithDetailHandler(event:ButtonControlDetailEvent):void
{
	if(!viewOnlyFlag)
	{
		if(isFetchFromCriteria)
		{
			getCriteriaFormat()
		}
		else
		{
			if(dc_id.dataValue != '' && dc_id.dataValue != null)
			{
				setFetchRecordsWithDetail();
			}
			else
			{
				Alert.show(dc_id.toolTip + ' is required');
			}
		}		
	}	
}
private function setFetchRecordsWithDetail():void
{
	__genModel.activeModelLocator.detailEditObj = new DetailEditVO();

	
	__genModel.activeModelLocator.detailEditObj.detailEditContainer 			= 	new  DetailEditClass();
	
	__genModel.activeModelLocator.detailEditObj.genDataGrid						=	dgDtl	;
	__genModel.activeModelLocator.detailEditObj.selectedRow						=	dgDtl.selectedRow;
	
	
	__genModel.activeModelLocator.detailEditObj.title							=	title
	
	if(dc_id != null)
	{
		__genModel.activeModelLocator.detailEditObj.id							=	dc_id.dataValue;	
	}
	
	__genModel.activeModelLocator.detailEditObj.fetchDetailFormatServiceID		=	fetchDetailFormatServiceID;
	__genModel.activeModelLocator.detailEditObj.fetchDetailDataServiceID		=	fetchDetailDataServiceID;
	__genModel.activeModelLocator.detailEditObj.transactionDetailServiceID		=	transactionDetailServiceID;//bomdetail
	__genModel.activeModelLocator.detailEditObj.fetchMapingArrCol				=	fetchMapingArrCol;
	
	__genModel.activeModelLocator.detailEditObj.isFetchSingleSelected			=	isFetchSingleSelected;	
	__genModel.activeModelLocator.detailEditObj.fetchGetSelectedDetailServiceID	=	"";
	
	__genModel.activeModelLocator.detailEditObj.isFetchMultipalSelected			=	isFetchMultipalSelected;	
	
	__genModel.activeModelLocator.detailEditObj.isDetailRequired				=	false;
	__genModel.activeModelLocator.detailEditObj.isOverrideDetail				=	false;

	//when fetch records on the basis of criteria.
	__genModel.activeModelLocator.detailEditObj.isFetchFromCriteria				=	isFetchFromCriteria;
	__genModel.activeModelLocator.detailEditObj.fetchCriteriaXML				=	fetchCriteriaXML;
		
	fetchRecordsWithDetailEvent = new FetchRecordsWithDetailEvent();
	fetchRecordsWithDetailEvent.dispatch();	
}
private function creationCompleteHandler():void
{
	dgDtl.rows  = new XML('<' + rootNode + '/>');
	dgDtl.selectedRow	=	null;
}

/****************************Fetch on the basis of criteria functionality********************************************/
private function getCriteriaFormat():void
{
	CursorManager.setBusyCursor();
	Application.application.enabled	=	false;

	var __criteriaFormatService:HTTPService;
	var callbacksCriteriaFormat:IResponder = new mx.rpc.Responder(getFetchCriteriaFormatResultHandler, faultHandler);
	var __locator:ServiceLocator = __genModel.services;
	__criteriaFormatService = __locator.getHTTPService(fetchViewFormatID);
	
	formatService(__criteriaFormatService);
			
	var token:AsyncToken = __criteriaFormatService.send();
	token.addResponder(callbacksCriteriaFormat);
	
}
private function getFetchCriteriaFormatResultHandler(event:ResultEvent):void
{	
	var viewFormat:XML		=	XML(event.result);			  

	var __viewObj:ViewVO		=	new ViewVO();
	var criteriaXML:XML			=	__viewObj.criteria.copy();
	
	criteriaXML.default_yn 		=	"N";
	criteriaXML.company_id 		= 	__genModel.user.default_company_id;
	criteriaXML.user_id 		= 	__genModel.user.userID;
	criteriaXML.trans_flag 		= 	"A";
	criteriaXML.criteria_type 	= 	"U";
	criteriaXML.name	 		= 	"New Criteria";
	criteriaXML.default_request = 	"N";

	fetchCriteriaObj 			= 	FetchCriteria(PopUpManager.createPopUp(this, FetchCriteria, true));
	fetchCriteriaObj.x 			= 	fetchCriteriaObj.x + fetchCriteriaObj.width / 6;
	fetchCriteriaObj.y 			= 	fetchCriteriaObj.y + fetchCriteriaObj.height / 6;
	fetchCriteriaObj.title		=	'Criteria';
	
	fetchCriteriaObj.initializeView(viewFormat,criteriaXML);

	fetchCriteriaObj.addEventListener(FetchCriteriaEvent.OK_CLICK_EVENT,fetchCriteriaOKEventHandler);
}
private function fetchCriteriaOKEventHandler(e:FetchCriteriaEvent):void
{
	fetchCriteriaXML	=	e.criteriaXML;
	
	if(isCriteriaOKHandlerAtScreenLevel)
	{
		dispatchEvent(new EditableDetailEvent(EditableDetailEvent.FETCH_CRITERIA_OK_COMPLETE, null, null, null,fetchCriteriaXML));
	}
	else
	{
		openFetchWindow();
	}
	
	fetchCriteriaObj.removeEventListener(FetchCriteriaEvent.OK_CLICK_EVENT,fetchCriteriaOKEventHandler);
}
public function openFetchWindow():void
{
	if(btnFetchVisible)
	{
		setFetchRecords();
	}
	else//btnFetchWithDetail is visible
	{
		setFetchRecordsWithDetail();
	}	
}

private function formatService(service:HTTPService):HTTPService
{
	service.resultFormat = "e4x";
	service.method = "POST";
	service.useProxy = false;
	
	return service;
}
private function faultHandler(event:FaultEvent):void
{
	Alert.show('fetch structure :' + event.fault.toString() );
}