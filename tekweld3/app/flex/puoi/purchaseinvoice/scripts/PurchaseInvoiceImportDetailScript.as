import com.generic.components.Detail;
import com.generic.events.DetailAddEditEvent;
import com.generic.events.DetailEvent;

import flash.net.URLRequest;
import flash.net.navigateToURL;

import model.GenModelLocator;

import mx.controls.Alert;
import mx.formatters.NumberFormatter;

import valueObjects.DetailEditVO;

private var resultXml:XML		=	new XML(<rows/>);
private var __genModel:GenModelLocator	=	GenModelLocator.getInstance();
private var uniqueHeaderField:String	=	'packet_code';
private var uniqueHeaderFieldInMainGrid:String	=	'catalog_item_packet_code'
private var detailRequiredField:String	=	'stone_type';
private var numericFormatter2:NumberFormatter 	= new NumberFormatter();
private var numericFormatter3:NumberFormatter 	= new NumberFormatter();
private var modifiedXML:XML;
private var isErrorMsg:Boolean	=	false;
private var tableNames:Array	=	new Array({tablename:'catalog_item_packet'}, {tablename:'catalog_item_packet_stone'},{tablename:'catalog_item_packet_diamond'});

private function creationCompleteHandler():void
{
	numericFormatter2.precision = 2;
	numericFormatter2.rounding = "nearest";
	numericFormatter2.useThousandsSeparator = false;
	
	numericFormatter3.precision = 3;
	numericFormatter3.rounding = "nearest";
	numericFormatter3.useThousandsSeparator = false;
				
	if(__genModel.masterData.child('invn').child('packet_breakup').child('value').toString() != 'Y')
	{
		tbDetail.visible	=	false;
		tbDetail.height		=	0;
		tbDetail.width		=	0;
	}
		
}
private function generateHeaderXML(resultXml:XML):XML
{
	var tempList:XMLList = resultXml.children();
	var filterList:XMLList;
	var xmlMain:XML = new XML(<catalog_item_packets/>);
	var strName:String;
	var strValue:String;
	var xml:XML;
	
	var diamStoneQty:int;
	var diamStoneWt:Number;
	var diamValue:Number;
	
	var stoneQty:int;
	var stoneWt:Number;
	var stoneValue:Number;

	if (tempList.length() > 0)
	{
		strName = uniqueHeaderField.toString();

		while(true)
		{
			strValue = tempList.elements(strName)[0].toString() 
			filterList = tempList.(elements(strName) == strValue)

			if(filterList.length() > 0)
			{

				diamStoneQty		=	0;
				diamStoneWt			=	0;
				diamValue			=	0;
				
				stoneQty		=	0;
				stoneWt			=	0;
				stoneValue		=	0;		
				
				xml = new XML(<catalog_item_packet/>)
	
		       	
		       	//all other infornmation
		       	xml.catalog_item_packet_code			=	filterList[0].packet_code.toString()
		       	xml.catalog_item_code					=	filterList[0].style_code.toString()
		       	xml.metal_type							=	filterList[0].metal_type.toString()
		       	xml.metal_color							=	filterList[0].metal_color.toString()
		       
		       //we have to sum up these value and put in diam or stone
		       	for(var j:int = 0 ; j	< filterList.length()	;	j++)
		 		{
		 			if(filterList[j].stone_type.toString()	==	'DIAM')
		 			{
		 				diamStoneQty		=	diamStoneQty	+	int(filterList[j].stone_qty.toString());
						diamStoneWt			=	diamStoneWt		+	Number(filterList[j].stone_wt.toString());
						diamValue			=	diamValue		+	Number(filterList[j].diam_value.toString());
		 				
		 			}
		 			else if(filterList[j].stone_type.toString()	!=	'')
		 			{
		 				stoneQty			=	stoneQty	+	int(filterList[j].stone_qty.toString());
						stoneWt				=	stoneWt		+	Number(filterList[j].stone_wt.toString());
						stoneValue			=	stoneValue	+	Number(filterList[j].diam_value.toString());
		 				
		 			}
		 		}
		 		
		 		xml.diamond_qty							=	diamStoneQty;
		       	xml.diamond_wt							=	numericFormatter3.format(diamStoneWt);
		       	xml.total_diamond_amt					=	numericFormatter2.format(diamValue);
		       	
		       	xml.color_stone_qty						=	stoneQty;
		       	xml.color_stone_wt						=	numericFormatter3.format(stoneWt);
		       	xml.total_stone_amt						=	numericFormatter2.format(stoneValue)	 ;      	
		       
		       	xml.metal_base_rate						=	filterList[0].gold_base_rate.toString();
		       	xml.qty									=	"1"
		       	xml.casting_wt							=	filterList[0].finished_gold_wt.toString();
				
				/*888888*/		     
		       	xml.metal_total_rate 					=	filterList[0].gold_base_rate.toString();
		       	xml.casting_cost 						=	filterList[0].total_gold_rate.toString();
		       
		       	xml.casting_amt							=	filterList[0].gold_value.toString();
		       	xml.finding_wt							=	filterList[0].finding_wt.toString();
		       	xml.finding_amt							=	filterList[0].finding_value.toString();
		       	xml.setting_amt							=	filterList[0].setting_amt.toString();
		       	xml.labor_amt							=	filterList[0].labor_amt.toString();
		       
		       if(filterList[0].unit_price.toString()	==	'' || (Number(filterList[0].unit_price.toString())).toString()	==	'NaN')
		       {
		       		xml.price							=	"0";						
		       }
		       else
		       {
		       		xml.price							=	filterList[0].unit_price.toString();
		       }
		       
		       	
		       	xml.tag_price							=	filterList[0].tag_price.toString();
		       	xml.message								=	filterList[0].message.toString();
		       	if(xml.message.toString()	!=	'')
		       	{
		       		isErrorMsg	=	true;
		       	}		       			       					
				xmlMain.appendChild(xml);
				
				tempList = tempList.(elements(strName) != strValue);
			}
			
			if(tempList.length() == 0)
			{
				break;
			}
		}
	}
	return 	xmlMain;
}
private function mainStyleItemClickHandler():void
{
	var style_number:String
		
	style_number	=	XML(dgMain.selectedItem).child(uniqueHeaderFieldInMainGrid).toString();
	dgDiam.rows		=	XML(XML(dgMain.selectedItem).child('catalog_item_packet_diamonds'))//generateDiamondXML(style_number);
	dgStone.rows	=	XML(XML(dgMain.selectedItem).child('catalog_item_packet_stones'))//generateStoneXML(style_number);

	var tempXml:XMLList	=	XML(dgMain.selectedItem)..message;
	var arr:Array;
	var message:String	=	'';;
	
	for(var i:int = 0 ; i< tempXml.length() ;i++)
	{
		if(tempXml[i].toString() != '')
		{
			arr	=	String(tempXml[i].toString()).split('\\n')
			
			for(var j:uint = 0; j < arr.length ; j++) 
			{
				message += arr[j] + "\n";
			}
			
		}
		
		if(i==0)
		{
			++i;
		} 
	}	
	
	if(message != '')
	{
		Alert.show(message);
	}	
}
private function diamondDetailClickHandler():void
{
 	var message:String	=	XML(dgDiam.selectedItem).child('message').toString();
	
 	var arr:Array;
				
	if(message != '')
	{
		arr	=	message.split('\\n')
		
		message	=	'';
		for(var i:uint = 0; i < arr.length ; i++) 
		{
			message += arr[i] + "\n";
		}
		Alert.show(message);
	}  	
}
private function stoneDetailClickHandler():void
{
 	var message:String	=	XML(dgStone.selectedItem).child('message').toString();
	
 	var arr:Array;
				
	if(message != '')
	{
		arr	=	message.split('\\n')
		
		message	=	'';
		for(var i:uint = 0; i < arr.length ; i++) 
		{
			message += arr[i] + "\n";
		}
		Alert.show(message);
	}  	
}
private function generateStoneXML(style_number:String):XML
{
	var tempXMLList:XMLList	=	new XMLList(<row/>)
	var stoneDetailXML:XML	=	new XML(<catalog_item_packet_stones/>);
	var xml:XML;	
	tempXMLList	=	resultXml.children().(elements(uniqueHeaderField).toString()	==	style_number.toString() && elements('stone_type').toString() != 'DIAM')
	
	if(tempXMLList.children().length() > 0)
	{
		for(var i:int=0 ; i< tempXMLList.length() ; i++)
		{
			if(XML(tempXMLList[i]).child(detailRequiredField).toString() != '' && XML(tempXMLList[i]).child(detailRequiredField).toString() != null)
			{
				xml	=	new XML(<catalog_item_packet_stone/>)
		       	
		       	//all other infornmation
		       	xml.stone_type					=	tempXMLList[i].stone_type.toString()
		       	xml.cut							=	tempXMLList[i].cut.toString()
		       	xml.shade						=	tempXMLList[i].stone_shade.toString()
		       	xml.stone_shape					=	tempXMLList[i].stone_shape.toString()
		       	xml.stone_color					=	tempXMLList[i].stone_color.toString()
		       	xml.stone_clarity				=	tempXMLList[i].stone_clarity.toString()
		       	xml.stone_size					=	tempXMLList[i].stone_size.toString()
		       	xml.stone_sizemm				=	tempXMLList[i].stone_mmsize.toString()
		       	xml.stone_quality				=	tempXMLList[i].stone_quality.toString()
		       	xml.qty							=	tempXMLList[i].stone_qty.toString()
		   
		       	/*88888*/
		       	xml.total_wt					=	tempXMLList[i].stone_wt.toString()
		       	
		       	var totalwt:Number				=	Number(xml.total_wt.toString());
		       	var qty:Number					=	Number(xml.qty.toString());
		       
		       	
		       if(totalwt.toString()	==	'NaN' || qty.toString() == 'NaN' || qty	==	0)
		       {
		       		xml.wt						=	'0';
		       }
		       else 
		       {
		       		xml.wt						=	(totalwt/qty).toString();
		       }
		      
			  xml.cost							=	tempXMLList[i].rate.toString()
			  
			   var cost:Number					=	Number(xml.cost.toString())
		      
		       if(cost.toString()	==	'NaN' || totalwt.toString() == 'NaN')
		       {
		       		xml.total_cost		=	'0';
		       }
		       else
		       {
		       		xml.total_cost					=	(totalwt *  cost).toString()
		       }
		   

		       	
		       	xml.total_diamond_amt			=	tempXMLList[i].diam_value.toString()
		       	xml.message						=	tempXMLList[i].message.toString()
		       	if(xml.message.toString()	!=	'')
		       	{
		       		isErrorMsg	=	true;
		       	}			     	
		     	stoneDetailXML.appendChild(xml); 
			}
		}
	}

	return 	stoneDetailXML	
}
private function generateDiamondXML(style_number:String):XML
{
	var tempXMLList:XMLList	=	new XMLList(<row/>)
	var diamDetailXML:XML	=	new XML(<catalog_item_packet_diamonds/>);
	var xml:XML;		
	tempXMLList	=	resultXml.children().(elements(uniqueHeaderField).toString()	==	style_number.toString() && elements('stone_type').toString() == 'DIAM')
	
	if(tempXMLList.children().length() > 0)
	{
		for(var i:int=0 ; i< tempXMLList.length() ; i++)
		{
			if(XML(tempXMLList[i]).child(detailRequiredField).toString() != '' && XML(tempXMLList[i]).child(detailRequiredField).toString() != null)
			{
				xml	=	new XML(<catalog_item_packet_diamond/>)
				
		       	
		       	//all other infornmation
		       	xml.stone_type					=	tempXMLList[i].stone_type.toString()
		       	xml.cut							=	tempXMLList[i].cut.toString()
		       	xml.shade						=	tempXMLList[i].stone_shade.toString()
		       	xml.stone_shape					=	tempXMLList[i].stone_shape.toString()
		       	xml.stone_color					=	tempXMLList[i].stone_color.toString()
		       	xml.stone_clarity				=	tempXMLList[i].stone_clarity.toString()
		       	xml.stone_size					=	tempXMLList[i].stone_size.toString()
		       	xml.stone_sizemm				=	tempXMLList[i].stone_mmsize.toString()
		       	xml.stone_quality				=	tempXMLList[i].stone_quality.toString()
		       	xml.qty							=	tempXMLList[i].stone_qty.toString()
		       	
		       	/*88888*/
		       	xml.total_wt					=	tempXMLList[i].stone_wt.toString()
		       	
		       	var totalwt:Number				=	Number(xml.total_wt.toString());
		       	var qty:Number					=	Number(xml.qty.toString());
		       
		       	
		       if(totalwt.toString()	==	'NaN' || qty.toString() == 'NaN' || qty	==	0)
		       {
		       		xml.wt						=	'0';
		       }
		       else 
		       {
		       		xml.wt						=	(totalwt/qty).toString();
		       }
		      
			  xml.cost							=	tempXMLList[i].rate.toString()
			  
			   var cost:Number					=	Number(xml.cost.toString())
		      
		       if(cost.toString()	==	'NaN' || totalwt.toString() == 'NaN')
		       {
		       		xml.total_cost		=	'0';
		       }
		       else
		       {
		       		xml.total_cost					=	(totalwt *  cost).toString()
		       }
		      	
		       
		       	xml.total_diamond_amt			=	tempXMLList[i].diam_value.toString()
		       	xml.message						=	tempXMLList[i].message.toString()
		       	if(xml.message.toString()	!=	'')
		       	{
		       		isErrorMsg	=	true;
		       	}			     	
		     	diamDetailXML.appendChild(xml); 
			}
		}
	}

	return 	diamDetailXML
}
private function calculateNetAmount():void
{
	var rows:XMLList	=	dgMain.rows.children();
	var totalAmt:Number	=	0;
	for(var i:int= 0 ; i < rows.length() ; i++)
	{
		totalAmt	=	totalAmt + Number(numericFormatter2.format(Number(rows[i].qty.toString()) * Number(rows[i].price.toString())));
	}
	tiNetAmt.dataValue		=		numericFormatter2.format(totalAmt);
}
//it will call after save 
override protected function retrieveRowEventHandler(event:DetailAddEditEvent):void
{
	// we will set data in detail grid from here.
	var __detailEditObj:DetailEditVO	=	__genModel.activeModelLocator.detailEditObj;
	var retrieveXMLList:XMLList				=	event.rowXml.children();
	var invoiceXML:XML	=	new XML(<purchase_invoice_lines/>);
 	var xml:XML;	
	
	for(var i:int =0 ; i<retrieveXMLList.length() ; i++)
	{
		xml	=	new XML(<purchase_invoice_line/>)
		
		xml.id				=	'';
		xml.company_id		=	__genModel.user.default_company_id;
		xml.updated_by		=	__genModel.user.userID;
		xml.created_by		=	__genModel.user.userID;
		xml.lock_version	=	0	; 
		
		xml.serial_no						=	i+1;
		xml.catalog_item_id					=	retrieveXMLList[i].catalog_item_id.toString();
		xml.catalog_item_code				=	retrieveXMLList[i].catalog_item_code.toString();
		xml.item_description				=	retrieveXMLList[i].item_description.toString();
		xml.catalog_item_packet_code		=	retrieveXMLList[i].catalog_item_packet_code.toString();
		xml.catalog_item_packet_id			=	retrieveXMLList[i].catalog_item_packet_id.toString();
		
		xml.taxable							=	'N';
		xml.item_qty						=	"1";
		
		if(retrieveXMLList[i].price.toString()	==	'' || (Number(retrieveXMLList[i].price.toString())).toString()	==	'NaN')
		{
			xml.item_price						=	"0";
		}
		else
		{
			xml.item_price						=	numericFormatter2.format(retrieveXMLList[i].price.toString());
		}
		
		xml.item_amt						=	numericFormatter2.format(Number(xml.item_qty.toString()) * Number(xml.item_price.toString()));
		xml.discount_per					=	"0.00";
		xml.discount_amt					=	"0.00";
		xml.net_amt							=	numericFormatter2.format(Number(xml.item_amt.toString()));
		
		invoiceXML.appendChild(xml);
	} 
			
	__detailEditObj.genDataGrid.rows			=			invoiceXML;
	Detail(__detailEditObj.genDataGrid.parentDocument).dispatchEvent(new DetailEvent(DetailEvent.DETAIL_SAVE_IMPORTED_XML_COMPLETE,null,null,null));
}

