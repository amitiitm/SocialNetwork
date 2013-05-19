import com.generic.events.AddEditEvent;
import model.GenModelLocator;

private function init():void {}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	tiLotNo.enabled	=	false;
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	tiLotNo.enabled	=	true;
}