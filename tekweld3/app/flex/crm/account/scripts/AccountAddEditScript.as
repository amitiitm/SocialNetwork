import crm.otheraddress.components.*;
import model.GenModelLocator;
import business.events.InboxDrillDownEvent;
import flash.events.Event;
import com.generic.events.GenDataGridEvent;
import crm.account.AccountModelLocator;
import com.generic.events.AddEditEvent;
import mx.rpc.IResponder;

[Bindable]
private var editBarRowPosition:Number;
[Bindable]
private var __localModel:AccountModelLocator = (AccountModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance() 


private function init():void
{
	__localModel.account_id		= tiId.text	
}

/*private function handleDoubleClick(event:Event):void
{
		__genModel.activeModelLocator.listObj.drilldown_component_code	=	"crm/activity/components/Activity.swf"
	
		  editBarRowPosition	=	dgActivity_history.selectedIndex

		__genModel.drillObj.drillrow		=	XML(dgActivity_history.dataProvider[editBarRowPosition])
	
		//__genModel.drillObj.drillcolumn		=	dgActivity_history.colname.toString()
	
		var callback:IResponder			=	new mx.rpc.Responder(callbackDrillEventHandler,null);
	
		var drillDownEvent:InboxDrillDownEvent	=	new InboxDrillDownEvent(callback);
		drillDownEvent.dispatch();	
}

private function callbackDrillEventHandler(resultXml:XML):void
{

}*/

override protected function retrieveRecordEventHandler(event:AddEditEvent):void  
{
	__localModel.account_id		= tiId.text	
}


override protected function resetObjectEventHandler():void
{
	__localModel.account_id		= tiId.text
}