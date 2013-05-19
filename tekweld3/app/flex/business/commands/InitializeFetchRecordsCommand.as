package business.commands
{
	import business.delegates.FetchRecordDelegate;
	import business.events.InitializeFetchRecordsEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.customcomponents.GenDataGrid;
	import com.generic.genclass.Utility;
	
	import model.GenModelLocator;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import valueObjects.DetailEditVO;
	
	public class InitializeFetchRecordsCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __detailEditObj:DetailEditVO;
		private var  dgFetchDtl:GenDataGrid;
		private var callbacks:IResponder;
		
		public function execute(event:CairngormEvent):void
		{
			__detailEditObj = __genModel.activeModelLocator.detailEditObj;
			
			CursorManager.setBusyCursor();
			__detailEditObj.detailEditContainer.enabled	=	false;
			
			callbacks = (event as InitializeFetchRecordsEvent).callbacks;
			
			var callbacksFormat:Responder 	= new Responder(fetchRecordFormatHandler, faultHandler);
			var callbacksData:Responder		= new Responder(fetchRecordDataHandler, faultHandler);
			
			var delegate:FetchRecordDelegate = new FetchRecordDelegate(callbacksFormat ,callbacksData );
			
			dgFetchDtl	=	(event as InitializeFetchRecordsEvent).genDataGrid ; 
			
			if(__detailEditObj.isFetchFromCriteria)
			{
				delegate.getFetchRecordFormat(__detailEditObj.fetchDetailFormatServiceID);
				delegate.getFetchRecordDataFromCriteria(__detailEditObj.fetchCriteriaXML , __detailEditObj.fetchDetailDataServiceID);
			}
			else
			{
				delegate.getFetchRecordFormat(__detailEditObj.fetchDetailFormatServiceID);
				delegate.getFetchRecordData(__detailEditObj.id , __detailEditObj.fetchDetailDataServiceID, __genModel.user.default_company_id)
			}
		}
		
		private function fetchRecordFormatHandler(event:ResultEvent):void
		{
			dgFetchDtl.structure = (XML)(event.result);
			callbacks.result('STRUCTURE COMPLETED');
		}
		
		private function fetchRecordDataHandler(event:ResultEvent):void
		{
			var openDocXml:XML;
			var utilityObj:Utility	=	new Utility();
			openDocXml 				= 		utilityObj.getDecodedXML((XML)(event.result));
			
			//var openDocXml:XML	=	XML(event.result);
			var i:int
			var j:int
			var k:int
			var childXml:XML
			var rows:XML	=	(__detailEditObj.genDataGrid.rows).copy();
			var length:int	=	rows.children().length()
			var isAlreadyExist:Boolean	=	false;
			
			var mappingArrCol:ArrayCollection	=	__detailEditObj.fetchMapingArrCol;
			var primaryKeys:Array	=	new Array();
		
		
			for(i=0;i< mappingArrCol.length; i++)
			{
				if((mappingArrCol.getItemAt(i).isPrimaryKey).toString().toUpperCase() ==	'Y')
				{
					primaryKeys.push(mappingArrCol.getItemAt(i));
				}
			} 
			
			for(i=0; i < openDocXml.children().length() ; i++)
			{
				childXml	=	XML(openDocXml.children()[i])
				isAlreadyExist	=	false;
				
				for(j=0; j < length ; j++)
				{
					for(k=0; k < primaryKeys.length ; k++)
					{
						if(childXml.child(primaryKeys[k].source).toString()	== rows.children()[j].child(primaryKeys[k].target).toString())
						{
							isAlreadyExist	=	true;
						}
						else
						{
							isAlreadyExist	=	false;
							break;
						}
					}
					if(isAlreadyExist)
					{
						childXml.select_yn	=	'Y';
					  	childXml.trans_flag	=	'A'
					  	childXml.isAlreadyExist	=	'Y' 
					  	/* user can unselect already exist item but isAlreadyExist flag will remain 'Y' for that, so it will help
					  	to identified alresdy present item even if user has unchecked it */
					  	break;
					}
				}	
				if(!isAlreadyExist)
				{
					childXml.select_yn	=	'N';
					childXml.isAlreadyExist	=	'N'
				}
			}
			dgFetchDtl.rows	=	openDocXml;
			callbacks.result('DATA COMPLETED');
			
			CursorManager.removeBusyCursor();
			__detailEditObj.detailEditContainer.enabled	=	true;
		}
		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			
			Alert.show('InitializeFetchRecordsCommand'+ event.fault.toString());
		}
	}
}	

