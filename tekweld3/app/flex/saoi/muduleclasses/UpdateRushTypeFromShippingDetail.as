package saoi.muduleclasses
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import model.GenModelLocator;

	public class UpdateRushTypeFromShippingDetail
	{
		public var __genModel:GenModelLocator ;
		public var __localModel:Object;
		public var __services:ServiceLocator;
		
		private var cbRushType:Object;
		private var dtlShipping:Object;
		
		private const DEFAULTRUSHITEM1:String   = "RUSHDAY1";
		private const DEFAULTRUSHITEM2:String	= "RUSHDAY2";
		
		public function UpdateRushTypeFromShippingDetail()
		{
			__genModel		= GenModelLocator.getInstance();
			__localModel	= __genModel.activeModelLocator;
			__services		= __genModel.services;
		}
		
		public function updateRushType(cbRushType:Object,dltShipping:Object):void
		{
			
			
		}
	}
}