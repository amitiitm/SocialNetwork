package com.generic.customcomponents
{
	import mx.controls.RadioButtonGroup;
	import mx.core.IFlexDisplayObject;

	public class GenRadioButtonGroup extends RadioButtonGroup 
	{
		private var _xmlTag:String = "";
		private var _updatableFlag:String = "false";
		private var _tableName:String = "";
		private var _defaultValue:String = "";
		private var _validationFlag:String = "false";
		private var _dataType:String = "S";
		private var _viewOnlyFlag:Boolean = false;
		private var _initialEditableFlag:Boolean = true

		public function set dataValue(aString:String):void //jeetu 21/01/2010 
		{
		 	this.selectedValue	=	aString;
		}
		
		public function get dataValue():String
		{
		 	return (String)(this.selectedValue);
		}
		
		public function set initialEditableFlag(aBoolean:Boolean):void //jeetu 21/01/2010 
		{
		 	_initialEditableFlag	=	this.enabled;
		}
		
		public function get initialEditableFlag():Boolean
		{
		 	return _initialEditableFlag
		}
		public function set viewOnlyFlag(aBoolean:Boolean):void  //jeetu 21/01/2010 
		{
		 	_viewOnlyFlag = aBoolean
		}

		public function get viewOnlyFlag():Boolean
		{
		 	return _viewOnlyFlag
		}
		public function set dataType(aString:String):void
		{
			_dataType = aString
		}

		public function get dataType():String
		{
			return _dataType
		}

		public function set validationFlag(aString:String):void
		{
		 	_validationFlag = aString
		}
		
		public function get validationFlag():String
		{
		 	return _validationFlag
		}
		 
		public function GenRadioButtonGroup(document:IFlexDisplayObject=null)
		{
			super(document);
		}

		override public function initialized(document:Object, id:String):void
		{
			//document.genRadioButtonGroup.addItem(this)
		}
		
		public function set xmlTag(aString:String):void
		{
		 	_xmlTag = aString
		}
		
		public function get xmlTag():String
		{
		 	return _xmlTag
		}

		public function set updatableFlag(aString:String):void
		{
		 	_updatableFlag = aString
		}
		
		public function get updatableFlag():String
		{
		 	return _updatableFlag
		}

		public function set tableName(aString:String):void
		{
		 	_tableName = aString
		}
		
		public function get tableName():String
		{
		 	return _tableName
		}
		
		public function set defaultValue(aString:String):void
		{
		 	_defaultValue = aString
		}
		
		public function get defaultValue():String
		{
		 	return _defaultValue
		}		
	}
}
