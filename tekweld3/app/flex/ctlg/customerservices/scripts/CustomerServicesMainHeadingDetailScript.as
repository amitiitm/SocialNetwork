import business.events.RecordStatusEvent;

import ctlg.customerservices.components.CustomerServicesParagraphDataEntry;
import ctlg.customerservices.components.CustomerServicesParagraphRenderer;
import ctlg.customerservices.components.CustomerServicesSequenceManager;

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
private var customerServicesParagraph:CustomerServicesParagraphDataEntry;
private var maxSeqNO:int	=	0	// it is used to assign unique seq. no for a new para.
private var currentHeadingCode:String	=	null;
[Bindable]
private var currentMainHeading:String;


public function init(customerServicesHeadingDetailXml:XML , currentHeadingCode:String , currentMainHeading:String):void 
{
	this.currentHeadingCode	=	currentHeadingCode;
	this.currentMainHeading	=	currentMainHeading;
	
	dtlLine.deletedRows	=	new XML('<' + dtlLine.rootNode + '/>');
	vbMainContainer.removeAllChildren(); //beacause this function will aslo be called after save.	
	dtlLine.rows			=	setCompanySpecificParameter(customerServicesHeadingDetailXml);
	onResults_CustomerServicesData(dtlLine.rows) 
	
}

