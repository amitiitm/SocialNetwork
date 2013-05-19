import business.events.GetInformationEvent;

import com.generic.events.AddEditEvent;
import com.generic.events.GenUploadButtonEvent;
import mx.rpc.IResponder;
import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var getInformationEvent:GetInformationEvent;

public function init():void 
{
	getAccountPeriod();
}
private function getAccountPeriod():void
{
	if(dfTrans_date.text != '' && dfTrans_date.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('accountperiod', callbacks, dfTrans_date.text);
		getInformationEvent.dispatch(); 
	}
}
private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue	=	resultXml.child('code');
}
private function handleImportEvent(event:GenUploadButtonEvent):void
{
	tiXlsFile.text = event.fileName;
}
private function handleDownloadCompleteEvent(event:GenUploadButtonEvent):void
{
	if(event.downloadedObj != null &&  XML(event.downloadedObj).children().length() > 0)
	{
		dtlLine.rows	=	XML(event.downloadedObj);
	}
}	
private function handleSampleXLS():void
{
	var file_name:String = 'sample_item_upload_format.xls';
	var folderName:String = '/sampleformats/';
	var url:String = folderName + file_name;
	var request:URLRequest = new URLRequest(url);

    navigateToURL(request);
}
override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{
	tiXlsFile.editable		=	false;
	taRemarks.editable		=	false;
	btnBrowse_Xls.enabled	=	false;
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	tiXlsFile.editable		=	true;
	taRemarks.editable		=	true;
	btnBrowse_Xls.enabled	=	true;
	getAccountPeriod();
}
