package saoi.muduleclasses
{
	import mx.controls.TextInput;
	import mx.controls.ToolTip;
	import mx.events.ValidationResultEvent;
	import mx.managers.ToolTipManager;
	import mx.validators.EmailValidator;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	public class MultipleEmailValidator extends Validator
	{
		public var ERROR_MESSAGE:String  	   = "Emails are Invalid.";
		private var results:Array;
		private var emailValidaror:EmailValidator  = new EmailValidator();
		private var _seprator:String   = ',';
		private var myTip:ToolTip;
		
		public function set seprator(value:String):void
		{
			_seprator  = value;
		}
		public function get seprator():String
		{
			return _seprator;
		}
		
		public function MultipleEmailValidator()
		{
			super();
		}
		
		private function isAllEmailValid(param:String):Boolean
		{
			var returnvalue:Boolean = true;
			
			var emailArray:Array = param.split(seprator);
			
			for(var i:int=0; i<emailArray.length ; i++)
			{
				var email:String  		= emailArray[i];
				var ti:TextInput  		= new TextInput();
				ti.text           		= email;
				emailValidaror.property = 'text';
				emailValidaror.source	= ti;
				emailValidaror.required = this.required;
				var result:ValidationResultEvent = emailValidaror.validate();
				if(result.type==ValidationResultEvent.INVALID)
				{
					returnvalue  	= false;
					ERROR_MESSAGE 	= result.message;
					break;
				}
			}
			return returnvalue;
			
		}
		private function createErrorTip(errorMessage:String):void 
		{
			if(errorMessage!='')
			myTip = ToolTipManager.createToolTip(errorMessage, this.source.x + this.source.width,this.source.y,"errorTipRight") as ToolTip;
		}
		
		override protected function doValidation(value:Object):Array 
		{
			results = [];
			results = super.doValidation(value);
			if (!isAllEmailValid(value.toString()))
			{
				results.push(new ValidationResult(true, null, "SO102", ERROR_MESSAGE));
			}     
			/*if(results.length>0)
			{
				createErrorTip(ERROR_MESSAGE);
			}
			else
			{
				if(myTip!=null)
				ToolTipManager.destroyToolTip(myTip);
			}*/
			return results;
		}
	}
}