import business.events.InitializeCustomReportEvent;

import com.generic.events.GenModuleEvent;

import model.GenModelLocator;

import mx.events.FlexEvent;

import rept.puoi.indentregister.DrilldownPurchaseIndentRegisterReport;
import rept.puoi.indentregister.IndentRegisterController;
import rept.puoi.indentregister.IndentRegisterModelLocator;
import rept.puoi.indentregister.IndentRegisterServices;

[Bindable]
protected var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
protected var __localModel:IndentRegisterModelLocator = new IndentRegisterModelLocator();

public function handleIndentRegisterActive(event:GenModuleEvent):void
{
	__genModel.controller			= new IndentRegisterController();
	__genModel.services 			= new IndentRegisterServices();
	__genModel.activeModelLocator 	= __localModel;
}

public function handleCreationComplete(event:FlexEvent):void
{
	__localModel.documentObj.documentID			= __genModel.applicationObject.selectedMenuItem.@document_id;
    __localModel.documentObj.create_permission 	= "N";
    __localModel.documentObj.modify_permission 	= "N";
    __localModel.documentObj.view_permission 	= __genModel.applicationObject.selectedMenuItem.@view_permission;
    __localModel.documentObj.upload_permission 	= "N";

	 __localModel.reportObj.customReportDataGrid = this.customReportComponent;
	 __localModel.reportObj.idrilldown = new DrilldownPurchaseIndentRegisterReport();
	
	initializeEvent = new InitializeCustomReportEvent();
	initializeEvent.dispatch();
}

//all required classes and mxml are in com.farata.printing.*
  /*  private function openPDF(uiObject:Object):void{
   
      var xdpDocument:XdpDocument=new XdpDocument();
      var options:PrintOptions=new PrintOptions();
      options.paperSize=paperSize.A4;
      options.orientation=PrintOptions.ORIENTATION_LANDSCAPE;
      xdpDocument.init(options);
      var pdf: PDFHelper=new PDFHelper(xdpDocument);
      pdf.createPDFPrologue();
      pdf.createPage(uiObject, PDFHelper.TYPE_LIST);
      pdf.createPDFEpilogue();
      sendToServer("test.pdf", pdf.pdfContent);
   }
   private function sendToServer(file:String, ba:ByteArray):void{
      var req: URLRequest = new URLRequest("PDFServlet/"+file);
      req.method = URLRequestMethod.POST;
      ba.compress();
      req.data = ba;
      navigateToURL(req, "_blank");
   } */