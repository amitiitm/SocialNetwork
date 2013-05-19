import acct.glinfo.GLInfoController;
import acct.glinfo.GLInfoModelLocator;
import acct.glinfo.GLInfoServices;

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
protected var __localModel:GLInfoModelLocator = new GLInfoModelLocator();

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
private var GLAllTransactionCriteriaXML:XML
private var GLPeriodSummaryCriteriaXML:XML
private var GLDateSummaryCriteriaXML:XML

public function handleGLInfoAcitve(event:GenModuleEvent):void
{
	__genModel.controller = new GLInfoController();
	__genModel.services = new GLInfoServices();
	__genModel.activeModelLocator = __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
    __localModel.documentObj.documentID 		= __genModel.applicationObject.selectedMenuItem.@document_id
    __localModel.documentObj.create_permission	= __genModel.applicationObject.selectedMenuItem.@create_permission
    __localModel.documentObj.modify_permission 	= __genModel.applicationObject.selectedMenuItem.@modify_permission
    __localModel.documentObj.view_permission	= __genModel.applicationObject.selectedMenuItem.@view_permission
    __localModel.documentObj.upload_permission 	= 'Y' // Later we set thru column value
	
	 __localModel.listObj.listGrid = listGL;
		
	initializeGLInfo();
		
}
private function initializeGLInfo():void
{
	var callbacksListFormat:IResponder = new mx.rpc.Responder(GLListFormatResultHandler, faultHandler);
	var delegate:InitializeDataEntryDelegate = new InitializeDataEntryDelegate(callbacksListFormat);
	delegate.getListFormat();

	var initializeViewEvent:InitializeViewEvent	=	new InitializeViewEvent()
	initializeViewEvent.dispatch();
	
	getReportCriteiaXML();
	changeReportHandler();
}
private function GLListFormatResultHandler(event:ResultEvent):void
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

	GLAllTransactionCriteriaXML		= __viewObj.criteria.copy();
	GLPeriodSummaryCriteriaXML		= __viewObj.criteria.copy();
	GLDateSummaryCriteriaXML		= __viewObj.criteria.copy();
	
	initializeReportCriteria(GLAllTransactionCriteriaXML);
	initializeReportCriteria(GLPeriodSummaryCriteriaXML);
	initializeReportCriteria(GLDateSummaryCriteriaXML);
	
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

	//we have to set this date from GL view as the default value
	reportCriteriaXML.dt1			=	'01/01/1990';
	reportCriteriaXML.dt2			=	'12/12/2025'; 
	reportCriteriaXML.str3			=	'';
	reportCriteriaXML.str4			=	'zzzz'; 	
}
/*****************************************************************************************************************/
private function GLViewChangeHandler(event:Event):void
{	
	filteredReport	=	new XML();
	resetGLDetail();
	
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
private function btnGLQueryClickHandler():void
{
	queryEvent = new QueryEvent();
	queryEvent.dispatch();
}
private function GLItemClickHandler(event:GenDataGridEvent):void
{
	showGL()//get GL detail
	populateList();//change view such that it has selected GL and call service to get data	 
}
private function showGL():void
{
	var __locator:ServiceLocator = GenModelLocator.getInstance().services;
	var __showGLService:HTTPService;
	
	var callbackShowGL:IResponder 		= 	new mx.rpc.Responder(showGLResultHandler, faultHandler);
    
  	var params:XML = new XML(<params></params>)
    var str:String = "<id>" + listGL.selectedItem.gl_account_id.toString() + "</id>"
	params.appendChild((XML)(str));
									
	__showGLService = __locator.getHTTPService("showGL");
	
	dataService(__showGLService);
	
	var token:AsyncToken = __showGLService.send(params);
	token.addResponder(callbackShowGL);	 
}
private function showGLResultHandler(event:ResultEvent):void
{
	var utilityObj:Utility	=	new Utility();
	var GLDetail:XML		= 	utilityObj.getDecodedXML((XML)(event.result));
	
	if(GLDetail.children().length() > 0)
	{
		setGLDetail(GLDetail)	
	}
	else
	{
		resetGLDetail();
	}		
}
private function setGLDetail(GLDetail:XML):void
{
	lblGLCode.text			=	GLDetail.children().child('code').toString();
	lblGLName.text			=	GLDetail.children().child('name').toString();
	lblGLCategory.text		=	GLDetail.children().child('gl_category_code').toString();
	lblStartDate.text		=	GLDetail.children().child('start_date').toString();
	lblBalanceType.text		=	GLDetail.children().child('gl_category_code').toString();	
	
	lblGroup1.text			=	GLDetail.children().child('group1').toString();
	lblGroup2.text			=	GLDetail.children().child('group2').toString();
	lblGroup3.text			=	GLDetail.children().child('group3').toString();
	lblGroup4.text			=	GLDetail.children().child('group4').toString();						
}
private function resetGLDetail():void
{
	lblGLCode.text			=	''
	lblGLName.text			=	''
	lblGLCategory.text		=	''
	lblStartDate.text		=	''
	lblBalanceType.text		=	''	
		
}
private function dgGLUpdateCompleteHandler():void
{
	if(cbGLView.dataProvider.length > 0)
	{	
		filteredReport	=	new XML();
		resetGLDetail();
		
		updateReportCriteria(GLAllTransactionCriteriaXML);
		updateReportCriteria(GLPeriodSummaryCriteriaXML);
		updateReportCriteria(GLDateSummaryCriteriaXML);
	}	
}
private function updateReportCriteria(reportCriteriaXML:XML):void
{
	/*since there is no date criteria in GL List reportCriteriaXML.dt1			=	cbGLView.selectedItem.dt1.toString();
	reportCriteriaXML.dt2			=	cbGLView.selectedItem.dt2.toString(); 
	reportCriteriaXML.all1			=	'N'*/
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
	if(listGL.selectedItem != null && XMLList(listGL.selectedItem) != XMLList(undefined))
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
			
	reportCriteriaXML.str1	= listGL.selectedItem.gl_account_id.toString();
	reportCriteriaXML.str2	= listGL.selectedItem.gl_account_id.toString();
	
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
	if(listGL.selectedItem != null && XMLList(listGL.selectedItem) != XMLList(undefined))
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
		Alert.show('Please Select GL.');
	}
}
private function getReportCriteriaFormatResultHandler(event:ResultEvent):void
{
	var viewFormat:XML	=	XML(event.result);
	var reportCriteriaObj:ReportCriteria = ReportCriteria(PopUpManager.createPopUp(this, ReportCriteria, true));
	reportCriteriaObj.initializeView(viewFormat,getReportCriteriaXMLByReportCode(),listGL.selectedItem.gl_account_id.toString(),cmbReports.selectedItem.listService.toString());
   reportCriteriaObj.targetObj	=	dgReport;
}
	
private function itemClickCustomReportHandler(event:GenDataGridEvent):void{}

private function itemDoubleClickCustomReportHandler(event:GenDataGridEvent):void{}

private function btnEditGLClickHandler():void
{
	if(listGL.selectedItem == null ||  XMLList(listGL.selectedItem) == XMLList(undefined))
	{
		return;
	}
	var GLXML:XML	=	new XML(<GL><code>{listGL.selectedItem.code.toString()}</code></GL>)
	__genModel.drillObj.drillrow		=	GLXML;
	var tabpage:TabPage	=	new TabPage();
	tabpage.openDrillDownPage('acct/glacct/components/GLAccount.swf');	
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
		case  'GLDATESUMMARY' : 
					tempXML		=	GLDateSummaryCriteriaXML
				break
		case  'GLALLTRANSACTION' : 
					tempXML		=	GLAllTransactionCriteriaXML
				break
								
		case  'GLPERIODSUMMARY' : 
					tempXML		=	GLPeriodSummaryCriteriaXML
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