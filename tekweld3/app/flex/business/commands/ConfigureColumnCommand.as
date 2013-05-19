package business.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.Attachments;
	import com.generic.components.ConfigureColumn;
	
	import flash.display.DisplayObject;
	
	import model.GenModelLocator;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	
	import valueObjects.NoteAttachmentVO;
	
	public class ConfigureColumnCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			openConfigureColumnWindow();
			
		}
		 private function openConfigureColumnWindow():void
		{
			var configureColumnComponent:ConfigureColumn 	= ConfigureColumn(PopUpManager.createPopUp(DisplayObject(Application.application),ConfigureColumn, true));
		}		 
	}
}

