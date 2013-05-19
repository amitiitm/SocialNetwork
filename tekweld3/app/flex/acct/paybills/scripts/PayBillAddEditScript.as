
import business.delegates.SaveRecordDelegate;
import business.events.GetInformationEvent;
import business.events.RecordStatusEvent;

import com.generic.customcomponents.GenDataGrid;
import com.generic.customcomponents.GenTextInput;
import com.generic.events.AddEditEvent;
import com.generic.genclass.GenNumberFormatter;
import com.generic.genclass.GenValidator;
import com.generic.genclass.Utility;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.DateField;
import mx.controls.Spacer;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.core.UIComponent;
import mx.events.DataGridEvent;
import mx.events.ScrollEvent;
import mx.events.ScrollEventDirection;
import mx.formatters.DateFormatter;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;



[Bindable]
private var __genModel:GenModelLocator	=	GenModelLocator.getInstance();
private var getInformationEvent:GetInformationEvent;
private var _defaultDate:String = DateField.dateToString(new Date(),'YYYY/MM/DD');
private var filterdRows:XML
private var numericFormatter:GenNumberFormatter;


private function init():void
{
	numericFormatter	=	new GenNumberFormatter();
	numericFormatter.precision = 2;
	numericFormatter.rounding = 'nearest'	
	
	dgVendorOpenInvoices.addEventListener(DataGridEvent.COLUMN_STRETCH,changeOpenInvoiceColumnSize);
	dgVendorOpenInvoices.addEventListener(ScrollEvent.SCROLL,onOpenInvoiceScroll);
	
}
private function defaultBankHandler(resultXml:XML):void
{
	dcBank_id.dataValue 		=	resultXml.children().child('bank_id').toString();
	dcBank_id.labelValue		=	resultXml.children().child('bank_code').toString();
	tiBank_code.dataValue		=	resultXml.children().child('bank_code').toString();
	cbPayment_type.dataValue	=	resultXml.children().child('payment_type').toString();	
	tiCheck_no_from.dataValue	=	resultXml.children().child('check_no').toString();	
}

