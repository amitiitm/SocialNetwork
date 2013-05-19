import business.events.RecordStatusEvent;

import com.adobe.cairngorm.business.ServiceLocator;
import com.generic.events.AddEditEvent;
import com.generic.genclass.TreeFormatter;

import flash.events.Event;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.core.Application;
import mx.core.UIComponent;
import mx.events.DragEvent;
import mx.managers.CursorManager;
import mx.managers.DragManager;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
private var __locator:ServiceLocator = GenModelLocator.getInstance().services;
private var __getElementService:HTTPService;
private var __saveService:HTTPService;

[Bindable]
private var elementXML:XML = new XML(<element element_name="All" element_id="All" element_type="All"/>);

[Bindable]
private var treeXML:XML = new XML(<element element_name="All" element_id="All" element_type="All"/>);
 
private var listHierarchy:XML;
private var masterElementXML:XML; 
private var masterStruXml:XML;

private var recordStatusEvent:RecordStatusEvent;

[Embed(source="com/generic/assets/DottedWithout_Text.png")]
private const GROUP_HEADER_BLANK:Class;

[Embed(source="com/generic/assets/DottedWith_Text.png")]
private const GROUP_HEADER_WITH_DATA:Class;

public function init():void
{
	loadElementXml();
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	var tempXml:XML = new XML(<elements />);

	tempXml.appendChild((XMLList)(dgHierarchy.dataProvider));

	listHierarchy = tempXml;
	
	if(elementXML.children().length() > 0)
	{
		treeXML = decodeXml(listHierarchy)
		hlTree.dataProvider	=	treeXML.children();
		if(treeXML.children().length() > 0)
		{
			hlTree.selectedItem			=		treeXML.children()[0];
			trHierarchies.dataProvider	=		XML(hlTree.selectedItem)
		}
	} 
} 

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var tempXml:XML;
	var temp1Xml:XML;
	tempXml = encodeXml(temp1Xml);
	dgHierarchy.rows = tempXml;

	return 0;
}

public function loadElementXml():void
{
	CursorManager.setBusyCursor();
	Application.application.enabled = false;
	
	var callbacksGetElement:IResponder = new mx.rpc.Responder(getElementResultHandler, faultHandler);
	
	__getElementService = __locator.getHTTPService("getElementService");
	dataService(__getElementService);

	var token:AsyncToken = __getElementService.send(elementXML);
	token.addResponder(callbacksGetElement);
}

public function getElementResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled	= true;
	
	masterElementXML = XML(event.result);
	masterStruXml = generateXml(XML(event.result));
	elementXML = generateXml(XML(event.result));
	
	if(dgHierarchy.rows.length() != 0)
//	if(treeXML.children().length() != 0)
	{
		treeXML = decodeXml(listHierarchy)
		hlTree.dataProvider	=	treeXML.children();
		if(treeXML.children().length() > 0)
		{
			hlTree.selectedItem			=		treeXML.children()[0];
			trHierarchies.dataProvider	=		XML(hlTree.selectedItem)
		}
	}
}

public function getHierarchyResultHandler(event:ResultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled	= true;

	listHierarchy = XML(event.result)
	treeXML = decodeXml(listHierarchy)
	trHierarchies.dataProvider = treeXML.children();
}

public function saveRecordHandler(event:ResultEvent):void
{
	Alert.show("Record Saved");
	CursorManager.removeBusyCursor();
	Application.application.enabled	= true;
}

private function faultHandler(event:FaultEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled	= true;

	Alert.show(event.fault.toString());
}

public function dataService(service:HTTPService):HTTPService
{
	service.resultFormat = "e4x";
	service.method = "POST";
	service.useProxy = false;
	service.contentType="application/xml";

	return service;
}

public function onElementTreeDragEnter(event:DragEvent):void
{
	hlTree.dropEnabled			=	false; //for swaping in horizontal list
	DragManager.acceptDragDrop(event.target as UIComponent);
}

