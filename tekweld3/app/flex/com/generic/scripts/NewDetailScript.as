import business.events.FetchRecordsEvent;
import business.events.RecordStatusEvent;
import com.generic.customcomponents.GenDynamicComboBox;
import com.generic.events.ButtonControlDetailEvent;
import com.generic.events.EditBarEvent;
import com.generic.events.NewDetailEvent;
import model.GenModelLocator;
import mx.collections.ArrayCollection;
import mx.collections.ListCollectionView;
import mx.controls.Alert;
import mx.events.DataGridEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.events.ScrollEvent;
import mx.events.ScrollEventDirection;
import valueObjects.DetailEditVO;

[Bindable]
public var updatableFlag:String = "false";

[Bindable]
public var checkBlankRowColumn:String = "";

[Bindable]
public var rootNode:String = "";

[Bindable]
public var formatServiceID:String = "";

[Bindable]
public var deletedRows:XML;

private var _rows:XML;
private var _selectedRow:XML;
private var _structure:XML;

// fetch record releted
public var fetchDetailFormatServiceID:String = "";
public var fetchDetailDataServiceID:String = "";
public var dc_id:GenDynamicComboBox;
public var fetchMapingArrCol:ArrayCollection;
public var title:String = "";
public var recordStatusEnabled:Boolean = true;
private var fetchRecordsEvent:FetchRecordsEvent;
private var recordStatusEvent:RecordStatusEvent;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

private var _viewOnlyFlag:Boolean = false
private var _editable:Boolean = true
private var _initialEditableFlag:Boolean = true
public var editBarRowPosition:int;
//
public var btnFetchVisible:Boolean=false;
public var btnEditVisible:Boolean=false;
public var btnRemoveVisible:Boolean=true;

public function reset():void
{
	editBar.visible = false; // VD 0207
	editBarRowPosition = -1
	editBar.reset()
	scrollDataGrid(dgDtl.horizontalScrollPosition)
}

public function set rows(aXML:XML):void 
{
	reset()
 	_rows = aXML;
	dgDtl.rows = aXML;	
}

public function get rows():XML
{
   	return _rows;
}

public function set selectedRow(aXML:XML):void
{
	_selectedRow = aXML;
	dgDtl.selectedRow = aXML;
}

public function get selectedRow():XML
{
   	return _selectedRow;
} 

public function set structure(aXML:XML):void
{
	_structure = aXML;
	dgDtl.structure = aXML;
	editBar.structure = aXML;
	
	dispatchEvent(new NewDetailEvent(NewDetailEvent.STRUCTURE_COMPLETE_EVENT));
}

public function get structure():XML
{
	return _structure;
}

public function set initialEditableFlag(aBoolean:Boolean):void //jeetu 21/01/2010 
{
 	_initialEditableFlag = this.editable;
}

public function get initialEditableFlag():Boolean
{
 	return _initialEditableFlag
}

public function set editable(aBoolean:Boolean):void
{
	_editable = aBoolean;
}

public function get editable():Boolean
{
	return _editable;
}

public function set viewOnlyFlag(aBoolean:Boolean):void
{
	_viewOnlyFlag = aBoolean
	
 	if(initialEditableFlag)
 	{
	 	editable = !aBoolean
 	}
}

public function get viewOnlyFlag():Boolean
{
 	return _viewOnlyFlag
}

public function set fetchRecordFlag(isVisible:Boolean):void
{
	btnFetchVisible = isVisible

	if(isVisible)
	{
		btnEditVisible = false;
	}
}

// Vivek
public function set addRecordFlag(isVisible:Boolean):void
{
	btnEditVisible = isVisible

	if(isVisible)
	{
		btnFetchVisible = false;
		btnRemoveVisible = true;
	}
}

// Vivek
public function set removeRecordFlag(isVisible:Boolean):void
{
	btnRemoveVisible = isVisible
	//resetSortColumns();
}

