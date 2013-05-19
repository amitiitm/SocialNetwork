import com.generic.events.AddEditEvent;

import model.GenModelLocator;

import mx.controls.Alert;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

override protected function retrieveRecordEventHandler(event:AddEditEvent):void
{
	tiLoginEmail.enabled = false;
	
	 for(var i:int = 0 ; i < dtlLine.dgDtl.rows.children().length() ; i++)
	{
		var def_company:String = event.recordXml.user.default_company_id.toString();
		if(dtlLine.dgDtl.rows.children()[i].default_company_id == def_company)
		{
			dtlLine.dgDtl.rows.children()[i].dummy = 'Y';
		}
		else
		{
			dtlLine.dgDtl.rows.children()[i].dummy = 'N';
		}
	}  
	
	setLookUp(cbLogin_type.dataValue.toString())
	dcTypeId.dataValue	=	event.recordXml.children().child('type_id').toString();
	dcTypeId.labelValue	=	event.recordXml.children().child('type_code').toString();
}

private function setDefaultStore():void
{
	var l:Number = dtlLine.dgDtl.dataProvider.length ;
	var k:Number = dtlLine.dgDtl.selectedIndex ;
	
	if(l == 1)
	{
		dtlLine.dgDtl.dataProvider[0].dummy = 'Y'
		dcDefault_store.dataValue = dtlLine.dgDtl.dataProvider[0].default_company_id.toString() ;
		dcDefault_store.labelValue = dtlLine.dgDtl.dataProvider[0].company_cd.toString() ;
		tiDefault_company_code.dataValue = dtlLine.dgDtl.dataProvider[0].company_cd.toString() ;
	}
	else if(l > 1)
	{	
		if(dtlLine.dgDtl.dataProvider[k].dummy == 'Y')
		{
			for(var i:int = 0; i < dtlLine.dgDtl.dataProvider.length; i++)
			{
				dtlLine.dgDtl.dataProvider[i].dummy = "N";
			}
			dtlLine.dgDtl.dataProvider[k].dummy = "Y"
			
			dcDefault_store.dataValue = dtlLine.dgDtl.dataProvider[k].default_company_id ;
			dcDefault_store.labelValue = dtlLine.dgDtl.dataProvider[k].company_cd.toString();
			tiDefault_company_code.dataValue = dtlLine.dgDtl.dataProvider[k].company_cd.toString();
		}	
	}	
}

private function setEmail():void
{
	tiEmail.text = tiLoginEmail.text;
}

override protected function copyRecordCompleteEventHandler():void
{
	tiLoginEmail.dataValue	=	'';
}

private function logInTypeChanged():void
{	
		setLookUp(cbLogin_type.dataValue.toString())
		dcTypeId.dataValue = ''
		
		if(cbLogin_type.dataValue.toUpperCase() == 'C' ||cbLogin_type.dataValue.toUpperCase() == 'V')
		{
			dcDefault_store.dataValue	=	__genModel.user.default_company_id.toString()
			dcDefault_store.labelValue	=	__genModel.user.default_company_code.toString()
			tiDefault_company_code.dataValue =	__genModel.user.default_company_code.toString()
			dtlLine.dgDtl.rows	=	new XML(<user_companies>
										<user_company>
											<id></id>
											<default_company_id>{__genModel.user.default_company_id.toString()}</default_company_id>
											<company_id>{__genModel.user.default_company_id.toString()}</company_id>
											<updated_by>{__genModel.user.userID.toString()}</updated_by>
											<created_by>{__genModel.user.userID.toString()}</created_by>
										</user_company>
									</user_companies>);
									
		}
		else
		{
			dcDefault_store.dataValue	=	''
			dcDefault_store.labelValue	=	''
			tiDefault_company_code.dataValue =	''
		}							
}		
	
private function setLookUp(loginType:String):void
{	
	dcTypeId.dataValue	=	'';
	dcTypeId.labelValue	=	'';
	
		switch(loginType.toUpperCase())
	{
		case 'C':
						dcTypeId.dataSourceName =	'CustomerWholesale' 
						//dcTypeId.dataProvider   = 	__genModel.lookupObj.customerwholesale.children();	
						dtlLine.enabled			=	false 
						dcTypeId.enabled 		= 	true 
						break;
		case 'V':
						dcTypeId.dataSourceName	=	'Vendor' 
						//dcTypeId.dataProvider	=	__genModel.lookupObj.vendor.children();
						dtlLine.enabled			=	false
						dcTypeId.enabled 		= 	true 
						break;
		default :
						dcTypeId.validationFlag	=	"false"
						dcTypeId.enabled 		= 	false  
						dtlLine.enabled			=	true
						break;
	}	
}

override protected function resetObjectEventHandler():void 
{
	logInTypeChanged()
	tiLoginEmail.enabled = true;
}

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	var retValue:int=0;
	
	if(cbLogin_type.dataValue.toUpperCase() == 'C' ||cbLogin_type.dataValue.toUpperCase() == 'V')
	{
		if(dcTypeId.dataValue == '')
		{
			Alert.show("please provide code")
			retValue = 1;
		}
	} 
	if(dtlLine.dgDtl.rows == '' ||dtlLine.dgDtl.rows == 'NaN')
	{
			Alert.show("please provide company info")
			retValue = 1;
	
	}
	return retValue;	
}


