import business.events.GetInformationEvent;
import business.events.RecordStatusEvent;

import com.generic.events.AddEditEvent;

import model.GenModelLocator;

import mx.containers.*;
import mx.controls.*;
import mx.core.Application;
import mx.events.DragEvent;
import mx.managers.CursorManager;
import mx.rpc.IResponder;

import stup.userrolepermission.components.UserRolePermission;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var getInformationEvent:GetInformationEvent;
private var xmlRole:XML;
private var userXML:XML =  new XML(<Users></Users>) ;
private var tempList:XML = new XML(<user_roles></user_roles>);

private function lookUpUpdate():void
{
	
	Application.application.enabled	=	false;
	CursorManager.showCursor();
	
	var callbacks:IResponder = new mx.rpc.Responder(handleLookupUpUserResult,null);
	getInformationEvent = new GetInformationEvent('user_lookup',callbacks,__genModel.user.userID,__genModel.user.default_company_id);
	getInformationEvent.dispatch();	
	
	
	/* var callbacksUser:IResponder = new mx.rpc.Responder(handleLookupUpUserResult, null);
	var getLookupDataEvent:GetLookupDataEvent = new GetLookupDataEvent('User', callbacksUser);
	getLookupDataEvent.dispatch(); */
	
}
private function handleLookupUpUserResult(result:XML):void
{
	var _user:XML = (XML)(result);
	for(var i:int =0; i<_user.children().length();i++)
	{
	  var temp:XML= new XML(<user_role></user_role>);
      temp.appendChild(<name>{_user.children()[i].name.toString()}</name>);
      temp.appendChild(<user_id>{_user.children()[i].id.toString()}</user_id>);
      temp.appendChild(<id/>);
      temp.appendChild(<trans_flag/>);
      userXML.appendChild(temp);
	}
	getUserListResultHandler(userXML);
	
	var callbacks:IResponder = new mx.rpc.Responder(handleLookupUpRoleResult,null);
	getInformationEvent = new GetInformationEvent('role_lookup',callbacks,__genModel.user.userID,__genModel.user.default_company_id);
	getInformationEvent.dispatch();	
	
	/* var callbacksRole:IResponder = new mx.rpc.Responder(handleLookupUpRoleResult, null);
	var getLookupDataEvent:GetLookupDataEvent = new GetLookupDataEvent('Role', callbacksRole);
	getLookupDataEvent.dispatch(); */
}
private function handleLookupUpRoleResult(result:XML):void
{
	getRoleListResultHandler((XML)(result));
}
private function init():void
{
	UserRolePermission(this.parentDocument).bcp.btnRefresh.visible=false;
	lookUpUpdate();
}

private function getUserListResultHandler(user:XML):void
{
	lbUser.dataProvider = user.children();
}

private function getRoleListResultHandler(role:XML):void
{
	var _resultXml:XML = (XML)(role);
 	if (_resultXml.children().length() > 0)
	{
		createAccordion(_resultXml);
	}
}

private function createAccordion(aXml:XML):void
{
	accUserRole.removeAllChildren();
	for(var i:int = 0 ;i < aXml.children().length();i++)
   	{
		var _vbox:VBox = new VBox();
        var _list:List = new List();
        							        		
		_vbox.percentHeight = 100;
		_vbox.percentWidth = 100;
		_list.percentHeight = 100;
		_list.percentWidth = 100;
		
		_vbox.label = aXml.children()[i]['name'].toString();
		
		 _list.dropEnabled = true;
		_list.dragMoveEnabled = true;
		_list.dragEnabled = true;
		_list.labelField = 'name';
		
		_vbox.addChild(_list); 
		accUserRole.addChild(_vbox);
	}
	
	xmlRole = new XML(aXml);
    var callbacks:IResponder = new mx.rpc.Responder(getAssignedUserRoleListHandler, null);
	getInformationEvent	= new GetInformationEvent('get_assigned_user_role_list', callbacks);
	getInformationEvent.dispatch();  

}

private function getAssignedUserRoleListHandler(xml:XML):void
{
	Application.application.enabled	=	true;
	CursorManager.removeBusyCursor();
	
	var _resultXml:XML = XML(xml);
	
	 if (_resultXml.children().length() > 0)
	{
	    for(var j:int=0;j < xmlRole.children().length();j++)
		{
			var _userXml:XML = new XML(<user></user>);
			var _accobj:Object = accUserRole.getChildAt(j);
			var _acchildren:Object = _accobj.getChildAt(0);
			var _roleId:String = xmlRole.children()[j].id;
			
	 		for(var i:int=0;i < _resultXml.children().length(); i++) 
			{
				var _userRoleId:String = _resultXml.children()[i].role_id;
				if(_roleId == _userRoleId)
				{
					
					_userXml.appendChild(_resultXml.children()[i])
				}
			}
			_acchildren.dataProvider = _userXml.children();
		}
	}
	CursorManager.removeBusyCursor();
	Application.application.enabled = true; 
}

