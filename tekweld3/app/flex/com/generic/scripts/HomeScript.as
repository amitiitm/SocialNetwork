import business.events.GetMenuEvent;
import business.events.LogoutEvent;
import business.events.UpdateUserLastModuleEvent;

import com.generic.components.*;
import com.generic.customcomponents.*;
import com.generic.genclass.TabPage;

import flash.net.navigateToURL;

import model.GenModelLocator;

import mx.containers.*;
import mx.controls.*;
import mx.core.Application;
import mx.events.MenuEvent;
import mx.managers.PopUpManager;

[Bindable]
public var xmlModule:XML ; 

[Bindable]
public var xmlFilteredMenu:XML;

[Bindable]
public var lsUser:String;

[Bindable]
public var lsCompany:String;

[Bindable]
public var lsType_name:String;

private var tabPage:TabPage;
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private function creationComplete(): void
{
	__genModel.tabMain	=	tabMain;
	mainURL();
}

public function set selectedModule(aXML:XML):void
{
	cbMoodule.selectedItem = aXML;	
} 

private function cbModuleChangeHandler(): void
{
	var module_id:int = (int)(cbMoodule.selectedItem.id) ;
	var menuEvent:GetMenuEvent = new GetMenuEvent(module_id);
	menuEvent.dispatch();
	
	GenModelLocator.getInstance().applicationObject.selectedModule = (XML)(cbMoodule.selectedItem)
	
	var lastModuleEvent:UpdateUserLastModuleEvent = new UpdateUserLastModuleEvent(module_id);
	lastModuleEvent.dispatch()
}

public function mbMenuChangeHandler(event:MenuEvent):void
{
	if (event.menu != null)
	{
		var xmlTabPage:XML = (XML)(event.item)

		GenModelLocator.getInstance().context = 0
		GenModelLocator.getInstance().triggerSource = "MENU"

		GenModelLocator.getInstance().applicationObject.selectedMenuItem = xmlTabPage
		tabPage	=	new TabPage();
		tabPage.openTabpage(xmlTabPage.@page_heading, xmlTabPage.@component_cd)
	}
}

public function logoutButtonClickHandler():void
{
	var logoutEvent:LogoutEvent = new LogoutEvent();
	logoutEvent.dispatch();
}

private function openMailClient():void
{
	var mailid:String = "support.retail@diaspark.com"
	var request:URLRequest = new URLRequest ("mailto:" + mailid); 
    navigateToURL(request,"_parent");	
}

private function lbCurrentStoreClick():void
{
	if(tabMain.getChildren().length == 1)
	{
		var userCurrentStoreChange:UserCurrentStoreChange;
			
		userCurrentStoreChange = UserCurrentStoreChange(PopUpManager.createPopUp(Application.application.home, UserCurrentStoreChange, true));
		userCurrentStoreChange.x = 50;
		userCurrentStoreChange.y = 100;
	}
	else
	{
		Alert.show("Please close all opened documents to change Store...!");
	}
}
private function changeLoginPwd():void
{
	var changePasswordObj:ChangePassword	=	ChangePassword(PopUpManager.createPopUp(this,ChangePassword,true))
}
public function  mainURL():void
{
	var aURL:String	=  GenModelLocator.main_url
	if(aURL.toString() == ".promo.diasparkonline.com:4009")
	{
		
	}
	else if(aURL.toString() == "")
	{
		
	}
	else
	{
		lblProductName.setStyle("color","Red")
	}
}