private function onResults_CustomerServicesData(customerServicesHeaderDetailXml:XML):void
{
		var length:int		=	customerServicesHeaderDetailXml.children().length()
	
		if(length > 0)
 		{
 			var newPara:CustomerServicesParagraphRenderer;
 			var i:int;
 			
 			for( i	=	0	; i <  length ; i++	)
 			{
				newPara						= 	new CustomerServicesParagraphRenderer()
 				
 				vbMainContainer.addChild(newPara);
 				
 				newPara.btnEdit.addEventListener(MouseEvent.CLICK, btnEditParagraphClickHandler);
 				newPara.btnRemove.addEventListener(MouseEvent.CLICK, btnRemoveParagraphCilckHandler);
 				
 				newPara.name					=	customerServicesHeaderDetailXml.children()[i].sequence.toString();
 				newPara.btnEdit.name			=	customerServicesHeaderDetailXml.children()[i].sequence.toString();
 				newPara.btnRemove.name			=	customerServicesHeaderDetailXml.children()[i].sequence.toString();
 				
 				newPara.lblHeading.text			=	customerServicesHeaderDetailXml.children()[i].heading.toString();
 				newPara.textParagraph.text		=	customerServicesHeaderDetailXml.children()[i].paragraph.toString()
 			
 				if(customerServicesHeaderDetailXml.children()[i].link1_text.toString() != '')
 				{
 					newPara.lb1.label					=	customerServicesHeaderDetailXml.children()[i].link1_text.toString();
 					newPara.lb1.height					=	20;
 					newPara.lb1.visible					=	true;
 				}
 				else
 				{
 					newPara.lb1.height	=	0;
 					newPara.lb1.visible	=	false;	
 				}
 				if(customerServicesHeaderDetailXml.children()[i].link2_text.toString() != '')
 				{
 					newPara.lb2.label					=	customerServicesHeaderDetailXml.children()[i].link2_text.toString();
 					newPara.lb2.height					=	20;
 					newPara.lb2.visible					=	true;
 				}
 				else
 				{
 					newPara.lb2.height	=	0;
 					newPara.lb2.visible	=	false;
 				}
 				if(customerServicesHeaderDetailXml.children()[i].link3_text.toString() != '')
 				{
 					newPara.lb3.label					=	customerServicesHeaderDetailXml.children()[i].link3_text.toString();
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
	
	customerServicesParagraph	=	CustomerServicesParagraphDataEntry(PopUpManager.createPopUp(this,CustomerServicesParagraphDataEntry,true));
	customerServicesParagraph.heading					=	"Define New Section";
	customerServicesParagraph.btnUpdate.addEventListener(MouseEvent.CLICK , CustomerServicesParagraphDataEntrySaveBtnClickHandler);
}
private function btnEditParagraphClickHandler(event:MouseEvent):void
{
	currentSelectedChild	=	dtlLine.rows.children().(sequence.toString() == event.target.name.toString())
	
	customerServicesParagraph	=	CustomerServicesParagraphDataEntry(PopUpManager.createPopUp(this,CustomerServicesParagraphDataEntry,true));
	
	customerServicesParagraph.heading					=	"Edit The Selected Paragraph";
	
 	customerServicesParagraph.tiHeading.text			=			currentSelectedChild.heading.toString()
	customerServicesParagraph.textParagraph.text		=			currentSelectedChild.paragraph.toString()
	customerServicesParagraph.tiLink1.text				=			currentSelectedChild.link1_text.toString()
	customerServicesParagraph.tiLink2.text				=			currentSelectedChild.link2_text.toString()
	customerServicesParagraph.tiLink3.text				=			currentSelectedChild.link3_text.toString()
	
	customerServicesParagraph.btnUpdate.addEventListener(MouseEvent.CLICK , CustomerServicesParagraphDataEntrySaveBtnClickHandler);
	
	
	/*COMBOBOX TO BE SELECTED WITH THE GIVEN URL*/
	if(customerServicesParagraph.tiLink1.text != '')
	{
		for(var i:int=0 ; i< customerServicesParagraph.cmbUrl1.dataProvider.length ; i++)
		{
			if(customerServicesParagraph.cmbUrl1.dataProvider[i].url.toString() == currentSelectedChild.link1_url.toString())
			{
				customerServicesParagraph.cmbUrl1.selectedIndex	=	i;
				break;
			}
		}	
	}
	if(customerServicesParagraph.tiLink2.text != '')
	{
		for(var i:int=0 ; i< customerServicesParagraph.cmbUrl2.dataProvider.length ; i++)
		{
			if(customerServicesParagraph.cmbUrl2.dataProvider[i].url.toString() == currentSelectedChild.link2_url.toString())
			{
				customerServicesParagraph.cmbUrl2.selectedIndex	=	i;
				break;
			}
		}	
	}

	if(customerServicesParagraph.tiLink3.text != '')
	{
		for(var i:int=0 ; i< customerServicesParagraph.cmbUrl3.dataProvider.length ; i++)
		{
			if(customerServicesParagraph.cmbUrl3.dataProvider[i].url.toString() == currentSelectedChild.link3_url.toString())
			{
				customerServicesParagraph.cmbUrl3.selectedIndex	=	i;
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
private function CustomerServicesParagraphDataEntrySaveBtnClickHandler(event:Event):void
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
									<heading>{customerServicesParagraph.tiHeading.text}</heading>
									<paragraph>{customerServicesParagraph.textParagraph.text}</paragraph>
									<link1_text>{customerServicesParagraph.tiLink1.text}</link1_text>
									<link2_text>{customerServicesParagraph.tiLink2.text}</link2_text>
									<link3_text>{customerServicesParagraph.tiLink3.text}</link3_text>
									<link1_url>{customerServicesParagraph.cmbUrl1.selectedItem.url.toString()}</link1_url>
									<link2_url>{customerServicesParagraph.cmbUrl2.selectedItem.url.toString()}</link2_url>
									<link3_url>{customerServicesParagraph.cmbUrl3.selectedItem.url.toString()}</link3_url>
									<sequence>{maxSeqNO}</sequence>
									<main_heading_code>{currentHeadingCode}</main_heading_code>
									<trans_flag>A</trans_flag>
								</row>))
	
	
	var newPara:CustomerServicesParagraphRenderer	= 	new CustomerServicesParagraphRenderer()
 	
 	vbMainContainer.addChild(newPara);
 	
 	newPara.name					=	maxSeqNO.toString();
 	newPara.btnEdit.name			=	maxSeqNO.toString();
 	newPara.btnRemove.name			=	maxSeqNO.toString();
 	
 	++maxSeqNO;
 	
 	newPara.btnEdit.addEventListener(MouseEvent.CLICK, btnEditParagraphClickHandler);
 	newPara.btnRemove.addEventListener(MouseEvent.CLICK, btnRemoveParagraphCilckHandler);
 	
 	newPara.lblHeading.text			=	customerServicesParagraph.tiHeading.text
 	newPara.textParagraph.text		=	customerServicesParagraph.textParagraph.text
 
 	if(customerServicesParagraph.tiLink1.text != '')
 	{
 		newPara.lb1.label					=	customerServicesParagraph.tiLink1.text;
 		newPara.lb1.height					=	20;
 		newPara.lb1.visible					=	true;
 	}
 	else
 	{
 		newPara.lb1.height	=	0;
 		newPara.lb1.visible	=	false;
 	}
 	if(customerServicesParagraph.tiLink2.text != '')
 	{
 		newPara.lb2.label					=	customerServicesParagraph.tiLink2.text;
 		newPara.lb2.height					=	20;
 		newPara.lb2.visible					=	true;
 	}
 	else
 	{
 		newPara.lb2.height	=	0;
 		newPara.lb2.visible	=	false;
 			
 	}
 	if(customerServicesParagraph.tiLink3.text != '')
 	{
 		newPara.lb3.label					=	customerServicesParagraph.tiLink3.text;
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
	currentSelectedChild.heading		=	customerServicesParagraph.tiHeading.text
	currentSelectedChild.paragraph		=	customerServicesParagraph.textParagraph.text
	currentSelectedChild.link1_text			=	customerServicesParagraph.tiLink1.text
	currentSelectedChild.link2_text			=	customerServicesParagraph.tiLink2.text
	currentSelectedChild.link3_text			=	customerServicesParagraph.tiLink3.text
	currentSelectedChild.link1_url			=	customerServicesParagraph.cmbUrl1.selectedItem.url.toString()
	currentSelectedChild.link2_url			=	customerServicesParagraph.cmbUrl2.selectedItem.url.toString()
	currentSelectedChild.link3_url			=	customerServicesParagraph.cmbUrl3.selectedItem.url.toString()
	
  
  /*UPDATING CONTROL*/
  	var selectedParagraph:CustomerServicesParagraphRenderer	=	CustomerServicesParagraphRenderer(vbMainContainer.getChildByName(currentSelectedChild.sequence.toString()))
  	
 	selectedParagraph.lblHeading.text			=	customerServicesParagraph.tiHeading.text
 	selectedParagraph.textParagraph.text		=	customerServicesParagraph.textParagraph.text
 
 	if(customerServicesParagraph.tiLink1.text != '')
 	{
 		selectedParagraph.lb1.label		=	customerServicesParagraph.tiLink1.text ;
 		selectedParagraph.lb1.height	=	20;
 		selectedParagraph.lb1.visible	=	true;
 	}
 	else
 	{
 		selectedParagraph.lb1.height	=	0;
 		selectedParagraph.lb1.visible	=	false;
 	}
 	if(customerServicesParagraph.tiLink2.text != '')
 	{
 		selectedParagraph.lb2.label		=	customerServicesParagraph.tiLink2.text;
 		selectedParagraph.lb2.height	=	20;
 		selectedParagraph.lb2.visible	=	true;
 	}
 	else
 	{
 		selectedParagraph.lb2.height	=	0;
 		selectedParagraph.lb2.visible	=	false;
 	}
 	if(customerServicesParagraph.tiLink3.text != '')
 	{
 		selectedParagraph.lb3.label		=	customerServicesParagraph.tiLink3.text
 		selectedParagraph.lb3.height	=	20;
 		selectedParagraph.lb3.visible	=	true;
 	}
 	else
 	{
 		selectedParagraph.lb3.height	=	0;
 		selectedParagraph.lb3.visible	=	false;
 	}		 
}
private  function preSaveHeadingDetail():void
{
	for(var i:int = 0 ; i< dtlLine.rows.children().length(); i++)
	{
		dtlLine.rows.children()[i].sequence	=	i+1;
	}
	saveHeadingDetail() 
}
private function saveHeadingDetail():void
{
		var service:HTTPService = __genModel.services.getHTTPService("saveHeadingDetail");
	
		setDataService(service);
	
		service.addEventListener(ResultEvent.RESULT, saveHeadingDetailResultHandler)													
		service.addEventListener(FaultEvent.FAULT, faultHandler)
	
	
		CursorManager.setBusyCursor();
		Application.application.enabled	= false;
		
		service.send(dtlLine.rows);
}
private function saveHeadingDetailResultHandler(event:ResultEvent):void
{
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			
			var _resultXml:XML;

			_resultXml = (XML)(event.result.toString());
			//Alert.show(_resultXml);
		
			if(_resultXml.name() == "errors")
			{
				if(_resultXml.children().length() > 0) 
				{
					var message:String = '';
			
					for(var i:uint = 0; i < _resultXml.children().length(); i++) 
					{
						message += _resultXml.children()[i] + "\n";
					}
					Alert.show(message);
				} 
			}
			else
			{
				dtlLine.deletedRows	=	new XML('<' + dtlLine.rootNode + '/>');
				vbMainContainer.removeAllChildren(); 	
				
				dtlLine.rows	=	setCompanySpecificParameter(_resultXml);
				onResults_CustomerServicesData(dtlLine.rows) 
			}	
}
private function btnResetAllClickHandler():void
{
		var service:HTTPService = __genModel.services.getHTTPService("getDefaultHeadingDetail");
	
		setDataService(service);
	
		service.addEventListener(ResultEvent.RESULT, getDefaultPolicyHandler)													
		service.addEventListener(FaultEvent.FAULT, faultHandler)
	
		CursorManager.setBusyCursor();
		Application.application.enabled	= false;
		
		service.send(new XML(<params><main_heading_code>{currentHeadingCode}</main_heading_code></params>));
	// we have to call service for reseting to default privacy policy;
}
private function getDefaultPolicyHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;
	
	dtlLine.rows			=	setCompanySpecificParameter(XML(event.result));
	dtlLine.deletedRows		=	new XML('<' + dtlLine.rootNode + '/>');
	
	vbMainContainer.removeAllChildren(); //beacause this function will aslo be called after save.	
	onResults_CustomerServicesData(dtlLine.rows) 
}
private function setCompanySpecificParameter(customerServicesHeaderDetailXml:XML):XML
{
	var temp:String;
	 			
 	for(var i:int=0 ; i < customerServicesHeaderDetailXml.children().length() ;i++ )
 	{
 		temp	=	customerServicesHeaderDetailXml.children()[i].paragraph.toString();
 		while(temp.search('##companyshortname##') != -1)
 		{
 			temp	=	temp.replace('##companyshortname##', __genModel.user.company_name.toString());	
 		}
 		while(temp.search('##privacypolicycontactno##') != -1)
 		{
 			temp	=	temp.replace('##privacypolicycontactno##', __genModel.user.complc_phone.toString());	
 		}
 		while(temp.search('##privacypolicyemail##') != -1)
 		{
 			temp	=	temp.replace('##privacypolicyemail##', __genModel.user.complc_email.toString());	
 		}
 		
 		customerServicesHeaderDetailXml.children()[i].paragraph	=	temp.toString();
 	}

	return customerServicesHeaderDetailXml;
}
private function btnArrangeInSequenceClickHandler():void
{
	var sequenceManagerObj:CustomerServicesSequenceManager	=	CustomerServicesSequenceManager(PopUpManager.createPopUp(this,CustomerServicesSequenceManager,true));
	sequenceManagerObj.dgSource.dataProvider			=	dtlLine.rows.children();
	sequenceManagerObj.btnSave.addEventListener(MouseEvent.CLICK , customerServicesSequenceManagerSaveBtnClickHandler)
}
private function customerServicesSequenceManagerSaveBtnClickHandler(event:MouseEvent):void
{
	recordStatusEvent = new	RecordStatusEvent("MODIFY");
	recordStatusEvent.dispatch();	
	vbMainContainer.removeAllChildren(); 
	onResults_CustomerServicesData(dtlLine.rows) 
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

