package 
{
	import fl.controls.CheckBox;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Tela extends MovieClip
	{
		
		protected var formatoCheck:TextFormat = new TextFormat("Arial", 14, 0x000000);
		protected var larguraText:Number = 200;
		
		protected function configuraCheckbox(ch:CheckBox, format:TextFormat, largura:Number):void
		{
			ch.textField.autoSize = TextFieldAutoSize.LEFT;
			ch.setStyle("textFormat", format);
			ch.textField.width = largura;
			//ch.textField.multiline = true;
			if(ch.label.length > 20) ch.textField.wordWrap = true;
			ch.label = ch.label;
		}
		
		protected var bordaRectNormal:uint = 0xFF9900;
		protected var bordaRectSelected:uint = 0xD90000;
		private var insideRect:uint = 0xFFFFFF;
		private var insideAlpha:Number = 0.5;
		protected function drawRectangle(txt:TextField, rect:MovieClip, cor:uint):void
		{
			rect.x = txt.x;
			rect.y = txt.y;
			rect.graphics.clear();
			rect.graphics.lineStyle(2, cor);
			rect.graphics.beginFill(insideRect, insideAlpha);
			if (rect.rotation == 0) rect.graphics.drawRect(0, 0, txt.width, txt.height);
			else rect.graphics.drawRect(0, 0, txt.height, txt.width);
			rect.graphics.endFill();
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