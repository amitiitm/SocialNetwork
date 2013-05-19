import business.delegates.InitializeDataEntryDelegate;
import business.events.ExportGridEvent;
import business.events.InitializeViewEvent;
import business.events.PopulateListEvent;
import business.events.PrintGridEvent;
import business.events.QueryEvent;
import business.events.SaveViewEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.customcomponents.GenTextInput;
import com.generic.events.GenDataGridEvent;
import com.generic.events.GenModuleEvent;
import com.generic.genclass.TabPage;
import com.generic.genclass.URL;
import com.generic.genclass.Utility;

import cust.customerinfo.CustomerInfoController;
import cust.customerinfo.CustomerInfoModelLocator;
import cust.customerinfo.CustomerInfoServices;
import cust.customerinfo.components.ReportCriteria;

import flash.events.Event;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.controls.Alert;
import mx.core.Application;
import mx.core.UIComponent;
import mx.events.DataGridEvent;
import mx.events.FlexEvent;
import mx.events.ScrollEvent;
import mx.events.ScrollEventDirection;
import mx.formatters.DateFormatter;
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
protected var __localModel:CustomerInfoModelLocator = new CustomerInfoModelLocator();

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

/* account report criteria  */
private var CustOpenReceiptCriteriaXML:XML
private var CustOpenCreditCriteriaXML:XML
private var CustAllReceiptCriteriaXML:XML
private var CustAllCreditCriteriaXML:XML
private var CustAgingCriteriaXML:XML
/* sales report criteria  */
private var OpenMemoCriteriaXML:XML
private var AllMemosListCriteriaXML:XML
private var InvoiceSummaryCriteriaXML:XML
private var InvoiceByItemCriteriaXML:XML
private var CreditInvoiceSummaryCriteriaXML:XML
private var CreditInvoiceByItemCriteriaXML:XML
private var OpenOrderCriteriaXML:XML
private var AllOrdersCriteriaXML:XML
private var TopSalesCriteriaXML:XML
/**/

