package business.commands
{
	import business.delegates.FetchRecordDelegate;
	import business.events.GetGenDataGridFormatEvent;
	import business.events.GetGenListDataEvent;
	import business.events.InitializeFetchRecordsWithDetailEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.customcomponents.GenDataGrid;
	import com.generic.genclass.GenObject;
	import com.generic.genclass.GenValidator;
	import com.generic.genclass.Utility;
	
	import flash.utils.getQualifiedClassName;
	
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
	
	public class InitializeFetchRecordsWithDetailCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __detailEditObj:DetailEditVO;
		private var  dgFetchDtl:GenDataGrid;
		private var callbacks:IResponder;
		private var mappingArrCol:ArrayCollection;
		public function execute(event:CairngormEvent):void
		{
			__detailEditObj = __genModel.activeModelLocator.detailEditObj;
			mappingArrCol	=	__detailEditObj.fetchMapingArrCol;
			
			var genObj:GenObject = new GenObject();
			var genValidator:GenValidator = new GenValidator();
			var getGenDataGridFormatEvent:GetGenDataGridFormatEvent;
			var getGenListDataEvent:GetGenListDataEvent;
			
			CursorManager.setBusyCursor();
		
			//	__detailEditObj.detailEditContainer.enabled	=	false;
			__detailEditObj.genObjects = genObj.getGenObjects(__detailEditObj.detailEditContainer);
			__detailEditObj.validators = genValidator.applyValidation(__detailEditObj.genObjects)
			
			for(var i:int = 0; i < __detailEditObj.genObjects.length; i++)
			{
				if( getQualifiedClassName(__detailEditObj.genObjects[i]) == "com.generic.customcomponents::GenDataGrid"
					||	getQualifiedClassName(__detailEditObj.genObjects[i]) == "com.generic.components::Detail"
					|| 	getQualifiedClassName(__detailEditObj.genObjects[i]) == "com.generic.components::EditableDetail"
					|| 	getQualifiedClassName(__detailEditObj.genObjects[i]) == "com.generic.components::NewDetail"
				  )
				{
					getGenDataGridFormatEvent = new GetGenDataGridFormatEvent(__detailEditObj.genObjects[i]);
					getGenDataGridFormatEvent.dispatch();
				}
				else if(getQualifiedClassName(__detailEditObj.genObjects[i]) == "com.generic.customcomponents::GenList")
				{
					getGenListDataEvent = new GetGenListDataEvent(__detailEditObj.genObjects[i]);
					getGenListDataEvent.dispatch();
				}
			}
			
			callbacks = (event as InitializeFetchRecordsWithDetailEvent).callbacks;
			
			var callbacksFormat:Responder 	= new Responder(fetchRecordFormatHandler, faultHandler);
			var callbacksData:Responder		= new Responder(fetchRecordDataHandler, faultHandler);
			
			var delegate:FetchRecordDelegate = new FetchRecordDelegate(callbacksFormat ,callbacksData );
			
			dgFetchDtl	=	(event as InitializeFetchRecordsWithDetailEvent).genDataGrid ; 
			
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
					  	childXml.isExistAtPosition	=	j;
					  	childXml.isAppend			=	'Y'
					  
					  	__detailEditObj.rows.appendChild(rows.children()[j].copy());
					  
					 	 childXml.isAppendAtPostion	=	 __detailEditObj.rows.children().length()  -1;
					  
					  	modifyUpdatableTags( __detailEditObj.rows.children().length() -1,childXml)
					  	/* user can unselect already exist item but isAlreadyExist flag will remain 'Y' for that, so it will help
					  	to identified alresdy present item even if user has unchecked it */
					  
					  	break;
					}
				}	
				if(!isAlreadyExist)
				{
					childXml.select_yn		=	'N';
					childXml.isAlreadyExist	=	'N'
					
					 childXml.isAppend		=	'N'
				}
			}
			dgFetchDtl.rows	=	openDocXml;
			callbacks.result('DATA COMPLETED');
			
			CursorManager.removeBusyCursor();
			__detailEditObj.detailEditContainer.enabled	=	true;
		}
		/*it will modify only that tag of existing child in detailRows with sourceXml which are updatable in mapping*/
		private function modifyUpdatableTags(childPos:int , sourceXml:XML):void
		{
			var detailRows:XML	= __detailEditObj.rows;
			for(var k:int = 0; k < mappingArrCol.length; k++)
			{
				if(String(mappingArrCol.getItemAt(k).updatable).toUpperCase() == 'Y')// we have to modified only which has updatable=Y
				{
					detailRows.children()[childPos].replace(mappingArrCol.getItemAt(k).target,sourceXml.child(mappingArrCol.getItemAt(k).source))
				}
			}
			
		}
		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled	=	true;
			
			Alert.show('InitializeFetchRecordsCommand'+ event.fault.toString());
		}
	}
}	