import business.events.PreSaveEvent;
import business.events.RecordStatusEvent;

import com.generic.events.AddEditEvent;

import ctlg.customerservices.components.CustomerServices;

import flash.events.MouseEvent;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.CheckBox;
import mx.controls.Image;
import mx.controls.Label;
import mx.controls.LinkButton;
import mx.core.Application;
import mx.managers.CursorManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var currentHeadingCode:String	=	null;
[Bindable]
private var currentMainHeading:String;
private var recordStatusEvent:RecordStatusEvent;

public function init():void 
{
	CustomerServices(this.parentDocument).bcp.visible	=	false;;
	csmhComponent.btnBack.addEventListener(MouseEvent.CLICK , mainHeadingDetailbtnBackClickHandler);
}
private function mainHeadingDetailbtnBackClickHandler(event:MouseEvent):void
{
	vsMainPage.selectedChild = vbSection
}
private function setDataService(service:HTTPService):void
{
	service.resultFormat = "e4x";
	service.method = "POST";
	service.useProxy = false;
	service.contentType="application/xml";
}
private function faultHandler(event:FaultEvent):void
{
	Alert.show(event.fault.toString());
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
}

/*..........................................main customer service page..................................................*/
private function addSection(section1Xml:XMLList , sectionNo:int):void
{
	
	var hbSection1Heading:HBox	=	new HBox();
	/* hbSection1Heading.setStyle('paddingLeft' , 25); */
	
	var imgSection:Image		=	new Image();
	/* imgSection.source			=	'com/generic/assets/onlineShop.png' */
	var lblSectionHeading:Label	=	new Label();
	lblSectionHeading.text		=	section1Xml[0].section.toString();
	lblSectionHeading.styleName	=	"H2";
	
	hbSection1Heading.addChild(imgSection);
	hbSection1Heading.addChild(lblSectionHeading);
	
	var vbHeadingContainer:VBox	=	new VBox();
	vbHeadingContainer.setStyle('paddingLeft' , 25);
	vbHeadingContainer.setStyle('verticalGap','0');

	
	var hbHeading:HBox;
	var imgIcon:Image;	
	var lbHeading:LinkButton;
	
	var hbEdit:HBox;
	var lbEdit:LinkButton;
	var checkBox:CheckBox;
	
	for(var i:int=0; i<section1Xml.length();i++)
	{
		hbHeading	=	new HBox();
		hbHeading.setStyle('verticalAlign','middle');
		
		
		imgIcon		=	new Image();
		imgIcon.source		=	'com/generic/assets/arrow.png';
		
		lbHeading		=	new LinkButton();
		lbHeading.width	=	160;
		lbHeading.label	=	section1Xml[i].main_heading.toString();
		lbHeading.name	=	section1Xml[i].main_heading_code.toString();
		lbHeading.styleName	=	'mainText';
		
		hbEdit	=	new HBox();
		hbEdit.setStyle('backgroundColor' , '#EEEFF3');
		hbEdit.setStyle('horizontalGap' , 0);
		hbEdit.setStyle('horizontalAlign','right');
		hbEdit.percentHeight	=	100;
		
		lbEdit	=	new LinkButton();
		lbEdit.setStyle('color' , '#4977EF');
		lbEdit.name	=	section1Xml[i].main_heading_code.toString();
		lbEdit.label	=	'Edit'
		lbEdit.addEventListener(MouseEvent.CLICK,btnEditSectionHeadingClickHandler);
		
		checkBox		=	new CheckBox();
		if(section1Xml[i].visible_flag.toString() == 'Y' || section1Xml[i].visible_flag.toString() == 'y')
		{
			checkBox.selected	=	true;
		}
		else
		{
			checkBox.selected	=	false;
		}
		checkBox.name	=	section1Xml[i].main_heading_code.toString();
		checkBox.addEventListener(MouseEvent.CLICK , sectionHeadingShowHideClickHandler)
		checkBox.label	=	'show';
		
		hbEdit.addChild(lbEdit);
		hbEdit.addChild(checkBox);
		
		
		hbHeading.addChild(imgIcon);
		hbHeading.addChild(lbHeading);
		hbHeading.addChild(hbEdit);
		
		vbHeadingContainer.addChild(hbHeading);
	}
	
	switch(sectionNo)
	{
		case 1:
			imgSection.source			=	'com/generic/assets/onlineShop.png';
			vbSection1Container.addChild(hbSection1Heading);
			vbSection1Container.addChild(vbHeadingContainer);
		break; 
		case 2:
			imgSection.source			=	'com/generic/assets/afterSales.png'
			vbSection2Container.addChild(hbSection1Heading);
			vbSection2Container.addChild(vbHeadingContainer);
		break; 
		case 3:
			imgSection.source			=	'com/generic/assets/orderTracking.png'
			vbSection3Container.addChild(hbSection1Heading);
			vbSection3Container.addChild(vbHeadingContainer);
		break; 
		case 4:
			imgSection.source			=	'com/generic/assets/returns.png'
			vbSection4Container.addChild(hbSection1Heading);
			vbSection4Container.addChild(vbHeadingContainer);
		break; 
	}
	
}
private function sectionHeadingShowHideClickHandler(event:MouseEvent):void
{
	var headingXmlList:XMLList	=	dtlLineMain.rows.children().(main_heading_code.toString() == event.target.name.toString())
		
	if(event.target.selected)
	{
		headingXmlList.visible_flag	=	'Y'
	}
	else
	{
		headingXmlList.visible_flag	=	'N'
	}
	recordStatusEvent = new	RecordStatusEvent("MODIFY")
	recordStatusEvent.dispatch()
}
private function btnEditSectionHeadingClickHandler(event:MouseEvent):void
{
		var service:HTTPService = __genModel.services.getHTTPService("getHeadingDetail");
	
		setDataService(service);
	
		service.addEventListener(ResultEvent.RESULT, getHeadingDetailHandler)													
		service.addEventListener(FaultEvent.FAULT, faultHandler)
	
	
		vsMainPage.selectedChild	=	vsHeadingDetail;
		
		//CustomerServices(this.parentDocument).bcp.visible	=	false;
		
	
		CursorManager.setBusyCursor();
		Application.application.enabled	= false;
		
		currentHeadingCode	=	event.target.name.toString();
		currentMainHeading	=	XMLList(dtlLineMain.rows.children().(main_heading_code.toString() == event.target.name.toString())).main_heading.toString()
		
		if(currentHeadingCode	!=	null || currentHeadingCode != '')
		{
			service.send(new XML(<params><main_heading_code>{currentHeadingCode}</main_heading_code></params>));	
		}
		else
		{
			Alert.show('its code is not available');
		}
		
		
	
}
private function getHeadingDetailHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	csmhComponent.init(XML(event.result) , currentHeadingCode, currentMainHeading);
	
	//dtlLine.deletedRows	=	new XML('<' + dtlLine.rootNode + '/>');
	//vbMainContainer.removeAllChildren(); //beacause this function will aslo be called after save.	
	//dtlLine.rows			=	setCompanySpecificParameter(XML(event.result));
	//onResults_CustomerServicesData(dtlLine.rows) 
	
}
private function btnSaveSectionClickHandler():void
{
	var preSaveEvent:PreSaveEvent	=	new PreSaveEvent();
	preSaveEvent.dispatch();
}
override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	vbSection1Container.removeAllChildren();
	vbSection2Container.removeAllChildren();
	vbSection3Container.removeAllChildren();
	vbSection4Container.removeAllChildren();
	
	dtlLineMain.rows	=	XML(event.recordXml.children().child('rows'))
	var sectionXml:XMLList	=	dtlLineMain.rows.children().copy();
	var tempXmlList:XMLList	=	new XMLList(<rows/>);

	var i:int	=	1;

	while(sectionXml.length() > 0)
	{
		tempXmlList	=	sectionXml.(section.toString() ==  sectionXml[0].section.toString())
		sectionXml	=	sectionXml.(section.toString() !=  sectionXml[0].section.toString())
		
		addSection(tempXmlList, i); 
		
		++i;
	} 
		// initialize screen 
} 