private function onElementTreeDragDrop(event:DragEvent):void
{
	if(event.dragInitiator.name == "trHierarchies"  || event.dragInitiator.name == "hlTree")
	{
		trElements.dataProvider = null;
		elementXML = masterStruXml.copy();
		trElements.dataProvider = elementXML;
		trElements.showDropFeedback(event);
	}
	if(event.dragInitiator.name == "hlTree")
	{
		trHierarchies.dataProvider	=	null;
	}
}

private function onHLTreeDragEnter(event:DragEvent):void
{
	hlTree.dragMoveEnabled	=	true;
	DragManager.acceptDragDrop(event.target as UIComponent);
	recordStatusEvent = new RecordStatusEvent("MODIFY")
	recordStatusEvent.dispatch();
}
private function onHierarchyTreeDragEnter(event:DragEvent):void
{
	hlTree.dropEnabled	=	false;//for swaping in horizontal list
	DragManager.acceptDragDrop(event.target as UIComponent);
	recordStatusEvent = new RecordStatusEvent("MODIFY")
	recordStatusEvent.dispatch();
}
private function showClickedItemInTree(event:Event):void
{
	trHierarchies.dataProvider	=		XML(hlTree.selectedItem)
}
private function onHorizontalListDragDrop(event:DragEvent):void
{
	
	var listItemXml:XML
	var tempXml:XML;
	
	hlTree.dragMoveEnabled	=	true;;	
	
	if(event.dragInitiator.name == "hlTree")//for swaping in horizontal list
	{
		hlTree.dropEnabled			=	true;
		trHierarchies.dataProvider	=	null;
		recordStatusEvent = new RecordStatusEvent("MODIFY")
		recordStatusEvent.dispatch();
	}
	else if(event.dragInitiator.name == "trElements")
	{
	
		listItemXml = new XML(trElements.selectedItem)
		tempXml =new XML(<element/>);
		tempXml.@['element_name'] = listItemXml.@element_name;
		tempXml.@['element_id'] = listItemXml.@element_id;
		tempXml.@['element_type'] = listItemXml.@element_type;
	
		listItemXml = new XML(<element></element>)
		
		listItemXml.appendChild(tempXml)
	
	 	if(!existAsSibling(listItemXml,treeXML))
		{
			var dropIndex:int	=	hlTree.calculateDropIndex(event);
			if(dropIndex == 0)
			{
				treeXML.prependChild(tempXml);
			}
			else
			{
				treeXML.insertChildAfter(treeXML.children()[dropIndex -1],	tempXml)
			}
			
			
			hlTree.dataProvider			=	treeXML.children();
			hlTree.selectedItem			=	treeXML.children()[dropIndex];
			
			trHierarchies.dataProvider	=	XML(hlTree.selectedItem);
		}  

		recordStatusEvent = new RecordStatusEvent("MODIFY")
		recordStatusEvent.dispatch();
	}

}
private function onHierarchyTreeDragDrop(event:DragEvent):void
{
	hlTree.dragMoveEnabled	=	false;
	
	if(hlTree.selectedItem	==	null)
	{
		return;
	}
	if(event.dragSource.hasFormat("treeItems") && event.dragInitiator.name == "trElements")
	{
		var listItemXml:XML
		var treeItemXml:XML;
		var tempXml:XML;
		
		
		if(event.dragInitiator.name == "trElements")
		{
			listItemXml = new XML(trElements.selectedItem)
		}
		else if(event.dragInitiator.name == "trHierarchies")
		{
			listItemXml = new XML(trHierarchies.selectedItem)			
		}
				
		tempXml =new XML(<element/>);
		tempXml.@['element_name'] = listItemXml.@element_name;
		tempXml.@['element_id'] = listItemXml.@element_id;
		tempXml.@['element_type'] = listItemXml.@element_type;

		listItemXml = new XML(<element></element>)
		listItemXml.appendChild(tempXml)
					
		if(trHierarchies.selectedIndex >= 0)//if child is selected then appnend under that child
		{
			treeItemXml = XML(trHierarchies.selectedItem);

		   	if(!existAsSibling(listItemXml,treeItemXml) && !existAsParent(listItemXml,treeItemXml) )
		   	{
				 XML(trHierarchies.selectedItem).appendChild(tempXml);
			}
		}
		else//otherwise append under first level.
		{
			treeItemXml 				= XML(hlTree.selectedItem);
			//trHierarchies.selectedItem	= XML(hlTree.selectedItem);	
			if(!existAsSibling(listItemXml,treeItemXml) && !existAsParent(listItemXml,treeItemXml) )
		   	{
				XML(hlTree.selectedItem).appendChild(tempXml);
			  	trHierarchies.dataProvider	=	XML(hlTree.selectedItem)
			}  
		}
		recordStatusEvent = new RecordStatusEvent("MODIFY")
		recordStatusEvent.dispatch();
	}
	trHierarchies.expandItem(trHierarchies.selectedItem as Object,true);// to expand tree item
}

