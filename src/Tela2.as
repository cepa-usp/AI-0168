package 
{
	import fl.controls.CheckBox;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Tela2 extends Tela 
	{
		public var ch1:CheckBox;
		public var ch2:CheckBox;
		public var ch3:CheckBox;
		public var ch4:CheckBox;
		public var ch5:CheckBox;
		public var ch6:CheckBox;
		public var ch7:CheckBox;
		public var ch8:CheckBox;
		
		public var campo1:TextField;
		public var campo2:TextField;
		public var campo3:TextField;
		public var campo4:TextField;
		public var campo5:TextField;
		public var campo6:TextField;
		public var campo7:TextField;
		public var campo8:TextField;
		
		/*public var campo1_rect:MovieClip;
		public var campo2_rect:MovieClip;
		public var campo3_rect:MovieClip;
		public var campo4_rect:MovieClip;
		public var campo5_rect:MovieClip;
		public var campo6_rect:MovieClip;
		public var campo7_rect:MovieClip;
		public var campo8_rect:MovieClip;*/
		
		private var campoSelected:TextField;
		
		private var campo_fundo:Dictionary = new Dictionary();
		private var check_lock:Dictionary = new Dictionary();
		private var campo_check:Dictionary = new Dictionary();
		
		private var checksUsados:Vector.<CheckBox> = new Vector.<CheckBox>();
		
		public function Tela2() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			makeConections();
			configuraCheckboxes();
			
			addListeners();
			criaResposta();
			addListenerBarras();
		}
		
		private function addListeners():void 
		{
			campo1.addEventListener(MouseEvent.CLICK, campoClick);
			campo2.addEventListener(MouseEvent.CLICK, campoClick);
			campo3.addEventListener(MouseEvent.CLICK, campoClick);
			campo4.addEventListener(MouseEvent.CLICK, campoClick);
			campo5.addEventListener(MouseEvent.CLICK, campoClick);
			campo6.addEventListener(MouseEvent.CLICK, campoClick);
			campo7.addEventListener(MouseEvent.CLICK, campoClick);
			campo8.addEventListener(MouseEvent.CLICK, campoClick);
			
			ch1.addEventListener(Event.CHANGE, checkChange);
			ch2.addEventListener(Event.CHANGE, checkChange);
			ch3.addEventListener(Event.CHANGE, checkChange);
			ch4.addEventListener(Event.CHANGE, checkChange);
			ch5.addEventListener(Event.CHANGE, checkChange);
			ch6.addEventListener(Event.CHANGE, checkChange);
			ch7.addEventListener(Event.CHANGE, checkChange);
			ch8.addEventListener(Event.CHANGE, checkChange);
			
			stage.addEventListener(MouseEvent.CLICK, stageClick);
		}
		
		private var textConfigCh5:TextFormat = new TextFormat("Arial", 5, 0x000000);
		
		private function checkChange(e:Event):void 
		{
			var check:CheckBox = CheckBox(e.target);
			var iniIndex:int;
			
			if (check.selected) {
				if (campo_check[campoSelected].length > 0) {
					campo_check[campoSelected][0].selected = false;
					checksUsados.splice(checksUsados.indexOf(campo_check[campoSelected][0]), 1);
					campo_check[campoSelected].splice(0, 1);
				}
				campo_check[campoSelected].push(check);
				if (check == ch5) {
					campoSelected.text = check.label;
					campoSelected.setTextFormat(textConfigCh5, 42, 69);
					//Provável ancestral das plantas terrestres (Coleochaetales e Charales)
				}else{
					campoSelected.text = check.label;
				}
				
				checksUsados.push(check);
			}else {
				campo_check[campoSelected][0].selected = false;
				checksUsados.splice(checksUsados.indexOf(campo_check[campoSelected][0]), 1);
				campo_check[campoSelected].splice(0, 1);
				campoSelected.text = " ";
				campo_check[campoSelected] = null;
			}
			//drawRectangle(campoSelected, campo_fundo[campoSelected], bordaRectSelected);
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
			check_lock[ch6].visible = true;
			check_lock[ch7].visible = true;
			check_lock[ch8].visible = true;
		}
		
		private function unlockCheckboxes():void 
		{
			check_lock[ch1].visible = false;
			check_lock[ch2].visible = false;
			check_lock[ch3].visible = false;
			check_lock[ch4].visible = false;
			check_lock[ch5].visible = false;
			check_lock[ch6].visible = false;
			check_lock[ch7].visible = false;
			check_lock[ch8].visible = false;
			
			for each (var item:CheckBox in checksUsados) 
			{
				//if(campo_check[campoSelected][0] != item) check_lock[item].visible = true;
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
			configuraCheckbox(ch6, formatoCheck, larguraText);
			configuraCheckbox(ch7, formatoCheck, larguraText);
			configuraCheckbox(ch8, formatoCheck, larguraText);
		}
		
		private function makeConections():void 
		{
			ch1 = ch1_s;
			ch2 = ch2_s;
			ch3 = ch3_s;
			ch4 = ch4_s;
			ch5 = ch5_s;
			ch6 = ch6_s;
			ch7 = ch7_s;
			ch8 = ch8_s;
			
			campo1 = campo1_s;
			campo2 = campo2_s;
			campo3 = campo3_s;
			campo4 = campo4_s;
			campo5 = campo5_s;
			campo6 = campo6_s;
			campo7 = campo7_s;
			campo8 = campo8_s;
			
			//campo1.autoSize = TextFieldAutoSize.LEFT;
			//campo1.multiline = true;
			
			campo_check[campo1] = [];
			campo_check[campo2] = [];
			campo_check[campo3] = [];
			campo_check[campo4] = [];
			campo_check[campo5] = [];
			campo_check[campo6] = [];
			campo_check[campo7] = [];
			campo_check[campo8] = [];
			
			campo_fundo[campo1] = campo1_rect_s;
			campo_fundo[campo2] = campo2_rect_s;
			campo_fundo[campo3] = campo3_rect_s;
			campo_fundo[campo4] = campo4_rect_s;
			campo_fundo[campo5] = campo5_rect_s;
			campo_fundo[campo6] = campo6_rect_s;
			campo_fundo[campo7] = campo7_rect_s;
			campo_fundo[campo8] = campo8_rect_s;
			
			drawRectangle(campo1, campo_fundo[campo1], bordaRectNormal);
			drawRectangle(campo2, campo_fundo[campo2], bordaRectNormal);
			drawRectangle(campo3, campo_fundo[campo3], bordaRectNormal);
			drawRectangle(campo4, campo_fundo[campo4], bordaRectNormal);
			drawRectangle(campo5, campo_fundo[campo5], bordaRectNormal);
			drawRectangle(campo6, campo_fundo[campo6], bordaRectNormal);
			drawRectangle(campo7, campo_fundo[campo7], bordaRectNormal);
			drawRectangle(campo8, campo_fundo[campo8], bordaRectNormal);
			
			check_lock[ch1] = ch1_lock;
			check_lock[ch2] = ch2_lock;
			check_lock[ch3] = ch3_lock;
			check_lock[ch4] = ch4_lock;
			check_lock[ch5] = ch5_lock;
			check_lock[ch6] = ch6_lock;
			check_lock[ch7] = ch7_lock;
			check_lock[ch8] = ch8_lock;
		}
		
		override public function saveStatus():Object 
		{
			var status:Object = new Object();
			
			status.checks = new Object();
			status.campos = new Object();
			status.camposText = new Object();
			
			for (var i:int = 1; i <= 8; i++) 
			{
				status.checks["ch" + i] = this["ch" + i].selected;
				if (i <= 8) {
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
			
			for (var i:int = 1; i <= 8; i++) 
			{
				this["ch" + i].selected = status.checks["ch" + i];
				
				if (i <= 8) {
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
			for (var i:int = 1; i <= 8; i++) 
			{
				this["ch" + i + "_s"].selected = false;
				if(i <= 8){
					campo_check[this["campo" + i]] = [];
					this["campo" + i].text = "";
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
			
			resp[campo1] = ch1;
			resp[campo2] = ch2;
			resp[campo3] = ch3;
			resp[campo4] = ch4;
			resp[campo5] = ch5;
			resp[campo6] = ch6;
			resp[campo7] = ch7;
			resp[campo8] = ch8;
		}
		
		override public function avaliar():int 
		{
			var certas:int = 0;
			
			certas += calculaResp(campo1);
			certas += calculaResp(campo2);
			certas += calculaResp(campo3);
			certas += calculaResp(campo4);
			certas += calculaResp(campo5);
			certas += calculaResp(campo6);
			certas += calculaResp(campo7);
			certas += calculaResp(campo8);
			
			return certas;
		}
		
		private function calculaResp(campo:TextField):int
		{
			var certas:int = 0;
			
			//for (var i:int = 0; i < resp[campo].length; i++) 
			//{
				if (campo_check[campo][0] == resp[campo]) {
					certas++;
					//break;
				}
				
			//}
			
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