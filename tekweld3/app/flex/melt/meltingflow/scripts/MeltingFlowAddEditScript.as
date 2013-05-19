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
	
	makeLine(63,199,142,199);	//receive packet to attach video 
	
	makeLine(132,194,142,199);
	makeLine(132,204,142,199);
	
	makeLine(218,199,285,199);  // attach video to metal Analysis
	
	makeLine(275,194,285,199);
	makeLine(275,204,285,199);
	
	makeLine(349,199,425,199);	// metal analysis to updat metal rate
	
	makeLine(415,194,425,199);
	makeLine(415,204,425,199); 
	
 	makeLine(616.9,172,616.9,73);	// send offer to Accept Offer------------
	
	makeLine(612,83,617,73);
	makeLine(622,83,617,73);
	
	makeLine(462,80,462,175); // daily meal rate to update metal rate
	
	makeLine(457,165,462,175);
	makeLine(467,165,462,175);
	
	makeLine(497,200,587,200); // update metal rate to send offer
	
	makeLine(577,195,587,200);
	makeLine(577,205,587,200);
	
	
	makeLine(616.9,238,616.9,355);		// send video to reject offer--------
	
	makeLine(612,345,617,355);
	makeLine(622,345,617,355);   
	
	makeLine(648,210,732,270,1,true);  // send video to send reminder
	
	makeLine(728,260,732,270);
	makeLine(723,268,732,270);
	
	makeLine(949,294,975,294); 	//	stop payment to return packet
	makeLine(975,294,975,370);
	makeLine(975,370,1047,370);
	
	makeLine(1037,365,1047,370);
	makeLine(1037,375,1047,370); 
	
	makeLine(310,248,310,430);	// metal analysis to return packet
								
	makeLine(310,430,975,430);
	makeLine(975,430,975,395);
	
	makeLine(975,395,1047,395);
	
	makeLine(1037,390,1047,395);
	makeLine(1037,400,1047,395); 

	makeLine(957,135,1047,135);		// update encash date to print commission check

	makeLine(1037,131,1047,135);
	makeLine(1037,139,1047,135);
		
	makeLine(646,33,728,33);			// accept offer to print check
	
	makeLine(718,28,728,33);
	makeLine(718,38,728,33);
	
	makeLine(649,383,1047,383);	// reject offer to return packet
	
	makeLine(1037,378,1047,383);
	makeLine(1037,388,1047,383);
	
	makeLine(767,65,767,173);			// print check to verify check status
	
	makeLine(762,163,767,173);
	makeLine(772,163,767,173);
	
	makeLine(800,206,970,206,1,true);			// verify check status to send deposit reminder
	
	makeLine(960,201,970,206);
	makeLine(960,211,970,206);
	
	makeLine(796,195,887,150);					//  verify check status to update check status

	makeLine(879,150,887,150);
	makeLine(882,158,887,150);

	makeLine(796,217,887,268);					//	verify check status to stop payment

	makeLine(881,259,887,268);
	makeLine(879,268,887,268);
	

	
	makeLine(1105,136,1147,136);				//	print Commission check to update commission encash date
	
	makeLine(1137,132,1147,136);
	makeLine(1137,140,1147,136);
	
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
 	var btnId:String = event.target.label.toString()
	var __applicationObject:ApplicationVO = __genModel.applicationObject;
	
	var module_id:int =	83;
	var selectedModule:String = 'moodule_id == "' + module_id.toString() + '"' 	
	var menuItems:XMLList = __applicationObject.menu.rolepermission.(moodule_id == module_id.toString())		

	//Alert.show(menuItems.toString());
	
	var filteredMenu:XML = GetMenuCommand().changeMenuXMLFormat(menuItems)
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