package com.generic.events
{
	import flash.events.Event;
	import mx.controls.Alert;
	
	public class LoginEvent extends Event 
	{ 
		public static const LOGIN:String = "login"; 
		public static const CREATEUSER:String = "createuser"; //Create New Login and Company Jayesh 20 July 2009
		public static const CREATECOMPANY:String = "createcompany"; //Create New Login and Company Jayesh 20 July 2009
		
		public function LoginEvent(type:String) 
		{ 
			super(type, true);
		}

		override public function clone():Event
		{
			return new LoginEvent(type)  
        }
	}
}
