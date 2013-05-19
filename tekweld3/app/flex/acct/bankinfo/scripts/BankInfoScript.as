import business.delegates.InitializeDataEntryDelegate;
import business.events.ExportGridEvent;
import business.events.InitializeViewEvent;
import business.events.PopulateListEvent;
import business.events.PrintGridEvent;
import business.events.QueryEvent;
import business.events.SaveViewEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.events.GenDataGridEvent;
import com.generic.events.GenModuleEvent;
import com.generic.genclass.TabPage;
import com.generic.genclass.URL;
import com.generic.genclass.Utility;

import acct.bankinfo.BankInfoController;
import acct.bankinfo.BankInfoModelLocator;
import acct.bankinfo.BankInfoServices;
import acct.bankinfo.components.ReportCriteria;

import flash.media.Video;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Application;
import mx.events.FlexEvent;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import valueObjects.ViewVO;


[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
protected var __localModel:BankInfoModelLocator = new BankInfoModelLocator();

private var queryEvent:QueryEvent;	

/*for all reports*/

[Bindable]
public var filteredReport:XML;

[Bindable]
public var reportFormat:XML;

[Bindable]
public var changeInLayout:XML;

[Bindable]
public var sortableColumns:Boolean	=	true;

/*..................................................*/

[Bindable]
private var isShow:Boolean = true;

/* report criteria  */
private var BankReceiptCriteriaXML:XML
private var BankPaymentCriteriaXML:XML
private var BankAllTransactionCriteriaXML:XML
private var BankTransferCriteriaXML:XML
private var BankDateSummaryCriteriaXML:XML

public function handleBankInfoAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new BankInfoController();
	__genModel.services = new BankInfoServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value
	
	 __localModel.listObj.listGrid = listBank;
		
	initializeBankInfo();
		
}
private function initializeBankInfo():void
{
	var callbacksListFormat:IResponder = new mx.rpc.Responder(bankListFormatResultHandler, faultHandler);
	var delegate:InitializeDataEntryDelegate = new InitializeDataEntryDelegate(callbacksListFormat);
	delegate.getListFormat();

	var initializeViewEvent:InitializeViewEvent	=	new InitializeViewEvent()
	initializeViewEvent.dispatch();
	
	getReportCriteiaXML();
	changeReportHandler();
}
private function bankListFormatResultHandler(event:ResultEvent):void
{
	var listFormat:XML;
	listFormat = (XML)(event.result);
	
	__genModel.activeModelLocator.listObj.listFormat = listFormat;
	
	var xml:XML
	var __viewObj:ViewVO	=	new ViewVO();
	xml  = __viewObj.criteria	
	xml[0]["user_id"] = __genModel.user.userID;
	xml[0]["document_id"] = __genModel.activeModelLocator.documentObj.documentID;
	xml[0]["company_id"] = __genModel.user.default_company_id.toString(); // VD 20 May 2010.
	
	var populateListEvent:PopulateListEvent = new PopulateListEvent(xml); // 0 is for default view
	populateListEvent.dispatch();		
}
private function getReportCriteiaXML():void
{
	var __viewObj:ViewVO				=	new ViewVO();

	BankReceiptCriteriaXML			= __viewObj.criteria.copy();
	BankPaymentCriteriaXML			= __viewObj.criteria.copy();
	BankAllTransactionCriteriaXML	= __viewObj.criteria.copy();
	BankTransferCriteriaXML			= __viewObj.criteria.copy();
	BankDateSummaryCriteriaXML		= __viewObj.criteria.copy();
	
	initializeReportCriteria(BankReceiptCriteriaXML);
	initializeReportCriteria(BankPaymentCriteriaXML);
	initializeReportCriteria(BankAllTransactionCriteriaXML);
	initializeReportCriteria(BankTransferCriteriaXML);
	initializeReportCriteria(BankDateSummaryCriteriaXML);
	
}
private function initializeReportCriteria(reportCriteriaXML:XML):void
{
	reportCriteriaXML.default_yn = "N";
	reportCriteriaXML.company_id = __genModel.user.default_company_id;
	reportCriteriaXML.user_id = __genModel.user.userID;
	reportCriteriaXML.trans_flag = "A";
	reportCriteriaXML.criteria_type = "U";
	reportCriteriaXML.name = "New Criteria";
	reportCriteriaXML.default_request = "N";

	//we have to set this date from bank view as the default value
	/* reportCriteriaXML.dt1			=	'01/01/1990';
	reportCriteriaXML.dt2			=	'12/12/2025'; */	
	reportCriteriaXML.str3			=	'';
	reportCriteriaXML.str4			=	'zzzz'; 	
}
/*****************************************************************************************************************/
private function bankViewChangeHandler(event:Event):void
{
	
	filteredReport	=	new XML();
	resetBankDetail();
	
	if(XML((event.target).selectedItem).criteria_type.toString() != 'T')
	{
	 	__genModel.activeModelLocator.viewObj.selectedView = XML((event.target).selectedItem);
		__genModel.activeModelLocator.viewObj.selectedView[0]["default_yn"] = "Y"
		__genModel.activeModelLocator.viewObj.selectedView[0]["company_id"] = __genModel.user.default_company_id.toString(); // VD 04 Jul 2010.
	
		var saveViewEvent:SaveViewEvent = new SaveViewEvent(__genModel.activeModelLocator.viewObj.selectedView);
		saveViewEvent.dispatch();
	
		var populateListEvent:PopulateListEvent = new PopulateListEvent(__genModel.activeModelLocator.viewObj.selectedView);
		populateListEvent.dispatch();		
	}	
}
private function btnBankQueryClickHandler():void
{
	queryEvent = new QueryEvent();
	queryEvent.dispatch();
}
/* private function listBankResultHandler(event:ResultEvent):void
{
	listBank.dataProvider	=	XML(event.result).children();

} */
private function bankItemClickHandler(event:GenDataGridEvent):void
{
	showBank()//get bank detail
	populateList();//change view such that it has selected bank and call service to get data
	 
}
private function showBank():void
{
	var __locator:ServiceLocator = GenModelLocator.getInstance().services;
	var __showbankService:HTTPService;
	
	var callbackShowBank:IResponder 		= 	new mx.rpc.Responder(showBankResultHandler, faultHandler);
    
  	var params:XML = new XML(<params></params>)
    var str:String = "<id>" + listBank.selectedItem.id.toString() + "</id>"
	params.appendChild((XML)(str));
									
	__showbankService = __locator.getHTTPService("showBank");
	
	dataService(__showbankService);
	
	var token:AsyncToken = __showbankService.send(params);
	token.addResponder(callbackShowBank);	 
}
private function showBankResultHandler(event:ResultEvent):void
{
	var utilityObj:Utility	=	new Utility();
	var bankDetail:XML	= 	utilityObj.getDecodedXML((XML)(event.result));
	
	if(bankDetail.children().length() > 0)
	{
		setBankDetail(bankDetail)	
	}
	else
	{
		resetBankDetail();
	}		
}
private function setBankDetail(bankDetail:XML):void
{
	lblBankName.text		=	bankDetail.children().child('name').toString();
	lblAccountCode.text		=	bankDetail.children().child('bank_acct_no').toString();
	lblTransitCode.text		=	bankDetail.children().child('transit_no').toString();
	lblContat.text			=	bankDetail.children().child('contact_nm').toString();
	lblGLCategoryCode.text	=	bankDetail.children().child('gl_category_code').toString();
	lblCreditLimit.text		=	bankDetail.children().child('credit_limit').toString();
	lblAccountType.text		=	bankDetail.children().child('account_type').toString();
	lblBalanceType.text		=	bankDetail.children().child('balance_type').toString();
	lblPaymentType.text		=	bankDetail.children().child('payment_type').toString();
	lblCurrentBalance.text	=	bankDetail.children().child('current_balance').toString();
	
	
	
	var address:String	=	'';
	
	if(bankDetail.children()[0].child('address1').toString() != '')
	{
		address			=	bankDetail.children()[0].child('address1').toString() + "\n";
	}
	if(bankDetail.children()[0].child('address2').toString() != '');
	{
		address			=	address + bankDetail.children()[0].child('address2').toString() + '\n';
	}
	if(bankDetail.children()[0].child('city').toString() != '')
	{
		address			=	address + bankDetail.children()[0].child('city').toString();
	}
	if(bankDetail.children()[0].child('state').toString() != '')
	{
		address			=	address + ', '  + bankDetail.children()[0].child('state').toString();
	}
	if(bankDetail.children()[0].child('zip').toString() != '')
	{
		address			=	address + ', ' + bankDetail.children()[0].child('zip').toString();
	}
	if(bankDetail.children()[0].child('country').toString() != '')
	{
		address			=	address + ', ' + bankDetail.children()[0].child('country').toString();
	}

	taAddress.text	=	address;
}
private function resetBankDetail():void
{
	lblBankName.text		=	''  ;
	lblAccountCode.text		=	''	;
	lblTransitCode.text		=	''	;
	lblContat.text			=	''	;
	lblGLCategoryCode.text	=	''	;
	lblCreditLimit.text		=	''	;
	lblAccountType.text		=	''	;
	lblBalanceType.text		=	''	;
	lblPaymentType.text		=	''	;
	lblCurrentBalance.text	=	''  ;
	taAddress.text			=	''  ;
		
}
private function dgBankUpdateCompleteHandler():void
{
	if(cbBankView.dataProvider.length > 0)
	{
		updateReportCriteria(BankReceiptCriteriaXML);
		updateReportCriteria(BankPaymentCriteriaXML);
		updateReportCriteria(BankAllTransactionCriteriaXML);
		updateReportCriteria(BankTransferCriteriaXML);
		updateReportCriteria(BankDateSummaryCriteriaXML);
	}	
}
private function updateReportCriteria(reportCriteriaXML:XML):void
{
	reportCriteriaXML.dt1			=	cbBankView.selectedItem.dt1.toString();
	reportCriteriaXML.dt2			=	cbBankView.selectedItem.dt2.toString();
	reportCriteriaXML.all1			=	'N'
}
private function changeReportHandler():void
{
	filteredReport	=	new XML();
	
	getLayouts();
	
/* 	if(cmbReports.selectedItem.code	==	"CUSTAGING")
	{
		btnQuery.visible	=	false;
	}
	else
	{ */
		btnQuery.visible	=	true;
	//}
}
private function getLayouts():void
{
	var __locator:ServiceLocator = GenModelLocator.getInstance().services;
	var __getLayoutService:HTTPService;
	
	var callbacksLayout:IResponder 		= 	new mx.rpc.Responder(layoutResultHandler, faultHandler);
    
	__getLayoutService = __locator.getHTTPService(cmbReports.selectedItem.formatService.toString());
	
	formatService(__getLayoutService);
	
	var token:AsyncToken = __getLayoutService.send();
	token.addResponder(callbacksLayout);	
} 
private function layoutResultHandler(event:ResultEvent):void
{
	reportFormat				=	(XML)(event.result);
	if(listBank.selectedItem != null && XMLList(listBank.selectedItem) != XMLList(undefined))
	{
		populateList();
	} 
}			
private function faultHandler(event:FaultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled	=	true;
	Alert.show(event.fault.toString());
}
private  function populateList():void
{
	CursorManager.setBusyCursor();
	Application.application.enabled	= false;
	
	var __populateListService:HTTPService;
	var callbacksPopulateList:IResponder = new mx.rpc.Responder(populateListResultHandler, faultHandler);
	var __locator:ServiceLocator = __genModel.services;
	__populateListService = __locator.getHTTPService(cmbReports.selectedItem.listService.toString());
	
	dataService(__populateListService);
			
	var reportCriteriaXML:XML		=	getReportCriteriaXMLByReportCode();		
			
	reportCriteriaXML.str1	= listBank.selectedItem.id.toString();
	reportCriteriaXML.str2	= listBank.selectedItem.id.toString();
	
	var token:AsyncToken = __populateListService.send(reportCriteriaXML);
	token.addResponder(callbacksPopulateList); 
}

