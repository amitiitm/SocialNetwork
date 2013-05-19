package com.generic.events
{
	import flash.events.Event;

	public class GenComponentEvent extends Event
	{
		public static const VALUE_UPDATE_EVENT:String = "valueUpdateEvent";
		public static const RESET_EVENT:String = "resetEvent";
		public static const RETRIEVE_END_EVENT:String = "retrieveEndEvent";
		public static const VALUE_UPDATE_COMPLETE_EVENT:String = "valueUpdateCompleteEvent";
		public static const MAKE_DISABLE_EVENT:String = "makeDisableEvent";
		
		//
		public var value:XML;

		public function GenComponentEvent(type:String , aXML:XML=null)
		{
			super(type, true);
			this.value = aXML;
		}

		override public function clone():Event
		{
			return new GenComponentEvent(type)
        }
	}
}
