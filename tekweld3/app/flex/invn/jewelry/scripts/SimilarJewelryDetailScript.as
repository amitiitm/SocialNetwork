import business.events.GetInformationEvent;
import com.generic.events.DetailAddEditEvent;
import model.GenModelLocator;
import mx.controls.Alert;
import mx.rpc.IResponder;
import invn.jewelry.JewelryModelLocator;
protected var getInformationEvent:GetInformationEvent;

[Bindable]
private var __localModel:JewelryModelLocator = (JewelryModelLocator)(GenModelLocator.getInstance().activeModelLocator);

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function  getItemDetails():void
{
	if(dcItemId.text != '' && dcItemId.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getItemDetailsHandler, null);

		getInformationEvent = new GetInformationEvent('iteminfo', callbacks, dcItemId.dataValue, dfCurrentdate.dataValue);
		getInformationEvent.dispatch();
	}
  	else
	{
		tiItemDescription.text = tiItemDescription.defaultValue;
	}
}

public function getItemDetailsHandler(resultXml:XML):void
{
	tiItemCode.dataValue   = 	resultXml.children()[0].store_code.toString();
	dcItemId.labelValue	   =  	resultXml.children()[0].store_code.toString();
	dcItemId.dataValue     = 	resultXml.children()[0].cataclog_item_id.toString();
	tiItemDescription.text =  	resultXml.children()[0].name.toString();
	tiImage_thumnail.text = 	resultXml.children()[0].image_thumnail.toString();
}

override protected function preSaveRowEventHandler(event:DetailAddEditEvent):int
{
	var itemCode:String = tiItemCode.dataValue;

	 for(var i:int=0; i < __localModel.tempGrid.dataProvider.length; i++)
		{
			if((itemCode == __localModel.tempGrid.dataProvider[i]["similar_item_code"] && i != __genModel.activeModelLocator.tempGrid.selectedIndex))  
			{
				Alert.show("Item already exist !");
				return -1;
				break;
			}
			
		}
		
	if(itemCode == __localModel.item_code)
	{
		Alert.show("It is a parent item # please select another item")
			return -1;
	}	
		
	return 0;
}