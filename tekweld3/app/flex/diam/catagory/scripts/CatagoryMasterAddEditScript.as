import com.generic.events.AddEditEvent;
import model.GenModelLocator;

private function init():void {}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{
	tiCode.enabled	=	false;
}

override protected function resetObjectEventHandler():void
{
	tiCode.enabled	=	true;
}