private function populateListResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled	= true;

	var utilityObj:Utility	=	new Utility();
	filteredReport 			= 	utilityObj.getDecodedXML((XML)(event.result));
	
	//filteredReport = new XML((XML)(event.result));
}
public function btnQueryReportClickHandler():void
{
	if(listBank.selectedItem != null && XMLList(listBank.selectedItem) != XMLList(undefined))
	{
		CursorManager.setBusyCursor();
		Application.application.enabled	=	false;
		
		var __criteriaFormatService:HTTPService;
		var callbacksCriteriaFormat:IResponder = new mx.rpc.Responder(getReportCriteriaFormatResultHandler, faultHandler);
		var __locator:ServiceLocator = __genModel.services;
		__criteriaFormatService = __locator.getHTTPService(cmbReports.selectedItem.criteriaFormatService.toString());
		
		formatService(__criteriaFormatService);
				
		var token:AsyncToken = __criteriaFormatService.send();
		token.addResponder(callbacksCriteriaFormat); 
		
	}
	else
	{
		Alert.show('Please Select Bank.');
	}
}
private function getReportCriteriaFormatResultHandler(event:ResultEvent):void
{
	var viewFormat:XML	=	XML(event.result);
	var reportCriteriaObj:ReportCriteria = ReportCriteria(PopUpManager.createPopUp(this, ReportCriteria, true));
	reportCriteriaObj.initializeView(viewFormat,getReportCriteriaXMLByReportCode(),listBank.selectedItem.id.toString(),cmbReports.selectedItem.listService.toString());
   reportCriteriaObj.targetObj	=	dgReport;
}
	
