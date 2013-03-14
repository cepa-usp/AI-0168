package 
{
	import fl.controls.CheckBox;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Tela1 extends Tela 
	{
		public var ch1:CheckBox;
		public var ch2:CheckBox;
		public var ch3:CheckBox;
		public var ch4:CheckBox;
		public var ch5:CheckBox;
		
		public var campo1:TextField;
		public var campo2:TextField;
		public var campo3:TextField;
		
		public var campo1_rect:MovieClip;
		public var campo2_rect:MovieClip;
		public var campo3_rect:MovieClip;
		
		private var campoSelected:TextField;
		//private var campoSelected:TLFTextField;
		
		private var campo_fundo:Dictionary = new Dictionary();
		private var check_lock:Dictionary = new Dictionary();
		private var campo_check:Dictionary = new Dictionary();
		
		private var checksUsados:Vector.<CheckBox> = new Vector.<CheckBox>();
		
		public function Tela1() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			makeConections();
			configuraCheckboxes();
			
			addListeners();
			lockCheckboxes();
		}
		
		private function addListeners():void 
		{
			campo1.addEventListener(MouseEvent.CLICK, campoClick);
			campo2.addEventListener(MouseEvent.CLICK, campoClick);
			campo3.addEventListener(MouseEvent.CLICK, campoClick);
			
			ch1.addEventListener(Event.CHANGE, checkChange);
			ch2.addEventListener(Event.CHANGE, checkChange);
			ch3.addEventListener(Event.CHANGE, checkChange);
			ch4.addEventListener(Event.CHANGE, checkChange);
			ch5.addEventListener(Event.CHANGE, checkChange);
			
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
				if (campoSelected.text == " ") campoSelected.text = check.label;
				else {
					campoSelected.text += " " + check.label;
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
						iniIndex = campoSelected.text.indexOf(check.label + " ");
						campoSelected.replaceText(iniIndex, iniIndex + check.label.length + 1, "");
					}else {
						iniIndex = campoSelected.text.indexOf(" " + check.label);
						campoSelected.replaceText(iniIndex, iniIndex + check.label.length + 1, "");
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
			check_lock[ch1].visible = true;
			check_lock[ch2].visible = true;
			check_lock[ch3].visible = true;
			check_lock[ch4].visible = true;
			check_lock[ch5].visible = true;
		}
		
		private function unlockCheckboxes():void 
		{
			check_lock[ch1].visible = false;
			check_lock[ch2].visible = false;
			check_lock[ch3].visible = false;
			check_lock[ch4].visible = false;
			check_lock[ch5].visible = false;
			
			for each (var item:CheckBox in checksUsados) 
			{
				if(campo_check[campoSelected].indexOf(item) < 0) check_lock[item].visible = true;
			}
		}
		
		private function configuraCheckboxes():void 
		{
			configuraCheckbox(ch1, formatoCheck, larguraText);
			configuraCheckbox(ch2, formatoCheck, larguraText);
			configuraCheckbox(ch3, formatoCheck, larguraText);
			configuraCheckbox(ch4, formatoCheck, larguraText);
			configuraCheckbox(ch5, formatoCheck, larguraText);
		}
		
		private function makeConections():void 
		{
			ch1 = ch1_s;
			ch2 = ch2_s;
			ch3 = ch3_s;
			ch4 = ch4_s;
			ch5 = ch5_s;
			
			campo1 = campo1_s;
			campo2 = campo2_s;
			campo3 = campo3_s;
			
			campo1.autoSize = TextFieldAutoSize.LEFT;
			campo1.multiline = true;
			campo1.text = " ";
			campo2.autoSize = TextFieldAutoSize.LEFT;
			campo2.multiline = true;
			campo2.text = " ";
			campo3.autoSize = TextFieldAutoSize.LEFT;
			campo3.multiline = true;
			campo3.text = " ";
			
			campo_check[campo1] = [];
			campo_check[campo2] = [];
			campo_check[campo3] = [];
			
			campo1_rect = campo1_rect_s;
			campo2_rect = campo2_rect_s;
			campo3_rect = campo3_rect_s;
			
			campo_fundo[campo1] = campo1_rect;
			campo_fundo[campo2] = campo2_rect;
			campo_fundo[campo3] = campo3_rect;
			
			drawRectangle(campo1, campo_fundo[campo1], bordaRectNormal);
			drawRectangle(campo2, campo_fundo[campo2], bordaRectNormal);
			drawRectangle(campo3, campo_fundo[campo3], bordaRectNormal);
			
			check_lock[ch1] = ch1_lock;
			check_lock[ch2] = ch2_lock;
			check_lock[ch3] = ch3_lock;
			check_lock[ch4] = ch4_lock;
			check_lock[ch5] = ch5_lock;
		}
		
		override public function saveStatus():Object 
		{
			var obj:Object = new Object();
			
			//Salva o status dos checkbox
			obj.checks = new Object();
			obj.checks.ch1 = ch1.selected;
			obj.checks.ch2 = ch2.selected;
			obj.checks.ch3 = ch3.selected;
			obj.checks.ch4 = ch4.selected;
			obj.checks.ch5 = ch5.selected;
			
			obj.campos = new Object();
			obj.campos.campo1 = campo_check[campo1];
			obj.campos.campo2 = campo_check[campo2];
			obj.campos.campo3 = campo_check[campo3];
			
			obj.camposText = new Object();
			obj.camposText.campo1 = campo1.text;
			obj.camposText.campo2 = campo2.text;
			obj.camposText.campo3 = campo3.text;
			
			return obj;
		}
		
		override public function restoreStatus(status:Object):void 
		{
			ch1.selected = status.checks.ch1;
			ch2.selected = status.checks.ch2;
			ch3.selected = status.checks.ch3;
			ch4.selected = status.checks.ch4;
			ch5.selected = status.checks.ch5;
			
			campo_check[campo1] = status.campos.campo1;
			campo_check[campo2] = status.campos.campo2;
			campo_check[campo3] = status.campos.campo3;
			
			campo1.text = status.camposText.campo1;
			campo2.text = status.camposText.campo2;
			campo3.text = status.camposText.campo3;
			
			drawRectangle(campo1, campo_fundo[campo1], bordaRectNormal);
			drawRectangle(campo2, campo_fundo[campo2], bordaRectNormal);
			drawRectangle(campo3, campo_fundo[campo3], bordaRectNormal);
			
			checksUsados = new Vector.<CheckBox>();
			
			for each (var itemCampo1:CheckBox in campo_check[campo1]) 
			{
				checksUsados.push(itemCampo1);
			}
			for each (var itemCampo2:CheckBox in campo_check[campo2]) 
			{
				checksUsados.push(itemCampo2);
			}
			for each (var itemCampo3:CheckBox in campo_check[campo3]) 
			{
				checksUsados.push(itemCampo3);
			}
		}
		
		override public function reset():void 
		{
			ch1.selected = false;
			ch2.selected = false;
			ch3.selected = false;
			ch4.selected = false;
			ch5.selected = false;
			
			campo_check[campo1] = [];
			campo_check[campo2] = [];
			campo_check[campo3] = [];
			
			campo1.text = " ";
			campo2.text = " ";
			campo3.text = " ";
			
			drawRectangle(campo1, campo_fundo[campo1], bordaRectNormal);
			drawRectangle(campo2, campo_fundo[campo2], bordaRectNormal);
			drawRectangle(campo3, campo_fundo[campo3], bordaRectNormal);
			
			if (campoSelected != null) {
				drawRectangle(campoSelected, campo_fundo[campoSelected], bordaRectNormal);
				campoSelected = null;
				stage.focus = null;
			}
			
			checksUsados = new Vector.<CheckBox>();
		}
		
	}
	
}