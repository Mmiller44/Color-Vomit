package com.dfp.view
{
	import com.dfp.event.ColorEvent;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	public class Display extends DisplayBase
	{
		private var _paletteVOArray:Array;
		private var _canvas:Sprite;
		public var _currentIndex:int = 0;
		private var _main:Sprite;
		private var _color:uint;
		private var _hexBox1:HexBox1;
		private var _hexBox2:HexBox1;
		private var _hexBox3:HexBox1;
		private var _hexBox4:HexBox1;
		private var _hexBox5:HexBox1;
		
		public function Display(main:Main)
		{
			super();
			
			_main = main;
			
			this.Icon.buttonMode = true;
			this.Icon.mouseChildren = false;
			
			_canvas = new Sprite();
			addChild(_canvas);
			_canvas.x = 100;
			_canvas.y = 205;
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			var _currentBox:Object = event.currentTarget;
			
			_currentBox.alpha = .5;
			_currentBox.buttonMode = true;
			_currentBox.mouseChildren = false;
			_currentBox.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			_currentBox.addEventListener(MouseEvent.CLICK, copyHex);
		}
		
		protected function copyHex(event:MouseEvent):void
		{	
			var _currentBox:Object = event.currentTarget;
			var copy:String = "hex";
			
			if(_currentBox == _hexBox1)
			{
				copy = _paletteVOArray[_currentIndex].hex1Splice;
			}
			else if(_currentBox == _hexBox2)
			{
				copy = _paletteVOArray[_currentIndex].hex2Splice;
			}
			else if(_currentBox == _hexBox3)
			{
				copy = _paletteVOArray[_currentIndex].hex3Splice;
			}
			else if(_currentBox == _hexBox4)
			{
				copy = _paletteVOArray[_currentIndex].hex4Splice;
			}
			else if(_currentBox == _hexBox5)
			{
				copy = _paletteVOArray[_currentIndex].hex5Splice;
			}
			
			Clipboard.generalClipboard.clear();
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, copy);

		}
		
		protected function onOut(event:MouseEvent):void
		{		
			var _currentBox:Object = event.currentTarget;
			_currentBox.alpha = 0;
		}
		
		public function set paletteVOArray(value:Array):void
		{
			_paletteVOArray = value;
			
			_hexBox1 = new HexBox1();
			_hexBox1.alpha = 0;
			_hexBox1.x = 145;
			_hexBox1.y = 241;
			this.addChild(_hexBox1);
			_hexBox1.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
			_hexBox2 = new HexBox1();
			_hexBox2.alpha = 0;
			_hexBox2.x = 255;
			_hexBox2.y = 241;
			this.addChild(_hexBox2);
			_hexBox2.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
			_hexBox3 = new HexBox1();
			_hexBox3.alpha = 0;
			_hexBox3.x = 365;
			_hexBox3.y = 241;
			this.addChild(_hexBox3);
			_hexBox3.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
			_hexBox4 = new HexBox1();
			_hexBox4.alpha = 0;
			_hexBox4.x = 475;
			_hexBox4.y = 241;
			this.addChild(_hexBox4);
			_hexBox4.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
			_hexBox5 = new HexBox1();
			_hexBox5.alpha = 0;
			_hexBox5.x = 585;
			_hexBox5.y = 241;
			this.addChild(_hexBox5);
			_hexBox5.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
			updateUI();
		}
		
		public function onPrev():void
		{
			// This prevents the program from crashing if the user tries to click the previous button when on the first palette.
			if(_currentIndex != 0)
			{
				_currentIndex--;
				updateUI();
			}
		}
		
		public function onNext():void
		{
			// restraining the app from being able to try and navigate past the amount of palettes that were loaded
			// into the array.
			if(_currentIndex < _paletteVOArray.length -1)
			{
				_currentIndex++;
				updateUI();
			}
		}
		
		private function updateUI():void
		{	
			// This will be updating the data to display according to where the user has navigated.
			// This function gets called out whenever the next or previous buttons are clicked.
			this.tfAuthor.text = _paletteVOArray[_currentIndex].creator;
			this.tfFavorited.text = _paletteVOArray[_currentIndex].favorites;
			this.tfTitle.text = _paletteVOArray[_currentIndex].title;
			this.tfViews.text = _paletteVOArray[_currentIndex].views;
			this.tfPublished.text = _paletteVOArray[_currentIndex].published;
			this.tfResults.text = _currentIndex + 1 + " of " + _paletteVOArray[_currentIndex].results;
			this.tfHex1.text = _paletteVOArray[_currentIndex].hex1Splice + "";
			this.tfHex2.text = _paletteVOArray[_currentIndex].hex2Splice + "";
			this.tfHex3.text = _paletteVOArray[_currentIndex].hex3Splice + "";
			this.tfHex4.text = _paletteVOArray[_currentIndex].hex4Splice + "";
			this.tfHex5.text = _paletteVOArray[_currentIndex].hex5Splice + "";
			
			this.nextButton.buttonMode = true;
			this.prevButton.buttonMode = true;
			this.prevButton.mouseChildren = false;
			this.nextButton.mouseChildren = false;
							
			this.prevButton.addEventListener(MouseEvent.CLICK, prevClicked);
			this.nextButton.addEventListener(MouseEvent.CLICK, nextClicked);
			
			// running the draw palettes
			drawPalette();
			
			dispatchEvent(new ColorEvent(ColorEvent.PALETTE_CHANGE));
		}
		
		protected function nextClicked(event:MouseEvent):void
		{
			onNext();
		}
		
		protected function prevClicked(event:MouseEvent):void
		{
			onPrev();
		}
		
		private function drawPalette():void
		{	
			// This function is in charge of taking the VO values for the API's hex and creating 5 squares that are being drawn
			// to act like a color palette. This will save memory and load times over the alternative which was to take an image in.
			
			// Clearing any graphics that were here before this got run so it's not drawing on top of colors but instead "redrawing"
			_canvas.graphics.clear();
						
			// First Square
			_color = int(_paletteVOArray[_currentIndex].hex1);
			_canvas.graphics.beginFill(_color,1);
			_canvas.graphics.lineStyle(3,0xffffff);
			_canvas.graphics.drawRect(0,0,100,100);
			_canvas.graphics.endFill();
			
			// Second Square
			_color = int(_paletteVOArray[_currentIndex].hex2);
			_canvas.graphics.beginFill(_color,1);
			_canvas.graphics.drawRect(110,0,100,100);
			_canvas.graphics.endFill();
			
			// Third Square
			_color = int(_paletteVOArray[_currentIndex].hex3);
			_canvas.graphics.beginFill(_color,1);
			_canvas.graphics.drawRect(220,0,100,100);
			_canvas.graphics.endFill();
			
			// Fourth Square
			_color = int(_paletteVOArray[_currentIndex].hex4);
			_canvas.graphics.beginFill(_color,1);
			_canvas.graphics.drawRect(330,0,100,100);
			_canvas.graphics.endFill();
			
			// Fifth Square
			_color = int(_paletteVOArray[_currentIndex].hex5);
			_canvas.graphics.beginFill(_color,1);
			_canvas.graphics.drawRect(440,0,100,100);
			_canvas.graphics.endFill();
			
			var ct:ColorTransform = new ColorTransform();
			ct.color = int(_paletteVOArray[_currentIndex].hex1);
			logoBottom.transform.colorTransform = ct;
			
			var ct2:ColorTransform = new ColorTransform();
			ct2.color = int(_paletteVOArray[_currentIndex].hex2);
			logoTop.transform.colorTransform = ct2;
		}
		
		public function get currentIndex():int
		{
			return _currentIndex;
		}

	}
}