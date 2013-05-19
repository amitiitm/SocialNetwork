package business.commands
{
	import business.events.GetSpecificFormatEvent;
	import business.events.InitializeLayoutEvent;
	import business.events.InitializeViewEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class InitializeCustomReportCommand implements ICommand
	{
		private var initializeLayoutEvent:InitializeLayoutEvent
		private var initializeViewEvent:InitializeViewEvent
		private var getPrintSpecificFormat:GetSpecificFormatEvent;
		
		public function execute(event:CairngormEvent):void
		{
			initializeLayoutEvent	=	new InitializeLayoutEvent()
			initializeLayoutEvent.dispatch();
			
			initializeViewEvent	=	new InitializeViewEvent()
			initializeViewEvent.dispatch();
			
			//getPrintSpecificFormat	=	new GetSpecificFormatEvent();
			//getPrintSpecificFormat.dispatch();
			
		}
	}
}