private function removeRowHandler(event:ButtonControlDetailEvent):void
{
	if(!viewOnlyFlag)
	{
		if(editBarRowPosition >= 0)
		{
			var tempXml:XML;
			var node:String = dgDtl.dataProvider[editBarRowPosition].localName();
			var deleteChild:XML	=	new XML(dgDtl.dataProvider[editBarRowPosition]);
			
			deleteChild.trans_flag	=	"D"; // each detail window must have trans_flag
			
			if(Number(deleteChild.child('id').toString()) > 0)
			{
				XML(dgDtl.deletedRows).appendChild(deleteChild);
			}
			
			delete dgDtl.rows.child(node)[editBarRowPosition];
			tempXml	=  new XML(XML(dgDtl.rows).copy());
			dgDtl.rows	=	tempXml;

			// Editbar need to move on new row
			if(dgDtl.dataProvider.length > 0)
			{
				if(editBarRowPosition == dgDtl.dataProvider.length)
				{
					editBarRowPosition = editBarRowPosition - 1
				}

				moveEditbar()
			}
			else
			{
				reset()
			}
			// End
			
			dispatchEvent(new NewDetailEvent(NewDetailEvent.DETAIL_REMOVE_ROW));
	
			if(recordStatusEnabled)
			{
				recordStatusEvent = new	RecordStatusEvent("MODIFY");
				recordStatusEvent.dispatch();
			}			
		}
	} 
}

private function fetchRecordsHandler(event:ButtonControlDetailEvent):void
{
	if(!viewOnlyFlag)
	{
		if(dc_id.text != '' && dc_id.text != null)
		{
			__genModel.activeModelLocator.detailEditObj = new DetailEditVO();
		
			__genModel.activeModelLocator.detailEditObj.genDataGrid = dgDtl;
			__genModel.activeModelLocator.detailEditObj.selectedRow = dgDtl.selectedRow;
			
			__genModel.activeModelLocator.detailEditObj.title = title
			__genModel.activeModelLocator.detailEditObj.id = dc_id.dataValue;
			__genModel.activeModelLocator.detailEditObj.fetchDetailFormatServiceID = fetchDetailFormatServiceID;
			__genModel.activeModelLocator.detailEditObj.fetchDetailDataServiceID = fetchDetailDataServiceID;
			__genModel.activeModelLocator.detailEditObj.fetchMapingArrCol = fetchMapingArrCol;
			
			fetchRecordsEvent = new FetchRecordsEvent();
			fetchRecordsEvent.dispatch();
		}
		else
		{
			Alert.show(dc_id.toolTip + ' is required');
		}
	}
}

private function creationCompleteHandler():void
{
	dgDtl.rows = new XML('<' + rootNode + '/>');
	dgDtl.selectedRow = null;
	
	editBar.height = dgDtl.rowHeight;
	reset()
}

private function editRowHandler(event:ButtonControlDetailEvent):void
{
	/*  VD commented on 2nd July 2012, later will remove */ 
	if(editable)
	{
		var rows:XML = dgDtl.rows.copy();
		var newRow:XML = editBar.newRow.copy();
		
		newRow.setName(rootNode.slice(0, rootNode.length - 1));
		rows.appendChild(newRow)
		dgDtl.rows = rows;
		
		editBarRowPosition = dgDtl.rows.children().length() - 1;
		moveEditbar()
	}
}

private function moveEditbar():void
{
	if(editable)
	{
		selectedRow = dgDtl.dataProvider[editBarRowPosition]
	
		if((editBarRowPosition % 2) == 0)
		{
			editBar.setStyle("backgroundColor", '#F1F4F9')
		}
		else
		{
			editBar.setStyle("backgroundColor", '#FFFFFF')
		}
	
		editBar.record = selectedRow;
		editBar.height = dgDtl.rowHeight;
		editBar.lastColumnWidth();
		editBar.visible = true;
	
		editBar.move(2, bcdp.height + ((editBarRowPosition - dgDtl.verticalScrollPosition) * dgDtl.rowHeight + 19)) // VD 11 Feb 2010

		dispatchEvent(new NewDetailEvent(NewDetailEvent.ROW_FOCUS_CHANGED));
		resetSortColumns();
	}

	var invisibleColumns:int = dgDtl.horizontalScrollPosition
	scrollDataGrid(invisibleColumns)
}

