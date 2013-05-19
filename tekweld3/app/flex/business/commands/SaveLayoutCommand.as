package business.commands
{
	import business.delegates.LayoutDelegate;
	import business.events.SaveLayoutEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import model.GenModelLocator;
	
	public class SaveLayoutCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var layout:XML = (event as SaveLayoutEvent).layout;
			var delegate:LayoutDelegate = new LayoutDelegate();
			
			/*if user has select a layout of system type from combo box then we need user_id to make it as default.
			its type remain same  */
			layout.user_id		=	__genModel.user.userID;
			
			delegate.saveLayout(layout);
		}
	}
}
