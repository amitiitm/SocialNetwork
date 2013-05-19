package business.commands
{
	import business.delegates.ExportDelegate;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.generic.customcomponents.GenCustomReportDataGrid;
	import com.generic.customcomponents.GenDateField;
	import com.generic.genclass.Utility;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import model.GenModelLocator;
	
	import mx.collections.ArrayCollection;
	import mx.collections.HierarchicalCollectionView;
	import mx.collections.IViewCursor;
	import mx.controls.Alert;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.core.Application;
	import mx.managers.CursorManager;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	//export for report till 2 group;
	public class ExportCommand implements ICommand
	{
		private var __genModel:GenModelLocator=GenModelLocator.getInstance();
		private var arrColl:ArrayCollection;
		
		public function execute(event:CairngormEvent):void
		{
			var customReportObj:GenCustomReportDataGrid	=	__genModel.activeModelLocator.reportObj.customReportDataGrid;
			
			
			if(customReportObj.rows.children().length() <= 0)
			{
				return;	
			}
			
			//Alert.show((__genModel.activeModelLocator.reportObj.customReportDataGrid).rows.children().toString());
			
			CursorManager.setBusyCursor();
			Application.application.enabled = false;
			
		   	var htmlTableXml:XML;
			
			if(!customReportObj.ishavingGroup)
   			{ 
			   	htmlTableXml		=	getReportFormatForNoGroup();	
			}
			else if(!customReportObj.ishavingSummary && customReportObj.arrayOfGroupingFields.length	==	1)
			{
				htmlTableXml		=	getReportFormatForOneGroup();
			}
			else if(!customReportObj.ishavingSummary && customReportObj.arrayOfGroupingFields.length	==	2)
			{
				htmlTableXml		=	getReportFormatForTwoGroup();
			}
				
			else if(customReportObj.ishavingSummary  && customReportObj.arrayOfGroupingFields.length	==	2)
			{
				htmlTableXml		=	getReportFormatForOneGroup();
			}
			else if(customReportObj.ishavingSummary  && customReportObj.arrayOfGroupingFields.length	==	3)
			{
				htmlTableXml		=	getReportFormatForTwoGroup();
			}
			else
			{
				CursorManager.removeBusyCursor();
				Application.application.enabled = true;
				Alert.show('cannot export more than two groups.')
				return;
			}
			
			var utilityObj:Utility	=	new Utility();
			var encodedXML:XML		=	utilityObj.getEncodedXML(htmlTableXml);

			var callbacks:Responder 			= 	new Responder(exportCustomReportResultHandler, faultHandler);
			var delegate:ExportDelegate 		= 	new ExportDelegate(callbacks);
			delegate.getExportURL(encodedXML);

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
		    str	=	"<tr>"+ "<td>" + company_store_name +"</td>"+"<td/>"+"<td>" + new GenDateField().currentDate() +"</td>"+"</tr>"
		    htmlTableXml.appendChild(new XML(str));
		    
		     //view name
		    str	=	"<tr>"+ "<td>"+__genModel.applicationObject.selectedMenuItem.@name.toString()+' - '+__genModel.activeModelLocator.layoutObj.selectedLayout.name.toString()+"</td>"+"<td/>"+"<td>"+__genModel.activeModelLocator.viewObj.selectedView.name.toString()+"</td>"+"</tr>"
		    htmlTableXml.appendChild(new XML(str));
		  
		    //report name
		   /*  str	=	"<tr>"+ "<td>" +__genModel.applicationObject.selectedMenuItem.@name.toString()  +"</td>"+"</tr>"
		    htmlTableXml.appendChild(str); */
		    
		    //sub report name
		    /* str	=	"<tr>"+ "<td>" +__genModel.activeModelLocator.layoutObj.selectedLayout.name.toString()  +"</td>"+"</tr>"
		    htmlTableXml.appendChild(str); */
		    
		   //report layout
		   if(XML(__genModel.activeModelLocator.layoutObj.selectedLayout).child('print_orientation').toString()	==	'L')
		   {
		   		str	=	"<tr>"+ "<td>" + 'Landscape' +"</td>"+"</tr>"
		   		htmlTableXml.appendChild(new XML(str))
		   }
		   else
		   {
		   		str	=	"<tr>"+ "<td>" + 'Portrait' +"</td>"+"</tr>"
		   		htmlTableXml.appendChild(new XML(str))
		   }
			
		}
		private function setColumnSpecifications():void
		{
			  var structure:XML					=	GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).structure;
			  var obj:Object;	
			  arrColl	=	new ArrayCollection();
			  
			  for(var l:int=0 ;  l < structure.children().length() ; l++)
			  {
			  	if(structure.children()[l].isvisible.toString() == 'Y')
			  	{
			  		obj	=	new Object();
			  		
			  		
			  		switch(structure.children()[l].column_textalign.toString())
			  		{
			  			case  'L' :
						  			obj.textalign	=	'2'
						  			break;
			  			case  'R' :
						  			obj.textalign	=	'4'
						  			break;
			  			default :
			  						obj.textalign	=	'3'	 
			  		}
	
	
			  		switch(structure.children()[l].sortdatatype.toString())
			  		{
			  			case  'N' :
						  			obj.datatype	=	'N'
						  			break;
			  			case  'D' :
						  			obj.datatype	=	'D'
						  			break;
			  			default :
			  						obj.datatype	=	'S'
			  		}
	
			  		switch(structure.children()[l].column_datatype.toString())
			  		{
			  			case  'N' :
						  			if(!(String(structure.children()[l].column_precision) == 'NaN'  || String(structure.children()[l].column_precision) == ''))
									{
										obj.precision	=	Number(structure.children()[l].column_precision);
									}
									else
									{
										obj.precision	=	0;
									}
						  			
						  			break;
			  			
			  			default :
			  						obj.precision	=	'NaN'
			  		}		  							
					
					arrColl.addItem(obj);
				}
			  }
			
		}

		private function getReportFormatForNoGroup():XML
		{
		 	var hv:HierarchicalCollectionView	=	GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).dataProvider as HierarchicalCollectionView;
		    var cursor:IViewCursor				=	hv.createCursor();
		    var columns:Array					=	GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).columns;
		    var columnCount:int					=	GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).columns.length;
		    var str:String;
		    var htmlTableXml:XML				=	new XML(<table group = "G0"/>)
		   	var counter:int	=	1;
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
		   		str+= "<td"+" "+  "datatype ="+"'"+obj.datatype+"'"+  " "  + "align ="+"'"+obj.textalign+"'"  + " "+  "precision ="+"'"+obj.precision+"'" +">" + AdvancedDataGridColumn(GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).columns[i]).headerText.toString() + "</td>";
		   		++m;
		   }
		    str+="</tr>";
		   
		    htmlTableXml.appendChild(new XML(str));
		   
		    while (!cursor.afterLast)
           	{             
                 str ="<tr>";
                 
                for (var k:int = counter; k < columnCount; k++)
                {
              	 	if((columns[k] as AdvancedDataGridColumn).itemToLabel(cursor.current) == null)
               		{
               			str+="<td/>";
              	 	}
              	 	else
              	 	{
               			str+="<td>" + (columns[k] as AdvancedDataGridColumn).itemToLabel(cursor.current) + "</td>";
              	 	}
 				}
                str+="</tr>";
                htmlTableXml.appendChild(new XML(str));
                cursor.moveNext();
            }
           
          return htmlTableXml;
		}

		private function getReportFormatForOneGroup():XML
		{
		 	var hv:HierarchicalCollectionView	=	GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).dataProvider as HierarchicalCollectionView;
		    var cursor:IViewCursor				=	hv.createCursor();
		    var columns:Array					=	GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).columns;
		    var columnCount:int					=	GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).columns.length;
		    var str:String;
		    var htmlTableXml:XML				=	new XML(<table group = "G1"/>)
		   	var counter:int	=	1;
		    var s:String;
		   	var firstGroupingField:String;
		   	var structure:XML					=	GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).structure;
		   	var tempSelectedGroupXml:XMLList	=	XMLList(structure.children().(isgroup.toString()	==	'Y')).copy() 
		   	var utility:Utility	=	new Utility();
			var sortedXmlList:XMLList	=	utility.getSortedXmlList(tempSelectedGroupXml ,'group_level', 'N')
		   	var obj:Object;
		   	var isGroupRow:Boolean		=	false;
		   
		   	firstGroupingField			=	sortedXmlList[0].column_label.toString()
		   
		   
		   //if there is a group then we will start with column 0 otherwise with column 1;
		   if(GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).ishavingGroup)
		   {
		   		counter	=	0;
		   }
		    // for report Properties
		   
 			 setReportHeader(htmlTableXml);
			 setColumnSpecifications();
		  
		  
		   // we want columns header in first row
		   str	=	"<tr>";
		   var m:int = 0;
		   for(var i:int = 1; i < columnCount; i++)
		   {
		   		if(i == 1)
		   		{
					str+= "<td"+" "+  "datatype =" +"'" +"S" +"'" +  " "  + "align ="  +"'"+"2"+"'" + " "+  "precision =" +"'"+ "NaN"+"'"  +">" + "Row Type" + "</td>";
					str+= "<td"+" "+  "datatype =" +"'" +"S" +"'" +  " "  + "align ="  +"'"+"2"+"'" + " "+  "precision =" +"'"+ "NaN"+"'"  +">" + firstGroupingField + "</td>";		   			
		   		}
		   		
				obj	=	arrColl.getItemAt(m);
	   			str+= "<td"+" "+  "datatype ="+"'"+obj.datatype+"'"+  " "  + "align ="+"'"+obj.textalign+"'"  + " "+  "precision ="+"'"+obj.precision+"'" +">" + AdvancedDataGridColumn(GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).columns[i]).headerText.toString() + "</td>";
	   			++m;	   			
		   }
		    str+="</tr>";
		   
		    htmlTableXml.appendChild(new XML(str));
		   
		    while (!cursor.afterLast)
           	{             
                 str ="<tr>";
                 
                for (var k:int = 0; k < columnCount; k++)
                {
                   if(k == 0)
                   {
                   		if((columns[0] as AdvancedDataGridColumn).itemToLabel( cursor.current.GroupLabel).toString() != '')
                   		{
                   			str+="<td>" + "G" + "</td>";
                   			isGroupRow	=	true;
                   			htmlTableXml.appendChild(new XML("<tr>"+"<td>" + "B" + "</td>"+"</tr>"))
                   		}
                   		else
                   		{
                   			str+="<td>" + "R" + "</td>";
                   			isGroupRow	=	false;
                   		}
                   	 	str+="<td>" + (columns[k] as AdvancedDataGridColumn).itemToLabel( cursor.current.GroupLabel) + "</td>";
                   }
                   else
                   {
                  	 	if((columns[k] as AdvancedDataGridColumn).itemToLabel(cursor.current) == null)
                   		{
                   			str+="<td/>";
                  	 	}
                  	 	else
                  	 	{
                   			str+="<td>" + (columns[k] as AdvancedDataGridColumn).itemToLabel(cursor.current) + "</td>";
                  	 	}
                    }
                }
                str+="</tr>";
                htmlTableXml.appendChild(new XML(str));
               /*  if(isGroupRow)
                {
                	// we have to add a balnk row after group.
                	 htmlTableXml.appendChild("<tr>"+"<td>" + "B" + "</td>"+"</tr>")
                } */
                cursor.moveNext();
            }
           
          return htmlTableXml;
		}

		private function getReportFormatForTwoGroup():XML
		{
		 	var hv:HierarchicalCollectionView	=	GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).dataProvider as HierarchicalCollectionView;
		    var cursor:IViewCursor				=	hv.createCursor();
		    var columns:Array					=	GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).columns;
		    var columnCount:int					=	GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).columns.length;
		    var str:String;
		    var htmlTableXml:XML				=	new XML(<table group = "G2"/>)
		   	var counter:int	=	1;
		    var s:String;
		   	var firstGroupingField:String;
		   	var secondGroupingField:String;
		   	var structure:XML					=	GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).structure;
		   	var tempSelectedGroupXml:XMLList	=	XMLList(structure.children().(isgroup.toString()	==	'Y')).copy() 
		   	var utility:Utility	=	new Utility();
			var sortedXmlList:XMLList	=	utility.getSortedXmlList(tempSelectedGroupXml ,'group_level', 'N')
		   	var obj:Object;
		   	var isSecondGroupRow:Boolean		=	false;
		   	
		   	firstGroupingField			=	sortedXmlList[0].column_label.toString()
		   secondGroupingField			=	sortedXmlList[1].column_label.toString()
		   
		   //if there is a group then we will start with column 0 otherwise with column 1;
		   if(GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).ishavingGroup)
		   {
		   		counter	=	0;
		   }
		    // for report Properties
		   
			setReportHeader(htmlTableXml);
			setColumnSpecifications();		  
		  
		   // we want columns header in first row
		   str	=	"<tr>";
		   var m:int = 0;
		   for(var i:int = 1; i < columnCount; i++)
		   {
		   		if(i == 1)
		   		{
					str+= "<td"+" "+  "datatype =" +"'" +"S" +"'" +  " "  + "align ="  +"'"+"2"+"'" + " "+  "precision =" +"'"+ "NaN"+"'"  +">" + "Row Type" + "</td>";
					str+= "<td"+" "+  "datatype =" +"'" +"S" +"'" +  " "  + "align ="  +"'"+"2"+"'" + " "+  "precision =" +"'"+ "NaN"+"'"  +">" + firstGroupingField + "</td>";
					str+= "<td"+" "+  "datatype =" +"'" +"S" +"'" +  " "  + "align ="  +"'"+"2"+"'" + " "+  "precision =" +"'"+ "NaN"+"'"  +">" + secondGroupingField + "</td>";		   			
		   		}
		   		
				obj	=	arrColl.getItemAt(m);
	   			str+= "<td"+" "+  "datatype ="+"'"+obj.datatype+"'"+  " "  + "align ="+"'"+obj.textalign+"'"  + " "+  "precision ="+"'"+obj.precision+"'" +">" + AdvancedDataGridColumn(GenCustomReportDataGrid(__genModel.activeModelLocator.reportObj.customReportDataGrid).columns[i]).headerText.toString() + "</td>";
	   			++m;	   			
		   }
		    str+="</tr>";
		   
		    htmlTableXml.appendChild(new XML(str));
		   
		 
		   
		    while (!cursor.afterLast)
           	{             
                 str ="<tr>";
                 
                for (var k:int = 0; k < columnCount; k++)
                {
                   if(k == 0)
                   {
                   		if((columns[0] as AdvancedDataGridColumn).itemToLabel( cursor.current.GroupLabel).toString() != '')
                   		{
                   			cursor.moveNext() // because we have to check  wheher it is first group or second group
                   			if((columns[0] as AdvancedDataGridColumn).itemToLabel( cursor.current.GroupLabel).toString() != '')
                			{
                				//we have to add first group	
                				cursor.movePrevious();  //beacause we have moved to next row
                				str+="<td>" + "G" + "</td>";
                				str+="<td>" + (columns[k] as AdvancedDataGridColumn).itemToLabel( cursor.current.GroupLabel) + "</td>"; 
                				str+="<td/>" 
                				isSecondGroupRow	=	false;
                				htmlTableXml.appendChild(new XML("<tr>"+"<td>" + "B" + "</td>"+"</tr>"))
                			}
                			else
                			{
                				//we have to add second group
                				cursor.movePrevious();  //beacause we have moved to next row
                				
                				str+="<td>" + "G" + "</td>";
                				str+="<td/>" 
                				str+="<td>" + (columns[k] as AdvancedDataGridColumn).itemToLabel( cursor.current.GroupLabel) + "</td>";
                				isSecondGroupRow	=	true;
                				
                				//we donot have to add blank row before second group if it comes just after first group.
                				if(XML(htmlTableXml.children()[htmlTableXml.children().length() -1]).children()[0].toString() != 'G')
                				{
                					htmlTableXml.appendChild(new XML("<tr>"+"<td>" + "B" + "</td>"+"</tr>"))	
                				}
                			}
                   			
                   		}
                   		else
                   		{
                   			str+="<td>" + "R" + "</td>";
                   			str+="<td/>"
                   			str+="<td/>"
                   			isSecondGroupRow	=	false;
                   		}
                   	 	
                   }
                   else
                   {
                  	 	if((columns[k] as AdvancedDataGridColumn).itemToLabel(cursor.current) == null)
                   		{
                   			str+="<td/>";
                  	 	}
                  	 	else
                  	 	{
                   			str+="<td>" + (columns[k] as AdvancedDataGridColumn).itemToLabel(cursor.current) + "</td>";
                  	 	}
                    }
                }
                str+="</tr>";
                htmlTableXml.appendChild(new XML(str));
              /*   if(isSecondGroupRow)
                {
                	// we have to add a balnk row after second group.
                	htmlTableXml.appendChild("<tr>"+"<td>" + "B" + "</td>"+"</tr>")
                } */
                cursor.moveNext();
            }
           
           return htmlTableXml;
		   
		}
		private function getDateFormat():String
		{
			var date_format:String = __genModel.user.date_format.toLocaleUpperCase();
		
			if(date_format == null || date_format == "")
			{
				date_format = 'MM/DD/YYYY';
			}
		
			return date_format;
		}			
		private function exportCustomReportResultHandler(event:ResultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled = true; 
			
			
			var url:String = __genModel.path.report_export + event.result.toString();
			var request:URLRequest = new URLRequest(url);
			navigateToURL(request);
		}

		private function faultHandler(event:FaultEvent):void
		{
			CursorManager.removeBusyCursor();
			Application.application.enabled = true; 
			Alert.show(ExportCommand + " : " + event.fault.toString());
		}	
	}
}
