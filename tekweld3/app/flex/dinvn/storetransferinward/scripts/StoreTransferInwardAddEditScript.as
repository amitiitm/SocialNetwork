import com.generic.customcomponents.GenDateField;
import com.generic.events.InboxEvent;

import dinvn.storetransferinward.StoreTransferInwardModelLocator;

import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:StoreTransferInwardModelLocator  =  StoreTransferInwardModelLocator(__genModel.activeModelLocator);

private function calcRowColor(item:Object, rowIndex:int, dataIndex:int, color:uint):uint
{
	if(inbox.dgDtl.dataProvider[dataIndex].ack_flag == 'P')
	{
		return 0xF8EED5;
	}
	else
	{
		return color;
	}
}

private function handleInboxItemFocusOut(event:InboxEvent):void
{
	var oldDate:String = event.oldValues["received_trans_date"].toString();
	var currentDt:String = event.newValues["received_trans_date"].toString();
	
	if(event.newValues["select_yn"] == 'Y')
	{
		inbox.focusedRow["ack_flag"] = 'Y';
		
		if(event.newValues["received_trans_date"] == '')
		{
			inbox.focusedRow["received_trans_date"] = new GenDateField().currentDate();
		}
	}
	else
	{
		inbox.focusedRow["ack_flag"] = 'N';
		
		if(oldDate != currentDt)
		{
			inbox.focusedRow["received_trans_date"] = oldDate;
		}
	}  
}