public function handleCustomerInfoAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new CustomerInfoController();
	__genModel.services = new CustomerInfoServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID = __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission = __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission = __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission = __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission = 'Y' // Later we set thru column value
	
	 __localModel.listObj.listGrid = listCustomer;
		
	initializeCustomerInfo();
		
}
private function initializeCustomerInfo():void
{
	var callbacksListFormat:IResponder = new mx.rpc.Responder(customerListFormatResultHandler, faultHandler);
	var delegate:InitializeDataEntryDelegate = new InitializeDataEntryDelegate(callbacksListFormat);
	delegate.getListFormat();

	var initializeViewEvent:InitializeViewEvent	=	new InitializeViewEvent()
	initializeViewEvent.dispatch();
	
	getReportCriteiaXML();
	changeReportHandler();
}
private function customerListFormatResultHandler(event:ResultEvent):void
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

	/*acct report criteria*/
	CustOpenReceiptCriteriaXML			= __viewObj.criteria.copy();
	CustOpenCreditCriteriaXML			= __viewObj.criteria.copy();
	CustAllReceiptCriteriaXML			= __viewObj.criteria.copy();
	CustAllCreditCriteriaXML			= __viewObj.criteria.copy();
	CustAgingCriteriaXML				= __viewObj.criteria.copy();
	/* sales report criteria  */
	OpenMemoCriteriaXML					= __viewObj.criteria.copy();
	AllMemosListCriteriaXML				= __viewObj.criteria.copy();
	InvoiceSummaryCriteriaXML			= __viewObj.criteria.copy();
	InvoiceByItemCriteriaXML			= __viewObj.criteria.copy();
	CreditInvoiceSummaryCriteriaXML		= __viewObj.criteria.copy();
	CreditInvoiceByItemCriteriaXML		= __viewObj.criteria.copy();
	OpenOrderCriteriaXML				= __viewObj.criteria.copy();
	AllOrdersCriteriaXML				= __viewObj.criteria.copy();
	TopSalesCriteriaXML					= __viewObj.criteria.copy();
	
	initializeReportCriteria(CustOpenReceiptCriteriaXML);
	initializeReportCriteria(CustOpenCreditCriteriaXML);
	initializeReportCriteria(CustAllReceiptCriteriaXML);
	initializeReportCriteria(CustAllCreditCriteriaXML);
	initializeReportCriteria(CustAgingCriteriaXML);
	
	initializeReportCriteria(OpenMemoCriteriaXML);
	initializeReportCriteria(AllMemosListCriteriaXML);
	initializeReportCriteria(InvoiceSummaryCriteriaXML);
	initializeReportCriteria(InvoiceByItemCriteriaXML);
	initializeReportCriteria(CreditInvoiceSummaryCriteriaXML);
	initializeReportCriteria(CreditInvoiceByItemCriteriaXML);
	initializeReportCriteria(OpenOrderCriteriaXML);
	initializeReportCriteria(AllOrdersCriteriaXML);
	initializeReportCriteria(TopSalesCriteriaXML);
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

	//we have to set this date from customer view as the default value
	/* reportCriteriaXML.dt1			=	'01/01/1990';
	reportCriteriaXML.dt2			=	'12/12/2025'; */	
	reportCriteriaXML.str3			=	'';
	reportCriteriaXML.str4			=	'zzzz'; 	
}
/*****************************************************************************************************************/
private function customerViewChangeHandler(event:Event):void
{
	
	filteredReport	=	new XML();
	resetCustomerDetail();
	resetFilter()
	
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
private function btnCustomerQueryClickHandler():void
{
	queryEvent = new QueryEvent();
	queryEvent.dispatch();
}
private function listCustomerResultHandler(event:ResultEvent):void
{
	listCustomer.dataProvider	=	XML(event.result).children();

}
private function customerItemClickHandler(event:GenDataGridEvent):void
{
	showCustomer()//get customer detail
	populateList();//change view such that it has selected customer and call service to get data
	 
}
private function showCustomer():void
{
	var __locator:ServiceLocator = GenModelLocator.getInstance().services;
	var __showCustomerService:HTTPService;
	
	var callbackShowCustomer:IResponder 		= 	new mx.rpc.Responder(showCustomerResultHandler, faultHandler);
    
  	var params:XML = new XML(<params></params>)
    var str:String = "<id>" + listCustomer.selectedItem.customer_id.toString() + "</id>"
	params.appendChild((XML)(str));
									
	__showCustomerService = __locator.getHTTPService("showCustomer");
	
	dataService(__showCustomerService);
	
	var token:AsyncToken = __showCustomerService.send(params);
	token.addResponder(callbackShowCustomer);	 
}
private function showCustomerResultHandler(event:ResultEvent):void
{
	var utilityObj:Utility	=	new Utility();
	var customerDetail:XML	= 	utilityObj.getDecodedXML((XML)(event.result));
	
	if(customerDetail.children().length() > 0)
	{
		setCustomerDetail(customerDetail)	
	}
	else
	{
		resetCustomerDetail();
	}		
}
private function setCustomerDetail(customerDetail:XML):void
{
	lblCustomerName.text		=	customerDetail.children().child('name').toString();
	lblCustometType.text		=	customerDetail.children().child('type1').toString();
	lblCompanyName.text			=	customerDetail.children().child('company_id').toString();
	lblContat.text				=	customerDetail.children().child('contact1').toString();
	lblPhone.text				=	customerDetail.children().child('phone1').toString();
	lblFax.text					=	customerDetail.children().child('fax1').toString();
	lblAltPhone.text				=	customerDetail.children().child('phone2').toString();
	lblEmail.text				=	customerDetail.children().child('email').toString();
	lblTerms.text				=	customerDetail.children().child('invoice_term_code').toString();
	lblPriceLevel.text			=	customerDetail.children().child('price_level').toString();
	
	
	
	var address:String	=	'';
	
	if(customerDetail.children()[0].child('address1').toString() != '')
	{
		address			=	customerDetail.children()[0].child('address1').toString() + "\n";
	}
	if(customerDetail.children()[0].child('address2').toString() != '');
	{
		address			=	address + customerDetail.children()[0].child('address2').toString() + '\n';
	}
	if(customerDetail.children()[0].child('city').toString() != '')
	{
		address			=	address + customerDetail.children()[0].child('city').toString();
	}
	if(customerDetail.children()[0].child('state').toString() != '')
	{
		address			=	address + ', '  + customerDetail.children()[0].child('state').toString();
	}
	if(customerDetail.children()[0].child('zip').toString() != '')
	{
		address			=	address + ', ' + customerDetail.children()[0].child('zip').toString();
	}

	taBillAddress.text	=	address;
}
private function resetCustomerDetail():void
{
	lblCustomerName.text		=	''  ;
	lblCustometType.text		=	''	;
	lblCompanyName.text			=	''	;
	lblContat.text				=	''	;
	lblPhone.text				=	''	;
	lblFax.text					=	''	;
	lblAltPhone.text			=	''	;
	lblEmail.text				=	''	;
	lblTerms.text				=	''	;
	lblPriceLevel.text			=	''  ;
	taBillAddress.text			=	''  ;
		
}
private function dgCustomerUpdateCompleteHandler():void
{
	if(cbCustomerView.dataProvider.length > 0)
	{
		updateReportCriteria(CustOpenReceiptCriteriaXML);
		updateReportCriteria(CustOpenCreditCriteriaXML);
		updateReportCriteria(CustAllReceiptCriteriaXML);
		updateReportCriteria(CustAllCreditCriteriaXML);
		updateReportCriteria(CustAgingCriteriaXML);
	
		updateReportCriteria(OpenMemoCriteriaXML);
		updateReportCriteria(AllMemosListCriteriaXML);
		updateReportCriteria(InvoiceSummaryCriteriaXML);
		updateReportCriteria(InvoiceByItemCriteriaXML);
		updateReportCriteria(CreditInvoiceSummaryCriteriaXML);
		updateReportCriteria(CreditInvoiceByItemCriteriaXML);
		updateReportCriteria(OpenOrderCriteriaXML);
		updateReportCriteria(AllOrdersCriteriaXML);
		updateReportCriteria(TopSalesCriteriaXML);
	}	
}
private function updateReportCriteria(reportCriteriaXML:XML):void
{
	reportCriteriaXML.dt1			=	cbCustomerView.selectedItem.dt1.toString();
	reportCriteriaXML.dt2			=	cbCustomerView.selectedItem.dt2.toString();
	reportCriteriaXML.all1			=	'N'
}
private function changeReportHandler():void
{
	filteredReport	=	new XML();
	resetFilter();
	getLayouts();
	
	if(cmbReports.selectedItem.code	==	"CUSTAGING")
	{
		btnQuery.visible	=	false;
	}
	else
	{
		btnQuery.visible	=	true;
	}
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
	structureCompleteHandler(reportFormat,hbFilter);
	
	if(listCustomer.selectedItem != null && XMLList(listCustomer.selectedItem) != XMLList(undefined))
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
			
	reportCriteriaXML.str1	= listCustomer.selectedItem.customer_id.toString();
	reportCriteriaXML.str2	= listCustomer.selectedItem.customer_id.toString();
	
	
	var token:AsyncToken = __populateListService.send(reportCriteriaXML);
	token.addResponder(callbacksPopulateList); 
}

private function populateListResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled	= true;

	var utilityObj:Utility	=	new Utility();
	filteredReport 			= 	utilityObj.getDecodedXML((XML)(event.result));
	resetFilter();
	//filteredReport = new XML((XML)(event.result));
}
public function btnQueryReportClickHandler():void
{
	if(listCustomer.selectedItem != null && XMLList(listCustomer.selectedItem) != XMLList(undefined))
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
		Alert.show('Please Select customer.');
	}
}
private function getReportCriteriaFormatResultHandler(event:ResultEvent):void
{
	var viewFormat:XML	=	XML(event.result);
	var reportCriteriaObj:ReportCriteria = ReportCriteria(PopUpManager.createPopUp(this, ReportCriteria, true));
	reportCriteriaObj.initializeView(viewFormat,getReportCriteriaXMLByReportCode(),listCustomer.selectedItem.customer_id.toString(),cmbReports.selectedItem.listService.toString());
   //reportCriteriaObj.targetObj		=	dgReport;
   reportCriteriaObj.parentObj		=	this;
}
	
