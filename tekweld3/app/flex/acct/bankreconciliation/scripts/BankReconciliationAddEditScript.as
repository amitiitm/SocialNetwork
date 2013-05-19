
import business.events.GetInformationEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.customcomponents.GenTextInput;
import com.generic.customcomponents.NewGenDataGrid;
import com.generic.events.AddEditEvent;
import com.generic.events.NewDetailEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.genclass.URL;
import com.generic.genclass.Utility;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.DateField;
import mx.controls.Spacer;
import mx.core.Application;
import mx.core.UIComponent;
import mx.events.DataGridEvent;
import mx.events.ScrollEvent;
import mx.events.ScrollEventDirection;
import mx.managers.CursorManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.utils.ObjectUtil;



[Bindable]
private var __genModel:GenModelLocator	=	GenModelLocator.getInstance();
private var getInformationEvent:GetInformationEvent;
private var _defaultDate:String = DateField.dateToString(new Date(),'YYYY/MM/DD');
private var numericFormatter:GenNumberFormatter;

private function init():void
{
	getAccountPeriod();
	
	dgClearedCheckDtl.bcdp.height 	= 	0;
	dgDepositDtl.bcdp.height		=	0;
	dgPaymentDtl.bcdp.height		=	0;
	dgTransactionDtl.bcdp.height	=	0;			
	
	dgTransactionDtl.dgDtl.addEventListener(DataGridEvent.COLUMN_STRETCH,changeTransactionColumnSize);
	dgDepositDtl.dgDtl.addEventListener(DataGridEvent.COLUMN_STRETCH,changeDepositColumnSize);
	dgPaymentDtl.dgDtl.addEventListener(DataGridEvent.COLUMN_STRETCH,changePaymentColumnSize);
	dgClearedCheckDtl.dgDtl.addEventListener(DataGridEvent.COLUMN_STRETCH,changeClearedColumnSize);
	
	dgTransactionDtl.dgDtl.addEventListener(ScrollEvent.SCROLL,onTransactionScroll);
	dgDepositDtl.dgDtl.addEventListener(ScrollEvent.SCROLL,onDepositScroll);
	dgPaymentDtl.dgDtl.addEventListener(ScrollEvent.SCROLL,onPaymentScroll);
	dgClearedCheckDtl.dgDtl.addEventListener(ScrollEvent.SCROLL,onClearedScroll);
	
	numericFormatter	=	new GenNumberFormatter();
	numericFormatter.precision = 2;
	numericFormatter.rounding = 'nearest'

}
private function btnQueryClickHandler():void
{
	if(__genModel.isLockScreen)
	{
		Alert.show('In Progrss ! please try again');
		return;
		
	}
	var __locator:ServiceLocator = __genModel.services;
	var __getTransactionService:HTTPService;
	
	var callbackShowCustomer:IResponder 		= 	new mx.rpc.Responder(getTransactionInfoResultHandler, faultHandler);
    
  	var params:XML = new XML(<params>
  									<bank_id>{dcBank_Id.dataValue}</bank_id>
  									<from_date>{dfFrom_date.dataValue}</from_date>
  									<to_date>{dfTo_date.dataValue}</to_date>
  									<account_period_code>{dcAccount_period_code.dataValue}</account_period_code>
  									<company_id>{__genModel.user.default_company_id}</company_id>
  							</params>)
  								
	__getTransactionService = __locator.getHTTPService("geTransactionInfo");
	
	dataService(__getTransactionService);
	
	CursorManager.setBusyCursor();
	Application.application.enabled	=	false;
	
	var token:AsyncToken = __getTransactionService.send(params);
	token.addResponder(callbackShowCustomer);	 
}
private function dataService(service:HTTPService):HTTPService
{
	
	var urlObj:URL	=	new URL();
	service.url		=	urlObj.getURL(service.url.toString())
	
	service.resultFormat = "e4x";
	service.method = "POST";
	service.useProxy = false;
	service.contentType="application/xml";
	service.requestTimeout = 1800
	
	return service;
}
private function faultHandler(event:FaultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled	=	true;
	Alert.show(event.fault.toString());
}
private function getTransactionInfoResultHandler(event:ResultEvent):void
{
	var utilityObj:Utility	=	new Utility();
	var transactionDetail:XML	= 	utilityObj.getDecodedXML((XML)(event.result));
	
	if(transactionDetail.children().length() > 0)
	{
		setHeader(transactionDetail);
		setDetails(transactionDetail);
	}
	else
	{
		resetValues();
	}
	
	CursorManager.removeBusyCursor();
	Application.application.enabled	=	true;	
}
private function setHeader(transactionDetail:XML):void
{
	//**********************************************************************************************
	
	tiBKBeginingAmt.dataValue				=	transactionDetail.child('begining_amt').toString()
	tiBKDepositAmt.dataValue				=	transactionDetail.child('deposit_amt').toString()
	tiBKPaymentAmt.dataValue				=	transactionDetail.child('payment_amt').toString()
	
	tiBKEndingAmt.dataValue					=	transactionDetail.child('ending_amt').toString()
		
	//*********************************************************************************************
	
	//tiReBookEnding.dataValue						=	'0.00'	
	
	tiReOutstandingDepositAmt.dataValue				=	transactionDetail.child('outstanding_deposit_amt').toString()
	tiReOutstandingPaymentAmt.dataValue				=	transactionDetail.child('outstanding_payment_amt').toString()
	
	tiReBankTotalAmt.dataValue						=	'0.00'
	tiReBankEnding.dataValue						=	'0.00'
	tiDifference.dataValue							=	'0.00'
	
	//*********************************************************************************************
	tiBankEndingBalance.dataValue					=	'0.00'
		
}
/* private function setDetails(transactionDetail:XML):void
{
	//********************************************************************************************
	
	var banktTansactionXML:XML		=	XML(transactionDetail.child(dgTransactionDtl.rootNode));
	var banktDepositXML:XML			=	new XML('<' + dgDepositDtl.rootNode +'/>');
	var banktPaymentXML:XML			=	new XML('<' + dgPaymentDtl.rootNode +'/>');;
	var clearCheckXML:XML			=	new XML('<' + dgClearedCheckDtl.rootNode +'/>');;
	
	if(banktTansactionXML.children().length() > 0)
	{
		var tempDepositXMLList:XMLList	=	banktTansactionXML.children().(String(trans_type).toUpperCase() == 'DEPS');
		if(tempDepositXMLList !=  XMLList(undefined) && tempDepositXMLList != null )
		{
			banktDepositXML.appendChild(tempDepositXMLList);
		}
		
		var tempPaymentXMLList:XMLList	=	banktTansactionXML.children().(String(trans_type).toUpperCase() == 'PAYM');
		if(tempPaymentXMLList !=  XMLList(undefined) && tempPaymentXMLList != null )
		{
			banktPaymentXML.appendChild(tempPaymentXMLList);
		}
		
		
		var tempClearCheckXMLList:XMLList	=	banktTansactionXML.children().(String(clear_flag).toUpperCase() == 'Y');
		if(tempClearCheckXMLList !=  XMLList(undefined) && tempClearCheckXMLList != null )
		{
			//for clear tab we are using copy
			clearCheckXML.appendChild(tempClearCheckXMLList.copy());
		}
			
	}
	
	dgTransactionDtl.rows		=	banktTansactionXML//XML(transactionDetail.child(dgTransactionDtl.rootNode));
	dgDepositDtl.rows			=	banktDepositXML//XML(transactionDetail.child(dgDepositDtl.rootNode));
	dgPaymentDtl.rows			=	banktPaymentXML//XML(transactionDetail.child(dgPaymentDtl.rootNode));
	
	dgClearedCheckDtl.rows		=	clearCheckXML;
	
	transactionTotalCalculation();
	depositTotalCalculation();
	paymentTotalCalculation();
	clearedTotalCalculation();
	BankCalculation();
}
 */
