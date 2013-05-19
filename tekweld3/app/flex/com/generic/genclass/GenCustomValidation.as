package com.generic.genclass
{
	import mx.controls.*;
	import mx.events.ValidationResultEvent;
	import mx.validators.EmailValidator;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	import saoi.muduleclasses.MultipleEmailValidator;

    public class GenCustomValidation extends Validator 
    {
        // Define Array for the return value of doValidation().
		private var results:Array;
		private var _dataType:String
		private var _defaultValue:String
		private var _target:Object;
		
		private var emailValidator:MultipleEmailValidator  = new MultipleEmailValidator();
		
		public function GenCustomValidation()
		{
			super();
        }

        public function get dataType():String
        {
        	return _dataType;
        }
        
        public function set dataType(aString:String):void
        {
        	_dataType = aString
        }

        public function get defaultValue():String
        {
        	return _defaultValue;
        }
        
        public function set defaultValue(aString:String):void
        {
        	_defaultValue = aString
        }

        public function get target():Object
        {
        	return _target;
        }
        
        public function set target(aObject:Object):void
        {
        	_target = aObject
        }

		override protected function doValidation(value:Object):Array 
		{
			if(target.hasOwnProperty('validationType') && target.validationType=='email')
			{
				emailValidator.required  = false;
				if(emailValidator.validate(value).results==null)
				{
					var results:Array = [];
					//results.push(new ValidationResult(true, ""));
					return results;
				}
				else
				{
					return emailValidator.validate(value).results;
				}
				
			} 
			/*if(target.hasOwnProperty('validationType') && target.validationType=='email')
			{
				super.required	= false
			}*/
			results = super.doValidation(value); //it will check for empty fields

			if (results.length > 0)
			{
				return results;
			}

			switch(dataType)
			{
				case 'N':
					if(target.validationFlag == 'true')
					{
						var valNumber:String = target.text.toString();
	
						if(target.negativeFlag=='true')
						{
							if(Number(valNumber)<-(target.maxValue) || Number(valNumber) > target.maxValue)
							{
								results.push(new ValidationResult(true, 'Number', 'Must between -' + target.maxValue + ' and + ' + target.maxValue, ' must between  -' + target.maxValue + ' and + ' + target.maxValue));
								return results;
							}
						} 
						else if(target.negativeFlag=='false')
						{
							if(Number(valNumber) < target.defaultValue || Number(valNumber) > target.maxValue)
							{
								results.push(new ValidationResult(true, 'Number', 'Must between ' + target.defaultValue + ' and '+ target.maxValue, ' must between ' + target.defaultValue + ' and '+ target.maxValue));
								return results;
							}
						}
					}	
											
					break;
			}
          
        	return results;
		}
	}
}
