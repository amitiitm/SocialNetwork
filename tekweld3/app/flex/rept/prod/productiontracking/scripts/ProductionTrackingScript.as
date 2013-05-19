import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.core.ClassFactory;
import mx.events.FlexEvent;

import rept.prod.productiontracking.DrilldownProductionTracking;
import rept.prod.productiontracking.ProductionTrackingController;
import rept.prod.productiontracking.ProductionTrackingModelLocator;
import rept.prod.productiontracking.ProductionTrackingServices;
import rept.prod.productiontracking.components.ItemRendererLabel;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:ProductionTrackingModelLocator = new ProductionTrackingModelLocator();

public function handleProductionTrackingActive(event:GenModuleEvent):void
{
	__genModel.controller			= new ProductionTrackingController();
	__genModel.services 			= new ProductionTrackingServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID			= __genModel.applicationObject.selectedMenuItem.@document_id;
    __localModel.documentObj.create_permission 	= "N";
    __localModel.documentObj.modify_permission 	= "N";
    __localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
    __localModel.documentObj.upload_permission 	= "N";

	__localModel.reportObj.customReportDataGrid = this.customReportComponent;
	__localModel.reportObj.idrilldown			=	new DrilldownProductionTracking();
	
	__localModel.reportObj.customReportDataGrid.headerWordWrap = true;
	__localModel.reportObj.customReportDataGrid.sortableColumns = false;
	__localModel.reportObj.customReportDataGrid.sortItemRenderer= null;
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
	
	//setTimeout(formatCustumGrid ,5000,__localModel.reportObj.customReportDataGrid);
}
private function formatCustumGrid(advancedGrid:AdvancedDataGrid):void
{
	for(var i:int=0;i<advancedGrid.columnCount;i++)
	{
		var column:AdvancedDataGridColumn = advancedGrid.columns[i];
		if(column.headerText.toUpperCase() == 'PRINT')
		column.itemRenderer	= new ClassFactory(ItemRendererLabel);
	}
}