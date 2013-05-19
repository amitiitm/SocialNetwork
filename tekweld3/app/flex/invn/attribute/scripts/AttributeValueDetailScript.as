import com.generic.events.DetailAddEditEvent;

import mx.core.Application;
import mx.managers.CursorManager;

private function creationComplete():void
{
	
}
override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	setEnablityOfsetupCharge2();
}
override protected function resetObjectEventHandler():void
{
	setEnablityOfsetupCharge2();
}
private function setSetupCode():void
{
	tiSetupItemCode.dataValue = dcSetupItem_id.labelValue
	setEnablityOfsetupCharge2();
}
private function setInventoryCode():void
{
	tiInventoryItemCode.dataValue = dcInventoryItem_id.labelValue
}
private function setSetupCode2():void
{
	tiSetupItemCode2.dataValue = dcSetupItem_id2.labelValue
}

private function setEnablityOfsetupCharge2():void
{
	if(dcSetupItem_id.dataValue=='')
	{
		dcSetupItem_id2.enabled  	= false;
		dcSetupItem_id2.dataValue  	= '';
		tiSetupItemCode2.dataValue  = '';
	}
	else
	{
		dcSetupItem_id2.enabled  = true;
	}
	
}
