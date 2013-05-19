package business.commands
{
	import business.LookupServices;
	import business.delegates.GetLookupDataDelegate;
	import business.events.GetLookupDataEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.describeType;
	import flash.utils.setTimeout;
	
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import valueObjects.LookupVO;
	
	public class InitializeLookupCommand implements ICommand
	{
		private var processTimer:Timer = new Timer(900000, 1) // 15 mins (1 sec. = 1000 milisec.)
		private var callbacks:Responder;
		private var delegate:GetLookupDataDelegate;
		private var __lookupObj:LookupVO = GenModelLocator.getInstance().lookupObj;;

		public function execute(event:CairngormEvent):void
		{
			var description:XML = describeType(new LookupServices());
			var accessors:XMLList = description.accessor.(@access == "readwrite").@name;
			var i:int;

			callbacks = new Responder(lookupDataResultHandler, faultHandler);
			delegate = new GetLookupDataDelegate(callbacks);

			delegate.getLookupData("Lookup", GenModelLocator.getInstance().user.userID, GenModelLocator.getInstance().user.default_company_id);

			for(i=0; i<accessors.length(); i++)
			{
				if(! (accessors[i] == '' || accessors[i] == null || accessors[i] == 'Lookup'))
				{
					//getLookupData(accessors[i])
					setTimeout(getLookupData,10000,accessors[i]);
				}
			}
		}

		private function getLookupData(lookupName:String):void
		{
			var getLookupDataEvent:GetLookupDataEvent;
			
			getLookupDataEvent = new GetLookupDataEvent(lookupName);
			getLookupDataEvent.dispatch();
		}

		private function lookupDataResultHandler(event:ResultEvent):void
		{
			var newXML:XML = (XML)(event.result);
			var oldXML:XML = new XML(__lookupObj.lookup);
			var name:String;
			var newVersion:String;
			var oldVersion:String;
			var tempXMLList:XMLList;  

			__lookupObj.lookup = newXML

			if(oldXML.children().length() > 0)
			{
				for(var i:int=0; i<newXML.children().length(); i++)
				{
					name = newXML.children()[i]["name"].toString()
					newVersion = newXML.children()[i]["version"].toString()
					
					tempXMLList = oldXML.lookup.(elements("name") == name)
					oldVersion = tempXMLList[0]["version"].toString()
					
					if(oldVersion != newVersion)
					{
						getLookupData(name)
					}
				}
			}
			
			//setTimer()
		}

		private function faultHandler(event:FaultEvent):void
		{
			Alert.show('fault'+event.fault.toString());
		}
		
		/*
		private function setTimer():void
		{
			processTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			processTimer.start()
		}
		*/
		
		/*
		private function timerCompleteHandler(event:TimerEvent):void
		{
			processTimer.start()

			callbacks = new Responder(lookupDataResultHandler, faultHandler);
			delegate = new GetLookupDataDelegate(callbacks);

			delegate.getLookupData("Lookup", GenModelLocator.getInstance().user.userID, GenModelLocator.getInstance().user.default_company_id);
		}
		*/
	}
}
