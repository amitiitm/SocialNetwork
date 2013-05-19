import business.events.GetInformationEvent;

import com.generic.events.AddEditEvent;
import com.generic.events.NewDetailEvent;
import com.generic.genclass.GenNumberFormatter;

import model.GenModelLocator;

import mx.core.Application;
import mx.managers.CursorManager;
import mx.rpc.IResponder;

[Bindable]
public var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var numericFormatter:GenNumberFormatter = new GenNumberFormatter();
private var row_index:int

private function init():void
{
	numericFormatter.precision	=	2;
	numericFormatter.rounding	=	"nearest";
	numericFormatter.useThousandsSeparator	=	false;
}

private function setVendorAddress(aXml:XML):String
{
	var address:String = '';
	 
	if(aXml.children().child('name').toString() != '')
	{
		address = address + aXml.children().child('name').toString() + "\n" 	
	}
	
	if(aXml.children().child('address1').toString() != '')
	{
		address = address +  aXml.children().child('address1').toString() + "," 	
	}
	
	if(aXml.children().child('address2').toString() != '')
	{
		address = address +  aXml.children().child('address2').toString() + "\n" 	
	}
	
	if(aXml.children().child('city').toString() != '')
	{
		address = address +  aXml.children().child('city').toString() + ',' 	
	}

	if(aXml.children().child('state').toString() != '')
	{
		address = address +  aXml.children().child('state').toString() + " - " 	
	}
	
	if(aXml.children().child('zip').toString() != '')
	{
		address = address + aXml.children().child('zip').toString() + "\n" 	
	}

	if(aXml.children().child('phone1').toString() != '')
	{
		address = address + "Phone1 : " + aXml.children().child('phone1').toString()
	}

	if(aXml.children().child('fax1').toString()!= '')
	{
		address = address + " Fax1 : " + aXml.children().child('fax1').toString()
	}
	return address; 		
}

private function setAppliedAmt():void
{
	var balance_amt:Number = Number(tiBalance_amt.text);
	var received_amt:Number = Number(tiCredit_amt.text);

	var applied_amt:Number = getTotalApplyAmt();

	tiApplied_amt.text = String(applied_amt);
	
	if((applied_amt - received_amt) > 0)
	{
		tiBalance_amt.text = "0";
	}
	else
	{
		tiBalance_amt.text = String(received_amt - applied_amt);
	}
}
 
private function handleDetailItemFocusOut(event:NewDetailEvent):void
{
	var colName:String;
	var rowIndex:int;

	colName = event.object.id
	rowIndex = event.currentTarget.editBarRowPosition;

	if(dtlLine.dgDtl.dataProvider != null)
	{
		if(colName == "apply_flag")
		{
			changeApplyFlag(rowIndex)
			setAppliedAmt() 
		}
		else if(colName == "apply_amt")
		{
			changeApplyAmt(rowIndex)
			setAppliedAmt()
		}
		else if(colName == "disctaken_amt")
		{
			changeDisctakenAmt(rowIndex)
			setAppliedAmt()
		}
		else if(colName == "gl_account_code") 
		{
			if(event.object.text != null && event.object.text != '')
			{
				Application.application.enabled = false;
				CursorManager.setBusyCursor();
				
				row_index = event.currentTarget.editBarRowPosition
				var callbacks:IResponder	=	new mx.rpc.Responder(glAccountChangeEventHandler, null);
				
				var getInformationEvent:GetInformationEvent	=	new GetInformationEvent('paymentbankinbox', callbacks, new GenDateField().currentDate(), dtlLine.dgDtl.dataProvider[rowIndex].gl_account_code);
				getInformationEvent.dispatch(); 
			}
			else
			{
				dtlLine.dgDtl.dataProvider[row_index].gl_account_code	 = ''
				dtlLine.dgDtl.dataProvider[row_index].gl_account_id 	 = ''
				dtlLine.dgDtl.dataProvider[row_index].gl_account_name 	 = ''
			}
		}
	}
}

private function glAccountChangeEventHandler(resultXml:XML):void
{
	Application.application.enabled = true;
	CursorManager.removeBusyCursor();
				
	dtlLine.dgDtl.dataProvider[row_index].gl_account_code	 = resultXml.children().child('bank_code').toString()
	dtlLine.dgDtl.dataProvider[row_index].gl_account_id 	 = resultXml.children().child('bank_id').toString()
	dtlLine.dgDtl.dataProvider[row_index].gl_account_name 	 = resultXml.children().child('bank_name').toString()
}

