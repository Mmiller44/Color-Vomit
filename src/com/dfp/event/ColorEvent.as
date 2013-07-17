package com.dfp.event
{
	import flash.events.Event;
	
	public class ColorEvent extends Event
	{
		// Custom Event to handle when the palette has loaded or failed
		public static const PALETTE_ERROR:String = "paletteError";
		public static const PALETTE_LOADED:String = "paletteLoaded";
		public static const PALETTE_CHANGE:String = "paletteChange";
		
		public var paletteVOArray:Array;
		
		public function ColorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}