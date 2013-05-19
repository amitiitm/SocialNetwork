package com.generic.customcomponents 
{
	import business.events.RecordStatusEvent;
	
	import com.generic.events.GenDynamicComboBoxEvent;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.net.SharedObject;
	import flash.ui.Keyboard;
	
	import mx.collections.ListCollectionView;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.core.UIComponent;
	import mx.events.ListEvent;
	
	import valueObjects.LookupVO;
	
	[Event(name="itemChangedEvent", type="com.generic.events.GenDynamicComboBoxEvent")]
	[Event(name="filterFunctionChange", type="flash.events.Event")]
	[Event(name="typedTextChange", type="flash.events.Event")]
	[Exclude(name="editable", kind="property")]
	public class GenDynamicComboBox extends ComboBox
	{
		private var cursorPosition:Number = 0;
		private var prevIndex:Number = -1;
		private var removeHighlight:Boolean = false;	
		private var showDropdown:Boolean = false;
		private var showingDropdown:Boolean = true;
		private var tempCollection:Object;
		private var usingLocalHistory:Boolean = false;
		private var dropdownClosed:Boolean = true;
		
		private var _filterFunction:Function = defaultFilterFunction;
		private var filterFunctionChanged:Boolean = true;
		private var _keepLocalHistory:Boolean = false;
		private var keepLocalHistoryChanged:Boolean = true;
		private var _lookAhead:Boolean = true; // Vivek Dubey
		private var lookAheadChanged:Boolean;
		private var _typedText:String = "";
		private var typedTextChanged:Boolean;
		
		// Vivek Dubey -- Gen properties
		private var _dataType:String = "S";
		private var _defaultValue:String = "";
		private var _xmlTag:String = "";
		private var _validationFlag:String = "false";
		private var _updatableFlag:String = "false";
		private var _tableName:String = "";
		private var _dataSourceName:String = "";
		private var _dataValue:String = "";
		private var _dataField:String = "";
		private var _validateData:Boolean = true;
		
		// Vivek 13 Jan 2010
		private var _filterEnabled:Boolean = false;
		private var _filterKeyName:String = "";
		private var _filterKeyValue:String = "";
		
		public var recordStatusEnabled:Boolean = true;
		public var mergedWithOtherComponent:Boolean = false
		
		private var _viewOnlyFlag:Boolean = false
		private var _keyColumn:Boolean = false
		public var _initialEditableFlag:Boolean = true
		
		private var recordStatusEvent:RecordStatusEvent;
		private var changeFlag:Boolean = false
		private var keyValueChanged:Boolean = false
		
		public function GenDynamicComboBox()
		{
			super();
			
			
			editable = true;
			
			if(keepLocalHistory)
			{
				addEventListener("focusOut", focusOutHandler);
			}
			
			addEventListener(ListEvent.CHANGE, changeHandler);
			
			setStyle("arrowButtonWidth",0);
			setStyle("fontWeight","normal");
			setStyle("cornerRadius",0);
			setStyle("paddingLeft",0);
			setStyle("paddingRight",0);
			
			rowCount = 7;
		}
		
		// Gen properties (get & set)
		public function set dataSourceName(aString:String):void 
		{
			var xml:XML = new LookupVO().getData(aString);
			
			_dataSourceName = aString;
			dataProvider = xml.children();
		}
		
		public function get dataSourceName():String 
		{
			return _dataSourceName;
		}
		
		public function set dataType(aString:String):void 
		{
			_dataType = aString
		}
		
		public function get dataType():String
		{
			return _dataType
		}
		
		public function set defaultValue(aString:String):void 
		{
			_defaultValue = aString
		}
		
		public function get defaultValue():String
		{
			return _defaultValue
		}
		
		public function set xmlTag(aString:String):void 
		{
			_xmlTag = aString
		}
		
		public function get xmlTag():String
		{
			return _xmlTag
		}
		
		// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		public function set filterKeyName(aString:String):void 
		{
			_filterKeyName = aString
		}
		
		public function get filterKeyName():String
		{
			return _filterKeyName
		}
		
		public function set filterKeyValue(aString:String):void 
		{
			if(aString == null)
			{
				aString = ""
			}
			_filterKeyValue = aString
			
			// VD 28 Apr 2010			
			if(filterEnabled)
			{
				collection.filterFunction	=	null;//new changes 22 sep 2011 jeetu
				collection.refresh();//new changes 22 sep 2011 jeetu
				filterDataProvider();
			}
		}
		
		public function get filterKeyValue():String
		{
			return _filterKeyValue
		}
		
		public function set filterEnabled(aBoolean:Boolean):void 
		{
			_filterEnabled = aBoolean
		}
		
		public function get filterEnabled():Boolean
		{
			return _filterEnabled
		}
		//jeetu 21/01/2010
		public function set initialEditableFlag(aBoolean:Boolean):void
		{
			_initialEditableFlag	=	this.editable
		}
		
		public function get initialEditableFlag():Boolean
		{
			return _initialEditableFlag
		}
		// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		public function set viewOnlyFlag(aBoolean:Boolean):void
		{
			_viewOnlyFlag = aBoolean
			
			if(initialEditableFlag)
			{
				textInput.editable = !aBoolean
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
		// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		
		public function set validateData(aBoolean:Boolean):void 
		{
			_validateData = aBoolean
		}
		
		public function get validateData():Boolean
		{
			return _validateData
		}
		
		public function set validationFlag(aString:String):void 
		{
			_validationFlag = aString
		}
		
		public function get validationFlag():String
		{
			return _validationFlag
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
		
		public function set dataField(aString:String):void 
		{
			_dataField = aString
		}
		
		public function get dataField():String
		{
			return _dataField
		}
		
		public function set dataValue(aString:String):void
		{
			_dataValue = aString;
			
			if(filterEnabled)
			{
				collection.filterFunction	=	null;//new changes 22 sep 2011 jeetu
				collection.refresh();//new changes 22 sep 2011 jeetu
				filterDataProvider()
			}
			else
			{
				collection.filterFunction	=	null;//new changes 22 sep 2011 jeetu
				collection.refresh();//new changes 22 sep 2011 jeetu
				//dataProvider = tempCollection;  //new changes 22 sep 2011 jeetu
			}
			
			changeFlag = false;
			getText()
		}
		
		public function get dataValue():String
		{
			return _dataValue
		}
		
		override public function set editable(value:Boolean):void
		{
			super.editable = true;
		}
		
		override public function set dataProvider(value:Object):void
		{
			if(value is XMLList)//new changes 22 sep 2011 jeetu
			{
				if(XMLList(value).length() > 0)//new changes 22 sep 2011 jeetu
				{
					super.dataProvider = value;//new changes 22 sep 2011 jeetu
					collection.refresh();//new changes 22 sep 2011 jeetu
				}
				else
				{
					super.dataProvider = value;//new changes 22 sep 2011 jeetu
					collection.refresh();//new changes 22 sep 2011 jeetu
				}
			}
			else
			{
				super.dataProvider = value;
				collection.refresh();//new changes 22 sep 2011 jeetu
			}
			
			// Vivek 13 Jan 2010
			if(!(usingLocalHistory || keyValueChanged))
			{
				tempCollection = value;
			}
		}
		
		override public function set labelField(value:String):void
		{
			super.labelField = value;
			
			invalidateProperties();
			invalidateDisplayList();
		}
		
		[Bindable("filterFunctionChange")]
		[Inspectable(category="General")]
		public function get filterFunction():Function
		{
			return _filterFunction;
		}
		
		public function set filterFunction(value:Function):void
		{
			if(value != null)
			{
				_filterFunction = value;
				filterFunctionChanged = true;
				
				invalidateProperties();
				invalidateDisplayList();
				
				dispatchEvent(new Event("filterFunctionChange"));
			}
			else
			{
				_filterFunction = defaultFilterFunction;
			}
		}
		
		[Bindable("keepLocalHistoryChange")]
		[Inspectable(category="General")]
		public function get keepLocalHistory():Boolean
		{
			return _keepLocalHistory;
		}
		
		public function set keepLocalHistory(value:Boolean):void
		{
			_keepLocalHistory = value;
		}
		
		[Bindable("lookAheadChange")]
		[Inspectable(category="Data")]
		public function get lookAhead():Boolean
		{
			return _lookAhead;
		}
		
		public function set lookAhead(value:Boolean):void
		{
			_lookAhead = value;
			lookAheadChanged = true;
		}
		
		[Bindable("typedTextChange")]
		[Inspectable(category="Data")]
		public function get typedText():String
		{
			return _typedText;
		}
		
		public function set typedText(input:String):void
		{
			_typedText = input;
			typedTextChanged = true;
			
			invalidateProperties();
			invalidateDisplayList();
			dispatchEvent(new Event("typedTextChange"));
			
			if(recordStatusEnabled)
			{
				recordStatusEvent = new RecordStatusEvent("MODIFY")
				recordStatusEvent.dispatch()
			}			
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(!dropdown)
			{
				selectedIndex=-1;
			}
			
			if(dropdown)
			{
				if(typedTextChanged)
				{
					cursorPosition = textInput.selectionAnchorPosition;
					updateDataProvider();
					
					//In case there are no suggestions there is no need to show the dropdown.
					if(collection.length==0 || typedText==""|| typedText==null)
					{
						dropdownClosed=true;
						showDropdown=false;
					}
					else
					{
						showDropdown = true;
						selectedIndex = 0;
					}
				}
			}
		}
		
		override protected function focusOutHandler(event:FocusEvent):void
		{
			super.focusOutHandler(event)
			
			if(mergedWithOtherComponent == false)
			{
				focusOutProcess()
			}
		}
		
		public function focusOutProcess():void
		{
			if(keepLocalHistory && dataProvider.length==0)
			{
				addToLocalHistory();
			}
			
			if(changeFlag)
			{
				setData()
				dispatchEvent(new GenDynamicComboBoxEvent(GenDynamicComboBoxEvent.ITEMCHANGED_EVENT));
			}
		}
		
		private function changeHandler(event:ListEvent):void
		{
			changeFlag = true
			
			if(recordStatusEnabled)
			{
				recordStatusEvent = new RecordStatusEvent("MODIFY")
				recordStatusEvent.dispatch()
			}			
		}
		
		override public function getStyle(styleProp:String):*
		{
			if(styleProp != "openDuration")
			{
				return super.getStyle(styleProp);
			}
			else
			{
				if(dropdownClosed)
				{
					return super.getStyle(styleProp);
				}
				else
				{
					return 0;
				}
			}
		}
		
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			//jeetu 7 feb 2011 . if editable = true than only he can get dropdown list
			if(!textInput.editable)
			{
				return;
			}
			
			super.keyDownHandler(event);
			
			
			if(!event.ctrlKey)
			{
				//An UP "keydown" event on the top-most item in the drop-down
				//or an ESCAPE "keydown" event should change the text in text
				// field to original text
				if(event.keyCode == Keyboard.UP && prevIndex==0)
				{
					textInput.text = _typedText;
					textInput.selectRange(textInput.text.length, textInput.text.length);
					selectedIndex = -1; 
				}
				else if(event.keyCode==Keyboard.ESCAPE && showingDropdown)
				{
					
					textInput.text = _typedText;
					textInput.selectRange(textInput.text.length, textInput.text.length);
					showingDropdown = false;
					dropdownClosed=true;
				}
				else if(event.keyCode == Keyboard.ENTER)
				{
					if(keepLocalHistory && dataProvider.length==0)
					{
						addToLocalHistory();
					}
				}
				else if(lookAhead && event.keyCode ==  Keyboard.BACKSPACE || event.keyCode == Keyboard.DELETE)
				{
					
					removeHighlight = true;
				}
			}
			else
			{
				if(event.ctrlKey && event.keyCode == Keyboard.UP)
				{
					
					dropdownClosed=true;
				}
			}
			
			prevIndex = selectedIndex;
		}
		
		override protected function measure():void
		{
			super.measure();
			measuredWidth = mx.core.UIComponent.DEFAULT_MEASURED_WIDTH;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(selectedIndex == -1)
			{
				textInput.text = typedText;
			}
			
			if(dropdown)
			{
				if(typedTextChanged)
				{
					if(lookAhead && showDropdown && typedText!="" && !removeHighlight)
					{
						var label:String = itemToLabel(collection[0]);
						var index:Number =  label.toLowerCase().indexOf(_typedText.toLowerCase());
						
						if(index==0)
						{
							textInput.text = _typedText+label.substr(_typedText.length);
							
							textInput.selectRange(textInput.text.length,_typedText.length);
						}
						else
						{
							textInput.text = _typedText;
							textInput.selectRange(cursorPosition, cursorPosition);
							removeHighlight = false;
						}
					}
					else
					{
						textInput.text = _typedText;
						textInput.selectRange(cursorPosition, cursorPosition);
						removeHighlight = false;
					}
					
					typedTextChanged= false;
				}
				else if(typedText)
				{
					textInput.selectRange(_typedText.length,textInput.text.length);
				}
			}
			if(showDropdown && !dropdown.visible)
			{
				super.open();
				showDropdown = false;
				showingDropdown = true;
				
				if(dropdownClosed)
				{
					dropdownClosed=false;
				}
			}
		}
		
		override protected function textInput_changeHandler(event:Event):void
		{
			super.textInput_changeHandler(event);
			typedText = text;
			changeFlag = true
		}
		
		private function addToLocalHistory():void
		{
			if (id != null && id != "" && text != null && text != "")
			{
				var so:SharedObject = SharedObject.getLocal("GenDynamicComboBox");
				var savedData : Array = so.data.suggestions;
				
				if (savedData == null)
				{
					savedData = new Array();
				}
				
				var i:Number=0;
				var flag:Boolean=false;
				
				for(i=0; i<savedData.length; i++)
				{
					if(savedData[i]==text)
					{
						flag=true;
						break;
					}
				}
				
				if(!flag)
				{
					for(i=0;i<collection.length;i++)
					{
						if(defaultFilterFunction(itemToLabel(ListCollectionView(collection).getItemAt(i)),text))
						{
							flag=true;
							break;
						}
					}
				}
				
				if(!flag)
				{
					savedData.push(text);
				}
				
				so.data.suggestions = savedData;
				so.flush();
			}
		}	
		
		private function defaultFilterFunction(element:*, text:String):Boolean 
		{
			var label:String = itemToLabel(element);
			
			if(filterEnabled)//new changes 22 sep 2011 jeetu
			{
				var keyElement:String = element[filterKeyName];//new changes 22 sep 2011 jeetu
				if(keyElement.toLowerCase() == filterKeyValue.toLowerCase())//new changes 22 sep 2011 jeetu
				{
					return (label.toLowerCase().substring(0,text.length) == text.toLowerCase());//new changes 22 sep 2011 jeetu
				}
				else//new changes 22 sep 2011 jeetu
				{
					return false;	//new changes 22 sep 2011 jeetu
				}
					
			}
			else
			{
				return (label.toLowerCase().substring(0,text.length) == text.toLowerCase());
			}
			
			return false;//new changes 22 sep 2011 jeetu
		}
		
		private function templateFilterFunction(element:*):Boolean 
		{
			var flag:Boolean=false;
			
			if(filterFunction!=null)
			{
				flag=filterFunction(element,typedText);
			}
			
			return flag;
		}
		
		private function updateDataProvider():void
		{
			/*//new changes 22 sep 2011 jeetu if(!filterEnabled)
			{
				dataProvider = tempCollection;
			}*/
				
			collection.filterFunction = templateFilterFunction;
			collection.refresh();
			
			if(collection.length==0 && keepLocalHistory)
			{
				var so:SharedObject = SharedObject.getLocal("GenDynamicComboBox");
				usingLocalHistory = true;
				dataProvider = so.data.suggestions;
				usingLocalHistory = false;
				collection.filterFunction = templateFilterFunction;
				collection.refresh();
			}
		}
		
		override public function set selectedItem(value:Object):void
		{
			super.selectedItem = value
		}
		
		private function setData():void
		{
			// Set variable directly (code is ok)
			if(validateData || changeFlag)
			{
				if((XML)(selectedItem).children().length() > 0)
				{
					_dataValue = selectedItem[dataField];
					_typedText = selectedItem[labelField];
					text = selectedItem[labelField];
				}
				else
				{
					_dataValue = ""
					_typedText = ""
					text = ""
					selectedIndex = -1
					selectedItem = null
				}
			}
			
			changeFlag = false;
		}
		
		private function getText():void
		{
			if(validateData)
			{
				var flag:Boolean = false;
				
				// Set variable directly (code is ok)
				if(!(_dataValue == null || _dataValue == ""))	
				{
					for(var i:int = 0; i < dataProvider.length; i++)
					{
						if(_dataValue == dataProvider[i][dataField])
						{
							selectedItem = dataProvider[i]
							selectedIndex = i;
							flag = true
						}
					}
				}
				
				if(flag == false)
				{
					selectedIndex = -1;
					selectedItem = null;
				}
				
				setData()
			}
		}
		
		private function filterAgainDataProvider(element:Object):Boolean//new changes 22 sep 2011 jeetu 
		{
			var label:String = element[filterKeyName];
			return (label.toLowerCase() == filterKeyValue.toLowerCase());
		}	
		private function filterDataProvider():void
		{
			keyValueChanged = true;
			collection.filterFunction = filterAgainDataProvider;//new changes 22 sep 2011 jeetu
			collection.refresh();//new changes 22 sep 2011 jeetu
			//dataProvider = tempCollection.(elements(filterKeyName) == filterKeyValue)//new changes 22 sep 2011 jeetu
			keyValueChanged = false
		}
	}	
}
