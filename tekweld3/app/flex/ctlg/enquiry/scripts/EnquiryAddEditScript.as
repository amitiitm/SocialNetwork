import ctlg.enquiry.EnquiryModelLocator;

import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:EnquiryModelLocator =  EnquiryModelLocator(__genModel.activeModelLocator);

