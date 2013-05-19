// ActionScript file
import com.generic.events.DetailAddEditEvent;

import model.GenModelLocator;

import mx.controls.Alert;

import pos.salesreceipt.SalesReceiptModelLocator;

[Bindable]
public var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
private var __localModel:SalesReceiptModelLocator = (SalesReceiptModelLocator)(GenModelLocator.getInstance().activeModelLocator);

override protected function preSaveRowEventHandler(event:DetailAddEditEvent):int
{
	var oldTotalShare:Number	=	Number(__localModel.totalShare);
	var newShare:Number			=	Number(tiShare.text);
	
	if(__localModel.detailEditObj.selectedRow != null) //existing row
	{
		oldTotalShare			=	oldTotalShare - Number(__localModel.detailEditObj.selectedRow.share.toString());
		
	}
	
	if(oldTotalShare + newShare > 100)
	{
		Alert.show('Total Share can not be greater than 100');
		return 1;
	}	
	
	return 0;			
	
}