private function setDetails(transactionDetail:XML):void
{
	//********************************************************************************************
	var banktTansactionXML:XML		=	XML(transactionDetail.child(dgTransactionDtl.rootNode));
	var banktDepositXML:XML			=	XML(transactionDetail.child(dgDepositDtl.rootNode));
	var banktPaymentXML:XML			=	XML(transactionDetail.child(dgPaymentDtl.rootNode));
	var clearCheckXML:XML			=	XML(transactionDetail.child(dgClearedCheckDtl.rootNode));
	
	
	dgTransactionDtl.dgDtl.rows		=	banktTansactionXML;
	dgDepositDtl.dgDtl.rows			=	banktDepositXML;
	dgPaymentDtl.dgDtl.rows			=	banktPaymentXML;
	
	dgClearedCheckDtl.dgDtl.rows		=	clearCheckXML;
	
	transactionTotalCalculation();
	depositTotalCalculation();
	paymentTotalCalculation();
	clearedTotalCalculation();
	BankCalculation();
}
 
 private function setValues(transactionDetail:XML):void
{
	
	//set all information here
}
private function resetValues():void
{
	_defaultDate				=	dfTo_date.dataValue;
	//********************************************************************************************
	dgTransactionDtl.dgDtl.rows		=	new XML('<' + dgTransactionDtl.rootNode +'/>');
	dgDepositDtl.dgDtl.rows			=	new XML('<' + dgDepositDtl.rootNode +'/>');
	dgPaymentDtl.dgDtl.rows			=	new XML('<' + dgPaymentDtl.rootNode +'/>');
	
	dgClearedCheckDtl.dgDtl.rows		=	new XML('<' + dgClearedCheckDtl.rootNode +'/>');
	
	//**********************************************************************************************
	
	tiBKBeginingAmt.dataValue				=	'0.00'
	tiBKDepositAmt.dataValue				=	'0.00'
	tiBKPaymentAmt.dataValue				=	'0.00'
	
	tiBKEndingAmt.dataValue					=	'0.00'
	
	
	//*********************************************************************************************
	
	tiReBookEnding.dataValue						=	'0.00'	
	tiReOutstandingDepositAmt.dataValue				=	'0.00'
	tiReOutstandingPaymentAmt.dataValue				=	'0.00'
	tiReBankTotalAmt.dataValue						=	'0.00'
	tiReBankEnding.dataValue						=	'0.00'
	tiDifference.dataValue							=	'0.00'
	
	//*********************************************************************************************
	
	tiBankEndingBalance.dataValue					=	'0.00'
	
	//*********************************************************************************************
	
	resetTotal();
}
private function getAccountPeriod():void
{
	if(dfTo_date.text != '' && dfTo_date.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('accountperiod',callbacks, dfTo_date.text);
		getInformationEvent.dispatch(); 
	} 
}

