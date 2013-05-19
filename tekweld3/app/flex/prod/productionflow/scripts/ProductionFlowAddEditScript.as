import business.commands.GetMenuCommand;

import com.generic.genclass.TabPage;

import flash.events.MouseEvent;
import flash.geom.Point;

import model.GenModelLocator;

import mx.controls.Alert;

import valueObjects.ApplicationVO;

private var __genModel:GenModelLocator = GenModelLocator.getInstance();

public function init():void
{
	makeLine(80,195,100,195);    // to order to vertical line
	
	
	makeLine(70,45,70,345);    // vertical line 
	
	makeLine(70,45,100,45);    //  to gum impostion
	makeLine(100,45,95,40);
	makeLine(100,45,95,50);
	
	makeLine(220,45,250,45);    // gum impostion  to gum print
	makeLine(250,45,245,40);
	makeLine(250,45,245,50);
	
	makeLine(370,45,400,45);    // gum print to heivelberg cie cut
	makeLine(400,45,395,40);
	makeLine(400,45,395,50);
	
	
	
	
	
	
	makeLine(70,120,100,120);    // indigo imposition
	makeLine(100,120,95,115);
	makeLine(100,120,95,125);
	
	makeLine(220,120,250,120);    // indigo imposition  to indigo print
	makeLine(250,120,245,115);
	makeLine(250,120,245,125);
	
	makeLine(370,120,400,120);    // indigo print to ABG cie cut
	makeLine(400,120,395,115);
	makeLine(400,120,395,125);
	
	
	makeLine(70,195,100,195);  //direct film 
	makeLine(100,195,95,190);
	makeLine(100,195,95,200);
	
	makeLine(220,195,250,195);    // direct film  to direct print
	makeLine(250,195,245,190);
	makeLine(250,195,245,200);
	
	makeLine(70,270,100,270);  // paid film
	makeLine(100,270,95,265);
	makeLine(100,270,95,275);
	
	makeLine(220,270,250,270);    // paid film  to paid print
	makeLine(250,270,245,265);
	makeLine(250,270,245,275);

	makeLine(70,345,100,345);  // embroidery film
	makeLine(100,345,95,340);
	makeLine(100,345,95,350);
	
	makeLine(220,345,250,345);    // embroidery film  to embroidery stich
	makeLine(250,345,245,340);
	makeLine(250,345,245,350);
	 
	
}

public function drawCurve1(origin:Point,destination:Point,curvePercent:Number = .4,dashed:Boolean = false,color:uint = 0x000000):void
{
	var curveAnchor:Point = new Point( (origin.x + destination.x)/2, (origin.y + destination.y)/2);
	
	if (origin.x > destination.x)
	{
		curveAnchor.x += (destination.y-origin.y) * curvePercent;
	    curveAnchor.y -= (destination.x-origin.x) * curvePercent;
	}
	else
	{
	    curveAnchor.x -= (destination.y-origin.y)* curvePercent;
	    curveAnchor.y += (destination.x-origin.x) * curvePercent;
	}
	
	var curve:Shape = new Shape();
	curve.graphics.lineStyle(2, color, 1);
	drawQuadCurve(curve,origin,curveAnchor,destination,dashed);
	this.rawChildren.addChild(curve);
}
		
public function drawCurve2(origin:Point,destination:Point,curvePercent:Number = .5,dashed:Boolean = false ,color:uint = 0x000000):void
{
	var curveAnchor:Point = new Point( (origin.x + destination.x)/2,(origin.y + destination.y)/2);
	    
	if (origin.x > destination.x)
	{
	    curveAnchor.x -= (destination.y-origin.y) * curvePercent;
	    curveAnchor.y += (destination.x-origin.x) * curvePercent;
	}
	else
	{
	    curveAnchor.x += (destination.y-origin.y)* curvePercent;
	    curveAnchor.y -= (destination.x-origin.x) * curvePercent;
	}

	var curve:Shape = new Shape();
	curve.graphics.lineStyle(2, color, 1);
	drawQuadCurve(curve,origin,curveAnchor,destination,dashed);
	this.rawChildren.addChild(curve);
}

