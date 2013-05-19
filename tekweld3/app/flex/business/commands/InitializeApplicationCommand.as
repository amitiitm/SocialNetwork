package business.commands
{
	import business.delegates.InitializeApplicationDelegate;
	import business.events.GetMenuEvent;
	import business.events.LogoutEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.genclass.TabPage;
	import com.generic.genclass.Utility;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.TraceTarget;
	import mx.managers.CursorManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import valueObjects.PathVO;

	public class InitializeApplicationCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __count:int = 0;
		private var module_id:int = 0;
		private const MAXCOUNT:int = 4;

		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled = false;

			if(__genModel.user.login.toString()	==	'administrator@diaspark.com')
			{
				// Create a target.
	            var logTarget:TraceTarget = new TraceTarget();
	
	            // Log only messages for the classes in the mx.rpc.* and 
	            // mx.messaging packages.
	            logTarget.filters=["mx.rpc.*","mx.messaging.*"];
	
	            // Log all log levels.
	           
	            logTarget.level = LogEventLevel.DEBUG
	
	            // Add date, time, category, and log level to the output.
	            logTarget.includeDate = true;
	            logTarget.includeTime = true;
	            logTarget.includeCategory = true;
	            logTarget.includeLevel = true;
	
	            // Begin logging.
	            Log.addTarget(logTarget);
				
			}
           
			var callbacksGetModule:Responder = new Responder(getModulesResultHandler, faultHandler);
			var callbacksGetMenu:Responder = new Responder(getMenusResultHandler, faultHandler);
			var callbacksGetMasterData:Responder = new Responder(getMasterDataResultHandler, faultHandler);
			var callbacksGetPaths:Responder = new Responder(getPathsResultHandler, faultHandler);
			
			var callbacksGetDefaultSetup:Responder = new Responder(getDefaultSetupResultHandler, faultHandler);
			
			var delegate:InitializeApplicationDelegate = new InitializeApplicationDelegate(callbacksGetModule, callbacksGetMenu, callbacksGetMasterData, callbacksGetPaths,callbacksGetDefaultSetup);

			delegate.getDefaultSetup();
			delegate.getModules(__genModel.user.userID);
			delegate.getMenus(__genModel.user.userID);
			delegate.getMasterData();
			delegate.getPaths();
		}

		private function getModulesResultHandler(event:ResultEvent):void
		{
			var lbAccessFlag:Boolean = false;

			var utilityObj:Utility					=		new Utility();
			__genModel.applicationObject.module 	= 		utilityObj.getDecodedXML((XML)(event.result));
			
			//__genModel.applicationObject.module = (XML)(event.result);

			// Check still have access permission or not
			if(__genModel.applicationObject.module.children().length() > 0)
			{
				for(var i:int = 0; i < __genModel.applicationObject.module.children().length(); i++)
				{
					if(__genModel.applicationObject.module.children()[i]["id"] == __genModel.user.last_moodule_id)
					{
						__genModel.applicationObject.selectedModule = __genModel.applicationObject.module.children()[i];
						module_id = parseInt(__genModel.user.last_moodule_id)
						lbAccessFlag = true
						break
					}
				}

				if(!lbAccessFlag)
				{
					__genModel.applicationObject.selectedModule = __genModel.applicationObject.module.children()[0]
					module_id = parseInt(__genModel.applicationObject.module.children()[0]["id"])
				}
			}
			else
			{
				Alert.show("User does not have any permission to access application !", "Info", Alert.OK, null, handleLogout, null, Alert.OK)
			}
			
			__count = __count + 1;

			if(__count == MAXCOUNT)
			{
				CursorManager.removeBusyCursor();
				Application.application.enabled = true;

				triggerMenuEvent()

				__count = 0;
			}
		}

		private function handleLogout(event:CloseEvent):void
		{
			var logoutEvent:LogoutEvent	= new LogoutEvent();
			logoutEvent.dispatch();
		}
		
		private function getMenusResultHandler(event:ResultEvent):void
		{
			var utilityObj:Utility					=		new Utility();
			__genModel.applicationObject.menu 		= 		utilityObj.getDecodedXML((XML)(event.result));
			
			//__genModel.applicationObject.menu = (XML)(event.result);
			__count = __count + 1;
			
			if(__count == MAXCOUNT)
			{
				CursorManager.removeBusyCursor();
				Application.application.enabled	=	true;

				__count = 0;

				triggerMenuEvent()
			}
		}
		
		private function getMasterDataResultHandler(event:ResultEvent):void
		{
			var utilityObj:Utility					=		new Utility();
			__genModel.masterData 					= 		utilityObj.getDecodedXML((XML)(event.result));
			
			//__genModel.masterData = (XML)(event.result);
			__count = __count + 1;

			if(__count == MAXCOUNT)
			{
				CursorManager.removeBusyCursor();
				Application.application.enabled = true;

				__count = 0;

				triggerMenuEvent()
			}
		}

		private function getPathsResultHandler(event:ResultEvent):void
		{
			var _resultXml:XML;
			var utilityObj:Utility		=		new Utility();
			_resultXml					= 		utilityObj.getDecodedXML((XML)(event.result));
			
			//var _resultXml:XML = (XML)(event.result);
			__genModel.path = new PathVO(_resultXml)
		}
		
		
		private function getDefaultSetupResultHandler(event:ResultEvent):void
		{
			__genModel.defaultSetupXml		= XML(event.result);
			
			//__genModel.defaultSetupXml		= XML(event.result);;
			__count = __count + 1;
			
			if(__count == MAXCOUNT)
			{
				CursorManager.removeBusyCursor();
				Application.application.enabled = true;
				
				__count = 0;
				
				triggerMenuEvent()
			}
		}
		
		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			
			Alert.show('init app command' + event.fault.toString());
		}
		
		private function triggerMenuEvent():void
		{
			var menuEvent:GetMenuEvent;

			menuEvent = new GetMenuEvent(module_id);
			menuEvent.dispatch();
			if(__genModel.user.default_menu_id =='' || __genModel.user.default_menu_id ==null )
			{
				
			}
			else
			{
				openDefaultScreen();
			}
			
		}
		
		private function openDefaultScreen():void
		{
			var menuItems:XML = new GetMenuCommand().changeMenuXMLFormat(__genModel.applicationObject.menu.rolepermission);
			var xmlTabPage:XML = getDefaultMenu(menuItems);
			
			GenModelLocator.getInstance().context = 0
			GenModelLocator.getInstance().triggerSource = "MENU"
			
			GenModelLocator.getInstance().applicationObject.selectedMenuItem = xmlTabPage;
			
			var tabPage:TabPage	=	new TabPage();
			tabPage.openTabpage(xmlTabPage.@page_heading, xmlTabPage.@component_cd)
		}
		private function getDefaultMenu(aMenuItems:XML):XML
		{
			var xmlReturn:XML    = new XML();
			for(var i:int = 0; i < aMenuItems.children().length(); i++)
			{
				var tempXml:XML  = aMenuItems.children()[i];
				for(var j:int = 0; j < tempXml.children().length(); j++)
				{
					if(tempXml.children()[j].@id.toString() == __genModel.user.default_menu_id)
					{
						xmlReturn    = tempXml.children()[j];
						break;
					}
				}
			}
			return xmlReturn;
		}
	}
}
