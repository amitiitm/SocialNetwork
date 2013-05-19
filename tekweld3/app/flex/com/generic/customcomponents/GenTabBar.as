package com.generic.customcomponents
{
	import com.generic.events.GenModuleLoaderEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.collections.IList;
	import mx.containers.ViewStack;
	import mx.controls.TabBar;
	import mx.core.ClassFactory;
	import mx.core.IFlexDisplayObject;
	import mx.core.mx_internal;
	
	public class GenTabBar extends TabBar
	{
		use namespace mx_internal;
		private var _closePolicy:String = GenTab.CLOSE_ROLLOVER;
	
		public function get closePolicy():String 
		{
			return _closePolicy;
		}
		
		public function set closePolicy(value:String):void 
		{
			this._closePolicy = value;
			this.invalidateDisplayList();
			
			var n:int = numChildren;
	        for (var i:int = 0; i < n; i++)
	        {
	            var child:GenTab = GenTab(getChildAt(i));
				child.closePolicy = value;
	        }
		}
		
		public function GenTabBar()
		{
			super();
			navItemFactory = new ClassFactory(GenTab);
		}
		
		override protected function createNavItem(label:String,icon:Class = null):IFlexDisplayObject
		{
			var tab:GenTab = super.createNavItem(label,icon) as GenTab;
			
			if(tab.label.toUpperCase() == "HOME")
			{
				tab.closePolicy = GenTab.CLOSE_NEVER;
			}
			else
			{
				tab.closePolicy = this.closePolicy;
			}

			tab.addEventListener(GenTab.CLOSE_TAB_EVENT, onCloseTabClicked, false, 0, true);
			
			return tab;
		}
		
		public function onCloseTabClicked(event:Event):void{
			
			
			var index:int = getChildIndex(DisplayObject(event.currentTarget));
			GenModuleLoader(GenTabNavigator(this.parent.parent.parent).getChildAt(index)).unloadModule();
			 /* ............jeetu 11 nov 2010 please donot delete this commnent..................
			   	we have added setNull only for the SalesOrderModelLocator and SalesInvoiceModelLocator
				do it for all other screens.
			    we have done changes in AddEditVO and DetailEditVO we should do this for all other vo also and 
			   to work this changes we have to modify modellocator also see SalesOrderModelLocator addEditObj.setNull();*/
			/* if(GenModelLocator.getInstance().activeModelLocator.hasOwnProperty('setNull'))
			{
			  
				GenModelLocator.getInstance().activeModelLocator.setNull();	
			}
			GenModelLocator.getInstance().activeModelLocator	=	null;
			GenModelLocator.getInstance().controller			=	null;
			GenModelLocator.getInstance().services				=	null;
			
			focusEnabled	=	true;
			focusManager.setFocus(this.parentApplication.home.cbMoodule);
			focusManager.showFocus();
			GenModuleLoader(GenTabNavigator(this.parent.parent.parent).selectedChild).unloadModule(); */
			if(dataProvider is IList){
				dataProvider.removeItemAt(index);
			}
			else if(dataProvider is ViewStack){
				dataProvider.removeChildAt(index);
			}
			(GenModuleLoader)(GenTabNavigator(this.parent.parent.parent).selectedChild).dispatchEvent(new GenModuleLoaderEvent("genModuleLoaderActive"));
		}
	}
}