private function prepareCheckClickHandler():void
{
	var genValidator:GenValidator = new GenValidator();
	
	if(genValidator.runCustomValidator(__genModel.activeModelLocator.addEditObj.validators) >= 0)
	{
		CursorManager.setBusyCursor();
		Application.application.enabled	=	false;
	
		var saveXML:XML	=	new XML(<vendor_payments/>)
		var headerXML:XML;
		var detailXML:XML;
		
		var vendor_code:String
		var vendor_id:String
		var paidAmt:String
		var check_no:String
		var term_code:String
		var due_date:String
		
		for(var i:int = 0 ; i < dgPrapareCheckDtl.dataProvider.length ; i++)
		{
			vendor_code		=	dgPrapareCheckDtl.dataProvider[i].vendor_code.toString()
			vendor_id		=	dgPrapareCheckDtl.dataProvider[i].vendor_id.toString()
			paidAmt			=	dgPrapareCheckDtl.dataProvider[i].apply_amt.toString()
			term_code		=	dgPrapareCheckDtl.dataProvider[i].term_code.toString()
			due_date		=	dgPrapareCheckDtl.dataProvider[i].due_date.toString()
			
			if(i == 0)
			{
				check_no	=	tiCheck_no_from.dataValue
			}
			else
			{
				check_no	=	String(int(check_no) + 1)
			}
			
			headerXML	=	generateHeader(vendor_code,vendor_id,paidAmt,check_no,term_code,due_date);
			detailXML	=	generateDetailXML(vendor_code);
			
			headerXML.appendChild(detailXML);
			
			saveXML.appendChild(headerXML);
			
		}

					
		var responder:IResponder = new mx.rpc.Responder(saveResultHandler, faultHandler);
		var delegate:SaveRecordDelegate = new SaveRecordDelegate(responder);
		
		var utilityObj:Utility	=	new Utility();
		var encodedXML:XML		=	utilityObj.getEncodedXML(saveXML);
		delegate.saveRecords(encodedXML);		
	}	
}
private function saveResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled	=	true;
	
	var _resultXml:XML;
	
	var utilityObj:Utility	=	new Utility();
	_resultXml 				= 	utilityObj.getDecodedXML((XML)(event.result));
	
	if(_resultXml.name() == "errors")
	{
		if(_resultXml.children().length() > 0) 
		{
			var message:String = '';
	
			for(var i:uint = 0; i < _resultXml.children().length(); i++) 
			{
				message += _resultXml.children()[i] + "\n";
			}
			Alert.show(message);
		} 
	}
	else
	{
		var recordStatusEvent:RecordStatusEvent = new	RecordStatusEvent("SAVE") //16 feb 2010 this must be before setRecord and retrieve event
		recordStatusEvent.dispatch()
		
		vbOpenInvoices.enabled		=	false;
		vbPrepareCheck.enabled		=	false;
		tnDetail.selectedChild		=	vbPrintCheck;
		dgPPrintCheckDtl.rows		=	_resultXml
		__genModel.activeModelLocator.addEditObj.record	=	_resultXml
	}
}
private function faultHandler(event:FaultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled	=	true;
	
	Alert.show(event.fault.toString());
}
private function generateDetailXML(aVendor_code:String):XML
{
	var detailXML:XML			=	new XML(<vendor_payment_lines/>)
	
	var linesXML:XMLList		=	filterdRows.children().(vendor_code.toString() == aVendor_code && apply_flag.toString() == 'Y')	
	
	detailXML.appendChild(linesXML)
	
	return detailXML;
	
}
private function generateHeader(vendor_code:String,vendor_id:String,paid_amt:String,check_no:String,term_code:String,due_date:String):XML
{
	var headerXML:XML	=	new XML(<vendor_payment/>)
	
	headerXML.vendor_code					=	vendor_code	
	headerXML.vendor_id						=	vendor_id
	headerXML.paid_amt						=	paid_amt
	headerXML.applied_amt					=	paid_amt
	headerXML.balance_amt					=	'0.00'
	headerXML.description					=	tiRemarks.dataValue
	headerXML.payment_type					=	cbPayment_type.dataValue
	headerXML.bank_id						=	dcBank_id.dataValue
	headerXML.bank_code						=	dcBank_id.text;
	headerXML.check_no						=	check_no
	headerXML.check_date					=	dfCheck_date.dataValue;
	headerXML.account_period_code			=	dcAccount_period_code.dataValue
	headerXML.trans_flag					=	'A'
	headerXML.post_flag						=	'P'
	headerXML.trans_no						=	'';
	headerXML.trans_date					=	_defaultDate;
	headerXML.term_code						=	term_code;
	headerXML.due_date						=	due_date;
	
	
	return 	headerXML
}
private function printCheckClickHandler():void
{
	//var objPrintDetail:PrintRecordsDetail	=	PrintRecordsDetail(PopUpManager.createPopUp(this,PrintRecordsDetail,true));		
	
}
private function handleBankIdChange():void
{
	if(dcBank_id.text != '' &&  dcBank_id.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(BankIdChangeResultHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('bankchangepaym', callbacks , dcBank_id.dataValue);
		getInformationEvent.dispatch();
	}
}

private function BankIdChangeResultHandler(resultXml:XML):void
{
	tiBank_code.dataValue		=	resultXml.children().child('bank_code').toString();
	dcBank_id.labelValue		=	resultXml.children().child('bank_code').toString();
	dcBank_id.dataValue			=	resultXml.children().child('bank_id').toString();
	tiCheck_no_from.text		=	resultXml.children().child('check_no').toString();
	cbPayment_type.dataValue	=	resultXml.children().child('payment_type').toString();
	//set payment type and check no
} 
private function handlePaymentTypeChange():void
{
	var callbacks:IResponder	=	new mx.rpc.Responder(paymentTypeChangeResultHandler, null);
		
	if(dcBank_id.text != '' &&  dcBank_id.text != null)
	{
		getInformationEvent	=	new GetInformationEvent('paymenttypechange', callbacks, dcBank_id.dataValue , cbPayment_type.dataValue);
		getInformationEvent.dispatch();	
	}
}

private function paymentTypeChangeResultHandler(resultXml:XML):void
{
	tiCheck_no_from.text				=	resultXml.children().child('check_no').toString();
	//set check no 
} 
private function getAccountPeriod():void
{
	if(dfCheck_date.text != '' && dfCheck_date.text != null)
	{
		var callbacks:IResponder	=	new mx.rpc.Responder(getAccountPeriodHandler, null);
		
		getInformationEvent	=	new GetInformationEvent('accountperiod',callbacks, dfCheck_date.text);
		getInformationEvent.dispatch(); 
	} 
}

private function getAccountPeriodHandler(resultXml:XML):void
{
	dcAccount_period_code.dataValue	=	resultXml.child('code');
	dcAccount_period_code.labelValue	=	resultXml.child('code'); 
} 

private var colName:String;
private	var rowIndex:int;
private var removeFrom:String;

//**********************************************************************************************
private function handleOpenInvoicesFocusOut(event:DataGridEvent):void
{
	colName = DataGridColumn(event.currentTarget.columns[event.columnIndex]).dataField.toString()
	rowIndex = event.rowIndex


	handleFocusOut(dgVendorOpenInvoices)	
}
private function handleFocusOut(dg:GenDataGrid):void
{
	if(dg.dataProvider != null)
	{
		if(colName == "apply_flag")
		{
			if(dg.dataProvider[rowIndex].apply_flag == "Y")
			{
				if(dg.dataProvider[rowIndex].hasOwnProperty('added'))
				{
					if(dg.dataProvider[rowIndex].added.toString() == 'Y')
					{
						return;		
					}
				}
				
				if(!isTotalApplyAmtNegativeAfterAddingThis(XML(dg.dataProvider[rowIndex]).copy()))
				{
					dg.dataProvider[rowIndex].added			=	'Y'
					dg.dataProvider[rowIndex].apply_amt		=	numericFormatter.format(dg.dataProvider[rowIndex].balance_amt.toString())
					dg.dataProvider[rowIndex].remaining_amt	=	'0.00';
					
					/*calculate total apply amt*/
					var tiTotalApplyAmt:GenTextInput	=	GenTextInput(hbOpenInvoiceTotal.getChildByName('apply_amt'))
					var totalApplyAmt:Number = Number(numericFormatter.format(tiTotalApplyAmt.dataValue))
					var thisApplyAmt:Number  = Number(numericFormatter.format(dg.dataProvider[rowIndex].apply_amt.toString())); 	
					
					tiTotalApplyAmt.dataValue		=	numericFormatter.format(String(totalApplyAmt + thisApplyAmt));
					tiTotalPaidAmt.dataValue		=	tiTotalApplyAmt.dataValue;
					/*adding this row to prpare cheack*/
					addToPrepareCheckRows(XML(dg.dataProvider[rowIndex]).copy())	
					
					
				}
				else
				{
					XML(dg.dataProvider[rowIndex]).apply_flag = 'N'
					Alert.show('Total Clear Amt. Should be positive');
				}
				
			}
			else
			{
				if(dg.dataProvider[rowIndex].hasOwnProperty('added'))
				{
					if(dg.dataProvider[rowIndex].added.toString() == 'Y')
					{
						if(!isTotalApplyAmtNegativeAfterRemovingThis(XML(dg.dataProvider[rowIndex]).copy()))
						{
							dg.dataProvider[rowIndex].added			=	'N'
							dg.dataProvider[rowIndex].apply_amt		=	'0.00'
							dg.dataProvider[rowIndex].remaining_amt	=	numericFormatter.format(dg.dataProvider[rowIndex].balance_amt.toString());
							
							
							/*calculate total apply amt*/
							var tiTotalApplyAmt:GenTextInput	=	GenTextInput(hbOpenInvoiceTotal.getChildByName('apply_amt'))
							var totalApplyAmt:Number = Number(numericFormatter.format(tiTotalApplyAmt.dataValue))
							var thisBalanceAmt:Number  = Number(numericFormatter.format(dg.dataProvider[rowIndex].balance_amt.toString())); 	
							
							tiTotalApplyAmt.dataValue		=	numericFormatter.format(String(totalApplyAmt - thisBalanceAmt))
							tiTotalPaidAmt.dataValue		=	tiTotalApplyAmt.dataValue;
							/*remove this row to prpare cheack*/
							removeFromPrepareCheckRows(XML(dg.dataProvider[rowIndex]).copy());
						}
						else
						{
							XML(dg.dataProvider[rowIndex]).apply_flag = 'Y'
							Alert.show('Total Clear Amt. Should be positive');
						}
							
					}
				}
			}
		}
	}
}
private function addToPrepareCheckRows(row:XML):void
{
	var length:int = dgPrapareCheckDtl.dataProvider.length 
	var applyAmt1:Number	= Number(numericFormatter.format(row.apply_amt.toString()));	
	var applyAmt2:Number;	

	
	if(length > 0)
	{
		for(var i:int = 0 ; i < length ; i++)
		{
			if(row.vendor_code.toString() == dgPrapareCheckDtl.dataProvider[i].vendor_code.toString())
			{
				applyAmt2	=	Number(numericFormatter.format(dgPrapareCheckDtl.dataProvider[i].apply_amt.toString()));	
				dgPrapareCheckDtl.dataProvider[i].apply_amt	=	numericFormatter.format(String(applyAmt1 + applyAmt2))
				
					
				
				return;
			}
		}
	}
	
	var temp:XML	=	dgPrapareCheckDtl.rows.copy();
	temp.appendChild(new XML(<vendor_payment_line>
													<id/>
													<vendor_code>{row.vendor_code.toString()}</vendor_code>
													<vendor_id>{row.vendor_id.toString()}</vendor_id>
													<vendor_name>{row.vendor_name.toString()}</vendor_name>
													<term_code>{row.term_code.toString()}</term_code>
													<due_date>{row.payment_due_date.toString()}</due_date>
													<apply_amt>{numericFormatter.format(String(applyAmt1))}</apply_amt>
							</vendor_payment_line>))
		
	dgPrapareCheckDtl.rows	=	temp;	
			
}
private function isTotalApplyAmtNegativeAfterAddingThis(row:XML):Boolean
{
	var length:int = dgPrapareCheckDtl.dataProvider.length 
	var applyAmt1:Number	= Number(numericFormatter.format(row.balance_amt.toString()));	
	var applyAmt2:Number;
	
	if(length > 0)
	{
		for(var i:int = 0 ; i < length ; i++)
		{
			if(row.vendor_code.toString() == dgPrapareCheckDtl.dataProvider[i].vendor_code.toString())
			{
				applyAmt2	=	Number(numericFormatter.format(dgPrapareCheckDtl.dataProvider[i].apply_amt.toString()));	
				if(applyAmt1 + applyAmt2 < 0)
				{
					return true 	
				}
				else
				{
					return false; 
				}
			}
		}
	}
	
	if(applyAmt1 < 0)
	{
	  return 	true;
	} 
	
	return false		

}
private function isTotalApplyAmtNegativeAfterRemovingThis(row:XML):Boolean
{
	var length:int = dgPrapareCheckDtl.dataProvider.length 
	var applyAmt1:Number	= Number(numericFormatter.format(row.balance_amt.toString()));	
	var applyAmt2:Number;
	
	if(length > 0)
	{
		for(var i:int = 0 ; i < length ; i++)
		{
			if(row.vendor_code.toString() == dgPrapareCheckDtl.dataProvider[i].vendor_code.toString())
			{
				applyAmt2	=	Number(numericFormatter.format(dgPrapareCheckDtl.dataProvider[i].apply_amt.toString()));	
				if(applyAmt2 - applyAmt1 < 0)
				{
					return true 	
				}
				else
				{
					return false; 
				}
			}
		}
	}
		
	return false		
}
private function removeFromPrepareCheckRows(existingRow:XML):void
{
	if(dgPrapareCheckDtl.dataProvider.length > 0 )
	{
		var temp:XML;
		var row:XML		=	XML(dgPrapareCheckDtl.rows.children().(vendor_code.toString() == existingRow.vendor_code.toString()))
		
		var applyAmt:Number 	= 	Number(numericFormatter.format(row.apply_amt.toString()));
		var balanceAmt:Number	= 	Number(numericFormatter.format(existingRow.balance_amt.toString()));
		
		if(applyAmt == balanceAmt) 
		{
			var index:int	=	row.childIndex();
			var node:String	=	row.localName()
		
			delete dgPrapareCheckDtl.rows.child(node)[index];
		
			//dgPrapareCheckDtl.reset();
			temp	=	dgPrapareCheckDtl.rows.copy();	
			dgPrapareCheckDtl.rows	=	temp;	
		}
		else
		{
			row.apply_amt			=	numericFormatter.format(String(applyAmt - balanceAmt ))
		}
		
		
	}	
}
//**********************************************************************************************
override protected function retrieveRecordEventHandler(event:AddEditEvent):void  //after save and prev,next,.....
{	
	vbOpenInvoices.enabled		=	true;
	vbPrepareCheck.enabled		=	true;
	
	tnDetail.selectedChild		=	vbOpenInvoices;
	
	filterdRows		=	dgVendorOpenInvoices.rows;
	
	resetTotal();
	openInvoicesBalanceCalculation();
	
	var callbacks:IResponder = new mx.rpc.Responder(defaultBankHandler, null);
	getInformationEvent = new GetInformationEvent('bank_check_info', callbacks, 'payment','CHCK');
	getInformationEvent.dispatch();  
	
}



//***********************************structure complete handler****************************************************************
private function openInvoicesStructureCompleteEventHandler():void
{
	structureCompleteHandler(dgVendorOpenInvoices.structure , hbFilterOpenInvoice , hbOpenInvoiceTotal);	
}
private function prepareCkeckStructureCompleteEventHandler():void
{
	//structureCompleteHandler(dgPrapareCheckDtl.structure , hbFilterPrepareCheck);	
}
private function structureCompleteHandler(structure:XML , hbFilter:HBox ,  hbTotal:HBox):void
{
	if(structure.children().length() > 0)
	{
		var tiSearch:GenTextInput;
		var space:Spacer;
		
		for(var i:int = 0 ; i < structure.children().length()	;	i++)
		{
			if( structure.children()[i].@visible.toString()	==	'true')
			{		
					tiSearch			=	new GenTextInput();
					tiSearch.name		=	structure.children()[i].@data.toString();
					tiSearch.dataType	=	structure.children()[i].@sortDataType.toString();
					
					
					/*when we focus out then text autometically set down to integer value because of code in GenTextInputScript 
					to resolve this problem we have done this*/
					if(structure.children()[i].@sortDataType.toString() == 'N')
					{
						var maxValue:String    =	'.' 
						if(structure.children()[i].@columnPrecision.toString()!= '' &&  Number(structure.children()[i].@columnPrecision.toString()) > 0)
						{
							for(var k:int = 0; k < Number(structure.children()[i].@columnPrecision.toString()) ; k++)
							{
								maxValue	=	maxValue + '9'  //we can take any integer value we have taken '9'
							}
							
							tiSearch.maxValue = Number(maxValue); //here maxValue is used just to set precesion value after focus out
						}
						else
						{
							tiSearch.maxValue = 1;
						}
					}
					
					
					//tiSearch.enabled	=	false;
					tiSearch.width		=	Number(structure.children()[i].@width.toString());
					tiSearch.height		=	20;
					tiSearch.setStyle('textAlign' , structure.children()[i].@textAlign);
					tiSearch.addEventListener(KeyboardEvent.KEY_UP,filterRows);
					
					hbFilter.addChild(tiSearch);	
					
					/*.................for total....................*/		
					if(structure.children()[i].@data.toString() == 'balance_amt' || structure.children()[i].@data.toString() == 'apply_amt')
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
		var arr:Array	=	hbFilter.getChildren();
		
		var lastChild:UIComponent	=	UIComponent( hbFilter.getChildAt(arr.length -1));
		lastChild.percentWidth		=	100;	 
		
		
		/*...................for total............................*/
		arr	=	hbTotal.getChildren();
		
		lastChild	=	UIComponent( hbTotal.getChildAt(arr.length -1));
		lastChild.percentWidth		=	100;	
	}
	
}
private function filterRows(event:Event):void
{
	var scrollPosition:Number	=	dgVendorOpenInvoices.horizontalScrollPosition;
	
	var searchedRows:XML = new XML('<'+ filterdRows.localName().toString()+ '/>')
	
	var tempList:XMLList	=	new XMLList();
	tempList				=	filterdRows.children();

	var arr:Array			=	hbFilterOpenInvoice.getChildren();
	var filerKey:String ;
	var filterValue:String; 

	for(var i:int=0 ; i< arr.length; i++)
	{
		if(GenTextInput(arr[i]).text != '')
		{
			filerKey		=	arr[i].name;
			filterValue		=	arr[i].text;
			
			if(GenTextInput(arr[i]).dataType == "D")
			{
				tempList 		= 	tempList.(dateFunc(String(child(filerKey))).substr(0,filterValue.length).toUpperCase()	==	filterValue.toUpperCase())	
			}
			else
			{
				tempList 		= 	tempList.(String(child(filerKey)).substr(0,filterValue.length).toUpperCase()	==	filterValue.toUpperCase())
			}
		}
	}
	if(tempList.children().length() > 0)
	{
		searchedRows.appendChild(tempList);
		dgVendorOpenInvoices.rows	=	searchedRows;
	}
	else
	{
		dgVendorOpenInvoices.rows	=	new XML('<'+ filterdRows.localName().toString()+ '/>')
		//dgVendorOpenInvoices.rows	=	filterdRows
	}
	
	dgVendorOpenInvoices.horizontalScrollPosition	=	scrollPosition
	
	scrollDataGrid(dgVendorOpenInvoices.horizontalScrollPosition,dgVendorOpenInvoices,hbFilterOpenInvoice)
}
private function dateFunc(item:String):String
{
	var dateFormatter:DateFormatter = new DateFormatter();
	var date_format:String = __genModel.user.date_format.toLocaleUpperCase();
		
	if(date_format == null || date_format == "")
	{
		dateFormatter.formatString = 'MM/DD/YYYY';
	}
	else
	{
		dateFormatter.formatString = date_format;
	}

	return dateFormatter.format(item.toString());
}

//**********************************open invoices***************************************************************

private function changeOpenInvoiceColumnSize(event:DataGridEvent):void
{
	changeColumnSizeHandler(event,dgVendorOpenInvoices, hbFilterOpenInvoice , hbOpenInvoiceTotal);
}

private function handleOpenInvoiceResize(event:Event):void
{
	handleResize(event,dgVendorOpenInvoices, hbFilterOpenInvoice , hbOpenInvoiceTotal);
}
private function onOpenInvoiceScroll(event:ScrollEvent):void 
{
	onScroll(event,dgVendorOpenInvoices, hbFilterOpenInvoice , hbOpenInvoiceTotal);
}

//**********************************Prepare check***************************************************************
private function changePrepareCheckColumnSize(event:DataGridEvent):void
{
	//changeColumnSizeHandler(event,dgPrapareCheckDtl.dgDtl , hbFilterPrepareCheck);
}

private function handlePrepareCheckResize(event:Event):void
{
	//handleResize(event,dgPrapareCheckDtl.dgDtl , hbFilterPrepareCheck);
}
private function onPrepareCheckScroll(event:ScrollEvent):void 
{
	//onScroll(event,dgPrapareCheckDtl.dgDtl , hbFilterPrepareCheck);
}
//*************************************************************************************************
private function changeColumnSizeHandler(event:DataGridEvent , dg:GenDataGrid, hbFilter:HBox , hbTotal:HBox):void
{	
	UIComponent(hbFilter.getChildByName(dg.columns[event.columnIndex].dataField.toString())).width	=	dg.columns[event.columnIndex].width;
	UIComponent(hbTotal.getChildByName(dg.columns[event.columnIndex].dataField.toString())).width	=	dg.columns[event.columnIndex].width;
}
private function handleResize(event:Event , dg:GenDataGrid , hbFilter:HBox , hbTotal:HBox):void
{
	scrollDataGrid(dg.horizontalScrollPosition , dg, hbFilter)
	scrollDataGrid(dg.horizontalScrollPosition , dg, hbTotal)
}

private function scrollDataGrid(invisibleColumns:int, dg:GenDataGrid , hbFilter:HBox):void 
{
 	var ary:Array = hbFilter.getChildren()
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
		var lastChild:UIComponent	=	UIComponent(hbFilter.getChildAt(ary.length -1));
		lastChild.percentWidth		=	100;	
	} 				
} 
private function onScroll(event:ScrollEvent, dg:GenDataGrid , hbFilter:HBox , hbTotal:HBox):void 
{
	 if(event.direction == ScrollEventDirection.HORIZONTAL)
	{
		var invisibleColumns:int = dg.horizontalScrollPosition
		scrollDataGrid(invisibleColumns ,dg ,hbFilter )
		scrollDataGrid(invisibleColumns ,dg ,hbTotal )
	} 
}

//*******************************total calculations******************************************************************
private function openInvoicesBalanceCalculation():void
{
	var totalBalanceAmt:Number = 0.00;
	
	for(var i:int = 0 ; i < dgVendorOpenInvoices.dataProvider.length ; i++)
	{
		/*.........to make all invoices mark as not selected initially...................... */
		if(dgVendorOpenInvoices.dataProvider[i].apply_flag.toString() == '')
		{
			dgVendorOpenInvoices.dataProvider[i].apply_flag = 'N'
		}
		/*total balance amt calculation*/
		if(String(Number(dgVendorOpenInvoices.dataProvider[i].balance_amt.toString())) == 'NaN' || dgVendorOpenInvoices.dataProvider[i].balance_amt.toString() == '')
		{
			dgVendorOpenInvoices.dataProvider[i].balance_amt = '0.00'
		}
		
		totalBalanceAmt	=	totalBalanceAmt + Number(dgVendorOpenInvoices.dataProvider[i].balance_amt.toString())
		
		/*to make apply amt as default value if not exist*/
		if(String(Number(dgVendorOpenInvoices.dataProvider[i].apply_amt.toString())) == 'NaN' || dgVendorOpenInvoices.dataProvider[i].apply_amt.toString() == '')
		{
			dgVendorOpenInvoices.dataProvider[i].apply_amt = '0.00'
		}
	}
	
	GenTextInput(hbOpenInvoiceTotal.getChildByName('balance_amt')).dataValue	=	numericFormatter.format(String(totalBalanceAmt))
}
private function resetTotal():void
{
	if(hbOpenInvoiceTotal.getChildren().length > 0)
	{
		GenTextInput(hbOpenInvoiceTotal.getChildByName('apply_amt')).dataValue		=	'0.00'
	}	
}
//*******************************total calculations end******************************************************************
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    