private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue	=	resultXml.child('code');
	dcAccount_period_code.labelValue	=	resultXml.child('code'); 
}
private function bankChangeEvent():void
{
	tiBank_code.dataValue		= 	dcBank_Id.text;
	resetValues();
	if(dcBank_Id.text != '' && dcBank_Id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(fromDateHandler, null);
	
		getInformationEvent	=	new GetInformationEvent('bankreconciliationfromdate', callbacks,dcBank_Id.dataValue);
		getInformationEvent.dispatch(); 
	}
	else
	{
		dfFrom_date.dataValue	=	'';
	} 
}
private function fromDateHandler(resultXml:XML):void
{
	dfFrom_date.dataValue	=	resultXml.children().child('from_date').toString();
}

private function bankChangeEventHandler(resultXml:XML):void
{
	/* tiBank_name.dataValue		= 	resultXml.children().child('bank_name').toString();
	tiBank_code.dataValue		= 	resultXml.children().child('bank_code').toString();

	dcBank_Id.labelValue		= 	resultXml.children().child('bank_code').toString();
	dcBank_Id.dataValue  		=	resultXml.children().child('bank_id').toString(); */
	

	//Alert.show('bankchange'+resultXml);
}

private var colName:String;
private	var rowIndex:int;
private var removeFrom:String;

//**********************************************************************************************
private function handleTransactionDtlFocusOut(event:NewDetailEvent):void
{
	colName = event.object.id
	rowIndex = event.currentTarget.editBarRowPosition;

	handleFocusOut(dgTransactionDtl.dgDtl,'ALLTRANSACTION')					
}
private function handleDepositDtlFocusOut(event:NewDetailEvent):void
{
	colName = event.object.id
	rowIndex = event.currentTarget.editBarRowPosition;

	handleFocusOut(dgDepositDtl.dgDtl,'DEPOSIT')	
}
private function handlePaymentDtlFocusOut(event:NewDetailEvent):void
{
	colName = event.object.id
	rowIndex = event.currentTarget.editBarRowPosition;

	handleFocusOut(dgPaymentDtl.dgDtl,'PAYMENT')	
}
private function updateAlsoWith(row:XML, sourceTab:String):void
{
	var	aID:String		=	row.id.toString();
	var targetRow:XML;
	var index:int;
	
	if(sourceTab == 'ALLTRANSACTION')
	{
		if(String(row.trans_type.toString()).toUpperCase() == 'DEPS')
		{
			if(dgDepositDtl.dgDtl.rows.children().length()>0)
			{
				targetRow	=	XML(dgDepositDtl.dgDtl.rows.children().(id.toString() == aID))
				if(targetRow != XML(undefined) &&  targetRow != null)
				{
					index		=	targetRow.childIndex();
					dgDepositDtl.dgDtl.dataProvider[index].clear_flag	=	row.clear_flag.toString();	
					dgDepositDtl.dgDtl.dataProvider[index].clear_date	=	row.clear_date.toString();	
				}	
			}
			
				
		}
		else if(String(row.trans_type.toString()).toUpperCase() == 'PAYM')
		{
			if(dgPaymentDtl.dgDtl.rows.children().length()>0)
			{
				targetRow	=	XML(dgPaymentDtl.dgDtl.rows.children().(id.toString() == aID))
				if(targetRow != XML(undefined) &&  targetRow != null)
				{
					index		=	targetRow.childIndex();
					dgPaymentDtl.dgDtl.dataProvider[index].clear_flag	=	row.clear_flag.toString();
					dgPaymentDtl.dgDtl.dataProvider[index].clear_date	=	row.clear_date.toString();	
				}	
			}
		}
	}
	else if(sourceTab == 'DEPOSIT' || sourceTab == 'PAYMENT')
	{
		if(dgTransactionDtl.dgDtl.rows.children().length()>0)
		{
			targetRow	=	XML(dgTransactionDtl.dgDtl.rows.children().(id.toString() == aID))
			if(targetRow != XML(undefined) &&  targetRow != null)
			{
				index		=	targetRow.childIndex();
				dgTransactionDtl.dgDtl.dataProvider[index].clear_flag	=	row.clear_flag.toString();
				dgTransactionDtl.dgDtl.dataProvider[index].clear_date	=	row.clear_date.toString();	
			}	
		}
	}
	else if(sourceTab == 'CLEAREDROWS')
	{
		if(String(row.trans_type.toString()).toUpperCase() == 'DEPS')
		{
			if(dgDepositDtl.dgDtl.rows.children().length() > 0)
			{
				targetRow	=	XML(dgDepositDtl.dgDtl.rows.children().(id.toString() == aID))
				if(targetRow != XML(undefined) &&  targetRow != null)
				{
					index		=	targetRow.childIndex();
					dgDepositDtl.dgDtl.dataProvider[index].clear_flag	=	row.clear_flag.toString();	
					dgDepositDtl.dgDtl.dataProvider[index].clear_date	=	row.clear_date.toString();	
				}
					
			}
			
			if(dgTransactionDtl.dgDtl.rows.children().length() > 0)
			{
				targetRow	=	XML(dgTransactionDtl.dgDtl.rows.children().(id.toString() == aID))
				if(targetRow != XML(undefined) &&  targetRow != null)
				{
					index		=	targetRow.childIndex();
					dgTransactionDtl.dgDtl.dataProvider[index].clear_flag	=	row.clear_flag.toString();	
					dgTransactionDtl.dgDtl.dataProvider[index].clear_date	=	row.clear_date.toString();	
				}
					
			}							
		}
		else if(String(row.trans_type.toString()).toUpperCase() == 'PAYM')
		{
			if(dgPaymentDtl.dgDtl.rows.children().length() > 0 )
			{
				targetRow	=	XML(dgPaymentDtl.dgDtl.rows.children().(id.toString() == aID))
				if(targetRow != XML(undefined) &&  targetRow != null)
				{
					index		=	targetRow.childIndex();
					dgPaymentDtl.dgDtl.dataProvider[index].clear_flag	=	row.clear_flag.toString();
					dgPaymentDtl.dgDtl.dataProvider[index].clear_date	=	row.clear_date.toString();	
				}
			}
			
			if(dgTransactionDtl.dgDtl.rows.children().length() > 0 )
			{
				targetRow	=	XML(dgTransactionDtl.dgDtl.rows.children().(id.toString() == aID))
				if(targetRow != XML(undefined) &&  targetRow != null)
				{
					index		=	targetRow.childIndex();
					dgTransactionDtl.dgDtl.dataProvider[index].clear_flag	=	row.clear_flag.toString();	
					dgTransactionDtl.dgDtl.dataProvider[index].clear_date	=	row.clear_date.toString();	
				}				
			}			
		}
	}
}