private function itemClickCustomReportHandler(event:GenDataGridEvent):void{}

private function itemDoubleClickCustomReportHandler(event:GenDataGridEvent):void{}

private function btnEditBankClickHandler():void
{
	if(listBank.selectedItem == null ||  XMLList(listBank.selectedItem) == XMLList(undefined))
	{
		return;
	}
	var bankXML:XML	=	new XML(<bank><code>{listBank.selectedItem.code.toString()}</code></bank>)
	__genModel.drillObj.drillrow		=	bankXML;
	var tabpage:TabPage	=	new TabPage();
	tabpage.openDrillDownPage('acct/bank/components/Bank.swf');	
}

private function formatService(service:HTTPService):HTTPService
{
	service.resultFormat = "e4x";
	service.method = "POST";
	service.useProxy = false;
	
	return service;
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
private function getReportCriteriaXMLByReportCode():XML
{
	var tempXML:XML;
	switch(cmbReports.selectedItem.code)
	{
		case  'BANKBALANCE' : 
					tempXML		=	BankDateSummaryCriteriaXML
				break
		case  'BANKTRANSACTION' : 
					tempXML		=	BankAllTransactionCriteriaXML
				break
		case  'BANKRECEIPT' : 
					tempXML		=	BankReceiptCriteriaXML
				break						
		case  'BANKTRANSFER' : 
					tempXML		=	BankTransferCriteriaXML
				break						
		case  'BANKPAYMENT' : 
					tempXML		=	BankPaymentCriteriaXML
				break						
		default			:	
					Alert.show('Report Code Doesnot Exist.');	
					tempXML		=	new XML(<rows/>)						

	}
	
	return tempXML;
	
}
private function exportGridEventHandler():void
{
	var exportGridEvent:ExportGridEvent = new ExportGridEvent(dgReport,cmbReports.selectedItem.name.toString());
	exportGridEvent.dispatch();
}
public function btnPrintClickHandler():void
{
	if(cmbReports.selectedItem.printType.toString() == "LIST")
	{
		var printGridEvent:PrintGridEvent = new PrintGridEvent(dgReport,cmbReports.selectedItem.name.toString());
		printGridEvent.dispatch();		
	}
}
private function printResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	var url:String = __genModel.path.report_print  + XML(event.result)["result"].toString()
	var request:URLRequest = new URLRequest(url);

	navigateToURL(request);
}