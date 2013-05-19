import business.events.GetInformationEvent;
import business.events.RecordStatusEvent;
import com.generic.events.AddEditEvent;
import model.GenModelLocator;
import mx.collections.IList;
import mx.containers.*;
import mx.controls.*;
import mx.core.Application;
import mx.events.DragEvent;
import mx.events.ListEvent;
import mx.managers.CursorManager;
import mx.rpc.IResponder;

import stup.rolepermission.RolePermissionModelLocator;
import stup.rolepermission.components.RolePermission;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
private var __localModel:RolePermissionModelLocator = (RolePermissionModelLocator)(GenModelLocator.getInstance().activeModelLocator);

private var getInformationEvent:GetInformationEvent;
private var menuXml:XML ;
public var _windowStatus:String;

private function init():void
{ 
	RolePermission(this.parentDocument).bcp.btnRefresh.visible=false;
}

private function dataChangeHandler(): void
{
	if(dcRole_id.dataValue != '')
	{
		CursorManager.setBusyCursor();
		Application.application.enabled = false; 
		dgList.deletedRows	=	new XML(<role_permission_details/>);
		
		var callbacks:IResponder = new mx.rpc.Responder(getUnassignMenuListResultHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('get_unassigned_menus', callbacks, dcRole_id.dataValue);
		getInformationEvent.dispatch(); 
	}
}

private function dcClickHandler():void
{
	if(_windowStatus == 'MODIFIED')
	{
		Alert.show("Please Save The Changes");
	}
}

private function getUnassignMenuListResultHandler(resultXml:XML):void
{	
	if (resultXml.children().length() > 0)
	{
		createAccordion(resultXml);
	
		if(dcRole_id.dataValue != '')
		{
			var callbacks:IResponder = new mx.rpc.Responder(getAssignMenuListResultHandler, null);
		
			getInformationEvent	=	new GetInformationEvent('get_menu_role_permissions', callbacks, dcRole_id.dataValue);
			getInformationEvent.dispatch();
			 
			CursorManager.removeBusyCursor();
			Application.application.enabled = true; 
		}
	}
}

private function getAssignMenuListResultHandler(resultXml:XML):void
{
	menuXml = resultXml;
	dgList.rows = menuXml;
}

private function createAccordion(menuXML:XML):void
{	
	accModule.removeAllChildren();
	
	for(var i:int = 0;i < menuXML.children().length();i++)
   	{
		var _vbox:VBox = new VBox();
       	var _list:List = new List();
        
        _vbox.percentHeight = 100;
		_vbox.percentWidth = 100;
		_list.percentHeight = 100;
		_list.percentWidth = 100;
		
		_vbox.label = menuXML.children()[i]['moodule_name'].toString();
		
		_list.dropEnabled = true;
		_list.dragMoveEnabled = true;
		_list.dragEnabled = true;
		_list.addEventListener(DragEvent.DRAG_DROP,accDragDrop);
		
		_vbox.addChild(_list);
		accModule.addChild(_vbox);
	}
	
	var _aryaccChild:Array = new Array
    _aryaccChild = accModule.getChildren();
	
    for(var j:int=0;j < _aryaccChild.length;j++)
	{
		var _subMenuXml:XML = new XML(<submenu></submenu>)
		var _accobj:Object = accModule.getChildAt(j);
		var _acchildren:Object = _accobj.getChildAt(0);
	
		for (var k:int=0;k < menuXML.children()[j]['sub_menu'].length();k++)
		{
			_subMenuXml.appendChild(
									menuXML.children()[j]['sub_menu'].child('menu_name')[k].text() + '(' +
									menuXML.children()[j]['sub_menu'].child('menu_id')[k].text()+')'
									);
		}
		_acchildren.dataProvider = _subMenuXml.children();
	}
}

public function accDragDrop(event:DragEvent):void
{
	if (event.dragSource.hasFormat("items"))
	{
		event.preventDefault();
	   	event.currentTarget.hideDropFeedback(event);
	
	   	var dropTarget:List=List(event.currentTarget);
	   	var itemsArray:Array = event.dragSource.dataForFormat("items") as Array;
	   	var tempXML:XML = (XML)(itemsArray);
	
	  	var tempMenuItem:String = tempXML.child('menu_name')+'('+tempXML.child('menu_id')+')';
		
	   	var dropLoc:int = dropTarget.calculateDropIndex(event);
		var s:String =dropLoc.toString()
	 
	   	IList(dropTarget.dataProvider).addItemAt(XML(tempMenuItem), dropLoc);
	   
		/*	for(var i:int=0;i< menuXml.children().length();i++ )
	   		{
				if (menuXml.children()[i].child('menu_name') == tempXML.child('menu_name'))
				{
					delete menuXml.children()[i];
				}
	  		 }
	  	*/
	}
	
	_windowStatus = 'MODIFIED';
	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("MODIFY");
	recordStatusEvent.dispatch();

	var newXml:XML = new XML(tempXML);
	newXml.trans_flag = "D";
	dgList.deletedRows.appendChild(newXml);
}

private function listDragDrop(event:DragEvent):void
{
	if (event.dragSource.hasFormat("items"))
	{                
		event.preventDefault();
		event.currentTarget.hideDropFeedback(event);
		
		var dropTarget:DataGrid=DataGrid(event.currentTarget);
		var itemsArray:Array = event.dragSource.dataForFormat("items") as Array;
		var tempMenuItem:String = itemsArray.toString();
	//	var index1:int = tempMenuItem.indexOf('(');
		var index1:int = tempMenuItem.lastIndexOf('(');
	//	var index2:int = tempMenuItem.indexOf(')');
	    var index2:int = tempMenuItem.lastIndexOf(')');
		var tempItem:XML = new XML();
		
		if(index1 > 0)
		{
			var menuItemId:String 	= tempMenuItem.substr(index1+1,index2-index1-1);
			var menuItem:String 	= tempMenuItem.substr(0,index1);
			var tempItem		  	= <role_permission_detail>
										<role_id>{dcRole_id.dataValue}</role_id>
										<permission_id></permission_id>
										<menu_name>{menuItem}</menu_name>
										<menu_id>{menuItemId}</menu_id>
										<trans_flag>A</trans_flag>
										<create_permission>N</create_permission>
							    		<modify_permission>N</modify_permission>
							    		<view_permission>N</view_permission>
							    		<id></id>
									 </role_permission_detail>;
							 
			var dropLoc:int = dropTarget.calculateDropIndex(event);
			(dropTarget.dataProvider).addItemAt(XML(tempItem), dropLoc);
			
			_windowStatus = 'MODIFIED';
			var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("MODIFY");
			recordStatusEvent.dispatch();
		}
		else
		{
			//Do nothing
		}
	}
}

private function setWindowStatus(event:ListEvent):void
{
	_windowStatus = 'MODIFIED';
	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("MODIFY");
	recordStatusEvent.dispatch();
}

private function btnClickHandler():void
{
	_windowStatus = 'NEW'
	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("NEW")
	recordStatusEvent.dispatch()
	
	if(dcRole_id.dataValue != '')
	{	
		CursorManager.setBusyCursor();
		Application.application.enabled = false; 
		
		var callbacks:IResponder = new mx.rpc.Responder(getUnassignMenuListResultHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('get_unassigned_menus', callbacks, dcRole_id.dataValue);
		getInformationEvent.dispatch();
	}	
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	_windowStatus = 'SAVED'
	var recordStatusEvent:RecordStatusEvent = new	RecordStatusEvent("NEW") 
	recordStatusEvent.dispatch()
	return 0;
}

override protected function resetObjectEventHandler():void   
{
	dgList.deletedRows	=	new XML(<role_permission_details/>);
}
	
override protected function retrieveRecordEventHandler(event:AddEditEvent):void  
{
	dgList.deletedRows	=	new XML(<role_permission_details/>);
}
