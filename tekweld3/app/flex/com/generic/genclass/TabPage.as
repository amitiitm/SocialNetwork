package com.generic.genclass
{
	import com.generic.customcomponents.GenModuleLoader;
	
	import model.GenModelLocator;
	
	import mx.controls.*;
	import mx.core.Application;
	import mx.events.ModuleEvent;
	import mx.managers.CursorManager;
	 
	public class TabPage
	{
		private var mdloader:GenModuleLoader;
		private var __genModel:GenModelLocator	=	GenModelLocator.getInstance();
		
		public function TabPage()
		{
		
		}
		
		public function openTabpage(asName:String, asPath:String):void
		{
			var lbExistsFlag:Boolean = false
			var i:int

			i = searchTabPage(asName);

			if (i > 0)
			{
				if(__genModel.triggerSource == 'MENU')
				{
					__genModel.tabMain.selectedIndex = i;

					// VD 13 May 2009 -- code is require of not 					
					/*				
					var ml:GenModuleLoader = (GenModuleLoader)(__genModel.tabMain.selectedChild.getChildAt(0))
					var obj:Object = ml.getChildAt(0);
					
					if (obj.params != null)
					{
						obj.params.context = __genModel.tabMain.parentDocument.params.context;
						obj.params.triggerSource = __genModel.tabMain.parentDocument.params.triggerSource;
						
						var xmlMenu:XML = new BiztrackerMenuModel().getMeniItemXML(__genModel.tabMain.parentDocument.xmlCompPermission, asPath);
					
						obj.params.create_permission = xmlMenu.@create_permission.toString()
						obj.params.modify_permission = xmlMenu.@modify_permission.toString()
						obj.params.view_permission = xmlMenu.@view_permission.toString()
					}
					*/
				}
				
				else if(__genModel.triggerSource == 'DRILLDOWN')
				{
					__genModel.tabMain.selectedIndex = i;
					
				}
			}
			else
			{
				createTabPage(asName, asPath);
			}
		}	
		public function openDrillDownPage(asPath:String):void
		{
			var tempXmlList:XMLList	=	new XMLList(<temp/>)
			var menuItem:XML		=	new XML(<menuitem/>)
			tempXmlList			=	 __genModel.applicationObject.menu.rolepermission.(component_cd.toString() == asPath)
			
			menuItem	=	XML(tempXmlList[0]).copy();
			
			
			if(menuItem.children().length() > 0)
			{
				menuItem.setName('row');
				var selectedMenuXml:XML	=	new XML(<row/>)
				selectedMenuXml.appendChild(menuItem);
				selectedMenuXml	=	new Utility().convertElementXmlToAttributeXml(selectedMenuXml);
			
				__genModel.context = 0
				__genModel.triggerSource = "DRILLDOWN"
				__genModel.applicationObject.selectedMenuItem = selectedMenuXml.children()[0];
			
				openTabpage(selectedMenuXml.children()[0].@page_heading, selectedMenuXml.children()[0].@component_cd);					
			}
			else
			{
				Alert.show('requested page doesnot exist');
			}					
		}
		//--------------------------------------------------------------------------------
		public function createTabPage(asName:String, asPath:String):void
		{
			if(asPath == "")
	 		{
	        	Alert.show('Screen Under Construction...!!');
	 		}
			else
			{
				CursorManager.setBusyCursor();
				Application.application.enabled = false;
	
				mdloader = new GenModuleLoader();
				
				mdloader.label = asName; 
				mdloader.addEventListener(ModuleEvent.ERROR, onModuleError);
				mdloader.addEventListener(ModuleEvent.READY, onModuleReady);
				
				mdloader.percentHeight = 100
				mdloader.percentWidth = 100
			 	
				mdloader.url = asPath
	 			__genModel.tabMain.addChild(mdloader);
	 		}
		}
		
		private function onModuleReady(event:ModuleEvent):void
		{
			__genModel.tabMain.selectedChild = (GenModuleLoader)(event.target);

			CursorManager.removeBusyCursor();
			Application.application.enabled = true;
		}
		
		private function onModuleError(event:ModuleEvent):void 
   		{
			__genModel.tabMain.removeChild(mdloader)
        	Alert.show('Screen Under Construction...!!');

			CursorManager.removeBusyCursor();
			Application.application.enabled = true;
        }

		//--------------------------------------------------------------------------------
		public function searchTabPage(asName:String): int
		{
		 	var ary:Array = __genModel.tabMain.getChildren()
			// Search. 				
		 	for(var i:int; i < ary.length; i++)
		 	{
				if(ary[i].label.toString() == asName)
				{
					return i
				}
			}
			return 0
		}
	}
}

