package business.commands
{
	import business.events.ConfigureColumnOKEvent;
	import business.events.SaveLayoutEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	public class ConfigureColumnOKCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var	selectedLayout:XML = (event as ConfigureColumnOKEvent).selectedLayout;
			var isRunImmediately:Boolean = (event as ConfigureColumnOKEvent).isRunImmediately;
			
			var saveLayoutEvent:SaveLayoutEvent;
			
			if(selectedLayout.name.toString() != __genModel.activeModelLocator.layoutObj.selectedLayout.name.toString())
			{
				if(isRunImmediately)
				{
				 	selectedLayout.default_yn	= 'Y';//set default_view to y
				} 
			}
			
			selectedLayout.layout_type	=	'U'
			selectedLayout.user_id		=	__genModel.user.userID.toString();
			
			saveLayoutEvent = new SaveLayoutEvent(selectedLayout);
			saveLayoutEvent.dispatch();
			
			if(selectedLayout.name.toString() == __genModel.activeModelLocator.layoutObj.selectedLayout.name.toString())
			{
				//set chilrens new value
				XML(__genModel.activeModelLocator.layoutObj.selectedLayout).setChildren(selectedLayout.children())
				
				__genModel.activeModelLocator.layoutObj.listFormat = XML(XML(__genModel.activeModelLocator.layoutObj.selectedLayout).child('report_layout_columns'));	
				__genModel.activeModelLocator.layoutObj.changeInLayout	=	new XML();	
			
			}
			else
			{
				  var tempXml:XML = new XML(__genModel.activeModelLocator.layoutObj.layout)
				  tempXml.appendChild(selectedLayout);
				__genModel.activeModelLocator.layoutObj.layout = tempXml;
				
				if(isRunImmediately)
				{
					//set layout combo to  new layout
					var selectedchildIndex:int = XML(__genModel.activeModelLocator.layoutObj.layout).children().length()-1;
					__genModel.activeModelLocator.layoutObj.selectedLayout = __genModel.activeModelLocator.layoutObj.layout.children()[selectedchildIndex] as XML;
	
					__genModel.activeModelLocator.layoutObj.listFormat = XML(XML(__genModel.activeModelLocator.layoutObj.selectedLayout).child('report_layout_columns'));
					__genModel.activeModelLocator.layoutObj.changeInLayout	=	new XML();
				}
				else
				{
					 var oldSelectedIndex:int = XML(__genModel.activeModelLocator.layoutObj.selectedLayout).childIndex();
					__genModel.activeModelLocator.layoutObj.selectedLayout = __genModel.activeModelLocator.layoutObj.layout.children()[oldSelectedIndex] as XML;
				}
			}
		}
	}
}
