import business.events.*;
import model.GenModelLocator;
import mx.controls.Alert;
import mx.controls.Menu;
import mx.events.MenuEvent;

private var configureColumnEvent:ConfigureColumnEvent;			
private var sortEvent:SortEvent;		
private var layoutEvent:LayoutEvent;		
private var queryEvent:QueryEvent;		
private var printEvent:PrintEvent;		
private var exportEvent:ExportEvent;		
private var refreshEvent:RefreshEvent;		

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

public function btnPrintClickHandler():void
{
	printEvent = new PrintEvent();
	printEvent.dispatch();
}			

public function btnRefreshClickHandler():void
{
	refreshEvent = new RefreshEvent();
	refreshEvent.dispatch();
} 		

private function exportGridEventHandler():void
{
	exportEvent = new ExportEvent();
	exportEvent.dispatch();
}

public function btnQueryClickHandler():void
{
	queryEvent = new QueryEvent();
	queryEvent.dispatch();
	
	//btnListClickHandler() // Vivek 14 Jan 2010
}			

public function set view(aXML:XML):void
{
	cbView.dataProvider = aXML.children();
}

public function set defaultView(aXML:XML):void
{
	cbView.selectedItem	= aXML;
}

public function cmbViewChangeHandler(event:Event):void
{
	if(XML((event.target).selectedItem).criteria_type.toString() != 'T')
	{
		__genModel.activeModelLocator.viewObj.selectedView = XML((event.target).selectedItem);
		__genModel.activeModelLocator.viewObj.selectedView[0]["default_yn"] = "Y"
		__genModel.activeModelLocator.viewObj.selectedView[0]["company_id"] = __genModel.user.default_company_id.toString(); // VD 04 Jul 2010.
	
		var saveViewEvent:SaveViewEvent = new SaveViewEvent(__genModel.activeModelLocator.viewObj.selectedView);
		saveViewEvent.dispatch();
	
		var populateListEvent:PopulateListEvent = new PopulateListEvent(__genModel.activeModelLocator.viewObj.selectedView);
		populateListEvent.dispatch();		
	}

}

private function initPopUPBtn():void
{
	var menu:Menu = new Menu();
	
	menu.dataProvider = myMenuData.menuitem;
	menu.labelField	= "@label";
	menu.addEventListener(MenuEvent.ITEM_CLICK , popUPItemClickHandler)
	btnPopUp.popUp = menu;
}

private function popUPItemClickHandler(event:MenuEvent):void
{
	switch(String(event.item.@name).toLowerCase())
	{
		case "configurecolumns":
			 btnConfigureColumnClickHandler();
		     break;
		case "layout":
			 btnLayoutClickHandler();
		     break;
		case "showsort":
			  btnSortClickHandler();
		      break;
		default: Alert.show('item clicked' + String(event.item.@name).toLowerCase());     
	}	
}

private  function btnConfigureColumnClickHandler():void
{
	configureColumnEvent = new ConfigureColumnEvent();
	configureColumnEvent.dispatch();
}

public function btnLayoutClickHandler():void
{
   	layoutEvent	= new LayoutEvent();
	layoutEvent.dispatch();
}

public function btnSortClickHandler():void
{
	sortEvent = new SortEvent();
	sortEvent.dispatch();
}			
