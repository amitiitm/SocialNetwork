import com.generic.events.ImportEvent;
import com.generic.genclass.GenNumberFormatter;

import model.GenModelLocator;

import mx.containers.HBox;
import mx.controls.Alert;

import valueObjects.ImportVO;

[Bindable]
public var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
public var __importObj:ImportVO = __genModel.activeModelLocator.importObj;

private var tableNames:Array	=	new Array({tablename:'purchase_order'},{tablename:'purchase_order_line'});

private var saveXml:XML	= new XML(<purchase_orders/>);

private var uniqueHeaderField:String =  "po_no";
private var numericFormatter2:GenNumberFormatter 				= 	new GenNumberFormatter();
private var numericFormatterFourPrecesion:GenNumberFormatter	=	new GenNumberFormatter();		       		
					
private function init():void
{
	numericFormatter2.precision = 2;
	numericFormatter2.rounding = "nearest";
		
	numericFormatterFourPrecesion.precision		=	4;
	numericFormatterFourPrecesion.rounding = "nearest";	
}

override protected function downloadCompleteEventHandler(event:ImportEvent):void
{	
	dgValues.rows		=	new XML(<purchase_orders/>);
	saveXml				= 	new XML(<purchase_orders/>);
	var resultXml:XML 	= 	XML(event.recordXml);
	
	
	if(resultXml.name() == "errors")
	{
		if(resultXml.children().length() > 0) 
		{
			var message:String = '';
	
			for(var i:uint = 0; i < resultXml.children().length(); i++) 
			{
				message += resultXml.children()[i] + "\n";
			}
			Alert.show(message);
		} 
	}
	else
	{
		if(resultXml != '')
		{
			dgValues.rows	=	resultXml;
	
			
		}
		else
		{
			Alert.show('Excel is blank');
		}
	}
	
}

