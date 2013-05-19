import business.events.GetInformationEvent;

import com.generic.events.GenDynamicComboBoxEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.rpc.IResponder;
import mx.rpc.Responder;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function handleCodeChange():void
{
	if(dcCatalog_attribute_id.text != '' && dcCatalog_attribute_id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(attributeResultHandler,null)
		var getInformationEvent:GetInformationEvent	=	new GetInformationEvent('attribute_info',callbacks,dcCatalog_attribute_id.dataValue,dcCatalog_attribute_id.labelValue)
		getInformationEvent.dispatch();
	}
}

private function attributeResultHandler(resultXml:XML):void
{
	dcCatalog_attribute_id.dataValue	=	resultXml.children().child('id').toString()	
	dcCatalog_attribute_id.labelValue	=	resultXml.children().child('code').toString()
	tiName.dataValue 					=	resultXml.children().child('name').toString()
	tiCode.dataValue 					=	resultXml.children().child('code').toString()	
}