package business.commands
{
	import business.events.QuickAddEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.QuickDataEntry;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.ClassFactory;
	import mx.core.Container;
	import mx.managers.PopUpManager;
	
	public class QuickAddCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __addEditContainer:Container;
		private var selectedRow:XML	=	null;
		
		public function execute(event:CairngormEvent):void
		{
			__addEditContainer = __genModel.activeModelLocator.addEditObj.addEditContainer;
			
			if((event as QuickAddEvent).selectedRow != null)
			{
				selectedRow		   = (event as QuickAddEvent).selectedRow.copy()	
			}
				
			openQuickEdit();
		}

		private function openQuickEdit():void
		{
			var obj:Object	=	__genModel.lookupObj.getMasterInfo(__genModel.lookupObj.lookupName)
			
			if(obj.serviceClassFactory == "" || obj.addEditClassFactory == "" || obj.controllerClassFactory == "" || obj.modelLocatorClassFactory == "")
			{
				selectedRow	=	null;
				Alert.show("Master Path Not Exist");
			}
			else
			{
				//from here we are dealing with the objects of open quick add edit master window
				__genModel.activeModelLocator 	= ClassFactory(obj.modelLocatorClassFactory).newInstance();
				__genModel.services 			= ClassFactory(obj.serviceClassFactory).newInstance();
				__genModel.controller 			= ClassFactory(obj.controllerClassFactory).newInstance();
				
				__genModel.lookupObj.isQuickAddActive			= 		true
				
				__genModel.activeModelLocator.addEditObj.addEditContainer 		= 	ClassFactory(obj.addEditClassFactory).newInstance() as Container ;
				
				if(selectedRow != null)
				{
					__genModel.activeModelLocator.listObj.selectedRow				=	selectedRow;	
				}
				else
				{
					__genModel.activeModelLocator.listObj.selectedRow				=	null;
				}
				
				
				var quickDataEntry:QuickDataEntry;
	
				quickDataEntry 			= QuickDataEntry(PopUpManager.createPopUp(__addEditContainer, QuickDataEntry, true));
				quickDataEntry.vbAddEdit.addChild(__genModel.activeModelLocator.addEditObj.addEditContainer);
				quickDataEntry.x 		= quickDataEntry.x + quickDataEntry.width / 2;
				quickDataEntry.y 		= quickDataEntry.y + quickDataEntry.height / 4		;	
				quickDataEntry.title	=	obj.title;
				quickDataEntry.width	=	obj.width	;
				quickDataEntry.height	=	obj.height	;
			}	
		}
	}
}	