private function changeApplyFlag(rowIndex:int):void
{
	var receivedAmt:Number = Number(tiCredit_amt.text)
	var applyTotalAmt:Number = getTotalApplyAmt()
	var balanceAmt:Number = receivedAmt - applyTotalAmt  
	
	if(String(dtlLine.dgDtl.dataProvider[rowIndex].apply_flag).toLowerCase() == "y")
	{
		if(Number(dtlLine.dgDtl.dataProvider[rowIndex].balance_amt) < balanceAmt)
		{
			dtlLine.dgDtl.dataProvider[rowIndex].apply_amt = numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].balance_amt)
		}
		else
		{
			dtlLine.dgDtl.dataProvider[rowIndex].apply_amt = balanceAmt;
		}
		
		//dtlLine.dgDtl.dataProvider[rowIndex].disctaken_amt = "0.00"
		dtlLine.dgDtl.dataProvider[rowIndex].remaining_amt = numericFormatter.format(Number(numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].balance_amt)) - Number(numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].apply_amt)) - Number(numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].disctaken_amt)));
	}
	else //means select_yn !="y"
	{
		if(Number(dtlLine.dgDtl.dataProvider[rowIndex].id) > 0)  //means row is deleted
		{
			dtlLine.dgDtl.dataProvider[rowIndex].trans_flag = "D"
		}

		dtlLine.dgDtl.dataProvider[rowIndex].apply_amt = "0.00";
		//dtlLine.dgDtl.dataProvider[rowIndex].disctaken_amt = "0.00";
		dtlLine.dgDtl.dataProvider[rowIndex].remaining_amt = numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].balance_amt);
	}
}

private function changeApplyAmt(rowIndex:int):void
{
	var receivedAmt:Number = Number(tiCredit_amt.text)
	var applyTotalAmt:Number = getTotalApplyAmt()
	var balanceAmt:Number = receivedAmt - applyTotalAmt  
	
	if(Number(dtlLine.dgDtl.dataProvider[rowIndex].apply_amt) > balanceAmt)
	{
		//dtlLine.dgDtl.dataProvider[rowIndex].apply_flag = "N"
		//dtlLine.dgDtl.dataProvider[rowIndex].apply_amt = "0.00"
		dtlLine.dgDtl.dataProvider[rowIndex].remaining_amt = numericFormatter.format(Number(numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].balance_amt)) - Number(numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].apply_amt)) - Number(numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].disctaken_amt)));
	}
	else if(Number(dtlLine.dgDtl.dataProvider[rowIndex].apply_amt) > Number(dtlLine.dgDtl.dataProvider[rowIndex].balance_amt))
	{
		//dtlLine.dgDtl.dataProvider[rowIndex].apply_flag = "N"
		//dtlLine.dgDtl.dataProvider[rowIndex].apply_amt = "0.00"
		dtlLine.dgDtl.dataProvider[rowIndex].remaining_amt = numericFormatter.format(Number(numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].balance_amt)) - Number(numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].apply_amt)) - Number(numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].disctaken_amt)));
	}
	else
	{
		// dtlLine.dgDtl.dataProvider[rowIndex].apply_flag = "Y"
		dtlLine.dgDtl.dataProvider[rowIndex].remaining_amt = numericFormatter.format(Number(numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].balance_amt)) - Number(numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].apply_amt)) - Number(numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].disctaken_amt)));
	}
}

private function changeDisctakenAmt(rowIndex:int):void
{
	// dtlLine.dgDtl.dataProvider[rowIndex].apply_flag = "Y"
	dtlLine.dgDtl.dataProvider[rowIndex].remaining_amt = numericFormatter.format(Number(numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].balance_amt)) - Number(numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].apply_amt)) - Number(numericFormatter.format(dtlLine.dgDtl.dataProvider[rowIndex].disctaken_amt)));
}

private function getTotalApplyAmt():Number
{
	var applyTotalAmt:Number = 0;

	if(dtlLine.dgDtl.dataProvider != null)
	{
		for(var i:int = 0; i < dtlLine.dgDtl.dataProvider.length; i++)
		{
			applyTotalAmt = applyTotalAmt + (Number)(dtlLine.dgDtl.dataProvider[i].apply_amt);
		}
	}
	
	return Number(numericFormatter.format(applyTotalAmt));
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{
	var recordXml:XML	= event.recordXml;

	taVendor.text		=	setVendorAddress(recordXml)
	
	//set editable fields false 
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	
	//set editable fields true
}
