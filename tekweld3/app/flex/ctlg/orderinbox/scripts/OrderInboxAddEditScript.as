import ctlg.orderinbox.OrderInboxModelLocator;

import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:OrderInboxModelLocator =  OrderInboxModelLocator(__genModel.activeModelLocator);