private function itemClickCustomReportHandler(event:GenDataGridEvent):void
{
	
}
private function itemDoubleClickCustomReportHandler(event:GenDataGridEvent):void
{
	
}
private function structureCompleteEventHandler(event:GenDataGridEvent):void
{
	if(cmbReports.selectedItem.code == 'CUSTAGING')
	{
		var bracket1_header_from :String 	= __genModel.masterData.child('aging_customer').bracket_1_from.value.toString()
		var bracket1_header_to :String 		= __genModel.masterData.child('aging_customer').bracket_1_to.value.toString()
				
		var bracket2_header_from :String 	= __genModel.masterData.child('aging_customer').bracket_2_from.value.toString()
		var bracket2_header_to :String 		= __genModel.masterData.child('aging_customer').bracket_2_to.value.toString()
	
		var bracket3_header_from :String 	= __genModel.masterData.child('aging_customer').bracket_3_from.value.toString()
		var bracket3_header_to :String 		= __genModel.masterData.child('aging_customer').bracket_3_to.value.toString()
	
		var bracket4_header_from :String 	= __genModel.masterData.child('aging_customer').bracket_4_from.value.toString()
		var bracket4_header_to :String 		= __genModel.masterData.child('aging_customer').bracket_4_to.value.toString()
		
		var bracket5_header_from :String 	= __genModel.masterData.child('aging_customer').bracket_5_from.value.toString()
		var bracket5_header_to :String 		= __genModel.masterData.child('aging_customer').bracket_5_to.value.toString()
	
		var bracket6_header_from :String 	= __genModel.masterData.child('aging_customer').bracket_6_from.value.toString()
		var bracket6_header_to :String 		= __genModel.masterData.child('aging_customer').bracket_6_to.value.toString()
	
		var bracket7_header_from :String 	= __genModel.masterData.child('aging_customer').bracket_7_from.value.toString()
		
	
		var bracket1_range:String;
		if(bracket1_header_to.toString() == '' ||  bracket1_header_to.toString() == null)
		{
			bracket1_range	=	'[1-30]'
		}
		else
		{
			bracket1_range	=	'[' +  bracket1_header_from.toString() + '-' + bracket1_header_to.toString()  + ']'
		}	
	
	
		var bracket2_range:String;
		if(bracket2_header_to.toString() == '' ||  bracket2_header_to.toString() == null)
		{
			bracket2_range	=	'[31-60]'
		}
		else
		{
			bracket2_range	=	'[' +  bracket2_header_from.toString() + '-' + bracket2_header_to.toString()  + ']'
		}	
	
	
		var bracket3_range:String;
		if(bracket3_header_to.toString() == '' ||  bracket3_header_to.toString() == null)
		{
			bracket3_range	=	'[61-90]'
		}
		else
		{
			bracket3_range	=	'[' +  bracket3_header_from.toString() + '-' + bracket3_header_to.toString()  + ']'
		}	
	
		var bracket4_range:String;
		if(bracket4_header_to.toString() == '' ||  bracket4_header_to.toString() == null)
		{
			bracket4_range	=	'[91-120]'
		}
		else
		{
			bracket4_range	=	'[' +  bracket4_header_from.toString() + '-' + bracket4_header_to.toString()  + ']'
		}	
	
		var bracket5_range:String;
		if(bracket5_header_to.toString() == '' ||  bracket5_header_to.toString() == null)
		{
			bracket5_range	=	'[121-150]'
		}
		else
		{
			bracket5_range	=	'[' +  bracket5_header_from.toString() + '-' + bracket5_header_to.toString()  + ']'
		}	
	
		var bracket6_range:String;
		if(bracket6_header_to.toString() == '' ||  bracket6_header_to.toString() == null)
		{
			bracket6_range	=	'[151-180]'
		}
		else
		{
			bracket6_range	=	'[' +  bracket6_header_from.toString() + '-' + bracket6_header_to.toString()  + ']'
		}	
	
		var bracket7_range:String;
		if(bracket7_header_from.toString() == '' ||  bracket7_header_from.toString() == null)
		{
			bracket7_range	=	'[181+]'
		}
		else
		{
			bracket7_range	=	'[' +  bracket7_header_from.toString() + '+]'
		}	
	
		var columns:Array					=	dgReport.cols
		var columnCount:int					=	dgReport.cols.length;
		
		for(var i:int =0 ; i < columnCount ; i++)
		{
			if(columns[i].dataField.toString() == 'group1_amt')
			{
				columns[i].headerText	=	bracket1_range;
			}
			else if(columns[i].dataField.toString() == 'group2_amt')
			{
				columns[i].headerText	=	bracket2_range;
			}
			else if(columns[i].dataField.toString() == 'group3_amt')
			{
				columns[i].headerText	=	bracket3_range;
			}
			else if(columns[i].dataField.toString() == 'group4_amt')
			{
				columns[i].headerText	=	bracket4_range;
			}
			else if(columns[i].dataField.toString() == 'group5_amt')
			{
				columns[i].headerText	=	bracket5_range	;
			}
			else if(columns[i].dataField.toString() == 'group6_amt')
			{
				columns[i].headerText	=	bracket6_range;
			}
			else if(columns[i].dataField.toString() == 'group7_amt')
			{
				columns[i].headerText	=	bracket7_range;
			}
		}	

	}
}
private function btnEditCustomerClickHandler():void
{
	if(listCustomer.selectedItem == null ||  XMLList(listCustomer.selectedItem) == XMLList(undefined))
	{
		return;
	}
	var customerXML:XML	=	new XML(<customer><customer_code>{listCustomer.selectedItem.customer_code.toString()}</customer_code></customer>)
	__genModel.drillObj.drillrow		=	customerXML;
	var tabpage:TabPage	=	new TabPage();
	tabpage.openDrillDownPage('cust/wholesalecustomer/components/WholeSaleCustomerMaster.swf');	
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
		/*acct*/
		case  'CUSTOPENRCPT' : 
					tempXML		=	CustOpenReceiptCriteriaXML
				break
		case  'CUSTOPENCRD' : 
					tempXML		=	CustOpenCreditCriteriaXML
				break
		case  'CUSTALLRCPT' : 
					tempXML		=	CustAllReceiptCriteriaXML
				break						
		case  'CUSTALLCRD' : 
					tempXML		=	CustAllCreditCriteriaXML
				break						
		case  'CUSTAGING' : 
					tempXML		=	CustAgingCriteriaXML
				break						
		
		
		/*sales*/
		case  'SLOPNMEMO' : 
					tempXML		=	OpenMemoCriteriaXML
				break						
		case  'SLALLMEMO' : 
					tempXML		=	AllMemosListCriteriaXML
				break						
		case  'SLINVSUMM' : 
					tempXML		=	InvoiceSummaryCriteriaXML
				break						
		case  'SLINVBYITEM' : 
					tempXML		=	InvoiceByItemCriteriaXML
				break						
		case  'SLCRDTINVSUMM' : 
					tempXML		=	CreditInvoiceSummaryCriteriaXML
				break						
		case  'SLCRDINVBYITEM' : 
					tempXML		=	CreditInvoiceByItemCriteriaXML
				break						
		case  'SLOPENORDER' : 
					tempXML		=	OpenOrderCriteriaXML
				break						
		case  'SLALLORDER' : 
					tempXML		=	AllOrdersCriteriaXML
				break						
		case  'SLTOPSL' : 
					tempXML		=	TopSalesCriteriaXML
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
	else
	{
		// we have RPT file for this and we have to call service to print using RPT file
		
		if(listCustomer.selectedItem == null ||  XMLList(listCustomer.selectedItem) == XMLList(undefined))
		{
			return;
		}	
		CursorManager.setBusyCursor();
		Application.application.enabled	= false;
		var __locator:ServiceLocator = GenModelLocator.getInstance().services;
		var __service:HTTPService;
		
		var callbackPrint:IResponder 		= 	new mx.rpc.Responder(printResultHandler, faultHandler);
	    var _xml:XML
	  	
	  		switch(cmbReports.selectedItem.code)
			{
		
				case  'SLTOPSL' : 
								 		_xml = new XML(	<params>
																<customer_category_code>{listCustomer.selectedItem.customer_category_code.toString()}</customer_category_code>
																<from_customer_code>{listCustomer.selectedItem.customer_code.toString()}</from_customer_code>
																<to_customer_code>{listCustomer.selectedItem.customer_code.toString()}</to_customer_code>
																<from_date>{TopSalesCriteriaXML.dt1.toString()}</from_date>
																<to_date>{TopSalesCriteriaXML.dt2.toString()}</to_date>
																<from_accountperiod>{TopSalesCriteriaXML.str3.toString()}</from_accountperiod>
																<to_accountperiod>{TopSalesCriteriaXML.str4.toString()}</to_accountperiod>
																<in_accountperiod>{TopSalesCriteriaXML.multiselect1.toString()}</in_accountperiod>
																<company_id>{__genModel.user.default_company_id}</company_id>
														</params>);
										__service = __locator.getHTTPService("printTopSaleRecord");				
						break
			}		
		
		dataService(__service);
		
		var token:AsyncToken = __service.send(_xml);
		token.addResponder(callbackPrint);	 
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
/***************************Filter***********************************************************/
private function structureCompleteHandler(structure:XML , hbFilter:HBox):void
{
	hbFilter.removeAllChildren();
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
					
			}
		}		
		var arr:Array	=	hbFilter.getChildren();
		
		var lastChild:UIComponent	=	UIComponent( hbFilter.getChildAt(arr.length -1));
		lastChild.percentWidth		=	100;	 
	}	
}
private function filterRows(event:Event):void
{
	var scrollPosition:Number	=	dgReport.horizontalScrollPosition;
	
	var searchedRows:XML = new XML('<'+ filteredReport.localName().toString()+ '/>')
	
	var tempList:XMLList	=	new XMLList();
	tempList				=	filteredReport.children();

	var arr:Array			=	hbFilter.getChildren();
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
		dgReport.rows	=	searchedRows;
	}
	else
	{
		dgReport.rows	=	new XML('<'+ filteredReport.localName().toString()+ '/>')
		//dgReport.rows	=	filteredReport
	}
	
	dgReport.horizontalScrollPosition	=	scrollPosition
	
	scrollDataGrid(dgReport.horizontalScrollPosition,dgReport,hbFilter)
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
//*************************************************************************************************
private function onChangeColumnSize(event:DataGridEvent):void
{
	changeColumnSizeHandler(event,dgReport, hbFilter);
}