public function makeLine(originX:Number,originY:Number,destX:Number,destY:Number,thickness:Number = 1,dashed:Boolean = false,color:uint = 0x000000):void
{
	var origin:Point = new Point(originX,originY);
	var destination:Point = new Point(destX,destY);
	var line:Shape = new Shape();
	
	line.graphics.lineStyle(thickness,color,1);
	drawLine(line,origin,destination,dashed);
	this.rawChildren.addChild(line); 
}

public function drawLine(g:Shape, start:Point, end:Point, dashed:Boolean = false, dashLength:Number = 10):void 
{
    g.graphics.moveTo(start.x, start.y);

    if (dashed) 
    {
        var total:Number = Point.distance(start, end);
        if (total <= dashLength) 
        {
            g.graphics.lineTo(end.x, end.y);
        } 
        else 
        {
            var step:Number = dashLength / total;
            var dashOn:Boolean = false;
            var p:Point;
            for (var t:Number = step; t <= 1; t += step) 
            {
                p = getLinearValue(t, start, end);
                dashOn = !dashOn;
                if (dashOn) 
                {
                    g.graphics.lineTo(p.x, p.y);
                } 
                else 
                {
                    g.graphics.moveTo(p.x, p.y);
                }
            }
            dashOn = !dashOn;
            if (dashOn && !end.equals(p)) 
            {
                g.graphics.lineTo(end.x, end.y);
            }
        }
    } 
    else 
    {
        g.graphics.lineTo(end.x, end.y);
    }
}

public function getLinearValue(t:Number, start:Point, end:Point):Point 
{
    t = Math.max(Math.min(t, 1), 0);
    var x:Number = start.x + (t * (end.x - start.x));
    var y:Number = start.y + (t * (end.y - start.y));
    return new Point(x, y);    
}

 public function drawQuadCurve(g:Shape, start:Point, cp:Point, end:Point, dashed:Boolean = false, dashLength:Number = 10, segments:Number = 200):void 
 {
    g.graphics.moveTo(start.x, start.y);

    if (dashed) 
    {
        var step:Number = 1 / segments;
        var dist:Number = 0;   
        var dashNum:Number;  
        var last:Point = start;
        var p:Point;
        for (var t:Number = step; t <= 1; t += step) 
        {
            p = getQuadraticValue(t, start, cp, end);
            dist += Point.distance(p, last);
            dashNum = Math.floor((dist / dashLength) % 2); 
            if (dashNum == 0) 
            {
                g.graphics.lineTo(p.x, p.y);
            } 
            else 
            {
                g.graphics.moveTo(p.x, p.y);
            }
            last = p;
        }
    } 
    else 
    {
        g.graphics.curveTo(cp.x, cp.y, end.x, end.y);
    }
}
 
public function getQuadraticValue(t:Number, start:Point, cp:Point, end:Point):Point 
{
    t = Math.max(Math.min(t, 1), 0);
    var tp:Number = 1 - t;
    var t2:Number = t * t;
    var tp2:Number = tp * tp;
    var x:Number = (tp2*start.x) + (2*tp*t*cp.x) + (t2*end.x);
    var y:Number = (tp2*start.y) + (2*tp*t*cp.y) + (t2*end.y);
    return new Point(x, y);    
}

