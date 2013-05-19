import com.generic.events.AddEditEvent;
import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{
	tiCode.enabled = false;
}

override protected function resetObjectEventHandler():void
{
	tiCode.enabled = true;
}

override protected function copyRecordCompleteEventHandler():void
{
	resetOptions();
}

private function resetOptions():void
{
	var rowsXml:XML		= dtlAttribute.dgDtl.rows.copy();
	for(var i:int=0;i<rowsXml.children().length();i++)
	{
		rowsXml.children()[i].catalog__item_category_id   = '';
	}
	dtlAttribute.dgDtl.rows  = rowsXml;
}