private function handleClearCheckDtlFocusOut(event:NewDetailEvent):void
{
	colName = event.object.id
	rowIndex = event.currentTarget.editBarRowPosition;

	if(colName == "clear_flag")
	{
		if(dgClearedCheckDtl.dgDtl.dataProvider[rowIndex].clear_flag == "N")  //because cleared tab has only 'Y' value so user can only delete
		{
			dgClearedCheckDtl.dgDtl.dataProvider[rowIndex].clear_date	=	'';
			updateAlsoWith(XML(dgClearedCheckDtl.dgDtl.dataProvider[rowIndex]).copy(),'CLEAREDROWS')
			doOutStandingCalculation(XML(dgClearedCheckDtl.dgDtl.dataProvider[rowIndex]).copy(),'CLEAREDROWS','REMOVE')
			removeFromClearRows(XML(dgClearedCheckDtl.dgDtl.dataProvider[rowIndex]).id.toString());
		}
	}
	else if(colName == "clear_date")
	{
		updateAlsoWith(XML(dgClearedCheckDtl.dgDtl.dataProvider[rowIndex]).copy(),'CLEAREDROWS')
	}
	
	
	transactionTotalCalculation();
	depositTotalCalculation();
	paymentTotalCalculation();
	clearedTotalCalculation();
	BankCalculation();
				
}
// it will also update transaction because they are binded 
/* private function updateTransactionRows(row:XML):void
{
	var	aID:String			=	row.id.toString();
	var index:int;
	var transactionRow:XML
	
	if(String(row.trans_type.toString()).toUpperCase() == 'DEPS')
	{
		transactionRow 		=	XML(dgDepositDtl.rows.children().(id.toString() == aID))
		index				=	transactionRow.childIndex();
	
		dgDepositDtl.dgDtl.dataProvider[index].clear_flag	=	row.clear_flag.toString();
		dgDepositDtl.dgDtl.dataProvider[index].clear_date	=	row.clear_date.toString();
	}
	else if(String(row.trans_type.toString()).toUpperCase() == 'PAYM')
	{
		transactionRow 		=	XML(dgPaymentDtl.rows.children().(id.toString() == aID))
		index				=	transactionRow.childIndex();
	
		dgPaymentDtl.dgDtl.dataProvider[index].clear_flag	=	row.clear_flag.toString();
		dgPaymentDtl.dgDtl.dataProvider[index].clear_date	=	row.clear_date.toString();
	}	
	
} */
private function handleFocusOut(dg:NewGenDataGrid , sourceTAB:String):void
{
	if(dg.dataProvider != null)
	{
		if(colName == "clear_flag")
		{
			var currentRow:XML;
			currentRow	= XML(dg.dataProvider[rowIndex])
				
			if(dg.dataProvider[rowIndex].clear_flag == "Y")
			{
				dg.dataProvider[rowIndex].clear_date	=	_defaultDate;
				
				addToClearRows(currentRow.copy());
				updateAlsoWith(currentRow.copy() , sourceTAB);
				doOutStandingCalculation(currentRow.copy(),sourceTAB,'ADD')
			}  
			else
			{
				dg.dataProvider[rowIndex].clear_date	=	'';
				
				removeFromClearRows(currentRow.id.toString());
				updateAlsoWith(currentRow.copy(),sourceTAB);
				doOutStandingCalculation(currentRow.copy(),sourceTAB,'REMOVE')
			}
		}
		else if(colName == "clear_date")
		{
			if(dg.dataProvider[rowIndex].clear_flag == "Y")
			{
				updateClearRows(XML(dg.dataProvider[rowIndex]).copy())
				updateAlsoWith(XML(dg.dataProvider[rowIndex]).copy(),sourceTAB)
			}
		}
	}
	
	transactionTotalCalculation();
	depositTotalCalculation();
	paymentTotalCalculation();
	clearedTotalCalculation();	
	BankCalculation();
}
private function addToClearRows(row:XML):void
{
	row.setLocalName('bank_cleared_transaction');
	var temp:XML;
	dgClearedCheckDtl.dgDtl.rows.appendChild(new XML(row))
	
	temp	=	dgClearedCheckDtl.dgDtl.rows.copy();
	
	dgClearedCheckDtl.dgDtl.rows	=	temp;
}
private function updateClearRows(row:XML):void
{
	var	aID:String		=	row.id.toString();
	var clearRow:XML	=	XML(dgClearedCheckDtl.dgDtl.rows.children().(id.toString() == aID))
	
	var index:int		=	clearRow.childIndex();
	
	dgClearedCheckDtl.dgDtl.dataProvider[index].clear_date	=	row.clear_date.toString();
}
private function removeFromClearRows(aID:String):void
{
	var temp:XML;
	
	var row:XML		=	XML(dgClearedCheckDtl.dgDtl.rows.children().(id.toString() == aID))
	var index:int	=	row.childIndex();
	var node:String	=	row.localName()
	
	delete dgClearedCheckDtl.dgDtl.rows.child(node)[index];
	
	//dgClearedCheckDtl.reset();
	temp	=	dgClearedCheckDtl.dgDtl.rows.copy();	
	dgClearedCheckDtl.dgDtl.rows	=	temp;	
	
}
private function doOutStandingCalculation(currentRow:XML, sourceTAB:String ,sourceOperation:String):void
{
	if(sourceTAB == 'DEPOSIT')
	{
		outStandingDepositCalculation(currentRow.copy(),sourceOperation);	
	}
	else if(sourceTAB == 'PAYMENT')
	{
		outStandingPaymentCalculation(currentRow.copy(),sourceOperation)	
	}
	else if(sourceTAB == 'ALLTRANSACTION')
	{
		if(String(currentRow.trans_type.toString()).toUpperCase() == 'DEPS')
		{
			outStandingDepositCalculation(currentRow.copy(),sourceOperation);	
		}
		else if(String(currentRow.trans_type.toString()).toUpperCase() == 'PAYM')
		{
			outStandingPaymentCalculation(currentRow.copy(),sourceOperation)	
		}
	}
	else if(sourceTAB == 'CLEAREDROWS')
	{
		if(String(currentRow.trans_type.toString()).toUpperCase() == 'DEPS')
		{
			outStandingDepositCalculation(currentRow.copy(),sourceOperation);	
		}
		else if(String(currentRow.trans_type.toString()).toUpperCase() == 'PAYM')
		{
			outStandingPaymentCalculation(currentRow.copy(),sourceOperation)	
		}
		
	}		
}
private var databaseDateFormat:String   = 'YYYY/MM/DD'; 
private function checkDate():Boolean
{
	var fromDate:Date	=	 DateField.stringToDate(dfFrom_date.text,databaseDateFormat)
	var toDate:Date		=	 DateField.stringToDate(dfTo_date.text,databaseDateFormat)

	if(ObjectUtil.dateCompare(fromDate, toDate) == 1){

		Alert.show('To Date can not be less than From Date.');
		/* dfTo_date.text	=	""; */
		return false;
	} 
	
	return true;
}
//**********************************************************************************************
override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{	
	dcBank_Id.enabled			=	false;
	dfTo_date.enabled			=	false;
	tiBankEndingBalance.enabled	=	false;
	btnQuery.enabled			=	false;
	
	var transactionDetail:XML	=	XML(event.recordXml.children()[0]);
	
	if(transactionDetail.children().length() > 0)
	{
		transactionTotalCalculation();
		depositTotalCalculation();
		paymentTotalCalculation();
		clearedTotalCalculation();
		BankCalculation();
		//setDetails(transactionDetail)	
	}
	else
	{
		resetTotal();
	}	
}

