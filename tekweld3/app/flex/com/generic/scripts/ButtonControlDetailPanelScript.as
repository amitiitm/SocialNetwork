import com.generic.events.*;

[Bindable]
public var btnFetchVisible:Boolean=false;
[Bindable]
public var btnEditVisible:Boolean=true;
[Bindable]
public var btnRemoveVisible:Boolean=true;
[Bindable]
public var btnImportVisible:Boolean=false;
[Bindable]
public var btnFetchWithDetailVisible:Boolean=false;

public function editRowEventHandler():void
{
	dispatchEvent(new ButtonControlDetailEvent('editRowEvent'));
}			

public function removeRowEventHandler():void
{
	dispatchEvent(new ButtonControlDetailEvent('removeRowEvent'));
}			

public function fetchReordsEventHandler():void
{
	dispatchEvent(new ButtonControlDetailEvent('fetchRecordsEvent'));
}
public function importEventHandler():void
{
	dispatchEvent(new ButtonControlDetailEvent('importEvent'));
}		
public function fetchReordsWithDetailEventHandler():void
{
	dispatchEvent(new ButtonControlDetailEvent('fetchRecordsWithDetailEvent'));
}