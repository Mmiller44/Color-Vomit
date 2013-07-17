package com.dfp.model
{
	import com.dfp.event.ColorEvent;
	import com.dfp.model.vo.PaletteVO;
	import com.dfp.view.Background;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	public class ColorService extends EventDispatcher
	{
		private var _paletteVOArray:Array = [];
		
		public function ColorService()
		{
		}
		
		public function runSearch(keyword:String,pageNum:uint=1):void
		{	
			// Setting the request for the API with the value of the keyword that was received from the Main class
			var uVars:URLVariables = new URLVariables();
			uVars.keywords = keyword;
			uVars.numResults = "60";
			
			var url:String = "http://www.colourlovers.com/api/palettes";
			
			var uRequest:URLRequest = new URLRequest(url);
			uRequest.data = uVars;
			
			var uloader:URLLoader = new URLLoader();
			uloader.load(uRequest);
			uloader.addEventListener(Event.COMPLETE, onLoad);
		}
		
		protected function onLoad(event:Event):void
		{
			_paletteVOArray = [];
			
			// runs when the palette API has been loaded.
			// Sets the amount API data to my array
			// Has a conditional to dispatch an event if the API failed to load.
			var xmlData:XML = XML(event.currentTarget.data);
			
			if(xmlData.@numResults <= 0)
			{
				dispatchEvent(new ColorEvent(ColorEvent.PALETTE_ERROR));
			}
			else{	
				//Everytime there is XML Data within the palette node of my api, I am asking it to save this data.
				for each (var palette:XML in xmlData.palette) 
				{
					var paletteVO:PaletteVO = new PaletteVO();
					paletteVO.title = palette.title;
					paletteVO.creator = palette.userName;
					paletteVO.views = palette.numViews;
					paletteVO.results = Number(xmlData.@numResults);
					paletteVO.favorites = palette.numVotes;
					paletteVO.hex1 = "0x" + palette.colors.hex[0];
					paletteVO.hex2 = "0x" + palette.colors.hex[1];
					paletteVO.hex3 = "0x" + palette.colors.hex[2];
					paletteVO.hex4 = "0x" + palette.colors.hex[3];
					paletteVO.hex5 = "0x" + palette.colors.hex[4];
					paletteVO.hex1Splice = palette.colors.hex[0];
					paletteVO.hex2Splice = palette.colors.hex[1];
					paletteVO.hex3Splice = palette.colors.hex[2];
					paletteVO.hex4Splice = palette.colors.hex[3];
					paletteVO.hex5Splice = palette.colors.hex[4];
					paletteVO.published = palette.dateCreated;

					paletteVO.splat1 = palette.colors.hex[0];
					
					// pushing the entire VO into my array I have created to hold it.
					_paletteVOArray.push(paletteVO);
				}
				
				// This is letting the main class know that my palettes have successfully loaded.
				var evt:ColorEvent = new ColorEvent(ColorEvent.PALETTE_LOADED);
				evt.paletteVOArray = _paletteVOArray;
				dispatchEvent(evt);
			}
		}
	}
}
