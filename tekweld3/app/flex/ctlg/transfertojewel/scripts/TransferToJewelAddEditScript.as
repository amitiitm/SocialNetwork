import ctlg.transfertojewel.TransferToJewelModelLocator

import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();
[Bindable]
private var __localModel:TransferToJewelModelLocator =  TransferToJewelModelLocator(__genModel.activeModelLocator);

