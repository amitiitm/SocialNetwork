package com.generic.genclass
{
	//Must Instantiate in the script before using the functions.
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.validators.*;
	
	public class GenValidator
	{
		public function runCustomValidator(_validators:Array):int 
		{
			var _results:Array = Validator.validateAll(_validators);
			
			if(_results.length > 0)
			{
				var message:String = "The following fields are invalid:\n";
		
				for(var i:uint = 0; i < _results.length; i++)
				{
					message += _results[i].target.source.toolTip + "\n";
				}
				Alert.show(message);
			}
			return _results.length * -1;
		}

		public function refreshValidator(_validators:Array):void 
		{
			Validator.validateAll(_validators);
		}

		/* if require uncomment
		public function runCustomValidatorBeforeClosing(fn:Function):int 
		{
			var _results:Array = Validator.validateAll(_validators);
			
			if(_results.length > 0) 
			{
				var message:String = "The following fields cannot be blank:\n";
				
				for(var i:uint = 0; i < _results.length; i++) 
				{
					message += _results[i].target.source.toolTip + "\n";
				}
				message += "\n\n Discard changes & exit ?";
				Alert.show(message, "Confirm", Alert.YES | Alert.NO, null, fn, null,  Alert.YES);
			}
			return _results.length * -1;
		}
		*/
		
		private function customValidation(aObject:Object, asProperty:String):GenCustomValidation
		{
			var _valid:GenCustomValidation = new GenCustomValidation();
			
			_valid.defaultValue = aObject.defaultValue;
			if(getQualifiedClassName(aObject) == "com.generic.customcomponents::GenDynamicComboBoxWithHelp")
			{
				_valid.source = aObject.dcb;
			}
			else if(getQualifiedClassName(aObject) == "com.generic.customcomponents::GenTextInputWithHelp")
			{
				_valid.source = aObject.tiLabelField;
			}
			else
			{
				_valid.source = aObject;	
			}
			
			_valid.property = asProperty;
			_valid.dataType = aObject.dataType;
			_valid.target = aObject;
			
			return _valid;
		}

		public function applyValidation(aGenObj:ArrayCollection):Array
		{
			var _validators:Array = new Array(0);
			var lsClassName:String;
			var lsProperty:String;
			
			for(var i:int = 0; i < aGenObj.length; i++)
			{
				lsClassName = getQualifiedClassName(aGenObj[i])
				
				if(lsClassName == "com.generic.customcomponents::GenTextInput"
					|| lsClassName == "com.generic.customcomponents::GenDateField"
					|| lsClassName == "com.generic.customcomponents::GenTextArea"
					|| lsClassName == "com.generic.customcomponents::GenComboBox"
					|| lsClassName == "com.generic.customcomponents::GenDynamicComboBox"
					|| lsClassName == "com.generic.customcomponents::GenCheckBox"
					|| lsClassName == "com.generic.customcomponents::GenDynamicComboBoxWithHelp"
					|| lsClassName == "com.generic.customcomponents::GenTextInputWithHelp"
				)
				{
					if(aGenObj[i].validationFlag == "true")
					{
						lsProperty = 'dataValue'
						_validators.push(customValidation(aGenObj[i], lsProperty))
					}
				}
			}

			return _validators;
		}
	}
}