override protected function downloadCompleteEventHandler(event:DetailAddEditEvent):void
{
	isErrorMsg	=	false;
	resultXml 	= 	XML(event.rowXml);
	dgMain.rows	=	generateHeaderXML(resultXml.copy());
	
	calculateNetAmount();
	
	var  diamXML:XML	=	new XML(<catalog_item_packet_diamonds/>);
	var  stoneXML:XML	=	new XML(<catalog_item_packet_stones/>);
	var style_number:String;
	var lastChild:XML;
	
	modifiedXML	=	new XML(<catalog_item_packets/>)
	
	for(var i:int=0 ; i< dgMain.rows.children().length() ;i++)
	{
		modifiedXML.appendChild(dgMain.rows.children()[i]);
		
		style_number = XML(dgMain.rows.children()[i]).child(uniqueHeaderFieldInMainGrid).toString();
	
		diamXML 	= generateDiamondXML(style_number);
		stoneXML 	= generateStoneXML(style_number);
		
		lastChild	=	XML(modifiedXML.children()[modifiedXML.children().length()-1])
		
		lastChild.appendChild(diamXML);
		lastChild.appendChild(stoneXML);
				
	}
	
	dgMain.rows	=	modifiedXML;
								
}

override protected function  preSaveImportedXMLEventHandler(event:DetailAddEditEvent):int
{
	if(isErrorMsg)
	{
		Alert.show('one or many row has invalid data please correct it.');
		return 1;
	}
	var __detailEditObj:DetailEditVO	=	__genModel.activeModelLocator.detailEditObj;
	__detailEditObj.tablenames			=	tableNames;
		
	return 0;
}
private function handleSampleXLS():void
{
	var file_name:String = 'sample_jewelary_packet_upload_format.xlsx';
	var folderName:String = '/sampleformats/';
	var url:String = folderName + file_name;
	var request:URLRequest = new URLRequest(url);

    navigateToURL(request);
}