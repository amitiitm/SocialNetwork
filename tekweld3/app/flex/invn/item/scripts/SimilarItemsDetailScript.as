import business.events.GetInformationEvent;
import model.GenModelLocator;
import mx.controls.Alert;
import mx.rpc.IResponder;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
protected var getInformationEvent:GetInformationEvent;

private function  getItemDetails():void
{
	if(dcItemId.text != '')
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
	tiItemCode.dataValue	= 	resultXml.children()[0].store_code.toString();
	dcItemId.labelValue		= 	resultXml.children()[0].store_code.toString();
	dcItemId.dataValue		=	resultXml.children()[0].catalog_item_id.toString();
	
	tiItemDescription.text = resultXml.children()[0].name.toString();
	tiImage_thumnail.text = resultXml.children()[0].image_thumnail.toString();
}
