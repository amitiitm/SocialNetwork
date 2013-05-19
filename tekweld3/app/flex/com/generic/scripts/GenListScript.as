import mx.controls.Alert;

private var _updatableFlag:String = "false";
private var _dataServiceID:String = "";
private var _rows:XML;
private var _filteredData:XML;

private var _viewOnlyFlag:Boolean = false
private var _keyColumn:Boolean = false
private var _initialEditableFlag:Boolean = true

//jeetu 21/01/2010
public function set initialEditableFlag(aBoolean:Boolean):void
{
 	_initialEditableFlag	=	this.dropEnabled
}

public function get initialEditableFlag():Boolean
{
 	return _initialEditableFlag
}

public function set dataValue(aXML:XML):void //jeetu 21/01/2010 
{
 	this.filteredData	=	aXML;
}

public function get dataValue():XML
{
 	return this.filteredData;
}

// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

public function set viewOnlyFlag(aBoolean:Boolean):void
{
 	_viewOnlyFlag = aBoolean

 	if(initialEditableFlag)
 	{
 		dropEnabled = !aBoolean;
 		dragEnabled = !aBoolean;
 		dragMoveEnabled = !aBoolean;
 	}
}

public function get viewOnlyFlag():Boolean
{
 	return _viewOnlyFlag
}

public function set keyColumn(aBoolean:Boolean):void
{
 	_keyColumn = aBoolean
}

public function get keyColumn():Boolean
{
	return _keyColumn
}
// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

public function get updatableFlag():String
{
 	return _updatableFlag
}

public function set dataServiceID(aString:String):void 
{
 	_dataServiceID = aString;
}

public function get dataServiceID():String
{
   	return _dataServiceID;
}

public function set rows(aXML:XML):void 
{
 	_rows = new XML(aXML);
 	filteredData =new XML(aXML);
}

public function get rows():XML
{
	return _rows;
}

public function set filteredData(aXML:XML):void 
{
 	_filteredData = aXML;
	dataProvider = _filteredData.children() 
}

public function get filteredData():XML
{
	return _filteredData;
}
