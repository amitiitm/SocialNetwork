import business.events.RecordStatusEvent;

import com.generic.components.AboutUsRenderer;
import com.generic.events.AddEditEvent;

import ctlg.aboutus.components.AboutUsDetail;

import flash.events.Event;
import flash.events.MouseEvent;

import model.GenModelLocator;

import mx.containers.VBox;
import mx.core.Container;
import mx.managers.PopUpManager;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var recordStatusEvent:RecordStatusEvent;
private var aboutUsTab:AboutUsDetail;

public function init():void {}

private function onResults_AboutUsData(tabDetailXml:XML):void
{
	dtlLine.rows = XML(tabDetailXml.children().child('rows'))
	
	var aboutUsXml:XML = XML(tabDetailXml.children().child('rows'))
	var length:int = aboutUsXml.children().length();
	
 	if(length > 0)
 	{
 		var newTab:AboutUsRenderer
 		
 		for(var i:int	=	0	; i <  length ; i++	)
 		{
			newTab						= 	new AboutUsRenderer()
 			newTab.label				=	aboutUsXml.children()[i].name.toString()
 		
 			tabnavAboutUs.addChild(newTab);
 			
 			newTab.txtDescription.text	=	aboutUsXml.children()[i].description.toString()
 			newTab.img.source			=	__genModel.path.image + aboutUsXml.children()[i].image_file.toString()
 		
 			setTemplate(newTab , aboutUsXml.children()[i].code.toString());
 		}
 		tabnavAboutUs.selectedIndex	=		0;
 	}
}
private function setTemplate(tab:AboutUsRenderer , templateType:String):void
{
 	switch(templateType)
 	{
	 	case 'img':			tab.txtDescription.visible	=	false;	
	 						tab.txtDescription.height	=	0;
	 						tab.txtDescription.width		=	0;
	 						
	 						tab.img.visible		=	true;
	 						tab.img.height		=	400;
	 						tab.img.width		=	800;
	 						break;
 		
 		case 'textimg':		tab.txtDescription.visible			=	true;	
			 				tab.txtDescription.percentHeight	=	100;
			 				tab.txtDescription.width			=	500;
			 				
			 				tab.img.visible						=	true;
			 				tab.img.height						=	250;
			 				tab.img.width						=	450;
			 				break;
			 								
 		default		:		tab.txtDescription.visible			=	true;	
			 				tab.txtDescription.percentHeight	=	100;
			 				tab.txtDescription.width			=	500;
			 				
			 				tab.img.visible						=	true;
			 				tab.img.height						=	250;
			 				tab.img.width						=	450;
			 				break;
 	}	
}
private function createNewTab():void
{
 	if(tiTabName.text != '')
	{
		recordStatusEvent = new	RecordStatusEvent("MODIFY");
		recordStatusEvent.dispatch();	
		
		if(tabnavAboutUs.selectedIndex > 0)
		{
			updateExistingTab();
		}
		else
		{
			var newTab:AboutUsRenderer;
			newTab						= 	new AboutUsRenderer()
	 		newTab.label				=	 tiTabName.text
	 		
	 		tabnavAboutUs.addChild(newTab);
	 			
	 		newTab.txtDescription.text	=	textDescription.text;
	 		newTab.img.source			=	__genModel.path.image + tiImageName.text;	
			
			dtlLine.rows.appendChild(new XML(<row>
												<id/>
												<code>{tiCode.text}</code>
												<trans_flag>A</trans_flag>
												<name>{tiTabName.text}</name>
												<image_file>{tiImageName.text}</image_file>
												<description>{textDescription.text}</description>
											</row>))
			
			setTemplate(newTab , tiCode.text);
			
			tabnavAboutUs.selectedIndex	=	dtlLine.rows.children().length()
			//resetValues();			
		}
	}
 
} 
private function RemoveTab():void
{
		var deleteChild:XML	=	new XML(dtlLine.rows.children()[tabnavAboutUs.selectedIndex - 1])
		
		deleteChild.trans_flag	=	"D"; // each detail window must have trans_flag
		
		if(Number(deleteChild.child('id').toString()) > 0)
		{
			XML(dtlLine.deletedRows).appendChild(deleteChild);
		} 
		
		
		delete dtlLine.rows.children()[tabnavAboutUs.selectedIndex - 1]
		tabnavAboutUs.removeChildAt(tabnavAboutUs.selectedIndex);	
		recordStatusEvent = new	RecordStatusEvent("MODIFY");
		recordStatusEvent.dispatch();	
} 
private function setValues():void
{
 	tiTabName.text			=	dtlLine.rows.children()[tabnavAboutUs.selectedIndex - 1].name.toString();
	tiImageName.text		=	dtlLine.rows.children()[tabnavAboutUs.selectedIndex - 1].image_file.toString();
	textDescription.text	=	dtlLine.rows.children()[tabnavAboutUs.selectedIndex - 1].description.toString();
	tiCode.text				=	dtlLine.rows.children()[tabnavAboutUs.selectedIndex - 1].code.toString();
 
}
private function updateExistingTab():void
{
 	dtlLine.rows.children()[tabnavAboutUs.selectedIndex - 1].code			=		tiCode.text
	dtlLine.rows.children()[tabnavAboutUs.selectedIndex - 1].name			=		tiTabName.text;
	dtlLine.rows.children()[tabnavAboutUs.selectedIndex - 1].image_file		=		tiImageName.text;
	dtlLine.rows.children()[tabnavAboutUs.selectedIndex - 1].description	=		textDescription.text;
	
	
	AboutUsRenderer(tabnavAboutUs.selectedChild).label					=	tiTabName.text;
	AboutUsRenderer(tabnavAboutUs.selectedChild).img.source				=	__genModel.path.image + tiImageName.text;
	AboutUsRenderer(tabnavAboutUs.selectedChild).txtDescription.text	=	textDescription.text;	
	
	setTemplate(AboutUsRenderer(tabnavAboutUs.selectedChild) , tiCode.text);
	
	//resetValues()
 
}
private function resetValues():void
{
	tiCode.text					=	''
	tiTabName.text				=	''
	tiImageName.text			=	''
	textDescription.text		=	''
	tabnavAboutUs.selectedIndex	=		0; 
}
private function openDetailWindow():void
{
	aboutUsTab	=	AboutUsDetail(PopUpManager.createPopUp(this,AboutUsDetail,true));
	
	for(var i:int=0 ; i< aboutUsTab.cmbTemplateType.dataProvider.length ; i++)
	{
		if(aboutUsTab.cmbTemplateType.dataProvider[i].code.toString() == tiCode.text)
		{
			aboutUsTab.cmbTemplateType.selectedIndex	=	i;
			aboutUsTab.cmbTemplateChangeHandler();
			break;
		}
	}
	aboutUsTab.tiImageName.text			=	tiImageName.text;		
	aboutUsTab.tiTabName.text			=	tiTabName.text	;	
	aboutUsTab.textDescription.text		=	textDescription.text;
	if(tabnavAboutUs.selectedIndex > 0)
	{
		aboutUsTab.heading	=	"Edit The Selected Tab";
	}
	else
	{
		aboutUsTab.heading	=	"Define New Tab";
	}
	aboutUsTab.btnUpdate.addEventListener(MouseEvent.CLICK , aboutUsDetailSaveBtnClickHandler);
}
private function aboutUsDetailSaveBtnClickHandler(event:Event):void
{
	tiCode.text				=	aboutUsTab.cmbTemplateType.selectedItem.code.toString();
	tiImageName.text		=	aboutUsTab.tiImageName.text;
	tiTabName.text			=	aboutUsTab.tiTabName.text;
	textDescription.text	=	aboutUsTab.textDescription.text;
	createNewTab();
}
override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	dtlLine.deletedRows	=	new XML('<' + dtlLine.rootNode + '/>');
	tabnavAboutUs.removeAllChildren();

	var home:VBox =	new VBox();
	
	tabnavAboutUs.addChild(home);
	onResults_AboutUsData(event.recordXml)
	// initialize screen 
} 
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	tabnavAboutUs.selectedIndex	=	0;
	
	for(var i:int = 0 ; i< dtlLine.rows.children().length(); i++)
	{
		dtlLine.rows.children()[i].sequence	=	i+1;
	}
	return 0;
}

