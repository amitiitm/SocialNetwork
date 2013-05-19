package business.commands
{
	import business.delegates.UpdateUserProfileDelegate;
	import business.events.UpdateUserLastModuleEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import model.GenModelLocator;
	
	public class UpdateUserLastModuleCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();

		public function execute(event:CairngormEvent):void
		{
			var module_id:int = (event as UpdateUserLastModuleEvent).module_id;
			var delegate:UpdateUserProfileDelegate = new UpdateUserProfileDelegate();
			
			delegate.updateLastModule(module_id, __genModel.user.userID);
		}
	}
}
