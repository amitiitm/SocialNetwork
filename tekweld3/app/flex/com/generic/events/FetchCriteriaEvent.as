package com.generic.events
{
	import flash.events.Event;
	
	
	public class FetchCriteriaEvent extends Event
	{
		public static const OK_CLICK_EVENT:String = "okClickEvent";
		
		
		public var criteriaXML:XML;
		
		public function FetchCriteriaEvent(type:String , aXML:XML)
		{
			super(type,true);
			this.criteriaXML	=	aXML;
		}
		
		override public function clone():Event
		{
			return new FetchCriteriaEvent(type,criteriaXML);
        }  
	} 
 }
