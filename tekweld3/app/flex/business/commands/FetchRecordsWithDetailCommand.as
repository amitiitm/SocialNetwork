package business.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.components.FetchRecordsWithDetail;
	import com.generic.customcomponents.GenTextInput;
	
	import model.GenModelLocator;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	import mx.managers.PopUpManager;
	
	public class FetchRecordsWithDetailCommand implements ICommand
	{
		private var __genModel:GenModelLocator = GenModelLocator.getInstance();
		private var __addEditContainer:Container;
		private var fetchComponent:FetchRecordsWithDetail;
		private var rootNode:String;
		public function execute(event:CairngormEvent):void
		{
			rootNode= (__genModel.activeModelLocator.detailEditObj.genDataGrid.rootNode);	
			
			__addEditContainer = __genModel.activeModelLocator.addEditObj.addEditContainer
			__genModel.activeModelLocator.detailEditObj.rows	=	new XML('<' + rootNode + '/>')
			openDetailEdit();
			
		}

		private function openDetailEdit():void
		{
			fetchComponent = FetchRecordsWithDetail(PopUpManager.createPopUp(__addEditContainer, FetchRecordsWithDetail, true));
			
			generateHeaderComponent();
			
			fetchComponent.vbDetail.addChild(__genModel.activeModelLocator.detailEditObj.detailEditContainer);
			
			__genModel.activeModelLocator.detailEditObj.detailEditContainer	=	fetchComponent.vbRow;
			fetchComponent.x 		= fetchComponent.x + fetchComponent.width / 6
			fetchComponent.y 		= fetchComponent.y + fetchComponent.height / 6
			fetchComponent.title	=	__genModel.activeModelLocator.detailEditObj.title;
			//__genModel.activeModelLocator.detailEditObj.detailEditContainer	=	fetchComponent;
		}
		private function generateHeaderComponent():Boolean
		{
			var mappingArrCol:ArrayCollection 	= 		__genModel.activeModelLocator.detailEditObj.fetchMapingArrCol;
			var genTextInput:GenTextInput;
			
			var localName:String = rootNode.slice(0, rootNode.length - 1)
			
			
			
			for(var j:int=0; j < mappingArrCol.length; j++)
			{
				genTextInput				=	new GenTextInput();
				genTextInput.tableName		=	localName;
				genTextInput.xmlTag			=	mappingArrCol.getItemAt(j).target;
				genTextInput.updatableFlag	=	"true";
				
				fetchComponent.hbHeader.addChild(genTextInput);
			}
			
				genTextInput				=	new GenTextInput();
				genTextInput.tableName		=	localName;
				genTextInput.xmlTag			=	'trans_flag';
				genTextInput.defaultValue	=	"A";
				genTextInput.updatableFlag	=	"true";
				
				fetchComponent.hbHeader.addChild(genTextInput);
				
				genTextInput				=	new GenTextInput();
				genTextInput.tableName		=	localName;
				genTextInput.xmlTag			=	'serial_no';
				genTextInput.defaultValue	=	"";
				genTextInput.updatableFlag	=	"true";
				
				fetchComponent.hbHeader.addChild(genTextInput);
				
			return true;	
		}
	}
}	

