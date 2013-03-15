package 
{
	import fl.controls.CheckBox;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
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
		private var textUp:Array;
		private var textUpInicial:Dictionary = new Dictionary();
		
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
			criaResposta();
			addListenerBarras();
			
			textUp = [campo1_s, campo3_s, campo6_s, campo8_s];
			textUpInicial[campo1_s] = new Point(campo1_s.y, campo1_s.height);
			textUpInicial[campo3_s] = new Point(campo3_s.y, campo3_s.height);
			textUpInicial[campo6_s] = new Point(campo6_s.y, campo6_s.height);
			textUpInicial[campo8_s] = new Point(campo8_s.y, campo8_s.height);
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
				status.checks["ch" + i] = this["ch" + i + "_s"].selected;
				if (i <= 8) {
					if (campo_check[this["campo" + i + "_s"]].length == 0) {
						status.campos["campo" + i] = "vazio";
					}else {
						status.campos["campo" + i] = "";
						for (var j:int = 0; j < campo_check[this["campo" + i + "_s"]].length; j++) 
						{
							status.campos["campo" + i] += (j > 0 ? "," : "") + campo_check[this["campo" + i + "_s"]][j].name;
						}
					}
					status.camposText["campo" + i] = this["campo" + i + "_s"].text;
				}
			}
			
			return status;
		}
		
		override public function restoreStatus(status:Object):void 
		{
			checksUsados = new Vector.<CheckBox>();
			
			for (var i:int = 1; i <= 18; i++) 
			{
				this["ch" + i + "_s"].selected = status.checks["ch" + i];
				
				if (i <= 8) {
					if (status.campos["campo" + i] == "vazio") {
						campo_check[this["campo" + i + "_s"]] = [];
					}else {
						var camposCheck:Array = String(status.campos["campo" + i]).split(",");
						for (var j:int = 0; j < camposCheck.length; j++) {
							var check:CheckBox = this[camposCheck[j]];
							campo_check[this["campo" + i + "_s"]].push(check);
							checksUsados.push(check);
						}
					}
					
					this["campo" + i + "_s"].text = status.camposText["campo" + i];
				}
			}
		}
		
		override public function reset():void 
		{
			for (var i:int = 1; i <= 18; i++) 
			{
				this["ch" + i + "_s"].selected = false;
				if(i <= 8){
					campo_check[this["campo" + i + "_s"]] = [];
					this["campo" + i + "_s"].text = "";
					drawRectangle(this["campo" + i + "_s"], campo_fundo[this["campo" + i + "_s"]], bordaRectNormal);
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
			
			resp[campo1] = [ch1];
			resp[campo2] = [ch3];
			resp[campo3] = [ch4, ch10, ch13, ch12, ch6];
			resp[campo4] = [ch2, ch16];
			resp[campo5] = [ch5, ch14];
			resp[campo6] = [ch17, ch9, ch11, ch12, ch6];
			resp[campo7] = [ch7, ch8, ch15];
			resp[campo8] = [ch18];
		}
		
		override public function avaliar():int 
		{
			var certas:int = 0;
			
			certas += calculaResp(campo1_s);
			certas += calculaResp(campo2_s);
			certas += calculaResp(campo3_s);
			certas += calculaResp(campo4_s);
			certas += calculaResp(campo5_s);
			certas += calculaResp(campo6_s);
			certas += calculaResp(campo7_s);
			certas += calculaResp(campo8_s);
			
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