package valueObjects
{
	import com.generic.components.Import;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	[Bindable]
	public class ImportVO
	{
		public var container:Container;
		public var genObjects:ArrayCollection;
		public var validators:Array;
		public var records:XML		=	null;
		public var tablenames:Array	=	null;
		
		/*called from activeModelLocator(like SalesOrderModelLocator) setNull() */	
		public function setNull():void
		{
			removeEventListners()
			
			container	=	null
			genObjects			=	null		
			validators			=	null
			
			
			records				=	null
			tablenames			=	null;
			
		}
		private function removeEventListners():void
		{
			Import(container).removeEventListnerFromComponent()
			
		}
	}
}
