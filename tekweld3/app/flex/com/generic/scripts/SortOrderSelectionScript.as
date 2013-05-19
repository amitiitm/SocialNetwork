import business.events.SaveViewEvent;
import business.events.SortOrderSelectionChangingEvent;

import flash.events.Event;

import model.GenModelLocator;

import mx.controls.Alert;

[Bindable]
public var _sortField:XMLList;

public var currentIndexLevel1:int;
public var currentIndexLevel2:int;
public var currentIndexLevel3:int;
public var selectedView:XML;// it is taken to effect change in 

private var sortOrderSelectionChangingEvent:SortOrderSelectionChangingEvent;

public function set sortField(sortFieldXml:XMLList):void
{
	var __activeModel:Object = GenModelLocator.getInstance().activeModelLocator;

	_sortField = sortFieldXml;
	
	if(currentIndexLevel1 == 0 && currentIndexLevel2 == 0 && currentIndexLevel3 == 0 )
	{
	}
	else
	{
		cbLevel1.selectedIndex = currentIndexLevel1;
		cbLevel2.selectedIndex = currentIndexLevel2;
		cbLevel3.selectedIndex = currentIndexLevel3;
		
		__activeModel.sortOrderSelectionObj.selectedLevel1 = XML(cbLevel1.selectedItem);
		__activeModel.sortOrderSelectionObj.selectedLevel2 = XML(cbLevel2.selectedItem);
		__activeModel.sortOrderSelectionObj.selectedLevel3 = XML(cbLevel3.selectedItem);
	}
}

public function set defaultLevels(aSelectedView:XML):void
{
	selectedView = aSelectedView;  // binding is used here to get change in view,selectedView of activeModelLocator
	
	var __activeModel:Object = GenModelLocator.getInstance().activeModelLocator;

	currentIndexLevel1 = selectedView.child('list1').toString();
	currentIndexLevel2 = selectedView.child('list2').toString();
	currentIndexLevel3 = selectedView.child('list3').toString();

	if(currentIndexLevel1 == currentIndexLevel2 && currentIndexLevel1 == currentIndexLevel3)
	{
		currentIndexLevel1 = 0
		currentIndexLevel2 = 1
		currentIndexLevel3 = 2
	}
	
	cbLevel1.selectedIndex = currentIndexLevel1;
	cbLevel2.selectedIndex = currentIndexLevel2;
	cbLevel3.selectedIndex = currentIndexLevel3;
	
	__activeModel.sortOrderSelectionObj.selectedLevel1 = XML(cbLevel1.selectedItem);
	__activeModel.sortOrderSelectionObj.selectedLevel2 = XML(cbLevel2.selectedItem);
	__activeModel.sortOrderSelectionObj.selectedLevel3 = XML(cbLevel3.selectedItem);
}

public function sortOrderChangeEventHandler(event:Event):void
{
	var __activeModel:Object = GenModelLocator.getInstance().activeModelLocator;

	if(cbLevel1.selectedIndex == cbLevel2.selectedIndex || cbLevel1.selectedIndex == cbLevel3.selectedIndex || cbLevel2.selectedIndex == cbLevel3.selectedIndex)
	{
		Alert.show('Level(s) has duplicate value, Sort cannot be populate...!')

		cbLevel1.selectedIndex = currentIndexLevel1;
		cbLevel2.selectedIndex = currentIndexLevel2;
		cbLevel3.selectedIndex = currentIndexLevel3;
	}
	else
	{
		selectedView.list1 = cbLevel1.selectedIndex; // it will change autometically in view,selectedView of activeModelLocator.
		selectedView.list2 = cbLevel2.selectedIndex;
		selectedView.list3 = cbLevel3.selectedIndex;
	     
		currentIndexLevel1 = cbLevel1.selectedIndex;
		currentIndexLevel2 = cbLevel2.selectedIndex;
		currentIndexLevel3 = cbLevel3.selectedIndex;
		
		__activeModel.sortOrderSelectionObj.selectedLevel1 = XML(cbLevel1.selectedItem);
		__activeModel.sortOrderSelectionObj.selectedLevel2 = XML(cbLevel2.selectedItem);
		__activeModel.sortOrderSelectionObj.selectedLevel3 = XML(cbLevel3.selectedItem);  
		
		sortOrderSelectionChangingEvent	= new SortOrderSelectionChangingEvent();
		sortOrderSelectionChangingEvent.dispatch();
		 
		var saveViewEvent:SaveViewEvent = new SaveViewEvent(selectedView);
		saveViewEvent.dispatch();
	}
}
