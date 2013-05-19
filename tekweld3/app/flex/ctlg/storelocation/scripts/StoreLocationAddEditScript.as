import com.generic.events.AddEditEvent;

import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

override protected function preSaveEventHandler(event:AddEditEvent):int
{
	for(var i:int = 0 ; i < dtlLine.dgDtl.rows.children().length() ; i++)
	{
		 dtlLine.dgDtl.rows.children()[i].sequence	=	i+1;
	}
	
	return 0;
}



