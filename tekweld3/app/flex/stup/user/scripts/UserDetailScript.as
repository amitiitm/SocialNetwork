import business.events.GetInformationEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.rpc.IResponder;

private var getInformationEvent:GetInformationEvent;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

private function getCompanyDetails():void
{
	if(dcCompany_id.text != '' && dcCompany_id.text != null)
		{
			var callbacks:IResponder = new mx.rpc.Responder(getCompanyDetailsHandler, null);

			getInformationEvent	= new GetInformationEvent('companystoreinfo', callbacks, dcCompany_id.dataValue);
			getInformationEvent.dispatch(); 
		}
}

private function getCompanyDetailsHandler(resultXml:XML):void
{
	dcCompany_id.dataValue	 = resultXml.children()[0].id.toString();
	dcCompany_id.labelValue	 = resultXml.children()[0].company_cd.toString();
	tiCompany_name.dataValue = resultXml.children()[0].name.toString();
	tiCompany_code.dataValue = resultXml.children()[0].company_cd.toString();
}