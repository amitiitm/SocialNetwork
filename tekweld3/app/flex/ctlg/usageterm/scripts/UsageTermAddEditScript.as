import business.events.RecordStatusEvent;
import com.generic.events.AddEditEvent;
import ctlg.usageterm.components.UsageTermDetail;
import ctlg.usageterm.components.UsageTermRenderer;
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
private var usageTermParagraph:UsageTermDetail;
private var maxSeqNO:int	=	0	// it is used to assign unique seq. no for a new para.

public function init():void {}

private function onResults_UsageTermData(usageTermXml:XML):void
{
	var length:int = usageTermXml.children().length()
	
	if(length > 0)
	{
		var newPara:UsageTermRenderer;
 		var i:int;
 			
 		for(i=0; i <  length; i++)
 		{
			newPara = new UsageTermRenderer()
			vbMainContainer.addChild(newPara);
			newPara.btnEdit.addEventListener(MouseEvent.CLICK, btnEditParagraphClickHandler);
 			newPara.btnRemove.addEventListener(MouseEvent.CLICK, btnRemoveParagraphCilckHandler);
 				
			newPara.name					=	usageTermXml.children()[i].sequence.toString();
 			newPara.btnEdit.name			=	usageTermXml.children()[i].sequence.toString();
 			newPara.btnRemove.name			=	usageTermXml.children()[i].sequence.toString();
 				
			newPara.lblHeading.text			=	usageTermXml.children()[i].heading.toString();
 			newPara.textParagraph.text		=	usageTermXml.children()[i].paragraph.toString()
 			
 			if(usageTermXml.children()[i].link1_text.toString() != '')
 			{
 				newPara.lb1.label					=	usageTermXml.children()[i].link1_text.toString();
 				newPara.lb1.height					=	20;
 				newPara.lb1.visible					=	true;
 			}
 			else
 			{
 				newPara.lb1.height	=	0;
 				newPara.lb1.visible	=	false;	
 			}
 			
 			if(usageTermXml.children()[i].link2_text.toString() != '')
 			{
 				newPara.lb2.label					=	usageTermXml.children()[i].link2_text.toString();
 				newPara.lb2.height					=	20;
 				newPara.lb2.visible					=	true;
 			}
 			else
 			{
 				newPara.lb2.height	=	0;
 				newPara.lb2.visible	=	false;
 			}
 			
 			if(usageTermXml.children()[i].link3_text.toString() != '')
 			{
 				newPara.lb3.label					=	usageTermXml.children()[i].link3_text.toString();
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
	
	usageTermParagraph = UsageTermDetail(PopUpManager.createPopUp(this, UsageTermDetail, true));
	usageTermParagraph.heading = "Define New Section";
	usageTermParagraph.btnUpdate.addEventListener(MouseEvent.CLICK, usageTermDetailSaveBtnClickHandler);
}

private function btnEditParagraphClickHandler(event:MouseEvent):void
{
	currentSelectedChild	=	dtlLine.rows.children().(sequence.toString() == event.target.name.toString())
	usageTermParagraph		=	UsageTermDetail(PopUpManager.createPopUp(this, UsageTermDetail, true));
	
	usageTermParagraph.heading					=	"Edit The Selected Paragraph";
	
 	usageTermParagraph.tiHeading.text			=			currentSelectedChild.heading.toString()
	usageTermParagraph.textParagraph.text		=			currentSelectedChild.paragraph.toString()
	usageTermParagraph.tiLink1.text				=			currentSelectedChild.link1_text.toString()
	usageTermParagraph.tiLink2.text				=			currentSelectedChild.link2_text.toString()
	usageTermParagraph.tiLink3.text				=			currentSelectedChild.link3_text.toString()
	
	usageTermParagraph.btnUpdate.addEventListener(MouseEvent.CLICK, usageTermDetailSaveBtnClickHandler);
	
	
	/*COMBOBOX TO BE SELECTED WITH THE GIVEN URL*/
	if(usageTermParagraph.tiLink1.text != '')
	{
		for(var i:int=0 ; i < usageTermParagraph.cmbUrl1.dataProvider.length ; i++)
		{
			if(usageTermParagraph.cmbUrl1.dataProvider[i].url.toString() == currentSelectedChild.link1_url.toString())
			{
				usageTermParagraph.cmbUrl1.selectedIndex	=	i;
				break;
			}
		}	
	}

	if(usageTermParagraph.tiLink2.text != '')
	{
		for(var i:int=0 ; i< usageTermParagraph.cmbUrl2.dataProvider.length ; i++)
		{
			if(usageTermParagraph.cmbUrl2.dataProvider[i].url.toString() == currentSelectedChild.link2_url.toString())
			{
				usageTermParagraph.cmbUrl2.selectedIndex	=	i;
				break;
			}
		}	
	}

	if(usageTermParagraph.tiLink3.text != '')
	{
		for(var i:int=0 ; i< usageTermParagraph.cmbUrl3.dataProvider.length ; i++)
		{
			if(usageTermParagraph.cmbUrl3.dataProvider[i].url.toString() == currentSelectedChild.link3_url.toString())
			{
				usageTermParagraph.cmbUrl3.selectedIndex	=	i;
				break;
			}
		}	
	}	
} 

private function btnRemoveParagraphCilckHandler(event:MouseEvent):void
{
	var tempXmlList:XML	=	XML(dtlLine.rows.children().(sequence.toString()	==	event.target.name.toString()))
	var index:int		=	tempXmlList.childIndex();
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

private function usageTermDetailSaveBtnClickHandler(event:Event):void
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
										<heading>{usageTermParagraph.tiHeading.text}</heading>
										<paragraph>{usageTermParagraph.textParagraph.text}</paragraph>
										<link1_text>{usageTermParagraph.tiLink1.text}</link1_text>
										<link2_text>{usageTermParagraph.tiLink2.text}</link2_text>
										<link3_text>{usageTermParagraph.tiLink3.text}</link3_text>
										<link1_url>{usageTermParagraph.cmbUrl1.selectedItem.url.toString()}</link1_url>
										<link2_url>{usageTermParagraph.cmbUrl2.selectedItem.url.toString()}</link2_url>
										<link3_url>{usageTermParagraph.cmbUrl3.selectedItem.url.toString()}</link3_url>
										<sequence>{maxSeqNO}</sequence>
										<trans_flag>A</trans_flag>
									</row>))
	
	var newPara:UsageTermRenderer = new UsageTermRenderer()
 	
 	vbMainContainer.addChild(newPara);
 	
 	newPara.name					=	maxSeqNO.toString();
 	newPara.btnEdit.name			=	maxSeqNO.toString();
 	newPara.btnRemove.name			=	maxSeqNO.toString();
 	
 	++maxSeqNO;
 	
 	newPara.btnEdit.addEventListener(MouseEvent.CLICK, btnEditParagraphClickHandler);
 	newPara.btnRemove.addEventListener(MouseEvent.CLICK, btnRemoveParagraphCilckHandler);
 	
 	newPara.lblHeading.text			=	usageTermParagraph.tiHeading.text
 	newPara.textParagraph.text		=	usageTermParagraph.textParagraph.text
 
 	if(usageTermParagraph.tiLink1.text != '')
 	{
 		newPara.lb1.label					=	usageTermParagraph.tiLink1.text;
 		newPara.lb1.height					=	20;
 		newPara.lb1.visible					=	true;
 	}
 	else
 	{
 		newPara.lb1.height	=	0;
 		newPara.lb1.visible	=	false;
 	}
 	
 	if(usageTermParagraph.tiLink2.text != '')
 	{
 		newPara.lb2.label					=	usageTermParagraph.tiLink2.text;
 		newPara.lb2.height					=	20;
 		newPara.lb2.visible					=	true;
 	}
 	else
 	{
 		newPara.lb2.height	=	0;
 		newPara.lb2.visible	=	false;
 			
 	}
 	
 	if(usageTermParagraph.tiLink3.text != '')
 	{
 		newPara.lb3.label					=	usageTermParagraph.tiLink3.text;
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
	currentSelectedChild.heading		=	usageTermParagraph.tiHeading.text
	currentSelectedChild.paragraph		=	usageTermParagraph.textParagraph.text
	currentSelectedChild.link1_text		=	usageTermParagraph.tiLink1.text
	currentSelectedChild.link2_text		=	usageTermParagraph.tiLink2.text
	currentSelectedChild.link3_text		=	usageTermParagraph.tiLink3.text
	currentSelectedChild.link1_url		=	usageTermParagraph.cmbUrl1.selectedItem.url.toString()
	currentSelectedChild.link2_url		=	usageTermParagraph.cmbUrl2.selectedItem.url.toString()
	currentSelectedChild.link3_url		=	usageTermParagraph.cmbUrl3.selectedItem.url.toString()
	
  
  /*UPDATING CONTROL*/
  	var selectedParagraph:UsageTermRenderer	=	UsageTermRenderer(vbMainContainer.getChildByName(currentSelectedChild.sequence.toString()))
  	
 	selectedParagraph.lblHeading.text		=	usageTermParagraph.tiHeading.text
 	selectedParagraph.textParagraph.text	=	usageTermParagraph.textParagraph.text
 
 	if(usageTermParagraph.tiLink1.text != '')
 	{
 		selectedParagraph.lb1.label		=	usageTermParagraph.tiLink1.text ;
 		selectedParagraph.lb1.height	=	20;
 		selectedParagraph.lb1.visible	=	true;
 	}
 	else
 	{
 		selectedParagraph.lb1.height	=	0;
 		selectedParagraph.lb1.visible	=	false;
 	}
 	
 	if(usageTermParagraph.tiLink2.text != '')
 	{
 		selectedParagraph.lb2.label		=	usageTermParagraph.tiLink2.text;
 		selectedParagraph.lb2.height	=	20;
 		selectedParagraph.lb2.visible	=	true;
 	}
 	else
 	{
 		selectedParagraph.lb2.height	=	0;
 		selectedParagraph.lb2.visible	=	false;
 	}
 	
 	if(usageTermParagraph.tiLink3.text != '')
 	{
 		selectedParagraph.lb3.label		=	usageTermParagraph.tiLink3.text
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
	onResults_UsageTermData(dtlLine.rows) 
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
	var service:HTTPService = __genModel.services.getHTTPService("getDefaultUsageTerm");
	
	setDataService(service);
	
	service.addEventListener(ResultEvent.RESULT, getDefaultUsageTermHandler)													
	service.addEventListener(FaultEvent.FAULT, faultHandler)
	
	CursorManager.setBusyCursor();
	Application.application.enabled	= false;
		
	service.send(new XML());
	// we have to call service for reseting to default privacy policy;
}

private function getDefaultUsageTermHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	dtlLine.rows			=	setCompanySpecificParameter(XML(XML(event.result).children().child('rows')));
	dtlLine.deletedRows		=	new XML('<' + dtlLine.rootNode + '/>');
	
	vbMainContainer.removeAllChildren(); //beacause this function will aslo be called after save.	
	onResults_UsageTermData(dtlLine.rows) 
}

private function setCompanySpecificParameter(usageTermXml:XML):XML
{
	var temp:String;
	 			
 	for(var i:int=0 ; i < usageTermXml.children().length() ;i++ )
 	{
 		temp = usageTermXml.children()[i].paragraph.toString();

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
 		while(temp.search('##companystate##') != -1)
 		{
 			temp	=	temp.replace('##companystate##', __genModel.user.complc_state.toString());	
 		}
 		while(temp.search('##companycity##') != -1)
 		{
 			temp	=	temp.replace('##companycity##', __genModel.user.complc_city.toString());	
 		}
 		
 		usageTermXml.children()[i].paragraph	=	temp.toString();
 	}

	return usageTermXml;
}

private function btnArrangeInSequenceClickHandler():void
{
	var sequenceManagerObj:UsageTermSequenceManager = UsageTermSequenceManager(PopUpManager.createPopUp(this, UsageTermSequenceManager, true));
	
	sequenceManagerObj.dgSource.dataProvider = dtlLine.rows.children();
	sequenceManagerObj.btnSave.addEventListener(MouseEvent.CLICK , UsageTermSequenceManagerSaveBtnClickHandler)
}

private function UsageTermSequenceManagerSaveBtnClickHandler(event:MouseEvent):void
{
	recordStatusEvent = new	RecordStatusEvent("MODIFY");
	recordStatusEvent.dispatch();	
	vbMainContainer.removeAllChildren(); 
	onResults_UsageTermData(dtlLine.rows) 
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