private function scrollDataGrid(invisibleColumns:int):void 
{
	if(editable)
	{
		var ary:Array = editBar.getChildren()
		
		if(ary.length > 0)
		{
			for(var i:int=0; i<invisibleColumns; i++)
			{
				ary[i].visible = false
				ary[i].width = 0
			}
			
			for(var j:int=invisibleColumns; j < dgDtl.columns.length; j++)
			{
				ary[j].visible = true
				ary[j].width = dgDtl.columns[j].width
			}
		}
	}
}

private function moveToPreviousRow():Boolean
{
	var flag:Boolean = false;
	
	if(editable)
	{
		if(editBarRowPosition > 0)
		{
			editBarRowPosition = editBarRowPosition - 1
			dgDtl.scrollToIndex(editBarRowPosition);
			moveEditbar()
			flag = true
		}
	}

	return flag
}

private function moveToNextRow():Boolean
{
	var flag:Boolean=false;

	if(editable)
	{
		if(editBarRowPosition < dgDtl.dataProvider.length - 1)
		{
			editBarRowPosition = editBarRowPosition + 1
			dgDtl.scrollToIndex(editBarRowPosition);			
			moveEditbar()
			flag = true
		}
	}
	
	return flag;
}

private function handleUpKeyEvent(event:EditBarEvent):void
{
	if(editable)
	{
		moveToPreviousRow()
	}
}

private function handleShiftTabKeyEvent(event:EditBarEvent):void 
{
	if(editable)
	{
		if(moveToPreviousRow())
		{
			editBar.getColumn(editBar.lastEditableCompID).setFocus()
		}
	}
}

private function handleDownKeyEvent(event:EditBarEvent):void
{
	if(editable)
	{
		moveToNextRow()
	}
}

private function handleTabKeyEvent(event:EditBarEvent):void 
{
	if(editable)
	{
		if(moveToNextRow())
		{
			editBar.getColumn(editBar.firstEditableCompID).setFocus()
		}
	}
}

private function handleScrollOnTabEvent(event:EditBarEvent):void
{
	if(editable)
	{
		if(event.object.x > dtl.width - 25)
		{
			dgDtl.horizontalScrollPosition = dgDtl.maxHorizontalScrollPosition + 1;
		}
	
		if(event.object.x < dtl.x + 25)
		{
			dgDtl.horizontalScrollPosition = 0;
		}
	
		scrollDataGrid(dgDtl.horizontalScrollPosition)
	}
}

private function handleResize(event:Event):void
{
	if(editable)
	{
		reset()
	}
}

private function onScroll(event:ScrollEvent):void 
{
	if(editable)
	{
		if(event.direction == ScrollEventDirection.HORIZONTAL)
		{
			var invisibleColumns:int = dgDtl.horizontalScrollPosition
			scrollDataGrid(invisibleColumns)
		}
		else
		{
			reset();
		}
	}
}

private function handleUpdateComplete(event:FlexEvent):void
{
	if(editBarRowPosition > -1 && editBarRowPosition < dgDtl.dataProvider.length)
	{	
		selectedRow = dgDtl.dataProvider[editBarRowPosition]
		editBar.record = selectedRow
	}
	else
	{
		reset();
	}
}

private function handleItemClick(event:ListEvent):void
{
	if(editable && (! __genModel.isLockScreen))
	{
		editBarRowPosition = event.rowIndex
		moveEditbar()
		resetSortColumns();
	}
}

private function handleEditBarItemChangedEvent(event:EditBarEvent):void
{
	selectedRow = dgDtl.dataProvider[editBarRowPosition]
	editBar.record = selectedRow
	dispatchEvent(new NewDetailEvent(NewDetailEvent.DETAIL_ITEM_FOCUS_OUT, event.object));
	resetSortColumns();
}

public function handleColumnStretch(event:DataGridEvent):void
{
	reset();
}

public function headerReleaseHandler(event:DataGridEvent):void
{
	reset();
}

private function resetSortColumns():void
{
	ListCollectionView(dgDtl.dataProvider).sort = null;
	//	ListCollectionView(dgDtl.dataProvider).refresh();
}
