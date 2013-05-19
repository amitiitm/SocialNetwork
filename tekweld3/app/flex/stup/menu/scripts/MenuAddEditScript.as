import business.events.GetLookupDataEvent;

import com.generic.events.AddEditEvent;
import com.generic.genclass.GenValidator;

import flash.events.Event;

import model.GenModelLocator;

import mx.core.Application;
import mx.managers.CursorManager;
import mx.rpc.IResponder;

import stup.menu.MenuModelLocator;

[Bindable]
private var __localModel:MenuModelLocator = (MenuModelLocator)(GenModelLocator.getInstance().activeModelLocator);

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var _user:XML;


private function setDocument(): void
{
	if(cbMenu_type.dataValue.toUpperCase()=='M')
	{
		dcMenu_id.dataValue				= "";
		dcDocument_id.dataValue			= "";
		dcDocument_id.labelValue			= "";
		dcMenu_id.enabled 	  			= false;
		dcDocument_id.enabled 			= false ;
		dcDocument_id.validationFlag    = "false";
		dcMenu_id.validationFlag 		= "false";
		tiPage_name.validationFlag		= "false"
		cbVisible_flag.dataValue 		= cbVisible_flag.defaultValue;	
		cbVisible_flag.enabled          = false;
	}
	else
	{
		dcMenu_id.enabled     			= true;
		dcDocument_id.enabled 			= true ;
		tiPage_name.enabled				= true;
		cbVisible_flag.enabled			= true;
		dcDocument_id.validationFlag 	= "true";
		dcMenu_id.validationFlag 		= "true";
		tiPage_name.validationFlag		= "true"	
	}
	
	var genValidator:GenValidator = new GenValidator();
	__localModel.addEditObj.validators = genValidator.applyValidation(__localModel.addEditObj.genObjects)
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	tiCode.enabled = false;
	dcMenu_id.filterKeyValue = dcModule_id.dataValue;
	
	if(cbMenu_type.dataValue.toUpperCase()=='M')
	{
		dcMenu_id.enabled 	  			= false;
		dcDocument_id.enabled 			= false ;
		dcDocument_id.validationFlag    = "false";
		dcMenu_id.validationFlag 		= "false";
		tiPage_name.validationFlag		= "false"
		cbVisible_flag.dataValue 		= cbVisible_flag.defaultValue;	
		cbVisible_flag.enabled          = false;
	}
	else
	{
		dcMenu_id.enabled     			= true;
		dcDocument_id.enabled 			= true ;
		tiPage_name.enabled				= true;
		cbVisible_flag.enabled			= true;
		dcDocument_id.validationFlag 	= "true";
		dcMenu_id.validationFlag 		= "true";
		tiPage_name.validationFlag		= "true"	
	}
	var genValidator:GenValidator = new GenValidator();
	__localModel.addEditObj.validators = genValidator.applyValidation(__localModel.addEditObj.genObjects)
}

override protected function resetObjectEventHandler():void
{
	tiCode.enabled = true;
	if(cbMenu_type.dataValue.toUpperCase()=='M')
	{
		dcMenu_id.enabled 	  			= false;
		dcDocument_id.enabled 			= false ;
		dcDocument_id.validationFlag    = "false";
		dcMenu_id.validationFlag 		= "false";
		tiPage_name.validationFlag		= "false"
		cbVisible_flag.dataValue 		= cbVisible_flag.defaultValue;	
		cbVisible_flag.enabled          = false;
	}
	else
	{
		dcMenu_id.enabled     			= true;
		dcDocument_id.enabled 			= true ;
		tiPage_name.enabled				= true;
		cbVisible_flag.enabled			= true;
		dcDocument_id.validationFlag 	= "true";
		dcMenu_id.validationFlag 		= "true";
		tiPage_name.validationFlag		= "true"	
	}
	var genValidator:GenValidator = new GenValidator();
	__localModel.addEditObj.validators = genValidator.applyValidation(__localModel.addEditObj.genObjects)
}


public function handleBtnClick(event:Event):void
{
	dcMenu_id.filterKeyValue = dcModule_id.dataValue;
	
	/* if(cbMenu_type.dataValue.toUpperCase()=='M')
	{
		return;
	}
	else
	{
		var type:String = event.type.toUpperCase();
		if(type == 'CLICK')
		{
			CursorManager.setBusyCursor();
			Application.application.enabled = false;
			var callbacksMenu:IResponder = new mx.rpc.Responder(handleLookupUpMenuResult, null);
			var getLookupDataEvent:GetLookupDataEvent = new GetLookupDataEvent('Menu', callbacksMenu);
			getLookupDataEvent.dispatch();
			
			
		}
		else
		{
			if(dcModule_id.text !='' && dcMenu_id.text!=null)
			{
				dcMenu_id.dataProvider = XMLList(__genModel.lookupObj.menu.children().(moodule_id ==dcModule_id.dataValue && menu_type=='M'));
			}
			else
			{
				dcMenu_id.dataProvider= __genModel.lookupObj.menu.children().(menu_type=='M');
			}	
			dcMenu_id.dataValue    = "";
		}
	} */

}

/* public function handleLookupUpMenuResult(result:Object):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled	=	true;
	_user= (XML)(result);
	if(dcModule_id.text !='' && dcMenu_id.text!=null)
	{
		dcMenu_id.dataProvider = XMLList(_user.children().(moodule_id ==dcModule_id.dataValue && menu_type=='M'));
	}
	else
	{
		dcMenu_id.dataProvider= _user.children().(menu_type=='M');	
	}
	dcMenu_id.dataValue    = "";	
} */

override protected function copyRecordCompleteEventHandler():void
{
	tiCode.dataValue	=	'';
}