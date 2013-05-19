import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import rept.melt.packetstatusreport.DrillDownPacketStatusReport;
import rept.melt.packetstatusreport.PacketStatusReportController;
import rept.melt.packetstatusreport.PacketStatusReportModelLocator;
import rept.melt.packetstatusreport.PacketStatusReportServices;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:PacketStatusReportModelLocator = new PacketStatusReportModelLocator();

public function handlePacketStatusReportActive(event:GenModuleEvent):void
{
	__genModel.controller			= new PacketStatusReportController();
	__genModel.services 			= new PacketStatusReportServices();
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
	__localModel.reportObj.idrilldown			= new DrillDownPacketStatusReport();
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}
