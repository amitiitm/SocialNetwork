package business.commands
{
	import model.GenModelLocator;
	import com.adobe.cairngorm.control.CairngormEvent; 
	import com.adobe.cairngorm.commands.ICommand;
	import mx.core.Application;
	import mx.managers.CursorManager;
		
	public class LayoutCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			CursorManager.setBusyCursor();
			Application.application.enabled	= false;

	    	CursorManager.removeBusyCursor();
			Application.application.enabled	= true;
		}
	}
}