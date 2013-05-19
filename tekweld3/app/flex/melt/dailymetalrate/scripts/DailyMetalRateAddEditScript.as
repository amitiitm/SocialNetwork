import com.generic.events.AddEditEvent;

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	dfMetal_rate_date.enabled = false;
}

override protected function resetObjectEventHandler():void
{
	dfMetal_rate_date.enabled = true;
}