override protected function resetObjectEventHandler():void   //on add buttton press,
{
	dcBank_Id.enabled			=	true;
	dfTo_date.enabled			=	true;
	tiBankEndingBalance.enabled	=	true;
	btnQuery.enabled			=	true;
	
	getAccountPeriod();	
	resetTotal();
}
override protected function preSaveEventHandler(event:AddEditEvent):int  
{
	if(!checkDate())
	{
		return 1;
	}
	
	return 0;
}
//***********************************structure complete handler****************************************************************
private function transactionStructureCompleteEventHandler():void
{
	structureCompleteHandler(dgTransactionDtl.structure , hbTotalTransaction);	
}
private function depositStructureCompleteEventHandler():void
{
	structureCompleteHandler(dgDepositDtl.structure , hbTotalDeposit);
}
private function paymentStructureCompleteEventHandler():void
{
	structureCompleteHandler(dgPaymentDtl.structure , hbTotalPayment);
}
private function clearedStructureCompleteEventHandler():void
{
	structureCompleteHandler(dgClearedCheckDtl.structure , hbTotalCleared);	
}

private function structureCompleteHandler(structure:XML , hbTotal:HBox):void
{
	if(structure.children().length() > 0)
	{
		var tiSearch:GenTextInput;
		var space:Spacer;
		
		for(var i:int = 0 ; i < structure.children().length()	;	i++)
		{
			if( structure.children()[i].@visible.toString()	==	'true')
			{
				if(structure.children()[i].@data.toString() == 'credit_amt' || structure.children()[i].@data.toString() == 'debit_amt')
				{
					tiSearch			=	new GenTextInput();
					tiSearch.name		=	structure.children()[i].@data.toString();
					tiSearch.dataType	=	structure.children()[i].@sortDataType.toString();
					tiSearch.enabled	=	false;
					tiSearch.width		=	Number(structure.children()[i].@width.toString());
					tiSearch.height		=	20;
					tiSearch.setStyle('textAlign' , structure.children()[i].@textAlign);
					
					if(tiSearch.dataType == 'N')
					{
						tiSearch.negativeFlag = 'true'
						tiSearch.maxValue = 99999999.99
						tiSearch.defaultValue = '0.00'
						tiSearch.setDefaultOnEmpty = 'true';
						tiSearch.dataValue  		=	'0.00'
					}
					hbTotal.addChild(tiSearch);	
				}
				else
				{
					space		=	new Spacer();
					space.name	=	structure.children()[i].@data.toString();
					space.width	=	Number(structure.children()[i].@width.toString());
					hbTotal.addChild(space);	
				}
			}
		}		
		var arr:Array	=	hbTotal.getChildren();
		
		var lastChild:UIComponent	=	UIComponent( hbTotal.getChildAt(arr.length -1));
		lastChild.percentWidth		=	100;	 
	}
	
}


