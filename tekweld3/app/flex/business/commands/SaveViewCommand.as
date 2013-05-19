package business.commands
{
	import business.delegates.ViewDelegate;
	import business.events.SaveViewEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import model.GenModelLocator;
	
	public class SaveViewCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var view:XML = (event as SaveViewEvent).view;
			var delegate:ViewDelegate = new ViewDelegate();
			
			view.user_id		=	__genModel.user.userID;
			delegate.saveView(view, __genModel.user.userID, __genModel.activeModelLocator.documentObj.documentID);
		}
	}
}