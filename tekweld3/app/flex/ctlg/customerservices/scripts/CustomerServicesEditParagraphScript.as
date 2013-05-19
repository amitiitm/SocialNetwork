import business.events.RecordStatusEvent;

import com.generic.events.AddEditEvent;

import ctlg.privacypolicy.components.PrivacyPolicyDetail;
import ctlg.privacypolicy.components.PrivacyPolicyRenderer;
import ctlg.privacypolicy.components.PrivacyPolicySequenceManager;

import flash.events.Event;
import flash.events.MouseEvent;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var recordStatusEvent:RecordStatusEvent;
private var currentSelectedChild:XMLList	=	null;
private var privacyPolicyParagraph:PrivacyPolicyDetail;
private var maxSeqNO:int	=	0	// it is used to assign unique seq. no for a new para.

public function init():void {}

private function onResults_PrivacyPolicyData(privacyPolicyXml:XML):void
{
		var length:int		=	privacyPolicyXml.children().length()
	
		if(length > 0)
 		{
 			var newPara:PrivacyPolicyRenderer;
 			var i:int;
 			
 			for( i	=	0	; i <  length ; i++	)
 			{
				newPara						= 	new PrivacyPolicyRenderer()
 				
 				vbMainContainer.addChild(newPara);
 				
 				newPara.btnEdit.addEventListener(MouseEvent.CLICK, btnEditParagraphClickHandler);
 				newPara.btnRemove.addEventListener(MouseEvent.CLICK, btnRemoveParagraphCilckHandler);
 				
 				newPara.name					=	privacyPolicyXml.children()[i].sequence.toString();
 				newPara.btnEdit.name			=	privacyPolicyXml.children()[i].sequence.toString();
 				newPara.btnRemove.name			=	privacyPolicyXml.children()[i].sequence.toString();
 				
 				newPara.lblHeading.text			=	privacyPolicyXml.children()[i].heading.toString();
 				newPara.textParagraph.text		=	privacyPolicyXml.children()[i].paragraph.toString()
 			
 				if(privacyPolicyXml.children()[i].link1_text.toString() != '')
 				{
 					newPara.lb1.label					=	privacyPolicyXml.children()[i].link1_text.toString();
 					newPara.lb1.height					=	20;
 					newPara.lb1.visible					=	true;
 				}
 				else
 				{
 					newPara.lb1.height	=	0;
 					newPara.lb1.visible	=	false;	
 				}
 				if(privacyPolicyXml.children()[i].link2_text.toString() != '')
 				{
 					newPara.lb2.label					=	privacyPolicyXml.children()[i].link2_text.toString();
 					newPara.lb2.height					=	20;
 					newPara.lb2.visible					=	true;
 				}
 				else
 				{
 					newPara.lb2.height	=	0;
 					newPara.lb2.visible	=	false;
 				}
 				if(privacyPolicyXml.children()[i].link3_text.toString() != '')
 				{
 					newPara.lb3.label					=	privacyPolicyXml.children()[i].link3_text.toString();
 					newPara.lb3.height					=	20;
 					newPara.lb3.visible					=	true;
 				}
 				else
 				{
 					newPara.lb3.height	=	0;
 					newPara.lb3.visible	=	false;
 				}
 			
 			}
 			maxSeqNO	=	i+1;
 		} 
}
private function btnAddNewParagraphClickHandler():void
{
	currentSelectedChild	=	null;
	
	privacyPolicyParagraph	=	PrivacyPolicyDetail(PopUpManager.createPopUp(this,PrivacyPolicyDetail,true));
	privacyPolicyParagraph.heading					=	"Define New Section";
	privacyPolicyParagraph.btnUpdate.addEventListener(MouseEvent.CLICK , privacyPolicyDetailSaveBtnClickHandler);
}
private function btnEditParagraphClickHandler(event:MouseEvent):void
{
	currentSelectedChild	=	dtlLine.rows.children().(sequence.toString() == event.target.name.toString())
	
	privacyPolicyParagraph	=	PrivacyPolicyDetail(PopUpManager.createPopUp(this,PrivacyPolicyDetail,true));
	
	privacyPolicyParagraph.heading					=	"Edit The Selected Paragraph";
	
 	privacyPolicyParagraph.tiHeading.text			=			currentSelectedChild.heading.toString()
	privacyPolicyParagraph.textParagraph.text		=			currentSelectedChild.paragraph.toString()
	privacyPolicyParagraph.tiLink1.text				=			currentSelectedChild.link1_text.toString()
	privacyPolicyParagraph.tiLink2.text				=			currentSelectedChild.link2_text.toString()
	privacyPolicyParagraph.tiLink3.text				=			currentSelectedChild.link3_text.toString()
	
	privacyPolicyParagraph.btnUpdate.addEventListener(MouseEvent.CLICK , privacyPolicyDetailSaveBtnClickHandler);
	
	
	/*COMBOBOX TO BE SELECTED WITH THE GIVEN URL*/
	if(privacyPolicyParagraph.tiLink1.text != '')
	{
		for(var i:int=0 ; i< privacyPolicyParagraph.cmbUrl1.dataProvider.length ; i++)
		{
			if(privacyPolicyParagraph.cmbUrl1.dataProvider[i].url.toString() == currentSelectedChild.link1_url.toString())
			{
				privacyPolicyParagraph.cmbUrl1.selectedIndex	=	i;
				break;
			}
		}	
	}
	if(privacyPolicyParagraph.tiLink2.text != '')
	{
		for(var i:int=0 ; i< privacyPolicyParagraph.cmbUrl2.dataProvider.length ; i++)
		{
			if(privacyPolicyParagraph.cmbUrl2.dataProvider[i].url.toString() == currentSelectedChild.link2_url.toString())
			{
				privacyPolicyParagraph.cmbUrl2.selectedIndex	=	i;
				break;
			}
		}	
	}

	if(privacyPolicyParagraph.tiLink3.text != '')
	{
		for(var i:int=0 ; i< privacyPolicyParagraph.cmbUrl3.dataProvider.length ; i++)
		{
			if(privacyPolicyParagraph.cmbUrl3.dataProvider[i].url.toString() == currentSelectedChild.link3_url.toString())
			{
				privacyPolicyParagraph.cmbUrl3.selectedIndex	=	i;
				break;
			}
		}	
	}	
} 
private function btnRemoveParagraphCilckHandler(event:MouseEvent):void
{
		var tempXmlList:XML	=	XML(dtlLine.rows.children().(sequence.toString()	==	event.target.name.toString()))
		var index:int		=		tempXmlList.childIndex();
		var deleteChild:XML	=	new XML(tempXmlList);
		deleteChild.trans_flag	=	"D"; 
		
		if(Number(deleteChild.child('id').toString()) > 0)
		{
			XML(dtlLine.deletedRows).appendChild(deleteChild);
		} 
		delete dtlLine.rows.children()[index]
		
		vbMainContainer.removeChildAt(index);	
		
		recordStatusEvent = new	RecordStatusEvent("MODIFY");
		recordStatusEvent.dispatch();	
} 
private function privacyPolicyDetailSaveBtnClickHandler(event:Event):void
{
	recordStatusEvent = new	RecordStatusEvent("MODIFY");
	recordStatusEvent.dispatch();	
	
	if(currentSelectedChild == null)
	{
		createNewParagraph();
	}
	else
	{
		updateExistingParagraph();
	}
}
private function createNewParagraph():void
{
  	

	dtlLine.rows.appendChild(new XML(<row>
									<id/>
									<heading>{privacyPolicyParagraph.tiHeading.text}</heading>
									<paragraph>{privacyPolicyParagraph.textParagraph.text}</paragraph>
									<link1_text>{privacyPolicyParagraph.tiLink1.text}</link1_text>
									<link2_text>{privacyPolicyParagraph.tiLink2.text}</link2_text>
									<link3_text>{privacyPolicyParagraph.tiLink3.text}</link3_text>
									<link1_url>{privacyPolicyParagraph.cmbUrl1.selectedItem.url.toString()}</link1_url>
									<link2_url>{privacyPolicyParagraph.cmbUrl2.selectedItem.url.toString()}</link2_url>
									<link3_url>{privacyPolicyParagraph.cmbUrl3.selectedItem.url.toString()}</link3_url>
									<sequence>{maxSeqNO}</sequence>
									<trans_flag>A</trans_flag>
								</row>))
	
	
	var newPara:PrivacyPolicyRenderer	= 	new PrivacyPolicyRenderer()
 	
 	vbMainContainer.addChild(newPara);
 	
 	newPara.name					=	maxSeqNO.toString();
 	newPara.btnEdit.name			=	maxSeqNO.toString();
 	newPara.btnRemove.name			=	maxSeqNO.toString();
 	
 	++maxSeqNO;
 	
 	newPara.btnEdit.addEventListener(MouseEvent.CLICK, btnEditParagraphClickHandler);
 	newPara.btnRemove.addEventListener(MouseEvent.CLICK, btnRemoveParagraphCilckHandler);
 	
 	newPara.lblHeading.text			=	privacyPolicyParagraph.tiHeading.text
 	newPara.textParagraph.text		=	privacyPolicyParagraph.textParagraph.text
 
 	if(privacyPolicyParagraph.tiLink1.text != '')
 	{
 		newPara.lb1.label					=	privacyPolicyParagraph.tiLink1.text;
 		newPara.lb1.height					=	20;
 		newPara.lb1.visible					=	true;
 	}
 	else
 	{
 		newPara.lb1.height	=	0;
 		newPara.lb1.visible	=	false;
 	}
 	if(privacyPolicyParagraph.tiLink2.text != '')
 	{
 		newPara.lb2.label					=	privacyPolicyParagraph.tiLink2.text;
 		newPara.lb2.height					=	20;
 		newPara.lb2.visible					=	true;
 	}
 	else
 	{
 		newPara.lb2.height	=	0;
 		newPara.lb2.visible	=	false;
 			
 	}
 	if(privacyPolicyParagraph.tiLink3.text != '')
 	{
 		newPara.lb3.label					=	privacyPolicyParagraph.tiLink3.text;
 		newPara.lb3.height					=	20;
 		newPara.lb3.visible					=	true;
 	}
 	else
 	{
 		newPara.lb3.height	=	0;
 		newPara.lb3.visible	=	false;
 		
 	}			
}
private function updateExistingParagraph():void
{
	/*UPDATING XML*/
	currentSelectedChild.heading		=	privacyPolicyParagraph.tiHeading.text
	currentSelectedChild.paragraph		=	privacyPolicyParagraph.textParagraph.text
	currentSelectedChild.link1_text			=	privacyPolicyParagraph.tiLink1.text
	currentSelectedChild.link2_text			=	privacyPolicyParagraph.tiLink2.text
	currentSelectedChild.link3_text			=	privacyPolicyParagraph.tiLink3.text
	currentSelectedChild.link1_url			=	privacyPolicyParagraph.cmbUrl1.selectedItem.url.toString()
	currentSelectedChild.link2_url			=	privacyPolicyParagraph.cmbUrl2.selectedItem.url.toString()
	currentSelectedChild.link3_url			=	privacyPolicyParagraph.cmbUrl3.selectedItem.url.toString()
	
  
  /*UPDATING CONTROL*/
  	var selectedParagraph:PrivacyPolicyRenderer	=	PrivacyPolicyRenderer(vbMainContainer.getChildByName(currentSelectedChild.sequence.toString()))
  	
 	selectedParagraph.lblHeading.text			=	privacyPolicyParagraph.tiHeading.text
 	selectedParagraph.textParagraph.text		=	privacyPolicyParagraph.textParagraph.text
 
 	if(privacyPolicyParagraph.tiLink1.text != '')
 	{
 		selectedParagraph.lb1.label		=	privacyPolicyParagraph.tiLink1.text ;
 		selectedParagraph.lb1.height	=	20;
 		selectedParagraph.lb1.visible	=	true;
 	}
 	else
 	{
 		selectedParagraph.lb1.height	=	0;
 		selectedParagraph.lb1.visible	=	false;
 	}
 	if(privacyPolicyParagraph.tiLink2.text != '')
 	{
 		selectedParagraph.lb2.label		=	privacyPolicyParagraph.tiLink2.text;
 		selectedParagraph.lb2.height	=	20;
 		selectedParagraph.lb2.visible	=	true;
 	}
 	else
 	{
 		selectedParagraph.lb2.height	=	0;
 		selectedParagraph.lb2.visible	=	false;
 	}
 	if(privacyPolicyParagraph.tiLink3.text != '')
 	{
 		selectedParagraph.lb3.label		=	privacyPolicyParagraph.tiLink3.text
 		selectedParagraph.lb3.height	=	20;
 		selectedParagraph.lb3.visible	=	true;
 	}
 	else
 	{
 		selectedParagraph.lb3.height	=	0;
 		selectedParagraph.lb3.visible	=	false;
 	}		 
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	
	dtlLine.deletedRows	=	new XML('<' + dtlLine.rootNode + '/>');
	vbMainContainer.removeAllChildren(); //beacause this function will aslo be called after save.	
	
	dtlLine.rows	=	setCompanySpecificParameter(XML(event.recordXml.children().child('rows')));
	onResults_PrivacyPolicyData(dtlLine.rows) 
	Alert.show(dtlLine.rows);
	// initialize screen 
} 
override protected function preSaveEventHandler(event:AddEditEvent):int
{
	for(var i:int = 0 ; i< dtlLine.rows.children().length(); i++)
	{
		dtlLine.rows.children()[i].sequence	=	i+1;
	} 
	return 0;
}
private function btnResetAllClickHandler():void
{
		var service:HTTPService = __genModel.services.getHTTPService("getDefaultPolicy");
	
		setDataService(service);
	
		service.addEventListener(ResultEvent.RESULT, getDefaultPolicyHandler)													
		service.addEventListener(FaultEvent.FAULT, faultHandler)
	
		CursorManager.setBusyCursor();
		Application.application.enabled	= false;
		
		service.send(new XML());
	// we have to call service for reseting to default privacy policy;
}
private function getDefaultPolicyHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	dtlLine.rows			=	setCompanySpecificParameter(XML(XML(event.result).children().child('rows')));
	dtlLine.deletedRows		=	new XML('<' + dtlLine.rootNode + '/>');
	
	Alert.show(dtlLine.rows);
	vbMainContainer.removeAllChildren(); //beacause this function will aslo be called after save.	
	onResults_PrivacyPolicyData(dtlLine.rows) 
}
private function setCompanySpecificParameter(privacyPolicyXml:XML):XML
{
	var temp:String;
	 			
 	for(var i:int=0 ; i < privacyPolicyXml.children().length() ;i++ )
 	{
 		temp	=	privacyPolicyXml.children()[i].paragraph.toString();
 		while(temp.search('##companyshortname##') != -1)
 		{
 			temp	=	temp.replace('##companyshortname##', __genModel.user.company_name.toString());	
 		}
 		while(temp.search('##companycontactno##') != -1)
 		{
 			temp	=	temp.replace('##companycontactno##', __genModel.user.complc_phone.toString());	
 		}
 		while(temp.search('##companyemail##') != -1)
 		{
 			temp	=	temp.replace('##companyemail##', __genModel.user.complc_email.toString());	
 		}
 		
 		privacyPolicyXml.children()[i].paragraph	=	temp.toString();
 	}

	return privacyPolicyXml;
}
private function btnArrangeInSequenceClickHandler():void
{
	var sequenceManagerObj:PrivacyPolicySequenceManager	=	PrivacyPolicySequenceManager(PopUpManager.createPopUp(this,PrivacyPolicySequenceManager,true));
	sequenceManagerObj.dgSource.dataProvider			=	dtlLine.rows.children();
	sequenceManagerObj.btnSave.addEventListener(MouseEvent.CLICK , PricyPolicySequenceManagerSaveBtnClickHandler)
}
private function PricyPolicySequenceManagerSaveBtnClickHandler(event:MouseEvent):void
{
	recordStatusEvent = new	RecordStatusEvent("MODIFY");
	recordStatusEvent.dispatch();	
	vbMainContainer.removeAllChildren(); 
	onResults_PrivacyPolicyData(dtlLine.rows) 
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