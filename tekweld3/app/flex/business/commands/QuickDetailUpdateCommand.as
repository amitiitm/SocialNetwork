package business.commands
{
	import business.events.QuickDetailUpdateEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.QuickDetailUpdate;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.ClassFactory;
	import mx.core.Container;
	import mx.managers.PopUpManager;
	
	public class QuickDetailUpdateCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __addEditContainer:Container;
		private var __masterName:String;
	
		public function execute(event:CairngormEvent):void
		{
			__addEditContainer = __genModel.activeModelLocator.addEditObj.addEditContainer;
			__masterName = (event as QuickDetailUpdateEvent).masterName;

			openQuickEdit();
		}

		private function openQuickEdit():void
		{
			var obj:Object	=	__genModel.lookupObj.getMasterInfo(__masterName)
			
			if(obj.serviceClassFactory == "" || obj.addEditClassFactory == "" || obj.controllerClassFactory == "" || obj.modelLocatorClassFactory == "")
			{
				Alert.show("Master Path Not Exist");
			}
			else
			{
				// from here we are dealing with the objects of open quick add edit master window
				__genModel.activeModelLocator 	= ClassFactory(obj.modelLocatorClassFactory).newInstance();
				__genModel.services 			= ClassFactory(obj.serviceClassFactory).newInstance();
				__genModel.controller 			= ClassFactory(obj.controllerClassFactory).newInstance();
				
				__genModel.lookupObj.isQuickAddActive	= 		true
				
				__genModel.activeModelLocator.addEditObj.addEditContainer	=	ClassFactory(obj.addEditClassFactory).newInstance() as Container ;
			
				var quickDetailUpdate:QuickDetailUpdate;
	
				quickDetailUpdate	=	QuickDetailUpdate(PopUpManager.createPopUp(__addEditContainer, QuickDetailUpdate, true));
				quickDetailUpdate.vbAddEdit.addChild(__genModel.activeModelLocator.addEditObj.addEditContainer);
				quickDetailUpdate.x 		=	quickDetailUpdate.x + quickDetailUpdate.width / 2;
				quickDetailUpdate.y 		= 	quickDetailUpdate.y + quickDetailUpdate.height / 4;	
				quickDetailUpdate.title		=	obj.title;
				quickDetailUpdate.width		=	obj.width;
				quickDetailUpdate.height	=	obj.height;
			}	
		}
	}
}	