private function existAsSibling(listItemXml:XML,treeItemXml:XML):Boolean
{
	for(var i:int=0;i<treeItemXml.children().length();i++)
	{
		if(treeItemXml.children()[i].@element_id.toString()==listItemXml.children()[0].@element_id.toString())
		{
			return true;
		}
	}
	return false;
}

private function existAsParent(listItemXml:XML,treeItemXml:XML):Boolean
{
	var ary:Array = new Array();
	var tObj:Object;
	var aObj:Object;
	
	tObj = trHierarchies.selectedItem;
	
	if(trHierarchies.selectedItem	==	null)
	{
		tObj = hlTree.selectedItem;
	}
	
	if(hlTree.selectedItem.@element_id.toString() == listItemXml.children()[0].@element_id.toString())
	{
		return true
	}
	
	while(tObj != null)
	{
		aObj = new Object();
		aObj.name = tObj.@element_name;
		aObj.value = tObj.@element_id;
		aObj.type	=tObj.@element_type;

		if(!(aObj.element_name == 'All' && aObj.value == 'ALL'))
		{
			ary.push(aObj);
		}
		
		tObj = trHierarchies.getParentItem(tObj);
	}

	for(var i:int=0; i<ary.length; i++)
	 {
	 	if(ary[i].value == listItemXml.children()[0].@element_id.toString())
	 	{
	 		return true
	 	}
	 }
	return false;
}

private function decodeXml(encodedXml:XML):XML
{
	var treeFormatterObj:TreeFormatter = new TreeFormatter();
    return	treeFormatterObj.decode(encodedXml,masterElementXML);
}

private function encodeXml(decodedXml:XML):XML
{
	var treeFormatterObj:TreeFormatter = new TreeFormatter();
    return	treeFormatterObj.encode(treeXML);
}

private function generateXml(aXML:XML):XML
{
	var rootTagXml:XML = new XML(<element element_name="All" element_id="All" element_type="All"/>)
	var childTagXml:XML;
	var tempXml:XML;
	
	if (aXML != null )
	{
		for(var i:int=0; i < aXML.children().length(); i++)
		{
			tempXml = new XML(<element/>);
			tempXml.@['element_name'] = aXML.children()[i].element_name;
			tempXml.@['element_id'] = aXML.children()[i].element_id;
			tempXml.@['element_type'] = aXML.children()[i].element_type;
			
			if(aXML.children()[i].element_type == 'A')
			{
				i = i + 1;

				while(i < aXML.children().length() && aXML.children()[i].element_type == 'V')
				{
					childTagXml =new XML(<element/>);
					childTagXml.@['element_name'] = aXML.children()[i].element_name;
					childTagXml.@['element_id'] = aXML.children()[i].element_id;
					childTagXml.@['element_type'] = aXML.children()[i].element_type;
					
					tempXml.appendChild(childTagXml);
					i = i + 1;
				}
				rootTagXml.appendChild(tempXml);
				i  = i - 1;	
			}	
		}
	}
	
	return rootTagXml;
}
private function changeBackgroundImage():void
{
	if(hlTree.dataProvider.length > 0)
	{
		hlTree.setStyle("backgroundImage",GROUP_HEADER_BLANK);
	}
	else
	{
		hlTree.setStyle("backgroundImage",GROUP_HEADER_WITH_DATA);
	}

}