//**********************************Total Transaction, handlers***************************************************************

private function changeTransactionColumnSize(event:DataGridEvent):void
{
	changeColumnSizeHandler(event,dgTransactionDtl.dgDtl , hbTotalTransaction);
}
private function handleTransactionResize(event:Event):void
{
	handleResize(event,dgTransactionDtl.dgDtl, hbTotalTransaction);
}
private function onTransactionScroll(event:ScrollEvent):void 
{
	onScroll(event,dgTransactionDtl.dgDtl, hbTotalTransaction);
}
//****************************Total Deposit  Handlers*******************************************************************
private function changeDepositColumnSize(event:DataGridEvent):void
{
	changeColumnSizeHandler(event,dgDepositDtl.dgDtl , hbTotalDeposit);
}
private function handleDepositResize(event:Event):void
{
	handleResize(event,dgDepositDtl.dgDtl , hbTotalDeposit);
}
private function onDepositScroll(event:ScrollEvent):void 
{
	onScroll(event,dgDepositDtl.dgDtl , hbTotalDeposit);
}

//*************************************************************************************************

private function changePaymentColumnSize(event:DataGridEvent):void
{
	changeColumnSizeHandler(event,dgPaymentDtl.dgDtl , hbTotalPayment);
}
private function handlePaymentResize(event:Event):void
{
	handleResize(event,dgPaymentDtl.dgDtl , hbTotalPayment);
}
private function onPaymentScroll(event:ScrollEvent):void 
{
	onScroll(event,dgPaymentDtl.dgDtl , hbTotalPayment);
}

//*************************************************************************************************

