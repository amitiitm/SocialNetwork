package model
{
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.generic.customcomponents.GenTabNavigator;
	
	import valueObjects.ApplicationVO;
	import valueObjects.DetailUpdateVO;
	import valueObjects.DrillVO;
	import valueObjects.LookupVO;
	import valueObjects.PathVO;
	import valueObjects.UserVO;
	
	[Bindable]
	public class GenModelLocator
	{
		public static var comapnyShortName:String = '';
		public static var main_url:String = "";
		//public static var main_url:String = ".retail:5000";
		
		public var isLockScreen:Boolean = false;
		
		// Login information
		public var user:UserVO;
		
		public var applicationObject:ApplicationVO = new ApplicationVO();
		public var drillObj:DrillVO	= new DrillVO();
		
		// Drilldown
		public var context:int;
		public var triggerSource:String;

		// All paths
		public var path:PathVO;

		// Combobox data
		public var masterData:XML;
		
		// For lookup
		public var lookupObj:LookupVO = new LookupVO();
		
		// Vivek Dubey 04 Oct 2011
	  	  public var detailUpdateObj:DetailUpdateVO =	new DetailUpdateVO();

		public var notes:XML;
		public var attachments:XML;

		public var services:ServiceLocator;
		public var controller:Object;


		//active tab page information
		public var activeModelLocator:Object;
		
		//tabnavigator
		public var tabMain:GenTabNavigator
		
		static private var __instance:GenModelLocator	=	null;
		
		
		// specific for tekwled (sarvesh)
		public var objectFromQuickAdd:XML  = new XML(<rows></rows>);
		public var objectFromDrilldown:XML = new XML(<rows></rows>);           
		public static var currentVersion:String='';	
		public var defaultSetupXml:XML ;
		public var screenRefreshTimeInterval:Number  = (2*60*1000);          // means 2 min
		
		static public function getInstance():GenModelLocator
		{
			if(__instance == null)
			{
				__instance	=	new GenModelLocator();
			}
			return __instance;
		}

		public function GenModelLocator()
		{
			if ( __instance != null )
			{
				throw new CairngormError(CairngormMessageCodes.SINGLETON_EXCEPTION, "GenModelLocator" );
			}
	            
    		__instance = this;
		}
		
		public function setNull():void
		{
			__instance = null;
		}
	}
}