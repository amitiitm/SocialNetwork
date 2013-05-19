import ctlg.updateorderstatus.UpdateOrderStatusModelLocator;

import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:UpdateOrderStatusModelLocator  =  UpdateOrderStatusModelLocator(__genModel.activeModelLocator);


