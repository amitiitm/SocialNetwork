package valueObjects
{
	import model.GenModelLocator;
	
	import mx.controls.Alert;
	
	[Bindable]
	public class PathVO
	{
		public var attachment:String;
		public var backup:String;
		public var catalog_image:String;
		public var image:String;
		public var inbox:String;
		public var log:String;
		public var report_export:String;
		public var report_print:String;
		public var video:String;
		public var ups_label:String;
		public var template_path:String;
		
		
		public function PathVO(aXML:XML)
		{
			// Alert.show(aXML.toXMLString())
			
			if(GenModelLocator.main_url	==	"")
			{
				//web application 
				attachment		=	aXML.children()['ATTACHMENT'].toString();
				backup			=	aXML.children()['BACKUP'].toString();
				catalog_image	=	aXML.children()['CATALOG_IMAGE'].toString();
				image			=	aXML.children()['IMAGE'].toString();
				inbox			=	aXML.children()['INBOX'].toString();
				log				=	aXML.children()['LOG'].toString();
				report_export	=	aXML.children()['REPORT_EXPORT'].toString();
				report_print	=	aXML.children()['REPORT_PRINT'].toString();
				video			=	aXML.children()['VIDEO'].toString();
				ups_label		= 	aXML.children()['UPS_LABEL'].toString();
				template_path	=   aXML.children()['TEMPLATE_PATH'].toString();
			}
			else
			{
				// desktop application
				
				var str:String	=	"../";
				
				
				attachment		=	aXML.children()['ATTACHMENT'].toString();
				backup			=	aXML.children()['BACKUP'].toString();
				catalog_image	=	aXML.children()['CATALOG_IMAGE'].toString();
				image			=	aXML.children()['IMAGE'].toString();
				inbox			=	aXML.children()['INBOX'].toString();
				log				=	aXML.children()['LOG'].toString();
				report_export	=	aXML.children()['REPORT_EXPORT'].toString();
				report_print	=	aXML.children()['REPORT_PRINT'].toString();
				video			=	aXML.children()['VIDEO'].toString();
				ups_label		= 	aXML.children()['UPS_LABEL'].toString();
				template_path	=   aXML.children()['TEMPLATE_PATH'].toString();
				
				if(attachment.search(str)	==	0)
				{
					attachment	=	attachment.replace(str,'/')
				}
				if(backup.search(str)	==	0)
				{
					backup	=	backup.replace(str,'/')
				}
				if(catalog_image.search(str)	==	0)
				{
					catalog_image	=	catalog_image.replace(str,'/')
				}
				if(image.search(str)	==	0)
				{
					image	=	image.replace(str,'/')
				}
				if(inbox.search(str)	==	0)
				{
					inbox	=	inbox.replace(str,'/')
				}
				if(log.search(str)	==	0)
				{
					log	=	log.replace(str,'/')
				}
				if(report_export.search(str)	==	0)
				{
					report_export	=	report_export.replace(str,'/')
				}
				if(report_print.search(str)	==	0)
				{
					report_print	=	report_print.replace(str,'/')
				}
				if(video.search(str)	==	0)
				{
					video	=	video.replace(str,'/')
				}
				if(ups_label.search(str)	==	0)
				{
					ups_label	=	ups_label.replace(str,'/')
				}
				if(template_path.search(str)	==	0)
				{
					template_path	=	template_path.replace(str,'/')
				}
				
				/*attachment		=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +aXML.children()['ATTACHMENT'].toString();
				backup			=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +aXML.children()['BACKUP'].toString();
				catalog_image	=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +aXML.children()['CATALOG_IMAGE'].toString();
				image			=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +aXML.children()['IMAGE'].toString();
				inbox			=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +aXML.children()['INBOX'].toString();
				log				=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +aXML.children()['LOG'].toString();
				report_export	=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +aXML.children()['REPORT_EXPORT'].toString();
				report_print	=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +aXML.children()['REPORT_PRINT'].toString();
				video			=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +aXML.children()['VIDEO'].toString();*/
			
				attachment		=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +	attachment
				backup			=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() + 	backup
				catalog_image	=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +	catalog_image
				image			=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +	image
				inbox			=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +	inbox
				log				=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +	log
				report_export	=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +	report_export
				report_print	=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +	report_print
				video			=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +	video
				ups_label		=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +	ups_label
				template_path	=	GenModelLocator.comapnyShortName + GenModelLocator.main_url.toString() +	template_path	
			
			}
		}
	}
}
