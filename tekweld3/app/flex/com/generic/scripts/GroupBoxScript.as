// ActionScript file
import flash.text.TextLineMetrics;

import mx.containers.Box;
import mx.controls.Alert;
import mx.controls.Label;
import mx.core.Container;

public static var ABSOLUTE:String = "absolute";
public static var VERTICAL:String = "vertical";
public static var HORIZONTAL:String = "horizontal";

private var titleBar:Container;
private var body:Container;
private var box:Box;
private var titleBox:Container;
private var titleLabel:Label;
private var _title:String;
private var _layout:String;

[Inspectable(category="General", name="lout", enumeration="vertical,horizontal,absolute", defaultValue="vertical")]			
public function get layout():String{
	return _layout;
}
public function set layout(l:String):void{
	_layout = l;
}

[Inspectable(category="General", defaultValue="afdge")]
public function get title():String{
	return _title;
}

public function set title(t:String):void{
	_title = t;
}

override protected function commitProperties():void{
	super.commitProperties();
	
	titleLabel.text = _title;
	var tlm:TextLineMetrics = titleLabel.measureText(_title);
	
	titleLabel.x = 0;
	titleLabel.y = 0;
	titleLabel.width = tlm.x + tlm.width + 4;
	titleLabel.height = tlm.ascent+tlm.descent+tlm.leading + 4;
	
	titleBox.width = titleLabel.width + 4;
	titleBox.height = titleLabel.height + 4;
	titleBox.x = 10;
	titleBox.y = 0;
	
	switch(_layout){
		case ABSOLUTE:
			
			break;
		case VERTICAL:
		case HORIZONTAL:
		default:
	}
	
	
}

override protected function measure():void{
	//var tlm:TextLineMetrics = titleLabel.measureText(_title);
	//titleLabel.width = tlm.width;
	//titleLabel.height = tlm.height;
}

override protected function createChildren():void{
	super.createChildren();
	
	if(!body){
		body = new Container();
		body.setStyle("borderStyle","solid");
		body.setStyle("cornerRadius","5");
		this.addChild(body);				
	}				
	if(!titleBar){
		titleBar = new Container();
		titleBar.verticalScrollPolicy = "off";
		titleBar.horizontalScrollPolicy = "off";
		this.addChild(titleBar);
	}
	if(!box){
		box = new Box();
	}
	if(!titleBox){
		titleBox = new Container();
		titleBox.styleName = getStyle("titleBoxStyleName");
		//titleBox.setStyle("borderStyle","solid");
		//titleBox.setStyle("backgroundColor","0x00B1A690");
		titleBar.addChild(titleBox);
	}
	if(!titleLabel){
		titleLabel = new Label();
		titleLabel.setStyle("fontSize","12");
		//body.setStyle("cornerRadius","5");					
		titleBox.addChild(titleLabel);
	}
}

override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
	super.updateDisplayList(unscaledWidth,unscaledHeight);
	
	body.setStyle("borderStyle","solid");
	body.setStyle("cornerRadius","5");
	titleBar.setActualSize(this.width, titleLabel.height);
	titleBar.move(0,0);				
	body.setActualSize(this.width-2,this.height-titleBar.height/2-1);
	body.move(1,titleBar.height/2);
	
}