private  function resetHandler():void
{
	CursorManager.setBusyCursor();
	Application.application.enabled = false; 
	
	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("NEW")
	recordStatusEvent.dispatch()
		
	getUserListResultHandler(userXML);
	var callbacks:IResponder = new mx.rpc.Responder(getAssignedUserRoleListHandler, null);
	getInformationEvent	= new GetInformationEvent('get_assigned_user_role_list', callbacks);
	getInformationEvent.dispatch();  
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	save();
	return 0;
}
 
override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	var xml:XML = new XML(dgSave.rows);
	getAssignedUserRoleListHandler(xml)
 	dgSave.rows = new XML(<user_roles/>);
 	
}
 
private function  save():void
{
	var _aryaccChild:Array = new Array
	_aryaccChild = accUserRole.getChildren();
	var _tempXml:XML = new XML(<user_roles></user_roles>);
	for (var i:int =0 ;i < _aryaccChild.length ; i++)
	{
		var _accobj:Object = accUserRole.getChildAt(i);
		var _acchildren:Object = _accobj.getChildAt(0);
		var _dataProviderXml:XML = new XML(<user_roles></user_roles>);
		_dataProviderXml.appendChild(XMLList(_acchildren.dataProvider));
		var _subXml:XML = new XML(<user_role></user_role>);
 		if(_dataProviderXml.children().length()>0)
 		{
 			for (var j:int=0;j<_dataProviderXml.children().length();j++)
			{            
				_subXml.appendChild(_dataProviderXml.user_role[j]);
				_subXml.user_role[j].trans_flag = 'A';
				 if(_accobj.label == xmlRole.children()[i]['name'])
				{
					_subXml.user_role[j].role_id=xmlRole.children()[i]['id'].toString();
				} 
			}
			
 			_tempXml.appendChild(_subXml.children());
 		}
 		
 	}
 	 XML(dgSave.rows).appendChild(_tempXml.children());
} 

private function dragToAcc(event:DragEvent):void
{
	var _items:Array = event.dragSource.dataForFormat("items") as Array;
	var _itemXml:XML = XML(_items);
    var _accobj:Object = accUserRole.selectedChild;
	var _acchildren:List = List(_accobj.getChildAt(0));
	var _dataProviderXml:XML = new XML(<user_roles></user_roles>);
	var _temp:XML = new XML(<user_roles></user_roles>);
	var xmllist:XMLList = new XMLList(_acchildren.dataProvider);
	_dataProviderXml.appendChild(xmllist);
	 var length:int = _dataProviderXml.children().length();
	 var user_id:Number;
	 user_id = Number(_itemXml..user_id.toString());
	var onetime:Boolean = false;
	for(var i:int=0;i<length;i++)
	{
		if(user_id  != Number(_dataProviderXml.user_role[i].user_id.toString()) )
		{
			_temp.appendChild(_dataProviderXml.user_role[i]); 
		}
		
		else if(user_id  == Number(_dataProviderXml.user_role[i].user_id.toString()) && Number(_dataProviderXml.user_role[i].id.toString())>0)
		{
			_dataProviderXml.user_role[i].id= '';
			_dataProviderXml.user_role[i].lock_version = 0;
			_temp.appendChild(_dataProviderXml.user_role[i]);
			onetime = true; 
		}
		else if(user_id  == Number(_dataProviderXml.user_role[i].user_id.toString()) && onetime==false)
		{
			_temp.appendChild(_dataProviderXml.user_role[i]);
			onetime = true; 
		} 
		
	}
	_acchildren.dataProvider = _temp.children();
	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("MODIFY");
	recordStatusEvent.dispatch();
}

private function same(id:Number):Boolean
{
	var same:Boolean =false;
	for(var i:int; i<XML(dgSave.rows).children().length();i++)
	{
		if(id == Number(XML(dgSave.rows).user_role[i].id))
		{
			same = true;
			return same;
		}
		
	}
	return same;
}

private function dragToList(event:DragEvent):void
{
	var _items:Array = event.dragSource.dataForFormat("items") as Array;
	var _itemXml:XML = XML(_items);
	var xml:XML = new XML(dgSave.rows);
	var length:Number = XML(dgSave.rows).length();
	 if(Number(_itemXml.id.toString())>0 && XML(dgSave.rows).children().length()<1)
	{
		_itemXml.trans_flag = 'D';
		XML(dgSave.rows).appendChild(_itemXml);
	}
	else
	{
		for(var i:int = 0; i<length;i++)
		{
			if(Number(_itemXml.id.toString())>0 && same(Number(_itemXml.id))==false )
			{
				_itemXml.trans_flag = 'D';
				XML(dgSave.rows).appendChild(_itemXml);
			}
		}
	} 
	var recordStatusEvent:RecordStatusEvent = new RecordStatusEvent("MODIFY");
	recordStatusEvent.dispatch(); 
}	