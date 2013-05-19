import business.events.GetInformationEvent;
import com.generic.events.DetailAddEditEvent;
import model.GenModelLocator;

import mx.controls.Alert;
import mx.rpc.IResponder;

import puoi.purchaseindent.PurchaseIndentModelLocator;

private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __localModel:PurchaseIndentModelLocator = (PurchaseIndentModelLocator)(GenModelLocator.getInstance().activeModelLocator);
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function getItemDetails():void
{
	if(dcItemId.dataValue != '')
	{
		var callbacks:IResponder = new mx.rpc.Responder(getItemDetailsHandler, null);

		getInformationEvent	=	new GetInformationEvent('iteminfo', callbacks, dcItemId.dataValue, __localModel.trans_date);
		getInformationEvent.dispatch(); 
	}
	else
	{
	 	tiItemDescription.dataValue = tiItemDescription.defaultValue;
		tiImage_thumnail.dataValue = tiImage_thumnail.defaultValue;
	}
}

public function getItemDetailsHandler(resultXml:XML):void
{
	var packet_require_yn:String;

	
    tiImage_thumnail.dataValue = resultXml.children()[0].image_thumnail.toString();
    tiItemDescription.dataValue = resultXml.children()[0].name.toString();
	
}

	