package business.commands
{
	import business.events.InitializeDetailEditEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import valueObjects.DetailEditVO;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class CancelRowCommand implements ICommand
	{
		private var initializeDetailEditEvent:InitializeDetailEditEvent;
		
		public function execute(event:CairngormEvent):void
		{
			initializeDetailEditEvent = new InitializeDetailEditEvent();
			initializeDetailEditEvent.dispatch(); 
		}
	}
}

