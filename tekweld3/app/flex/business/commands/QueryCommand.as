package business.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.Criteria;
	
	import flash.display.DisplayObject;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	
	public class QueryCommand implements ICommand
	{
		private var _criteria:Criteria;
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			
			if(__genModel.activeModelLocator.viewObj.selectedView	!=	null	&& __genModel.activeModelLocator.viewObj.selectedView	!=	XML(undefined))
			{
				_criteria = Criteria(PopUpManager.createPopUp((DisplayObject)(Application.application), Criteria, true));
			}
			else
			{
				Alert.show('please wait view is being populated.');
			}
		}
	}	
}
