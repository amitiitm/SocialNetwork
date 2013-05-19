import com.generic.customcomponents.GenDateField;
import com.generic.events.InboxEvent;
import pos.repairtracking.RepairTrackingModelLocator;
import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
private var __localModel:RepairTrackingModelLocator  =  RepairTrackingModelLocator(__genModel.activeModelLocator);
