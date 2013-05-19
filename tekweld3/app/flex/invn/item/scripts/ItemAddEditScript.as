import business.events.GetInformationEvent;
import business.events.RecordStatusEvent;

import com.generic.customcomponents.GenDataGrid;
import com.generic.events.AddEditEvent;
import com.generic.events.GenUploadButtonEvent;

import flash.net.FileReference;

import invn.item.ItemModelLocator;
import invn.item.components.ItemAddAttribtePopWindow;

import model.GenModelLocator;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.events.DataGridEvent;
import mx.events.DragEvent;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.rpc.IResponder;

import saoi.muduleclasses.CommonArtworkXml;
import saoi.muduleclasses.event.MissingInfoEvent;

private var getInformationEvent:GetInformationEvent;
private var fileReference:FileReference = new FileReference();
private static var uploadServiceUrl:String;
private var XMLDgGroup:XML;
[Bindable]
private var setupItem:Boolean = true;
[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:ItemModelLocator = ItemModelLocator(__genModel.activeModelLocator);
[Bindable]
private var image_name:String;
private var fetch_flag:Boolean = false;
private var column:int = 0;
private var dropLoc:int = 0 ;
private var fromDragDrop:Boolean	= false;
private var columnArray:ArrayCollection = new ArrayCollection();
private var columnIndex:int=0;
public var recordStatusEnabled:Boolean = true;
private var recordStatusEvent:RecordStatusEvent;
private var attribute_xml:XML
[Bindable]
private var isDistribtedByLabel:String = "Is \"Distribted By\" Applicable ?";

[Embed("com/generic/assets/add.png")]
private const addButtonIcon:Class;

[Embed("com/generic/assets/add_disabled.png")]
private const add_disabledButtonIcon:Class;

[Embed("com/generic/assets/delete.png")]
private const deleteButtonIcon:Class;

[Embed("com/generic/assets/delete_disabled.png")]
private const delete_disabledButtonIcon:Class;
private var itemAddAttribtePopWindow:ItemAddAttribtePopWindow;

private var commonartworkXml:CommonArtworkXml   			= new CommonArtworkXml(); 

private function getAttributeLookup():void
{
	var callbacks:IResponder = new mx.rpc.Responder(catalogAttributeValueLookupResultHandler,null);
	getInformationEvent = new GetInformationEvent('catalog_attribute_value_lookup',callbacks,__genModel.user.userID,__genModel.user.default_company_id);
	getInformationEvent.dispatch();	
}
private function catalogAttributeValueLookupResultHandler(resultXml:XML):void
{
	attribute_xml = resultXml;
}

private function editRowEventHandler():void
{
	itemAddAttribtePopWindow 			 = ItemAddAttribtePopWindow(PopUpManager.createPopUp(this,ItemAddAttribtePopWindow,true));
	itemAddAttribtePopWindow.x			 = ((Application.application.width/2)-(itemAddAttribtePopWindow.width/2));
	itemAddAttribtePopWindow.y			 = ((Application.application.height/2)-(itemAddAttribtePopWindow.height/2));
	itemAddAttribtePopWindow.orderDetail = new XML(<orderDetail>{dgAttribute.rows}</orderDetail>);
	
	itemAddAttribtePopWindow.addEventListener(MissingInfoEvent.MissingInfoEvent_Type,missingInfoSave);
}
private function missingInfoSave(event:MissingInfoEvent):void
{
	var xmlMissingInfo:XML					= event.xml;
	
	var tempXml:XML							= dgAttribute.rows.copy();
	tempXml.appendChild(xmlMissingInfo);
	
	dgAttribute.rows						= tempXml;
}
private function removeRowEventHandler():void
{
	deleteRow(dgAttribute.selectedIndex);
}
// VD 14/03/2011
public function deleteRow(row:int):void
{
	if(!dgAttribute.viewOnlyFlag)
	{
		if(row >= 0)
		{	
			var tempXml:XML;
			var dgDtlRow:XML = new XML(dgAttribute.dataProvider[row]);
			var node:String = dgDtlRow.localName();
			var deleteChild:XML	=	new XML(dgDtlRow);
			
			deleteChild.trans_flag1 = "D";
			
			if(__localModel.addEditObj.record!=null)
			{
				var catalog_item_id:String 	 = 	deleteChild.child('catalog_item_id').toString();
				var record_item_id:String    = 	__localModel.addEditObj.record.children()[0].id.toString();
				
				if(catalog_item_id == record_item_id)
				{
					if(XML(dgAttribute.deletedRows).children().length()<=0)
					{
						dgAttribute.deletedRows	 = new XML(<catalog_item_attributes_values></catalog_item_attributes_values>);
					}
					var tempDeletedRows:XML		= XML(dgAttribute.deletedRows).copy();
					tempDeletedRows.appendChild(deleteChild.copy());
					dgAttribute.deletedRows		= tempDeletedRows.copy();
					
					//XML(dgAttribute.deletedRows).appendChild(deleteChild.copy());       // its means we have to send database with trans_flag = 'D'
				} 
			}

			delete dgAttribute.rows.child(node)[row];	
			tempXml	=  new XML(XML(dgAttribute.rows).copy());
			dgAttribute.rows	=	tempXml; 
			
			if(recordStatusEnabled)
			{
				recordStatusEvent = new	RecordStatusEvent("MODIFY");
				recordStatusEvent.dispatch();
			}
		}
	} 
}

private function setToolTip():void
{
	setValueGridDragDrop();
	setColumnsOrder();
	for(var i:int=0; i<dtlPriceQuantity.dgDtl.columnCount;i++)
	{
		DataGridColumn(dtlPriceQuantity.dgDtl.columns[i]).showDataTips = true;
		if(i==2)
		{
			DataGridColumn(dtlPriceQuantity.dgDtl.columns[i]).dataTipFunction = makeToolTip1;
		}
		if(i==3)
		{
			DataGridColumn(dtlPriceQuantity.dgDtl.columns[i]).dataTipFunction = makeToolTip2;
		}
		if(i==4)
		{
			DataGridColumn(dtlPriceQuantity.dgDtl.columns[i]).dataTipFunction = makeToolTip3;
		}
		if(i==5)
		{
			DataGridColumn(dtlPriceQuantity.dgDtl.columns[i]).dataTipFunction = makeToolTip4;
		}
		if(i==6)
		{
			DataGridColumn(dtlPriceQuantity.dgDtl.columns[i]).dataTipFunction = makeToolTip5;
		}
		if(i==7)
		{
			DataGridColumn(dtlPriceQuantity.dgDtl.columns[i]).dataTipFunction = makeToolTip6;
		}
		if(i==8)
		{
			DataGridColumn(dtlPriceQuantity.dgDtl.columns[i]).dataTipFunction = makeToolTip7;
		}
		if(i==9)
		{
			DataGridColumn(dtlPriceQuantity.dgDtl.columns[i]).dataTipFunction = makeToolTip8;
		}
		if(i==10)
		{
			DataGridColumn(dtlPriceQuantity.dgDtl.columns[i]).dataTipFunction = makeToolTip9;
		}
		if(i==11)
		{
			DataGridColumn(dtlPriceQuantity.dgDtl.columns[i]).dataTipFunction = makeToolTip10;
		}
		if(i==12)
		{
			DataGridColumn(dtlPriceQuantity.dgDtl.columns[i]).dataTipFunction = makeToolTip11;
		}
		if(i==13)
		{
			DataGridColumn(dtlPriceQuantity.dgDtl.columns[i]).dataTipFunction = makeToolTip12;
		}
		if(i==14)
		{
			DataGridColumn(dtlPriceQuantity.dgDtl.columns[i]).dataTipFunction = makeToolTip13;
		}
		if(i==15)
		{
			DataGridColumn(dtlPriceQuantity.dgDtl.columns[i]).dataTipFunction = makeToolTip14;
		}
		if(i==16)
		{
			DataGridColumn(dtlPriceQuantity.dgDtl.columns[i]).dataTipFunction = makeToolTip15;
		}
	}

}

private function makeToolTip1(item:Object):String
{
	return tiColumn1.text
}
private function makeToolTip2(item:Object):String
{
	return tiColumn2.text
}
private function makeToolTip3(item:Object):String
{
	return tiColumn3.text
}
private function makeToolTip4(item:Object):String
{
	return tiColumn4.text
}
private function makeToolTip5(item:Object):String
{
	return tiColumn5.text
}
private function makeToolTip6(item:Object):String
{
	return tiColumn6.text
}
private function makeToolTip7(item:Object):String
{
	return tiColumn7.text
}
private function makeToolTip8(item:Object):String
{
	return tiColumn8.text
}
private function makeToolTip9(item:Object):String
{
	return tiColumn9.text
}
private function makeToolTip10(item:Object):String
{
	return tiColumn10.text
}
private function makeToolTip11(item:Object):String
{
	return tiColumn11.text
}
private function makeToolTip12(item:Object):String
{
	return tiColumn12.text
}
private function makeToolTip13(item:Object):String
{
	return tiColumn13.text
}
private function makeToolTip14(item:Object):String
{
	return tiColumn14.text
}
private function makeToolTip15(item:Object):String
{
	return tiColumn15.text
}


private function itemTypeChangedHandler():void
{
	if(cbItem_type.selectedItem.value=='I')
	{
		setupItem = true;
	}
	else
	{
		setupItem = false;
	}
	
	if(cbItem_type.selectedItem.value=='C' ||cbItem_type.selectedItem.value=='I')    // for accessories item column by  pricing
	{
		vbColumn.enabled 	= true;
		hbPrice.enabled 	= true;
	}
	else if(cbItem_type.selectedItem.value=='S')
	{
		hbPrice.enabled 	= true;
		vbColumn.enabled	= false;
	}
	else
	{
		vbColumn.enabled 	= false;
		hbPrice.enabled 	= false;
	}	
	
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var returnValue:int=0;
	if(cbItem_type.dataValue=='I' && cbWorkflow.dataValue=='')
	{
		Alert.show("select a workflow for the item.");
		returnValue  = -1;
	}
	return returnValue;
}

override protected function retrieveRecordEventHandler(event:AddEditEvent):void 
{
	itemTypeChangedHandler();
	tiStore_code.enabled = false;
	
	fetch_flag = true;
	
	if(dgAttribute.rows.children().length() > 0)
	{
		dgAttribute.selectedIndex = 0
	}	
	
	filterValue()
	
	setSelectedValue()
	setImages();
	setValueGridDragDrop();
	
	dgAttribute.deletedRows	 = new XML(<catalog_item_attributes_values></catalog_item_attributes_values>);
	setDefaultShipperFilter(false);
}

override protected function resetObjectEventHandler():void
{
	itemTypeChangedHandler();
	tiStore_code.enabled = true;
	filterValue()
	setImages();
	dgAttribute.deletedRows	 = new XML(<catalog_item_attributes_values></catalog_item_attributes_values>);
	setDefaultShipperFilter(true);
}

private function handleItemChangedItem_Category():void
{
	getAttributes()
}

private function getAttributes():void
{
	if(dcCatalog_item_category_id.text != "" && dcCatalog_item_category_id.text != null)
	{
		var callbacks:IResponder = new mx.rpc.Responder(attributeListHandler, null);
		
		getInformationEvent = new GetInformationEvent('item_category_attributes_info', callbacks, dcCatalog_item_category_id.dataValue);
		getInformationEvent.dispatch(); 
	}
}

private function attributeListHandler(resultXml:XML):void
{
	if(resultXml.children().length() > 0)
	{
		dgAttribute.rows = resultXml;
		dgAttribute.selectedIndex = 0
	
		filterValue()
		setSelectedValue()
	}
	else
	{
		dgAttribute.rows = new XML("<" + dgAttribute.rootNode + "></" + dgAttribute.rootNode + ">");
	}
}

private function filterValue():void
{
	var strValue:String = '';

	if(dgAttribute.selectedRow != null)
	{
		strValue = dgAttribute.selectedRow['catalog_attribute_id'].toString();
	}
		
	//var attributeValues:XMLList 	= __genModel.lookupObj.catalogattributevalue.children().copy();
	
	if(attribute_xml != null)
	{
		var attributeValues:XMLList 	= 	attribute_xml.children().copy();
	
		for(var k:int=0;k<attributeValues.length();k++)
		{
			attributeValues[k].default_value	= "N";
			attributeValues[k].select_yn		= "N";
		}
		
		var filteredValues:XMLList = attributeValues.(elements('catalog_attribute_id') == strValue);
		var xml:XML = new XML(<rows></rows>);
		
		xml.appendChild(filteredValues);
		dgValues.rows = xml;
	}
}

private function handleValuesFocusOut(event:DataGridEvent):void
{
	if(event.currentTarget == dgValues)
	{
		var str:String = dgValues.selectedRow['select_yn'].toString()
		
		if(str == 'Y')
		{
			for(var i:int=0; i < dgValues.dataProvider.length; i++)
			{
				if(i == event.rowIndex)
				{ 
					if(dgAttribute.selectedRow.child('attribute_values').length() == 0)
					{
						dgAttribute.selectedRow.appendChild(new XML(<attribute_values/>));
					} 
					
					var attributeValue:XML = new XML(<attribute_value/>);
					
					attributeValue.catalog_attribute_value_id = dgValues.dataProvider[i]['id'].toString() ;
					attributeValue.value_name				  = dgValues.dataProvider[i]['name'].toString();
					attributeValue.default_value			  = dgValues.dataProvider[i]['default_value'].toString();

					if(dgAttribute.selectedRow.attribute_values.attribute_value.(catalog_attribute_value_id == dgValues.dataProvider[i]['id'].toString()).catalog_attribute_value_id.toString() == ''  )
					{
						dgAttribute.selectedRow.attribute_values.appendChild(attributeValue);
					}
					
					var attr_xml:XMLList = dgAttribute.selectedRow.child('attribute_values').attribute_value;
					
					for(var j:int = 0; j < attr_xml.length() ; j++)
					{
						if(attr_xml[j].catalog_attribute_value_id.toString() == dgValues.dataProvider[i]['id'].toString() && fetch_flag)
						{
							dgAttribute.selectedRow.child('attribute_values').attribute_value[j].trans_flag = 'A'
						}
						
					}
					var dgValueXml:XML = new XML(<dgvalue></dgvalue>);
					 {
					 	if(dgValues.rows.row.hasOwnProperty('select_yn'))
					 	{
					 		dgValueXml.appendChild(dgValues.rows.row.(select_yn=='Y'));
							if(dgValueXml.children().length()==1)
							{
								dgValues.selectedItem = dgValueXml.children()[0];
								dgValues.selectedRow.default_value='Y';
								var attr_xml:XMLList = dgAttribute.selectedRow.child('attribute_values').attribute_value;
								for(var k:int=0;k<attr_xml.length();k++)
								{
									if(attr_xml[k].catalog_attribute_value_id.toString() == dgValues.selectedRow.id.toString())
									dgAttribute.selectedRow.child('attribute_values').attribute_value[k].default_value = 'Y';
								}
								
							} 
					 		
					 	}
					 }
				}
				
			}
			
			var def_str:String = dgValues.selectedRow['default_value'].toString()
			
			if(def_str == 'Y')
			{
				var attr_xml:XMLList = dgAttribute.selectedRow.child('attribute_values').attribute_value;
					
					for(var j:int = 0; j < attr_xml.length() ; j++)
					{
						dgAttribute.selectedRow.child('attribute_values').attribute_value[j].default_value = 'N'
						if(dgAttribute.selectedRow.child('attribute_values').attribute_value[j].catalog_attribute_value_id==dgValues.selectedRow.id.toString())
						{
							dgAttribute.selectedRow.child('attribute_values').attribute_value[j].default_value = 'Y'	
						}
					}
					
					for(var k:int=0; k < dgValues.dataProvider.length; k++)
					{
						dgValues.dataProvider[k]['default_value'] = 'N';
					}
					dgValues.dataProvider[event.rowIndex]['default_value'] = 'Y';
					
			}
			else
			{
				var attr_xml:XMLList = dgAttribute.selectedRow.child('attribute_values').attribute_value;
					
					for(var j:int = 0; j < attr_xml.length() ; j++)
					{
						if(attr_xml[j].catalog_attribute_value_id.toString() == dgValues.dataProvider[event.rowIndex]['id'].toString())
						{
							 if(dgAttribute.selectedRow.child('attribute_values').children().length()==1)
							{
								dgAttribute.selectedRow.child('attribute_values').attribute_value[j].default_value = 'Y'
							}
							else
							{
								dgAttribute.selectedRow.child('attribute_values').attribute_value[j].default_value = 'N'
							} 
						
						}
					}
				
			}
			
		}
		else if(str == 'N')
		{
			
			for(var i:int=0; i < dgValues.dataProvider.length; i++)
			{
				 if(i == event.rowIndex)
				{
					var attr_xml:XMLList = dgAttribute.selectedRow.child('attribute_values').attribute_value;
					
					for(var j:int = 0; j < attr_xml.length() ; j++)
					{
						if(attr_xml[j].catalog_attribute_value_id.toString() == dgValues.dataProvider[i]['id'].toString())
						{
							if(!fetch_flag)
							{
								delete dgAttribute.selectedRow.child('attribute_values').attribute_value[j];
							}
							else
							{
								dgAttribute.selectedRow.child('attribute_values').attribute_value[j].trans_flag = 'D';
							}
						}
					}
									
					dgValues.dataProvider[event.rowIndex]['default_value'] = 'N';
					
					
				}
				
			}
			 var dgValueXml:XML = new XML(<dgvalue></dgvalue>);
			 {
			 	if(dgValues.rows.row.hasOwnProperty('select_yn'))
			 	{
			 		dgValueXml.appendChild(dgValues.rows.row.(select_yn=='Y'));
					if(dgValueXml.children().length()>0)
					{
						dgValues.selectedItem = dgValueXml.children()[0];
						dgValues.selectedRow.default_value='Y';
						var attr_xml:XMLList = dgAttribute.selectedRow.child('attribute_values').attribute_value;
						for(var k:int=0;k<attr_xml.length();k++)
						{
							if(attr_xml[k].catalog_attribute_value_id.toString() == dgValues.selectedRow.id.toString())
							dgAttribute.selectedRow.child('attribute_values').attribute_value[k].default_value = 'Y';
						}
						
					} 
			 		
			 	}
			 }
			
		}
		
		else if(str=='')
		{
			dgValues.dataProvider[event.rowIndex]['default_value'] = 'N';
		}
	}
	
	cbSelectAll.dataValue	 = isAllValuesSelected();
}

private function handleAttributeItemClick():void
{
	filterValue()
	setSelectedValue()
}

private function setSelectedValue():void
{
	if(dgAttribute.dataProvider.length > 0)
	{
		var attr_xml:XMLList = dgAttribute.selectedRow.child('attribute_values').attribute_value;
		
		for(var i:int=0; i < dgValues.dataProvider.length; i++)
		{
			
		for(var j:int = 0; j < attr_xml.length() ; j++)
		{
			if(attr_xml[j].catalog_attribute_value_id.toString() == dgValues.dataProvider[i]['id'].toString() && attr_xml[j].trans_flag.toString() != 'D')
			{
				dgValues.dataProvider[i]['select_yn'] = 'Y';
				
				if(attr_xml[j].default_value.toString() == 'Y')
				{
					dgValues.dataProvider[i]['default_value'] = 'Y';
				}
			}
		}
		}  
	}
	cbSelectAll.dataValue	 = isAllValuesSelected();
}

private function handleUploadEvent(event:GenUploadButtonEvent):void
{
	CursorManager.removeBusyCursor();
	Application.application.enabled = true;

	var recordStstusEvent:RecordStatusEvent	=	new RecordStatusEvent('MODIFY');
	recordStstusEvent.dispatch();
}

private function handleCompleteEvent(event:GenUploadButtonEvent):void
{
	setImage(event.currentTarget.id);	
}

private function setImages():void
{
	setImage('btnBrowse_imageThumnail')
	setImage('btnBrowse_imageSmall')
	setImage('btnBrowse_imageNormal')
	setImage('btnBrowse_imageEnlarge')
	setImage('btnBrowse_sketchImage1')
	setImage('btnBrowse_sketchImage2')
	setImage('btnBrowse_sketchImage3')
}

private function setImage(str:String):void
{
	switch(str)
	{
		case 'btnBrowse_imageThumnail':
			imageThumnail.source = __genModel.path.image + tiImage_Thumnail.dataValue;	
			break;
			
		case 'btnBrowse_imageSmall':
			imageSmall.source = __genModel.path.image + tiImage_Small.dataValue;	
		    break;

		case 'btnBrowse_imageNormal':
			imageNormal.source = __genModel.path.image + tiImage_Normal.dataValue;	
		    break;                    

		case 'btnBrowse_imageEnlarge':
			imageEnlarge.source = __genModel.path.image + tiImage_Enlarge.dataValue;	
		    break;

		case 'btnBrowse_sketchImage1':
			image1Sketch1.source = __genModel.path.image + tiSketch_image1.dataValue;	
			break;

		case 'btnBrowse_sketchImage2':
			image1Sketch2.source = __genModel.path.image + tiSketch_image2.dataValue;	
		    break;                    

		case 'btnBrowse_sketchImage3':
			image1Sketch3.source = __genModel.path.image + tiSketch_image3.dataValue;	
			break;
	}
}


private function setColumnsOrder():void
{
	if(!isColumnsCorrectOrder())
	{
		var lastColumnValue:int = columnArray.getItemAt(columnIndex).dataValue ;
		for(var i:int=columnIndex;i<columnArray.length;i++)
		{
			columnArray.getItemAt(i).dataValue = lastColumnValue.toString();
		}
	}
}


private function isColumnsCorrectOrder():Boolean
{
	columnArray.removeAll();
	columnArray.addItem(tiColumn1);
	columnArray.addItem(tiColumn2);
	columnArray.addItem(tiColumn3);
	columnArray.addItem(tiColumn4);
	columnArray.addItem(tiColumn5);
	columnArray.addItem(tiColumn6);
	columnArray.addItem(tiColumn7);
	columnArray.addItem(tiColumn8);
	columnArray.addItem(tiColumn9);
	columnArray.addItem(tiColumn10);
	columnArray.addItem(tiColumn11);
	columnArray.addItem(tiColumn12);
	columnArray.addItem(tiColumn13);
	columnArray.addItem(tiColumn14);
	columnArray.addItem(tiColumn15);

	
	var returnValue:Boolean = true;
	for(var i:int=0;i<columnArray.length-1;i++)
	{
		if(Number(columnArray.getItemAt(i).dataValue) > Number(columnArray.getItemAt(i+1).dataValue))
		{
			returnValue = false;
			columnIndex	= i;
			break;
		}
	}
	return returnValue;
}

private function attributeUpdateComplete():void
{
	if(fromDragDrop)
	{
		dgAttribute.selectedIndex = dropLoc;
		handleAttributeItemClick();
		fromDragDrop = false;
	}
	
}

private function attributeDragDrop(event:DragEvent):void
{
	var dropTarget:GenDataGrid=GenDataGrid(event.currentTarget);
	dropLoc = dropTarget.calculateDropIndex(event);
	fromDragDrop = true;
	var recordStatusEvent:RecordStatusEvent  = new RecordStatusEvent('MODIFY');
	recordStatusEvent.dispatch();
}
private function setValueGridDragDrop():void
{
	dgValues.viewOnlyFlag	= true;
	dgValues.editable		= true;
}
private function selectAllRowEventHandler():void
{
	if(cbSelectAll.dataValue=='Y')
	{
		for(var i:int=0;i<dgValues.rows.children().length();i++)
		{
			dgValues.rows.children()[i].select_yn 		= 'Y';
		}
		
		if(!isAnyDefaultValue()&& dgValues.rows.children().length()>0)
		{
			dgValues.rows.children()[0].default_value 	= 'Y';
		}
		
		dgValues.rows   = dgValues.rows;
	}
	else
	{
		for(var i:int=0;i<dgValues.rows.children().length();i++)
		{
			dgValues.rows.children()[i].select_yn 			= 'N';
			dgValues.rows.children()[i].default_value 		= 'N';
		}
		dgValues.rows   = dgValues.rows;
	}
	
	if(dgAttribute.rows.children().length()>0)
	{
		setAttributeValuesXml();
	}
	
}
private function isAllValuesSelected():String
{
	var returnValue:String  = 'Y';
	for(var i:int=0;i<dgValues.rows.children().length();i++)
	{
		if(dgValues.rows.children()[i].select_yn.toString() != 'Y')
		{
			returnValue  = 'N';
			break;
		}
	}
	return returnValue;
}
private function isAnyDefaultValue():Boolean
{
	var returnValue:Boolean  = false;
	for(var i:int=0;i<dgValues.rows.children().length();i++)
	{
		if(dgValues.rows.children()[i].default_value.toString() == 'Y')
		{
			returnValue  = true;
			break;
		}
	}
	return returnValue;
}
private function setAttributeValuesXml():void
{
	var attr_xml:XMLList = dgAttribute.selectedRow.child('attribute_values').attribute_value;
	
	for(var i:int=0;i<dgValues.rows.children().length();i++)
	{
		var select_yn:String					  = dgValues.dataProvider[i]['select_yn'].toString() ;
		
		if(select_yn=='Y')
		{
			var attributeValue:XML = new XML(<attribute_value/>);
			
			attributeValue.catalog_attribute_value_id = dgValues.dataProvider[i]['id'].toString() ;
			attributeValue.value_name				  = dgValues.dataProvider[i]['name'].toString();
			attributeValue.default_value			  = dgValues.dataProvider[i]['default_value'].toString();
			if(dgAttribute.selectedRow.child('attribute_values').length() == 0)
			{
				dgAttribute.selectedRow.appendChild(new XML(<attribute_values/>));
			} 
			for(var j:int = 0; j < attr_xml.length() ; j++)
			{
				if(attr_xml[j].(catalog_attribute_value_id == dgValues.dataProvider[i]['id'].toString()).catalog_attribute_value_id.toString() == '')
				{
					dgAttribute.selectedRow.attribute_values.appendChild(attributeValue);
				}
				if(attr_xml[j].(catalog_attribute_value_id == dgValues.dataProvider[i]['id'].toString()).trans_flag.toString() == 'D'  )
				{
					dgAttribute.selectedRow.attribute_values.trans_flag='A';
				}
			}
			
		}
		else if(select_yn=='N')
		{
			for(var j:int = 0; j < attr_xml.length() ; j++)
			{
				if(attr_xml[j].catalog_attribute_value_id.toString() == dgValues.dataProvider[i]['id'].toString())
				{
					if(!fetch_flag)
					{
						delete dgAttribute.selectedRow.child('attribute_values').attribute_value[j];
					}
					else
					{
						dgAttribute.selectedRow.child('attribute_values').attribute_value[j].trans_flag = 'D';
					}
				}
			}
			
		}
	}
}
override protected function copyRecordCompleteEventHandler():void
{
	resetAssembleItems();
	resetAccesoryItems();
	resetSetupItems();
	resetSetupItems();
	resetOptions();
	resetPackaging();
	resetQuantityPrice();
	resetLevelPrice();
	resetProductionDays();
}

private function resetAssembleItems():void
{
	var rowsXml:XML		= dtlAssemble.dgDtl.rows.copy();
	for(var i:int=0;i<rowsXml.children().length();i++)
	{
		rowsXml.children()[i].catalog_item_id   = '';
	}
	dtlAssemble.dgDtl.rows  = rowsXml;
}
private function resetAccesoryItems():void
{
	var rowsXml:XML		= dtlAccessories.dgDtl.rows.copy();
	for(var i:int=0;i<rowsXml.children().length();i++)
	{
		rowsXml.children()[i].catalog_item_id   = '';
	}
	dtlAccessories.dgDtl.rows  = rowsXml;
}
private function resetSetupItems():void
{
	/*var rowsXml:XML		= dtlSetupCharges.dgDtl.rows.copy();
	for(var i:int=0;i<rowsXml.children().length();i++)
	{
		rowsXml.children()[i].catalog_item_id   = '';
	}
	dtlSetupCharges.dgDtl.rows  = rowsXml;*/
}
private function SilmilarItems():void
{
	var rowsXml:XML		= dtlSimilar_items.dgDtl.rows.copy();
	for(var i:int=0;i<rowsXml.children().length();i++)
	{
		rowsXml.children()[i].catalog_item_id   = '';
	}
	dtlSimilar_items.dgDtl.rows  = rowsXml;
}
private function resetPackaging():void
{
	var rowsXml:XML		= dtlPackaging.dgDtl.rows.copy();
	for(var i:int=0;i<rowsXml.children().length();i++)
	{
		rowsXml.children()[i].catalog_item_id   = '';
	}
	dtlPackaging.dgDtl.rows  = rowsXml;
}
private function resetQuantityPrice():void
{
	var rowsXml:XML		= dtlPriceQuantity.dgDtl.rows.copy();
	for(var i:int=0;i<rowsXml.children().length();i++)
	{
		rowsXml.children()[i].catalog_item_id   = '';
	}
	dtlPriceQuantity.dgDtl.rows  = rowsXml;
}
private function resetLevelPrice():void
{
	/*var rowsXml:XML		= dtlPriceLevel.dgDtl.rows.copy();
	for(var i:int=0;i<rowsXml.children().length();i++)
	{
		rowsXml.children()[i].catalog_item_id   = '';
	}
	dtlPriceLevel.dgDtl.rows  = rowsXml;*/
}

private function resetProductionDays():void
{
	var rowsXml:XML		= dtlProductionDays.dgDtl.rows.copy();
	for(var i:int=0;i<rowsXml.children().length();i++)
	{
		rowsXml.children()[i].catalog_item_id   = '';
	}
	dtlProductionDays.dgDtl.rows  = rowsXml;
	
}
private function resetOptions():void
{
	var rowsXml:XML		= dgAttribute.rows.copy();
	for(var i:int=0;i<rowsXml.children().length();i++)
	{
		rowsXml.children()[i].catalog_item_id   = '';
	}
	dgAttribute.rows  = rowsXml;
}
private function  setDefaultShipperFilter(flag:Boolean):void
{
	if(flag)
	{
		dcDefaultShipperId.dataValue  			= '';
		dcDefaultShipperId.labelValue 			= '';
		tiDefaultShipperCode.dataValue 			= '';
	}
	
	if(cbDefaultShipper.dataValue=='V')
	{
		dcDefaultShipperId.dataSourceName 	= 'Vendor';
		dcDefaultShipperId.labelField	  	= 'code';
		dcDefaultShipperId.dataField	  	= 'id';
		dcDefaultShipperId.lookupFormatUrl	=  "lookupHelpFormat";
	}
	else
	{
		dcDefaultShipperId.dataSourceName	= 'CompanyStore';
		dcDefaultShipperId.labelField	  	= 'company_cd';
		dcDefaultShipperId.dataField	  	= 'id';
		dcDefaultShipperId.lookupFormatUrl	=  "userStoreAccessLookupHelpFormat"
	}
}
