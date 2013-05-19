import business.events.GetInformationEvent;

import model.GenModelLocator;

import mx.rpc.IResponder;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function handleUser_id():void
{
	if(dcUser_id.text != '' && dcUser_id.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(userDetailsHandler, null);

		var getInformationEvent:GetInformationEvent	= new GetInformationEvent('user', callbacks, dcUser_id.dataValue,dcUser_id.labelValue);
		getInformationEvent.dispatch();
	}
}

private function userDetailsHandler(resultXml:XML):void
{
	dcUser_id.dataValue		=	resultXml.children().child('id').toString()
	dcUser_id.labelValue	=	resultXml.children().child('user_cd').toString()
	tiUser_name.text		= 	resultXml.children().child('first_name').toString()
	tiUser_cd.text 			=	resultXml.children().child('user_cd').toString() 
}