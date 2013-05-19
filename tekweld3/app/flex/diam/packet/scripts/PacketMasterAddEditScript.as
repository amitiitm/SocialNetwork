import com.generic.events.AddEditEvent;
import model.GenModelLocator;

private function init():void {}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{
	tiPktNo.enabled	= false;
	dcLotId.enabled = false;
}

override protected function resetObjectEventHandler():void 
{
	tiPktNo.enabled	= true;
	dcLotId.enabled = true;
}