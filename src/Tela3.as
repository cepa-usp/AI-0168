package 
{
	import fl.controls.CheckBox;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Tela3 extends Tela 
	{
		public var ch1:CheckBox;
		public var ch2:CheckBox;
		public var ch3:CheckBox;
		public var ch4:CheckBox;
		public var ch5:CheckBox;
		public var ch6:CheckBox;
		public var ch7:CheckBox;
		public var ch8:CheckBox;
		public var ch9:CheckBox;
		public var ch10:CheckBox;
		public var ch11:CheckBox;
		public var ch12:CheckBox;
		public var ch13:CheckBox;
		public var ch14:CheckBox;
		public var ch15:CheckBox;
		public var ch16:CheckBox;
		public var ch17:CheckBox;
		public var ch18:CheckBox;
		
		public var campo1:TextField;
		public var campo2:TextField;
		public var campo3:TextField;
		public var campo4:TextField;
		public var campo5:TextField;
		public var campo6:TextField;
		public var campo7:TextField;
		public var campo8:TextField;
		
		private var campoSelected:TextField;
		
		private var campo_fundo:Dictionary = new Dictionary();
		private var check_lock:Dictionary = new Dictionary();
		private var campo_check:Dictionary = new Dictionary();
		
		private var checksUsados:Vector.<CheckBox> = new Vector.<CheckBox>();

		
		public function Tela3() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			makeConections();
			configuraCheckboxes();
			
			addListeners();
		}
		
		private function addListeners():void 
		{
			for (var i:int = 1; i <= 18; i++) 
			{
				var ch:CheckBox = this["ch" + i + "_s"];
				ch.addEventListener(Event.CHANGE, checkChange);
				
				if (i <= 8) {
					var campo:TextField = this["campo" + i + "_s"];
					campo.addEventListener(MouseEvent.CLICK, campoClick);
				}
			}
			
			stage.addEventListener(MouseEvent.CLICK, stageClick);
		}
		
		private function checkChange(e:Event):void 
		{
			var check:CheckBox = CheckBox(e.target);
			var iniIndex:int;
			
			if (check.selected) {
				campo_check[campoSelected].push(check);
				checksUsados.push(check);
				//campoSelected.text = check.label;
				if (campoSelected.text == " ") campoSelected.text = "• " + check.label;
				else {
					campoSelected.text += "\n• " + check.label;
				}
			}else {
				var indexCheck:int = campo_check[campoSelected].indexOf(check);
				campo_check[campoSelected].splice(indexCheck, 1);
				checksUsados.splice(checksUsados.indexOf(check), 1);
				//campoSelected.text.replace(check.label, "");
				if (campo_check[campoSelected].length == 0) {
					campoSelected.text = " ";
				}else {
					if (indexCheck == 0) {
						iniIndex = campoSelected.text.indexOf("• " + check.label);
						campoSelected.replaceText(iniIndex, iniIndex + check.label.length + 3, "");
					}else {
						iniIndex = campoSelected.text.indexOf("• " + check.label);
						campoSelected.replaceText(iniIndex, iniIndex + check.label.length + 3, "");
					}
				}
			}
			drawRectangle(campoSelected, campo_fundo[campoSelected], bordaRectSelected);
		}
		
		private function stageClick(e:MouseEvent):void 
		{
			if (campoSelected == null) return;
			if (e.target is TextField) return;
			if (e.target is CheckBox) return;
			
			drawRectangle(campoSelected, campo_fundo[campoSelected], bordaRectNormal);
			campoSelected = null;
			lockCheckboxes();
		}
		
		private function campoClick(e:MouseEvent):void 
		{
			if (campoSelected == null) {
				campoSelected = TextField(e.target);
				drawRectangle(campoSelected, campo_fundo[campoSelected], bordaRectSelected);
				unlockCheckboxes();
			}else {
				drawRectangle(campoSelected, campo_fundo[campoSelected], bordaRectNormal);
				if (campoSelected != TextField(e.target)) {
					campoSelected = TextField(e.target);
					drawRectangle(campoSelected, campo_fundo[campoSelected], bordaRectSelected);
					unlockCheckboxes();
				}else {
					campoSelected = null;
					lockCheckboxes();
				}
			}
		}
		
		private function lockCheckboxes():void 
		{
			for (var i:int = 1; i <= 18; i++) 
			{
				var ch:CheckBox = this["ch" + i + "_s"];
				check_lock[ch].visible = true;
			}
		}
		
		private function unlockCheckboxes():void 
		{
			for (var i:int = 1; i <= 18; i++) 
			{
				var ch:CheckBox = this["ch" + i + "_s"];
				check_lock[ch].visible = false;
			}
			
			for each (var item:CheckBox in checksUsados) 
			{
				if(campo_check[campoSelected].indexOf(item) < 0) check_lock[item].visible = true;
			}
		}
		
		private function configuraCheckboxes():void 
		{
			for (var i:int = 1; i <= 18; i++) 
			{
				var ch:CheckBox = this["ch" + i + "_s"];
				configuraCheckbox(ch, formatoCheck, larguraText);
			}
		}
		
		private function makeConections():void 
		{
			for (var i:int = 1; i <= 18; i++) 
			{
				this["ch" + i] = this["ch" + i + "_s"];
				//var ch:CheckBox = this["ch" + i];
				//ch = this["ch" + i + "_s"];
				//check_lock[ch] = this["ch" + i + "_lock"];
				check_lock[this["ch" + i]] = this["ch" + i + "_lock"];
				
				if (i <= 8) {
					var campo:TextField = this["campo" + i];
					campo = this["campo" + i + "_s"];
					
					campo.autoSize = TextFieldAutoSize.LEFT;
					campo.multiline = true;
					//campo.wordWrap = true;
					campo.text = " ";
					
					campo_check[campo] = [];
					
					campo_fundo[campo] = this["campo" + i + "_rect_s"];
					
					drawRectangle(campo, campo_fundo[campo], bordaRectNormal);
				}
			}
		}
		
		override public function saveStatus():Object 
		{
			var status:Object = new Object();
			
			status.checks = new Object();
			status.campos = new Object();
			status.camposText = new Object();
			
			for (var i:int = 1; i <= 18; i++) 
			{
				status.checks["ch" + i] = this["ch" + i].selected;
				if(i <= 8){
					status.campos["campo" + i] = campo_check[this["campo" + i]];
					status.camposText["campo" + i] = this["campo" + i].text;
				}
			}
			
			return status;
		}
		
		override public function restoreStatus(status:Object):void 
		{
			checksUsados = new Vector.<CheckBox>();
			
			for (var i:int = 1; i <= 18; i++) 
			{
				this["ch" + i].selected = status.checks["ch" + i];
				if(i <= 8){
					campo_check[this["campo" + i]] = status.campos["campo" + i];
					this["campo" + i].text = status.camposText["campo" + i];
					
					if (status.campos["campo" + i] != null) checksUsados.push(status.campos["campo" + i]);
				}
			}
		}
		
		override public function reset():void 
		{
			for (var i:int = 1; i <= 18; i++) 
			{
				this["ch" + i].selected = false;
				if(i <= 8){
					campo_check[this["campo" + i]] = null;
					this["campo" + i].text = "";
				}
			}
			
			if (campoSelected != null) {
				drawRectangle(campoSelected, campo_fundo[campoSelected], bordaRectNormal);
				campoSelected = null;
				stage.focus = null;
			}
			
			checksUsados = new Vector.<CheckBox>();
		}
		
	}
	
}