private function onHandleResize(event:Event):void
{
	handleResize(event,dgReport, hbFilter);
}
private function onScrollHandler(event:ScrollEvent):void 
{
	onScroll(event,dgReport, hbFilter);
}
//*************************************************************************************************
private function changeColumnSizeHandler(event:DataGridEvent , dg:GenDataGrid, hbFilter:HBox):void
{	
	UIComponent(hbFilter.getChildByName(dg.columns[event.columnIndex].dataField.toString())).width	=	dg.columns[event.columnIndex].width;	
}
private function handleResize(event:Event , dg:GenDataGrid , hbFilter:HBox):void
{
	scrollDataGrid(dg.horizontalScrollPosition , dg, hbFilter);
}
private function onScroll(event:ScrollEvent, dg:GenDataGrid , hbFilter:HBox):void 
{
	 if(event.direction == ScrollEventDirection.HORIZONTAL)
	{
		var invisibleColumns:int = dg.horizontalScrollPosition
		scrollDataGrid(invisibleColumns ,dg ,hbFilter )
	} 
}
//*************************************************************************************************
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
//used in ReportCriteria also i.e why public
public function resetFilter():void
{
	var ary:Array = hbFilter.getChildren()
	
	if(ary.length > 0)
	{
		for(var i:int = 0 ; i < ary.length ; i++)
		{
			GenTextInput(ary[i]).text	=	'';	
		}
	} 		
}
