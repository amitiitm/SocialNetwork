package business.commands
{
	import business.delegates.PrintDelegate;
	import business.events.PrintEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.customcomponents.GenDataGrid;
	import com.generic.customcomponents.GenDateField;
	import com.generic.genclass.Utility;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import model.GenModelLocator;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.ListCollectionView;
	import mx.controls.Alert;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import valueObjects.ModeVO;
	
	public class PrintCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		private var arrColl:ArrayCollection;
		
		public function execute(event:CairngormEvent):void
		{
			if(__genModel.activeModelLocator.documentObj.selectedMode	==	ModeVO.LIST_MODE)
			{
				if(GenDataGrid(__genModel.activeModelLocator.listObj.listGrid).rows.children().length() <= 0)
				{
					return;	
				}
				CursorManager.setBusyCursor();
		 		Application.application.enabled	= false; 
				var reportXml:XML		=	printList();
				var utilityObj:Utility	=	new Utility();
				var encodedXML:XML		=	utilityObj.getEncodedXML(reportXml);
				var callbacksPrintReport:Responder = new Responder(printCommandResultHandler, faultHandler);
				var delegate:PrintDelegate = new PrintDelegate(callbacksPrintReport);
				delegate.getPrintReportURL(encodedXML);
			}
			else if(__genModel.activeModelLocator.addEditObj.record != null)
			{
				if(XML(__genModel.activeModelLocator.addEditObj.record).children()[0].id.toString() != '')
				{
					CursorManager.setBusyCursor();
					Application.application.enabled	= false;
					
					var printInExcel:String	=	(event as PrintEvent).printInExcel;
					
					var callbacksPrint:Responder = new Responder(printCommandResultHandler, faultHandler);
					var delegate:PrintDelegate = new PrintDelegate(callbacksPrint)
					
					delegate.getPrintURL(XML(__genModel.activeModelLocator.addEditObj.record).children()[0].id.toString(),printInExcel);
				}
				else
				{
					Alert.show('Please save/get record first');
				}
			}
			else
			{
				Alert.show('Please save/get record first');
			}
		}
		private function printList():XML
		{
		 	var hv:ListCollectionView			=	GenDataGrid(__genModel.activeModelLocator.listObj.listGrid).dataProvider as ListCollectionView;
		    var cursor:IViewCursor				=	hv.createCursor();
		    var columns:Array					=	GenDataGrid(__genModel.activeModelLocator.listObj.listGrid).columns;
		    var columnCount:int					=	GenDataGrid(__genModel.activeModelLocator.listObj.listGrid).columns.length;
		    var str:String;
		    var htmlTableXml:XML				=	new XML(<table group = "G0"/>)
		   	var counter:int	=	0;
		    var s:String;
		   	var obj:Object;
		   	
		   
		    // for report Properties
		   
			setReportHeader(htmlTableXml);
			setColumnSpecifications();
		  			 		    
		  
		   // we want columns header in first row
		   str	=	"<tr>";
		   var m:int = 0;
		   for(var i:int = counter; i < columnCount; i++)
		   {
		   		obj	=	arrColl.getItemAt(m);
		   		str+= "<td"+" "+  "datatype ="+"'"+obj.datatype+"'"+  " "  + "align ="+"'"+obj.textalign+"'"  + " "+  "precision ="+"'"+obj.precision+"'" +">" + DataGridColumn(GenDataGrid(__genModel.activeModelLocator.listObj.listGrid).columns[i]).headerText.toString() + "</td>";
		   		++m;
		   }
		    str+="</tr>";
		   
		    htmlTableXml.appendChild(new XML(str));
		   
		    while (!cursor.afterLast)
           	{             
                 str ="<tr>";
                 
                for (var k:int = counter; k < columnCount; k++)
                {
                	str+="<td>" + (columns[k] as DataGridColumn).itemToLabel(cursor.current) + "</td>";
                }
                str+="</tr>";
                htmlTableXml.appendChild(new XML(str));
                cursor.moveNext();
            }
          
		 	return htmlTableXml;
		}
		private function setReportHeader(htmlTableXml:XML):void
		{
		   var str:String;
		   var company_store_name:String;
		   
		   if(__genModel.user.organization_name.toString()	==	__genModel.user.company_name.toString())
		   {
		   		company_store_name	=	__genModel.user.organization_name.toString()
		   }
		   else
		   {
		   		company_store_name	=	__genModel.user.organization_name.toString()+ ' - ' + __genModel.user.company_name.toString()
		   }
		   
		   //company name - store name ,date
		    str	=	"<tr>"+ "<td>" + company_store_name +"</td>"+"<td/>"+"<td>" + new GenDateField().currentDate() + "</td>"+"</tr>"
		    htmlTableXml.appendChild(new XML(str));
		    
		    //report name - sub report name ,view name
		    str	=	"<tr>"+ "<td>"+__genModel.applicationObject.selectedMenuItem.@name.toString()+' - '+'List'+"</td>"+"<td/>"+"<td>"+__genModel.activeModelLocator.viewObj.selectedView.name.toString()+"</td>"+"</tr>"
		    htmlTableXml.appendChild(new XML(str));
		  
		    //report name
		    /* str	=	"<tr>"+ "<td>" +__genModel.applicationObject.selectedMenuItem.@name.toString()  +"</td>"+"</tr>"
		    htmlTableXml.appendChild(str); */
		    
		    //sub report name
		    /* str	=	"<tr>"+ "<td>" + 'List' +"</td>"+"</tr>"
		    htmlTableXml.appendChild(str); */

		  //report layout
		   if(__genModel.activeModelLocator.listObj.print_orientation	==	'L')
		   {
		   		str	=	"<tr>"+ "<td>" + 'Landscape' +"</td>"+"</tr>"
		   		htmlTableXml.appendChild(new XML(str));
		   }
		   else
		   {
		   		str	=	"<tr>"+ "<td>" + 'Portrait' +"</td>"+"</tr>"
		   		htmlTableXml.appendChild(new XML(str));
		   }		    
		}
		private function setColumnSpecifications():void
		{
			  var structure:XML					=	GenDataGrid(__genModel.activeModelLocator.listObj.listGrid).structure;
			  var obj:Object;	
			  arrColl	=	new ArrayCollection();
			  
			  for(var l:int=0 ;  l < structure.children().length() ; l++)
			  {
			  	if(String(structure.children()[l].@visible.toString()).toUpperCase() == 'TRUE')
			  	{
			  		obj	=	new Object();
			  		
			  		
			  		switch(String(structure.children()[l].@textAlign.toString()).toUpperCase())
			  		{
			  			case  'LEFT' :
						  			obj.textalign	=	'2'
						  			break;
			  			case  'RIGHT' :
						  			obj.textalign	=	'4'
						  			break;
			  			default :
			  						obj.textalign	=	'3'	 
			  		}
	
	
			  		switch(String(structure.children()[l].@sortDataType.toString()).toUpperCase())
			  		{
			  			case  'N' :
						  			obj.datatype	=	'N'
						  			if(!(String(structure.children()[l].@columnPrecision) == 'NaN'  || String(structure.children()[l].@columnPrecision) == ''))
									{
										obj.precision	=	Number(structure.children()[l].@columnPrecision);
									}
									else
									{
										obj.precision	=	0;
									} 
									
						  			break;
			  			case  'D' :
						  			obj.datatype	=	'D';
						  			obj.precision	=	'NaN';
						  			break;
			  			default :
			  						obj.datatype	=	'S';
			  						obj.precision	=	'NaN';
			  		}
	
					
					arrColl.addItem(obj);
				}
			  }
			
		}
		
		private function printCommandResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled = true;
			
			var url:String = __genModel.path.report_print  + XML(event.result)["result"].toString()
			var request:URLRequest = new URLRequest(url);

			navigateToURL(request);
		}	

		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled = true;
			
			Alert.show(event.fault.toString());	
		}		
	}
}
