package 
{
	import fl.controls.CheckBox;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Tela extends MovieClip
	{
		protected var wrongFilter:GlowFilter = new GlowFilter(0xFF0000, 1, 4, 4, 1, 1);
		protected var formatoCheck:TextFormat = new TextFormat("Arial", 14, 0x000000);
		protected var formatoCheckDisabled:TextFormat = new TextFormat("Arial", 14, 0x808080);
		protected var larguraText:Number = 200;
		public var checksUsados:Vector.<CheckBox> = new Vector.<CheckBox>();
		
		protected function configuraCheckbox(ch:CheckBox, format:TextFormat, largura:Number):void
		{
			ch.textField.autoSize = TextFieldAutoSize.LEFT;
			ch.setStyle("textFormat", format);
			ch.setStyle("disabledTextFormat", formatoCheckDisabled);
			ch.textField.width = largura;
			//ch.textField.multiline = true;
			if(ch.label.length > 20) ch.textField.wordWrap = true;
			ch.label = ch.label;
		}
		
		protected var bordaRectNormal:uint = 0xC0C0C0;
		protected var bordaRectSelected:uint = 0xD90000;
		private var insideRect:uint = 0xFFFFFF;
		private var insideAlpha:Number = 1;
		private var glow:GlowFilter = new GlowFilter(0xFF8000, 1, 6, 6, 2, 1, false, false);
		protected function drawRectangle(txt:TextField, rect:MovieClip, cor:uint):void
		{
			rect.x = txt.x;
			rect.y = txt.y;
			rect.graphics.clear();
			//rect.graphics.lineStyle(2, cor);
			rect.graphics.lineStyle(2, bordaRectNormal);
			rect.graphics.beginFill(insideRect, insideAlpha);
			if (rect.rotation == 0) rect.graphics.drawRect(0, 0, txt.width, txt.height);
			else rect.graphics.drawRect(0, 0, txt.height, txt.width);
			rect.graphics.endFill();
			if (cor == bordaRectNormal) {
				rect.filters = [];
			}else {
				rect.filters = [glow];
			}
		}
		
		public function saveStatus():Object
		{
			return "";
		}
		
		public function restoreStatus(status:Object):void
		{
			
		}
		
		public function reset():void
		{
			
		}
		
		public function avaliar():int
		{
			return 0;
		}
		
	}
	
}