private function changeClearedColumnSize(event:DataGridEvent):void
{
	changeColumnSizeHandler(event,dgClearedCheckDtl.dgDtl , hbTotalCleared);
}
private function handleClearedResize(event:Event):void
{
	handleResize(event,dgClearedCheckDtl.dgDtl , hbTotalCleared);
}
private function onClearedScroll(event:ScrollEvent):void 
{
	onScroll(event,dgClearedCheckDtl.dgDtl , hbTotalCleared);
}


//*************************************************************************************************
private function changeColumnSizeHandler(event:DataGridEvent , dg:NewGenDataGrid , hbTotal:HBox):void
{	
	UIComponent(hbTotal.getChildByName(dg.columns[event.columnIndex].dataField.toString())).width	=	dg.columns[event.columnIndex].width;
}
private function handleResize(event:Event , dg:NewGenDataGrid , hbTotal:HBox):void
{
	scrollDataGrid(dg.horizontalScrollPosition , dg, hbTotal)
}

private function scrollDataGrid(invisibleColumns:int, dg:NewGenDataGrid , hbTotal:HBox):void 
{
 	var ary:Array = hbTotal.getChildren()
	var ismorecolumns:Boolean = false;
	
	if(ary.length > 0)
	{
		for(var i:int=0; i<invisibleColumns; i++)
		{
			ary[i].visible = false
			ary[i].width = 0
		}
		
		for(var j:int=invisibleColumns; j < dg.columns.length; j++)
		{
			ary[j].visible = true
			ary[j].width = dg.columns[j].width
		}
		var lastChild:UIComponent	=	UIComponent(hbTotal.getChildAt(ary.length -1));
		lastChild.percentWidth		=	100;	
	} 				
} 
private function onScroll(event:ScrollEvent, dg:NewGenDataGrid , hbTotal:HBox):void 
{
	 if(event.direction == ScrollEventDirection.HORIZONTAL)
	{
		var invisibleColumns:int = dg.horizontalScrollPosition
		scrollDataGrid(invisibleColumns ,dg ,hbTotal )
	} 
}

//*******************************total calculations******************************************************************
private function transactionTotalCalculation():void
{
	var totalDepositAmt:Number = 0.00;
	var totalPaymentAmt:Number = 0.00;
	
	for(var i:int = 0 ; i < dgTransactionDtl.dgDtl.dataProvider.length ; i++)
	{
		/* old if(dgTransactionDtl.dgDtl.dataProvider[i].trans_type == 'DEPS')
		{ */
			totalDepositAmt	=	totalDepositAmt + Number(dgTransactionDtl.dgDtl.dataProvider[i].credit_amt.toString())
			
		/* }
		else if(dgTransactionDtl.dgDtl.dataProvider[i].trans_type == 'PAYM')
		{ */
			totalPaymentAmt	=	totalPaymentAmt + Number(dgTransactionDtl.dgDtl.dataProvider[i].debit_amt.toString())
		/* } */
	}
	
	/* for transaction tab*/
	GenTextInput(hbTotalTransaction.getChildByName('credit_amt')).dataValue	=	totalDepositAmt.toString();
	GenTextInput(hbTotalTransaction.getChildByName('debit_amt')).dataValue	=	totalPaymentAmt.toString();
		
}
private function depositTotalCalculation():void
{
	var totalDepositAmt:Number = 0.00;
	
	for(var i:int = 0 ; i < dgDepositDtl.dgDtl.dataProvider.length ; i++)
	{
		totalDepositAmt	=	totalDepositAmt + Number(dgDepositDtl.dgDtl.dataProvider[i].credit_amt.toString())
	}
	
	
	/* for Deposit tab*/
	GenTextInput(hbTotalDeposit.getChildByName('credit_amt')).dataValue	=	totalDepositAmt.toString();
	
	//if we have to calculate outstanding amt tiReOutstandingDepositAmt.dataValue	=	((-1) * totalDepositAmt).toString();

}
private function paymentTotalCalculation():void
{
	var totalPaymentAmt:Number = 0.00;
	
	for(var i:int = 0 ; i < dgPaymentDtl.dgDtl.dataProvider.length ; i++)
	{		
		totalPaymentAmt	=	totalPaymentAmt + Number(dgPaymentDtl.dgDtl.dataProvider[i].debit_amt.toString())
	}
	
	/* for Payment tab*/
	GenTextInput(hbTotalPayment.getChildByName('debit_amt')).dataValue	=	totalPaymentAmt.toString();
	
	//if we have to calculate outstanding amt tiReOutstandingDepositAmt.dataValue	=	totalPaymentAmt.toString();
}

