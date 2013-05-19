import business.events.InitializeCustomReportEvent;

import com.generic.customcomponents.GenCustomReportDataGrid;
import com.generic.events.CustomReportEvent;
import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.events.FlexEvent;

import rept.acct.cust.backdatedagingdetail.BackdatedAgingDetailController;
import rept.acct.cust.backdatedagingdetail.BackdatedAgingDetailModelLocator;
import rept.acct.cust.backdatedagingdetail.BackdatedAgingDetailServices;
import rept.acct.cust.backdatedagingdetail.DrilldownCustBackdatedAgingDetail;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:BackdatedAgingDetailModelLocator = new BackdatedAgingDetailModelLocator();

public function handleBackdatedAgingDetailActive(event:GenModuleEvent):void
{
	__genModel.controller			= new BackdatedAgingDetailController();
	__genModel.services 			= new BackdatedAgingDetailServices();
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
	__localModel.reportObj.idrilldown  = new DrilldownCustBackdatedAgingDetail();
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}
 
override protected function structureCompleteEventHandler(event:CustomReportEvent):void
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

	var columns:Array					=	GenCustomReportDataGrid(__localModel.reportObj.customReportDataGrid).cols
	var columnCount:int					=	GenCustomReportDataGrid(__localModel.reportObj.customReportDataGrid).cols.length;
	
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
