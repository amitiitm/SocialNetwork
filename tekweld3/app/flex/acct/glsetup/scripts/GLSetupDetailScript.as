import com.generic.events.DetailAddEditEvent;
import model.GenModelLocator;
import mx.controls.Alert;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

override protected function preSaveRowEventHandler(event:DetailAddEditEvent):int
{
	var item_type:String = cbItem_type.dataValue;
	tiItem_type_desc.dataValue	=	cbItem_type.text;
	for(var i:int=0; i < __genModel.activeModelLocator.tempGrid.dataProvider.length; i++)
	{
		if(item_type == __genModel.activeModelLocator.tempGrid.dataProvider[i]["item_type"] && i != __genModel.activeModelLocator.tempGrid.selectedIndex)  
		{
			Alert.show("Item type already exist !");
			return -1;
			break;
		}
	}
	
	return 0;
}

override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	cbItem_type.enabled = false;

}

override protected function resetObjectEventHandler():void
{
	cbItem_type.enabled = true;
}
