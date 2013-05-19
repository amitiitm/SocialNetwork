 
 import flash.events.TimerEvent;
 import flash.utils.Timer;
 
 import mx.controls.Alert;
 import mx.events.SliderEvent;

 
 private var _url:String;
 
[Embed(source="../assets/player_play.png")]
  [Bindable]
  public var playIconCls:Class;

[Embed(source="../assets/player_pause.png")]
  [Bindable]
  public var pauseIconCls:Class;

[Embed(source="../assets/player_sound16.png")]
  [Bindable]
  public var soundIconCls:Class;

[Embed(source="../assets/player_mute16.png")]
  [Bindable]
  public var muteIconCls:Class;
  
private var _autoRepeat:Boolean = false;
private var _autoPlay:Boolean = false;

			
public function set url(aString:String):void
{
	_url	=	aString;
	
	if(aString != "")
	{
		player.source	=	aString;
		player.play();
		playButton.setStyle("icon", pauseIconCls);
		playButton.enabled = true;
		stopButton.enabled = true;
		repeatButton.enabled = true;
	}
	else
	{
		playButton.enabled = false;
		stopButton.enabled = false;
		repeatButton.enabled = false;
	}
}

public function get url():String
{
	return _url;
	
}

public function initPlayer():void 
{
	if (autoPlay)
	{
		play(0);
	}
}

private function changeTitle(timerEvent:TimerEvent):void
{
	/*var title:String = mp3Player.id3.songName;
	switch(_timer.currentCount % 3)
	{
		case 1: 
			title = mp3Player.id3.artist;
			break;
		case 2:
			title = mp3Player.id3.album;
			break;
	}
	trackLabel.text = title;*/
}



public function togglePlay():void
{
	if (!player.playing)
	{
		play();
	}
	else
	{
		pause();
	}
}

public function replay():void
{
	if (_autoRepeat)
	{
		play(0);
	}
	else
	{
		pause();
	}
}


public function play(position:Number = -1):void
{
	if (position >= 0)
	{
		player.playheadTime = position;
	}
	player.play();
	playButton.toolTip = "Pause";
	playButton.setStyle("icon", pauseIconCls);
	playButton.selected = true;		
	if (!muteButton.selected)
	{
		//musicVis.visible = true;
	}													
}

public function pause():void
{
	if (player.playing)
	{
		player.pause();
	}					
	playButton.toolTip = "Play";
	playButton.setStyle("icon", playIconCls);
//	musicVis.visible = false;																	
}

public function stop():void
{
	playButton.selected = false;
	player.stop();
	positionLabel.text = "";
	trackSlider.value = 0;
	//musicVis.visible = false;
}

private function seek(event:SliderEvent):void
{
	play(event.value);
	trackSlider.toolTip = positionText(event.value);
}

private function updatePosition(event:SliderEvent):void
{
	positionLabel.text = positionText(event.value);				
}

private function position(value:Number):String
{
	return positionText(trackSlider.value);
}

private function positionText(seconds:Number):String
{
	var min:Number = Math.floor(seconds / 60);
	 	var sec:Number = Math.floor(seconds % 60);
	 	if (isNaN(min) || isNaN(sec))
	 	{
	 		return "";
	 	}
	  return min + ":" + (sec < 10 ? "0" + sec:sec);
}

private function toggleRepeat():void
{
	_autoRepeat = repeatButton.selected;
	repeatButton.toolTip = player.autoRewind ? "Turn repeat off":"Turn repeat on";
}

private function toggleSound():void
{				
	if (muteButton.selected)
	{
		player.volume = 0;				
		muteButton.toolTip = "Sound";
		muteButton.setStyle("icon", muteIconCls);
	//	musicVis.visible = false;					
	}
	else
	{
		player.volume = (volumeSlider.value/100);				
		muteButton.toolTip =  "Mute";
		muteButton.setStyle("icon", soundIconCls);
		if (player.playing)
		{
		//	musicVis.visible = true;
		}
	}
}
	
/*	
public function toggleViewMode():void     // It may required later, so commented.
{
	var videoWidth:uint = player.videoWidth;
	var videoHeight:uint = player.videoHeight;
	
	var barHeight:uint = trackBox.height + controlBox.height + 5;
	var playerHeight:uint=this.height;
	var playerWidth:uint=this.width;
	 
	if (viewModeButton.selected )
	{				
		Tweener.addTween(this.playerBox,{width:playerWidth+180,height:playerHeight+barHeight+120,time:3});					
	
		Tweener.addTween(this.player, {width: player.width+170, height: player.height+barHeight+120, time: 3}); 
	}
	else
	{
		Tweener.addTween(this.playerBox, {width: 401 ,height: 370, time: 3});
		Tweener.addTween(this.player, {width: 380, height: 240, time: 3}); 
	}
}
	*/    	

			
public function get autoPlay():Boolean
{
	return _autoPlay;
}			
public function set autoPlay(auto:Boolean):void
{
	_autoPlay = auto;
}
			

public function get autoRepeat():Boolean
{
	return _autoRepeat;
}			
public function set autoRepeat(auto:Boolean):void
{
	_autoRepeat = auto;
}


