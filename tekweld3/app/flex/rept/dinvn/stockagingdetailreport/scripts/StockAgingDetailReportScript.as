import business.events.InitializeCustomReportEvent;
import com.generic.events.GenModuleEvent;
import model.GenModelLocator;
import mx.events.FlexEvent;
import rept.dinvn.stockagingdetailreport.StockAgingDetailReportController;
import rept.dinvn.stockagingdetailreport.StockAgingDetailReportModelLocator;
import rept.dinvn.stockagingdetailreport.StockAgingDetailReportServices;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:StockAgingDetailReportModelLocator = new StockAgingDetailReportModelLocator();

public function handleStockAgingDetailReportActive(event:GenModuleEvent):void
{
	__genModel.controller			= new StockAgingDetailReportController();
	__genModel.services 			= new StockAgingDetailReportServices();
	__genModel.activeModelLocator 	= __localModel;
	handleDrillDown();
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID			= __genModel.applicationObject.selectedMenuItem.@document_id;
    __localModel.documentObj.create_permission 	= "N";
    __localModel.documentObj.modify_permission 	= "N";
    __localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
    __localModel.documentObj.upload_permission 	= "N";

	__localModel.reportObj.customReportDataGrid = this.customReportComponent;
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}
