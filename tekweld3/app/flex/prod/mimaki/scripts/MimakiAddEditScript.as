import business.events.GetInformationEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.events.AddEditEvent;
import com.generic.events.InboxEvent;
import com.generic.genclass.URL;
import com.generic.genclass.Utility;
import com.generic.customcomponents.GenButton;

import flash.events.Event;
import flash.events.MouseEvent;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.CheckBox;
import mx.controls.Spacer;
import mx.core.Application;
import mx.events.ListEvent;
import mx.managers.CursorManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import prod.mimaki.MimakiModelLocator;
import prod.mimaki.components.Mimaki;

import saoi.muduleclasses.PrintObject;


private var indigoCode_status:GetInformationEvent;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:MimakiModelLocator =  MimakiModelLocator(__genModel.activeModelLocator);
private var __generateIndigo:IResponder;
private var __getOptionData:IResponder;
private var __service:ServiceLocator = __genModel.services;
private var oldValueIndigoCode:String;
private var newValueIndigoCode:String

[Embed("com/generic/assets/btn_print_pick_slip.png")]
private const printPickSlipButtonIcon:Class;

private function init():void
{
	addOptionBar();
}

private function addOptionBar():void
{
	var hb:HBox    = new HBox();	
	
	Mimaki(this.parentDocument).bcp.addChildAt(hb,7);
}
private function handleInboxItemFocusOut(event:InboxEvent):void
{
 	var oldValue:String = event.oldValues["print_flag"].toString();

	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["print_flag"] = 'Y';
	}
	else
	{
		inbox.focusedRow["print_flag"] = 'N';
	}
	
}
private function genratePickSlipHandler(event:MouseEvent):void
{
	new PrintObject().genratePickSlipHandler(inbox);
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var retValue:int = 0;
	
	return retValue;
}