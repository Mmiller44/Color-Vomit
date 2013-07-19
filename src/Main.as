package
{
	import com.dfp.event.ColorEvent;
	import com.dfp.model.ColorService;
	import com.dfp.view.Background;
	import com.dfp.view.Display;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	[SWF (width="1140", height="540", frameRate="60")]
	public class Main extends Sprite
	{
		private var _svc:ColorService;
		private var _display:Display;
		private var _bg:Background;
		private var _keyword:String;
		
		// URL to live deployment
		// http://mmiller44.github.io/Color-Vomit/index.html 
		// or www.colorvomit.com
		
		private var _errorMessage:ErrorBase;
		
		public function Main()
		{	
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT; 
			
			initData();
			
//			stage.align = StageAlign.TOP_LEFT;
//			stage.scaleMode = StageScaleMode.NO_BORDER;
//			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		protected function onResize(event:Event):void
		{
			trace("hello");
		}
		
		private function initData():void
		{
			// Creating a new background
			_bg = new Background();
			addChild(_bg);
			_bg.y = 0;
			_bg.x = 0;
			
			setupCopyright();
			
			// creating a new instance of ColorService to make the listeners listen for the palettes being loaded or failing to load.
			_svc = new ColorService();
			_svc.addEventListener(ColorEvent.PALETTE_ERROR, onPaletteError);
			_svc.addEventListener(ColorEvent.PALETTE_LOADED, onPaletteLoaded);
			
			// Creating the display.
			_display = new Display(this);
			addChild(_display);
			_display.gotoAndStop(1);
			_display.x = stage.stageWidth/2 - _display.width/2;
			_display.y = 0;
			_display.addEventListener(ColorEvent.PALETTE_CHANGE, onChange);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onEnter);
			
			// making the search button listen for the mouse click.
			_display.Icon.addEventListener(MouseEvent.CLICK, onClick);
			_display.Icon.addEventListener(TouchEvent.TOUCH_TAP, onClick);
		}
		
		protected function onEnter(event:KeyboardEvent):void
		{
			if(event.keyCode == 13)
			{
				_svc.runSearch(_display.search.tfSearch.text);
				_display.gotoAndStop(2);
				_display._currentIndex = 0;
			}
			
			if(_display.currentFrame == 2)
			{
				if(event.keyCode == 37)
				{
					_display.onPrev();
				}
				if(event.keyCode == 39)
				{
					_display.onNext();
				}
			}
		}
		
		public function onClick(event:MouseEvent):void
		{	
			// When the search icon is clicked, jump to frame two and pass the inputted text as the keyword for the API
			_svc.runSearch(_display.search.tfSearch.text);
			_display.gotoAndStop(2);
			_display._currentIndex = 0;
		}
		
		protected function onChange(event:Event):void
		{
			_bg.currentIndex = _display.currentIndex;
		}
		
		private function onPaletteError(event:Event):void
		{
			//inform the _display that there was an error
			_errorMessage = new ErrorBase();
			addChild(_errorMessage);
			_errorMessage.x = stage.stageWidth/2 + 4;
			_errorMessage.y = stage.stageHeight/2 - 51;
			_errorMessage.Icon.addEventListener(MouseEvent.CLICK, onErrorSearch);
			_errorMessage.Icon.addEventListener(TouchEvent.TOUCH_TAP, onErrorSearch);
			_errorMessage.addEventListener(KeyboardEvent.KEY_DOWN, onErrorEnter);
			
			_display.search.tfSearch.text = "";
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onEnter);
		}
		
		protected function onErrorSearch(event:MouseEvent):void
		{
			if(_errorMessage)
			{
				_svc.runSearch(_errorMessage.search.tfSearch.text);
				_display.search.tfSearch.text = _errorMessage.search.tfSearch.text;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onEnter);				
				_display.Icon.addEventListener(MouseEvent.CLICK, onClick);
				_display.Icon.addEventListener(TouchEvent.TOUCH_TAP, onClick);
				
				removeChild(_errorMessage);
			}
		}
		
		protected function onErrorEnter(event:KeyboardEvent):void
		{			
			if(event.keyCode == 13)
			{
				_svc.runSearch(_errorMessage.search.tfSearch.text);
				_display._currentIndex = 0;
				_display.search.tfSearch.text = _errorMessage.search.tfSearch.text;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onEnter);				
				_display.Icon.addEventListener(MouseEvent.CLICK, onClick);
				_display.Icon.addEventListener(TouchEvent.TOUCH_TAP, onClick);

				removeChild(_errorMessage);
			}
		}
		
		public function onPaletteLoaded(event:ColorEvent):void
		{	
			//inform the _display that there are palettes to draw
			_bg.paletteVOArray = event.paletteVOArray;
			_display.paletteVOArray = event.paletteVOArray;
		}
		
		private function setupCopyright():void
		{
			var cxtMenu:ContextMenu = new ContextMenu();
			cxtMenu.hideBuiltInItems();
			
			var myItem:ContextMenuItem = new ContextMenuItem("Copyright ©2013 Mike Miller", true);
			myItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onCopyClick);
			cxtMenu.customItems.push(myItem);
			
			this.contextMenu = cxtMenu;
		}
		
		protected function onCopyClick(event:ContextMenuEvent):void
		{
			var uRequest:URLRequest = new URLRequest("http://www.colorvomit.com/");
			navigateToURL(uRequest, "_blank");
		}
	}
}