private function clearedTotalCalculation():void
{
	var totalDepositAmt:Number = 0.00;
	var totalPaymentAmt:Number = 0.00;
	
	for(var i:int = 0 ; i < dgClearedCheckDtl.dgDtl.dataProvider.length ; i++)
	{
		/*old calculation if(dgClearedCheckDtl.dgDtl.dataProvider[i].trans_type == 'DEPS')
		{
			if(dgClearedCheckDtl.dgDtl.dataProvider[i].clear_flag == 'Y')
			{
				totalDepositAmt	=	totalDepositAmt + Number(dgClearedCheckDtl.dgDtl.dataProvider[i].credit_amt.toString())
			}
		}
		else if(dgClearedCheckDtl.dgDtl.dataProvider[i].trans_type == 'PAYM')
		{
			if(dgClearedCheckDtl.dgDtl.dataProvider[i].clear_flag == 'Y')
			{
				totalPaymentAmt	=	totalPaymentAmt + Number(dgClearedCheckDtl.dgDtl.dataProvider[i].debit_amt.toString())
			}
			
		} */
		
		if(dgClearedCheckDtl.dgDtl.dataProvider[i].clear_flag == 'Y')/*new calculation*/
		{
			totalDepositAmt	=	totalDepositAmt + Number(dgClearedCheckDtl.dgDtl.dataProvider[i].credit_amt.toString())
			totalPaymentAmt	=	totalPaymentAmt + Number(dgClearedCheckDtl.dgDtl.dataProvider[i].debit_amt.toString())
		}
	}
	
	/* for transaction tab*/
	GenTextInput(hbTotalCleared.getChildByName('credit_amt')).dataValue	=	totalDepositAmt.toString();
	GenTextInput(hbTotalCleared.getChildByName('debit_amt')).dataValue	=	totalPaymentAmt.toString();	
}
private function sum(a:Number , b:Number ,c:Number):Number
{
	
	var c:Number = a+b+c
	return c
}
private function BankCalculation():void
{
	var bookEndingAmt:Number 			= Number(numericFormatter.format(tiReBookEnding.dataValue ))
	var outStandingDepositAmt:Number	= Number(numericFormatter.format(tiReOutstandingDepositAmt.dataValue))
	var outStandingPaymentAmt:Number	= Number(numericFormatter.format(tiReOutstandingPaymentAmt.dataValue))
	
	tiReBankTotalAmt.dataValue			=  numericFormatter.format(bookEndingAmt + outStandingDepositAmt + outStandingPaymentAmt)
	
	
	var bankTotalAmt:Number				=  Number(numericFormatter.format(tiReBankTotalAmt.dataValue));
	var bankEndingAmt:Number			=  Number(numericFormatter.format(tiBankEndingBalance.dataValue));
	
	tiDifference.dataValue				=	numericFormatter.format(bankTotalAmt - bankEndingAmt);

}
private function resetTotal():void
{
	if(hbTotalTransaction.getChildren().length > 0)
	{
		/* for transaction tab*/
		GenTextInput(hbTotalTransaction.getChildByName('credit_amt')).dataValue	=	'0.00'
		GenTextInput(hbTotalTransaction.getChildByName('debit_amt')).dataValue	=	'0.00'
	}
	if(hbTotalDeposit.getChildren().length > 0)
	{
		/* for Deposit tab*/
		GenTextInput(hbTotalDeposit.getChildByName('credit_amt')).dataValue	=		'0.00'
	}
	if(hbTotalPayment.getChildren().length > 0)
	{
		/* for Payment tab*/
		GenTextInput(hbTotalPayment.getChildByName('debit_amt')).dataValue	=		'0.00'
	}
	if(hbTotalCleared.getChildren().length > 0)
	{
		/* for transaction tab*/
		GenTextInput(hbTotalCleared.getChildByName('credit_amt')).dataValue	=		'0.00'
		GenTextInput(hbTotalCleared.getChildByName('debit_amt')).dataValue	=		'0.00'
	}				
	
}

private function outStandingDepositCalculation(row:XML , sourceOperation:String):void
{
	var depositAmt:Number 				= Number(numericFormatter.format(row.credit_amt.toString()))
	var outStandingDepositAmt:Number	= Number(numericFormatter.format(tiReOutstandingDepositAmt.dataValue))	
	if(sourceOperation == 'ADD')
	{
		tiReOutstandingDepositAmt.dataValue	=	numericFormatter.format(outStandingDepositAmt + depositAmt)
	}
	else if(sourceOperation == 'REMOVE')
	{
		tiReOutstandingDepositAmt.dataValue	=	numericFormatter.format(outStandingDepositAmt - depositAmt)
	}
}
private function outStandingPaymentCalculation(row:XML , sourceOperation:String):void
{
	var paymentAmt:Number 				= 		Number(numericFormatter.format(row.debit_amt.toString()))
	var outStandingPaymentAmt:Number	= 		Number(numericFormatter.format(tiReOutstandingPaymentAmt.dataValue))	

	if(sourceOperation == 'ADD')
	{
		tiReOutstandingPaymentAmt.dataValue	=	numericFormatter.format(outStandingPaymentAmt - paymentAmt)
	}
	else if(sourceOperation == 'REMOVE')
	{
		tiReOutstandingPaymentAmt.dataValue	=	numericFormatter.format(outStandingPaymentAmt + paymentAmt)
	}	
}
//*******************************total calculations end******************************************************************