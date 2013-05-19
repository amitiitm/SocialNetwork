
import mx.controls.Alert;
public var selected:Boolean; // No use but Dont delete criteria may give error.
private var _objFrom:Object;
private var _objTo:Object;
private var _objMultiSelect:Object;
private var _dataType:String;


private function handleCreationComplete():void
{
	labelHB.text = label;
}

public function set dataType(aType:String):void 
{
 	_dataType = aType
}

public function get dataType():String
{
 	return _dataType
}

public function set objFrom(aObj:Object):void 
{
 	_objFrom = aObj
}

public function get objFrom():Object
{
 	return _objFrom
}

public function set objTo(aObj:Object):void 
{
 	_objTo = aObj
}

public function get objTo():Object
{
 	return _objTo
}

public function set objMultiSelect(aObj:Object):void
{
 	_objMultiSelect = aObj
}

public function get objMultiSelect():Object
{
 	return _objMultiSelect
}
