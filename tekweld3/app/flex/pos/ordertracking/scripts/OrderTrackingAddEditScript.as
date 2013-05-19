import com.generic.customcomponents.GenDateField;
import com.generic.events.InboxEvent;
import pos.ordertracking.OrderTrackingModelLocator;
import model.GenModelLocator;

[Bindable]
private var __genModel:GenModelLocator = GenModelLocator.getInstance();

[Bindable]
private var __localModel:OrderTrackingModelLocator  =  OrderTrackingModelLocator(__genModel.activeModelLocator);