private function clickHandler():void
{
	var message:String	=	XML(dgValues.selectedItem).child('message').toString();
	
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
override protected function preSaveEventHandler(event:ImportEvent):int
{
	var message:XMLList	=	new XMLList(<message/>);
	
	message	=	dgValues.rows.children().(child('message').toString()	!=	'')
	
	if(message.children().length() > 0)
	{
		Alert.show('one or many row has invalid data please correct it.');
		return 1;	
	}
	
	var _resulXml:XML = dgValues.rows.copy();
		
	saveXml	= 	new XML(<purchase_orders/>);
	saveXml	=	generateXML(_resulXml);
	
	if(saveXml.children().length() > 0 )
	{
		__importObj.tablenames = tableNames;
		__importObj.records = saveXml;
		
	}
	else
	{
		Alert.show('nothing to save.');
		return 1;	
	}
			
	
	return 0;
}

 
private function generateXML(resulXml:XML):XML
{	
	var total_item_amt:Number;
	var header_net_amt:Number;

	
	var tempList:XMLList = resulXml.children();
	
	var filterList:XMLList;
	var xmlHeader:XML;
	var xmlDetail:XML;
	var row:XML;	
	var xmlMain:XML;
	
	xmlMain				 = new XML(<purchase_orders/>);
	
	var strName:String;
	var strValue:String;
		
	if (tempList.length() > 0)
	{
		strName = uniqueHeaderField.toString();

		while(true)
		{
			strValue = tempList.elements(strName)[0].toString() 
			filterList = tempList.(elements(strName) == strValue)

			if(filterList.length() > 0)
			{

				xmlHeader = new XML(<purchase_order/>);
				xmlDetail = new XML(<purchase_order_lines/>);
				
				total_item_amt = 0;
				header_net_amt = 0;
		       	
		       	xmlHeader.upload_flag						=	"Y"
		       	
		       	//all other infornmation
		       	xmlHeader.ext_ref_no						=	filterList[0].po_no.toString()
		       	xmlHeader.ext_ref_date						=	filterList[0].po_date.toString()
		       	xmlHeader.trans_date						=	filterList[0].trans_date.toString()
		       	xmlHeader.ship_date							=	filterList[0].ship_date.toString()
		       	xmlHeader.vendor_code						=	filterList[0].vendor_code.toString()
		       	xmlHeader.term_code							=	filterList[0].term_code.toString()
		       	xmlHeader.due_date							=	filterList[0].due_date.toString()
		      	xmlHeader.cancel_date						=	filterList[0].due_date.toString()
		      
		       	xmlHeader.shipping_code						=	filterList[0].ship_via.toString()

				xmlHeader.account_period_code						=	filterList[0].account_period_code.toString()
		       	xmlHeader.vendor_id									=	filterList[0].vendor_id.toString()
		       
		      
		      	xmlHeader.store_id									=	 __genModel.user.id.toString()
				xmlHeader.store_code								=	 __genModel.user.company_cd.toString()
				   
				xmlHeader.ship_name									=	__genModel.user.company_name.toString()
				xmlHeader.ship_address1								=	 __genModel.user.complc_address1.toString()   	
				xmlHeader.ship_address2								=	__genModel.user.complc_address2.toString()
				xmlHeader.ship_city									=	__genModel.user.complc_city.toString()
				xmlHeader.ship_state								=	__genModel.user.complc_state.toString()
				xmlHeader.ship_zip									=	 __genModel.user.complc_pin.toString()	
				xmlHeader.ship_country								=	__genModel.user.company_country.toString()
				xmlHeader.ship_phone								=	 __genModel.user.complc_phone.toString()
				xmlHeader.ship_fax									=	__genModel.user.complc_fax.toString()
				   
				xmlHeader.bill_code									=	filterList[0].bill_code.toString()	
				xmlHeader.bill_name									=	filterList[0].bill_name.toString()
				xmlHeader.bill_address1								=	filterList[0].bill_address1.toString()			
				xmlHeader.bill_address2								=	filterList[0].bill_address2.toString()	
				xmlHeader.bill_city									=	filterList[0].bill_city.toString()		
				xmlHeader.bill_state								=	filterList[0].bill_state.toString()
				xmlHeader.bill_zip									=	filterList[0].bill_zip.toString()		
				xmlHeader.bill_country								=	filterList[0].bill_country.toString()		
				xmlHeader.bill_phone								=	filterList[0].bill_phone.toString()	
				xmlHeader.bill_fax									=	filterList[0].bill_fax.toString()			
		       
		        xmlHeader.trans_type								=	 filterList[0].trans_type.toString()//it may be O  or S
		       
		        xmlHeader.ref_trans_no								=	filterList[0].ref_trans_no.toString()
	       	    xmlHeader.ref_trans_date							=	filterList[0].ref_trans_date.toString()
	       	    xmlHeader.ref_trans_bk	   							=	filterList[0].ref_trans_bk.toString()
	       		xmlHeader.ref_type									=	filterList[0].ref_type.toString()	
	       		     
	       		     
	       		xmlHeader.purchaseperson_code						=	filterList[0].purchaseperson_code.toString()
	       		
		       //numericFormatterFourPrecesion
		        if(filterList[0].tax_amt.toString()	==	'' || (Number(filterList[0].tax_amt.toString())).toString()	==	'NaN')
		        {
		       		xmlHeader.tax_amt						=	"0.0000";						
		        }
		        else
		        {
		       		xmlHeader.tax_amt						=	numericFormatterFourPrecesion.format(filterList[0].tax_amt.toString());
		        }


				if(filterList[0].shipping_amt.toString()	==	'' || (Number(filterList[0].shipping_amt.toString())).toString()	==	'NaN')
		        {
		       		xmlHeader.shipping_amt						=	"0.00";	
		       										
		        }
		        else
		        {
		       		xmlHeader.shipping_amt						=	numericFormatter2.format(filterList[0].shipping_amt.toString());
		        	
		        }
		       
				if(filterList[0].insurance_amt.toString()	==	'' || (Number(filterList[0].insurance_amt.toString())).toString()	==	'NaN')
		        {
		       		xmlHeader.insurance_amt						=	"0.00";						
		        }
		        else
		        {
		       		xmlHeader.insurance_amt						=	numericFormatter2.format(filterList[0].insurance_amt.toString());
		        }
		       
		      
		       
		       //logic to generate detail xml	
		       for(var i:int = 0 ; i < filterList.length() ; i++)
		       {
		       		row = new XML(<purchase_order_line/>)
		       		
		       		row.catalog_item_code					=	filterList[i].item_code.toString()
		       		row.customer_sku_no						=	filterList[i].customer_sku_no.toString()
		       		row.vendor_sku_no						=	filterList[i].vendor_sku_no.toString()
		       		
		       		row.transaction_bom_id					=	filterList[i].transaction_bom_id.toString()
		       		row.catalog_item_id						=	filterList[i].catalog_item_id.toString()
		       		row.item_description					=	filterList[i].item_description.toString()
		       		
	       		  	row.item_type							=	"I"	;
	       		  
	       		    row.ref_trans_no						=	filterList[i].ref_trans_no.toString()
	       		    row.ref_trans_date						=	filterList[i].ref_trans_date.toString()
	       		    row.ref_trans_bk	   					=	filterList[i].ref_trans_bk.toString()
	       			row.ref_type							=	filterList[i].ref_type.toString()
	       		
	       		    row.ref_serial_no						=	filterList[i].ref_serial_no.toString()
	       		    
	       		   
					if(filterList[i].item_qty.toString()	==	'' || (Number(filterList[i].item_qty.toString())).toString()	==	'NaN')
			        {
			       		row.item_qty							=	"0";						
			        }
			        else
			        {
			       		row.item_qty							=	filterList[i].item_qty.toString();
			        }
		       		
		       		if(filterList[i].item_price.toString()	==	'' || (Number(filterList[i].item_price.toString())).toString()	==	'NaN')
			        {
			       		row.item_price							=	"0.00";						
			        }
			        else
			        {
			       		row.item_price							=	numericFormatter2.format(filterList[i].item_price.toString());
			        }
		       		
		       		
					/* if(filterList[i].item_amt.toString()	==	'' || (Number(filterList[i].item_amt.toString())).toString()	==	'NaN')
			        { */
			        	row.item_amt							=	numericFormatter2.format(Number(row.item_qty.toString()) * Number(row.item_price.toString()));  					
			      /*   }
			        else
			        {
			       		row.item_amt							=	numericFormatter2.format(filterList[i].item_amt.toString());
			        } */
		       		
		       		if(filterList[i].discount_amt.toString()	==	'' || (Number(filterList[i].discount_amt.toString())).toString()	==	'NaN')
			        {
			        	row.discount_amt							=	"0.00"
			        }
			        else
			        {
			       		row.discount_amt							=	numericFormatter2.format(filterList[i].discount_amt.toString());
			        }
		       			
		       		/* if(filterList[i].net_amt.toString()	==	'' || (Number(filterList[i].net_amt.toString())).toString()	==	'NaN')
			        { */
			        	row.net_amt							=	numericFormatter2.format(Number(row.item_amt.toString()) -  Number(row.discount_amt.toString()))
			        /* }
			        else
			        {
			       		row.net_amt							=	numericFormatter2.format(filterList[i].net_amt.toString());
			        } */
		       			
		       		
		       		
		       		total_item_amt							=	total_item_amt + Number(row.net_amt.toString())			
		       		xmlDetail.appendChild(row);
		       		
		       }
		       
		       
		        header_net_amt      =   Number(numericFormatter2.format(String(total_item_amt + Number(xmlHeader.shipping_amt.toString()) + Number(xmlHeader.tax_amt.toString()) + Number(xmlHeader.insurance_amt.toString()))))	
			    
		        xmlHeader.item_amt	=	String(total_item_amt);
		        xmlHeader.net_amt	=   String(header_net_amt);
		       
				
		        xmlHeader.appendChild(xmlDetail);
		        
		       
		        	
				xmlMain.appendChild(xmlHeader); 
				
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

override protected function retrieveRecordEventHandler(event:ImportEvent):void{}

override protected function resetObjectEventHandler():void
{
	dgValues.rows = new XML(<purchase_orders/>)
}