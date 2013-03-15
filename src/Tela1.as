package 
{
	import fl.controls.CheckBox;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
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
		private var textUp:Array;
		private var textUpInicial:Dictionary = new Dictionary();
		
		public function Tela1() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addListenerBarras();
			makeConections();
			configuraCheckboxes();
			
			addListeners();
			lockCheckboxes();
			criaResposta();
			
			textUp = [campo3];
			textUpInicial[campo3] = new Point(campo3.y, campo3.height);
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
			
			if (textUp.indexOf(campoSelected) >= 0) {
				var ptInicial:Point = textUpInicial[campoSelected];
				campoSelected.y = ptInicial.x - (campoSelected.height - ptInicial.y);
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
			var status:Object = new Object();
			
			status.checks = new Object();
			status.campos = new Object();
			status.camposText = new Object();
			
			for (var i:int = 1; i <= 5; i++) 
			{
				status.checks["ch" + i] = this["ch" + i].selected;
				if (i <= 3) {
					if (campo_check[this["campo" + i]].length == 0) {
						status.campos["campo" + i] = "vazio";
					}else {
						status.campos["campo" + i] = "";
						for (var j:int = 0; j < campo_check[this["campo" + i]].length; j++) 
						{
							status.campos["campo" + i] += (j > 0 ? "," : "") + campo_check[this["campo" + i]][j].name;
						}
					}
					status.camposText["campo" + i] = this["campo" + i].text;
				}
			}
			
			return status;
		}
		
		override public function restoreStatus(status:Object):void 
		{
			checksUsados = new Vector.<CheckBox>();
			
			for (var i:int = 1; i <= 5; i++) 
			{
				this["ch" + i].selected = status.checks["ch" + i];
				
				if (i <= 3) {
					if (status.campos["campo" + i] == "vazio") {
						campo_check[this["campo" + i]] = [];
					}else {
						var camposCheck:Array = String(status.campos["campo" + i]).split(",");
						for (var j:int = 0; j < camposCheck.length; j++) {
							var check:CheckBox = this[camposCheck[j]];
							campo_check[this["campo" + i]].push(check);
							checksUsados.push(check);
						}
					}
					
					this["campo" + i].text = status.camposText["campo" + i];
				}
			}
		}
		
		override public function reset():void 
		{
			for (var i:int = 1; i <= 5; i++) 
			{
				this["ch" + i].selected = false;
				if(i <= 3){
					campo_check[this["campo" + i]] = [];
					this["campo" + i].text = " ";
					drawRectangle(this["campo" + i], campo_fundo[this["campo" + i]], bordaRectNormal);
				}
			}
			
			if (campoSelected != null) {
				drawRectangle(campoSelected, campo_fundo[campoSelected], bordaRectNormal);
				campoSelected = null;
				stage.focus = null;
			}
			
			checksUsados = new Vector.<CheckBox>();
		}
		
		private var resp:Dictionary;
		public function criaResposta():void
		{
			resp = new Dictionary();
			
			resp[campo1] = [ch1, ch4];
			resp[campo2] = [ch2, ch5];
			resp[campo3] = [ch3];
		}
		
		override public function avaliar():int 
		{
			var certas:int = 0;
			
			certas += calculaResp(campo1);
			certas += calculaResp(campo2);
			certas += calculaResp(campo3);
			
			return certas;
		}
		
		private function calculaResp(campo:TextField):int
		{
			var certas:int = 0;
			
			for (var i:int = 0; i < resp[campo].length; i++) 
			{
				for each (var item:CheckBox in campo_check[campo]) 
				{
					if (item == resp[campo][i]) {
						certas++;
						break;
					}
				}
			}
			
			return certas;
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