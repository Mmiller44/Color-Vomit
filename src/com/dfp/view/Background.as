package com.dfp.view
{
	import flash.geom.ColorTransform;
	
	public class Background extends BackgroundBase
	{
		private var _paletteVOArray:Array;
		private var _currentIndex:int;
		
		public function Background()
		{
			super();
		}
		
		public function set paletteVOArray(value:Array):void
		{
			_paletteVOArray = value;
			makeSplats();
		}
		
		public function set currentIndex(value:int):void
		{
			// making a setter that will represent what index I am at within the array.
			// this is set from the display class and updates when the one in the display class updates.
			_currentIndex = value;
			makeSplats();
		}
		
		public function makeSplats():void
		{		
			// I am using 6 color transforms to transform the colors of the MovieClip splats.
			// The splats are instances within the Background
			// The color is being set based on what Palette the user is currently viewing
			
			var ct2:ColorTransform = new ColorTransform();
			ct2.color = int(_paletteVOArray[_currentIndex].hex4);
			Hex2.transform.colorTransform = ct2;
			
			var ct3:ColorTransform = new ColorTransform();
			ct3.color = int(_paletteVOArray[_currentIndex].hex3);
			Hex3.transform.colorTransform = ct3;
			
			var ct4:ColorTransform = new ColorTransform();
			ct4.color = int(_paletteVOArray[_currentIndex].hex4);
			Hex4.transform.colorTransform = ct4;
			
			var ct5:ColorTransform = new ColorTransform();
			ct5.color = int(_paletteVOArray[_currentIndex].hex5);
			Hex5.transform.colorTransform = ct5;
			
			var ct6:ColorTransform = new ColorTransform();
			ct6.color = int(_paletteVOArray[_currentIndex].hex2);
			Hex6.transform.colorTransform = ct6;
			
			var ct7:ColorTransform = new ColorTransform();
			ct7.color = int(_paletteVOArray[_currentIndex].hex1);
			Hex7.transform.colorTransform = ct7;
			
			var ct9:ColorTransform = new ColorTransform();
			ct9.color = int(_paletteVOArray[_currentIndex].hex2);
			Hex9.transform.colorTransform = ct9;
			
			var ct10:ColorTransform = new ColorTransform();
			ct10.color = int(_paletteVOArray[_currentIndex].hex5);
			Hex10.transform.colorTransform = ct10;
			
			var ct11:ColorTransform = new ColorTransform();
			ct11.color = int(_paletteVOArray[_currentIndex].hex1);
			Hex11.transform.colorTransform = ct11;
			
		}

	}
}