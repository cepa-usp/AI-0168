package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Tela4 extends MovieClip
	{
		public function Tela4() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addListenerBarras();
		}
		
		private var barra_ret:Dictionary = new Dictionary();
		public function addListenerBarras():void
		{
			ret1.visible = false;
			ret2.visible = false;
			ret3.visible = false;
			ret4.visible = false;
			ret5.visible = false;
			
			barra1.addEventListener(MouseEvent.MOUSE_OVER, overBarra);
			barra2.addEventListener(MouseEvent.MOUSE_OVER, overBarra);
			barra3.addEventListener(MouseEvent.MOUSE_OVER, overBarra);
			barra4.addEventListener(MouseEvent.MOUSE_OVER, overBarra);
			barra5.addEventListener(MouseEvent.MOUSE_OVER, overBarra);
			
			barra1.buttonMode = true;
			barra2.buttonMode = true;
			barra3.buttonMode = true;
			barra4.buttonMode = true;
			barra5.buttonMode = true;
			
			barra_ret[barra1] = ret1;
			barra_ret[barra2] = ret2;
			barra_ret[barra3] = ret3;
			barra_ret[barra4] = ret4;
			barra_ret[barra5] = ret5;
		}
		
		private function overBarra(e:MouseEvent):void 
		{
			var barra:MovieClip = MovieClip(e.target);
			barra.addEventListener(MouseEvent.MOUSE_OUT, outBarra);
			barra_ret[barra].visible = true;
		}
		
		private function outBarra(e:MouseEvent):void 
		{
			var barra:MovieClip = MovieClip(e.target);
			barra.removeEventListener(MouseEvent.MOUSE_OUT, outBarra);
			barra_ret[barra].visible = false;
		}
	}
	
}