public function clickHandler(event:MouseEvent):void
{
 	var btnId:String = event.target.id.toString()
	var __applicationObject:ApplicationVO = __genModel.applicationObject;
	
	var module_id:int =	61;
	var selectedModule:String = 'moodule_id == "' + module_id.toString() + '"' 	
	var menuItems:XMLList = __applicationObject.menu.rolepermission.(moodule_id == module_id.toString())		
    
	//Alert.show(menuItems.toString());
	
	var filteredMenu:XML = new GetMenuCommand().changeMenuXMLFormat(menuItems)
	var selectedMenuXml:XML = new XML(<rows/>);
	selectedMenuXml.appendChild(new XMLList(filteredMenu.row.row.(@code == btnId)));
	__genModel.context = 0
	__genModel.triggerSource = "MENU"
	__genModel.applicationObject.selectedMenuItem = selectedMenuXml.children()[0];
	
	var tabpage:TabPage	=	new TabPage();
	
	tabpage.openTabpage(selectedMenuXml.children()[0].@name, selectedMenuXml.children()[0].@component_cd);
}
public function clickOrderToHandler(event:MouseEvent):void
{
 	var btnId:String = event.target.id.toString()
	var __applicationObject:ApplicationVO = __genModel.applicationObject;
	
	var module_id:int =	41;
	var selectedModule:String = 'moodule_id == "' + module_id.toString() + '"' 	
	var menuItems:XMLList = __applicationObject.menu.rolepermission.(moodule_id == module_id.toString())		

	//Alert.show(menuItems.toString());
	
	var filteredMenu:XML = new GetMenuCommand().changeMenuXMLFormat(menuItems)
	var selectedMenuXml:XML = new XML(<rows/>);
	selectedMenuXml.appendChild(new XMLList(filteredMenu.row.row.(@code == btnId)));
	__genModel.context = 0
	__genModel.triggerSource = "MENU"
	__genModel.applicationObject.selectedMenuItem = selectedMenuXml.children()[0];
	
	var tabpage:TabPage	=	new TabPage();
	
	tabpage.openTabpage(selectedMenuXml.children()[0].@name, selectedMenuXml.children()[0].@component_cd);
}
private function acceptClickHandler():void
{
	var tabpage:TabPage	=	new TabPage();
	var i:int
	i = tabpage.searchTabPage('Accept Offer');
	
	if(i==0)
	{
		tabpage.createTabPage('Accept Offer','melt/customerresponseaccept/components/CustomerResponseAccept.swf');	
	}
	else
	{
		__genModel.tabMain.selectedIndex = i;
	}
	
}
private function rejectClickHandler():void
{
	var tabpage:TabPage	=	new TabPage();
	var i:int
	i = tabpage.searchTabPage('Reject Offer/No Response');
	
	if(i==0)
	{
		tabpage.createTabPage('Reject Offer/No Response','melt/customerresponsereject/components/CustomerResponseReject.swf');	
	}
		else
	{
		__genModel.tabMain.selectedIndex = i;
	}	
}
/*private function changeMenuXMLFormat(aMenuItems:XMLList):XML
{
	var xmlChild:XML
	var xml:XML = new XML(<row></row>)
	var xmlInner:XML
	
	for(var i:int = 0; i < aMenuItems.length(); i++)
	{
		if(aMenuItems.elements('menu_id')[i].toString() == null || aMenuItems.elements('menu_id')[i].toString() == '')
		{
			xmlChild = new XML(<row> </row>)
		
			xmlChild.@['name'] = aMenuItems.elements('name')[i].toString()
			xmlChild.@['menu_id'] = aMenuItems.elements('menu_id')[i].toString()

			for(var j:int = 0; j < aMenuItems.length(); j++)
			{
				if(aMenuItems.elements('id')[i].toString() == aMenuItems.elements('menu_id')[j].toString())
				{
					xmlInner = new XML(<row />)

					xmlInner.@['name'] = aMenuItems.elements('name')[j].toString()
					xmlInner.@['code'] = aMenuItems.elements('code')[j].toString()
					xmlInner.@['document_id'] = aMenuItems.elements('document_id')[j].toString()
					xmlInner.@['component_cd'] = aMenuItems.elements('component_cd')[j].toString()
					xmlInner.@['id'] = aMenuItems.elements('id')[j].toString()
					xmlInner.@['create_permission'] = aMenuItems.elements('create_permission')[j].toString()
					xmlInner.@['modify_permission'] = aMenuItems.elements('modify_permission')[j].toString()
					xmlInner.@['view_permission'] = aMenuItems.elements('view_permission')[j].toString()
					xmlInner.@['menu_id'] = aMenuItems.elements('menu_id')[j].toString()

					xmlChild.appendChild(xmlInner)
				}
			}
			xml.appendChild(xmlChild)
		}
	}
	return xml
}*/