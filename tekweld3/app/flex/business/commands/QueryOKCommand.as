package business.commands
{
	import business.events.PopulateListEvent;
	import business.events.QueryOKEvent;
	import business.events.SaveViewEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	
	public class QueryOKCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			var	selectedView:XML = (event as QueryOKEvent).selectedView;
			var isRunImmediately:Boolean = (event as QueryOKEvent).isRunImmediately;
			
			var populateListEvent:PopulateListEvent;
			var saveViewEvent:SaveViewEvent;
			
			if(selectedView.name != __genModel.activeModelLocator.viewObj.selectedView.name.toString())
			{
				if(isRunImmediately)
				{
				 	selectedView.default_yn	= 'Y';	//set default_view to y
				} 
				else	// VD 20100610 else add.
				{
				 	selectedView.default_yn	= 'N';	//set default_view to N
				}
			}
			
			if(selectedView.name != '')
			{
				saveViewEvent = new SaveViewEvent(selectedView);
				saveViewEvent.dispatch();
			}
			if(selectedView.name	==	'' )
			{
				if(__genModel.activeModelLocator.viewObj.selectedView.name.toString() == "Select View")
				{
					XML(__genModel.activeModelLocator.viewObj.selectedView).setChildren(selectedView.children())
				 	XML(__genModel.activeModelLocator.viewObj.selectedView).criteria_type	=	'T';
					XML(__genModel.activeModelLocator.viewObj.selectedView).name			=	"Select View"	 
				}
				populateListEvent = new PopulateListEvent(selectedView);
				populateListEvent.dispatch();
			}
			else if(selectedView.name == __genModel.activeModelLocator.viewObj.selectedView.name.toString())
			{
				//set chilrens new value
				XML(__genModel.activeModelLocator.viewObj.selectedView).setChildren(selectedView.children())
				populateListEvent = new PopulateListEvent(selectedView);
				populateListEvent.dispatch();
			}
			else
			{
				  var tempXml:XML = new XML(__genModel.activeModelLocator.viewObj.view)
				  tempXml.appendChild(selectedView);
				__genModel.activeModelLocator.viewObj.view = tempXml;
				
				if(isRunImmediately)
				{
					//set view combo to  new view
					var selectedchildIndex:int = XML(__genModel.activeModelLocator.viewObj.view).children().length()-1;
					__genModel.activeModelLocator.viewObj.selectedView = __genModel.activeModelLocator.viewObj.view.children()[selectedchildIndex] as XML;
	
					populateListEvent = new PopulateListEvent(selectedView);
					populateListEvent.dispatch();
				}
				else
				{
					 var oldSelectedIndex:int = XML(__genModel.activeModelLocator.viewObj.selectedView).childIndex();
					__genModel.activeModelLocator.viewObj.selectedView = __genModel.activeModelLocator.viewObj.view.children()[oldSelectedIndex] as XML;
				}
			}
		}
	}
}