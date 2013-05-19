import business.events.InitializeReportEvent;
import business.events.PopulateListEvent;
import model.GenModelLocator;
import com.generic.customcomponents.GenComboBox;
import com.generic.events.GenModuleEvent;
import flash.events.Event;
import model.GenModelLocator;

[Bindable]
public var _view:XML;

[Bindable]
public var isSortOrderSelectionVisible:Boolean;

//to set sortOrderSelection related variables
[Bindable]
public var sortField:XMLList;
[Bindable]
public var defaultLevelXml:XML; // to set default selected level for level comboboxes.


[Bindable]
public var treeXml:XML;   // to create filter tree

[Bindable]
public var filteredList:XML;

[Bindable]
public var listFormat:XML;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
protected var initializeEvent:InitializeReportEvent;

protected function handleModuleActive(event:GenModuleEvent):void {}

public function set view(aXML:XML):void
{
	bcpListView.view	=	aXML;
}

public function set defaultView(aXML:XML):void
{
	bcpListView.defaultView	=	aXML;
}

