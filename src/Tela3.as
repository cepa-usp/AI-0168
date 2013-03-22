package 
{
	import fl.controls.CheckBox;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
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
		private var campo_check:Dictionary = new Dictionary();
		
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
			lockCheckboxes();
			
			textUp = [campo1_s, campo3_s, campo6_s, campo8_s];
			textUpInicial[campo1_s] = new Point(campo1_s.y, campo1_s.height);
			textUpInicial[campo3_s] = new Point(campo3_s.y, campo3_s.height);
			textUpInicial[campo6_s] = new Point(campo6_s.y, campo6_s.height);
			textUpInicial[campo8_s] = new Point(campo8_s.y, campo8_s.height);
			
			setTimeout(sortPositions, 1);
		}
		
		private var alturaCheck:int = 68;
		private function sortPositions():void 
		{
			var checks:Array = [];
			for (var i:int = 1; i <= 18; i++) 
			{
				checks.push(this["ch" + i + "_s"]);
			}
			
			var dist:int = -3;
			var alturaTotal:Number = -1;
			
			while (checks.length > 0) {
				var index:int = Math.floor(Math.random() * checks.length);
				var ch:CheckBox = checks.splice(index, 1)[0];
				//trace(ch.getRect(ch.parent).height);
				var bounds:Rectangle = ch.getBounds(ch.parent);
				//trace(bounds.height);
				var diff:Number = Math.abs(ch.y - bounds.topLeft.y);
				
				ch.y = alturaTotal + diff;
				alturaTotal += bounds.height + dist;
			}
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
			}else {
				var indexCheck:int = campo_check[campoSelected].indexOf(check);
				campo_check[campoSelected].splice(indexCheck, 1);
				checksUsados.splice(checksUsados.indexOf(check), 1);
			}
			
			updateTextField(campoSelected);
			dispatchEvent(new Event("checkClicked"));
		}
		
		private function updateTextField(tf:TextField, bordaSelected:Boolean = true):void
		{
			var arrayChecks:Array = campo_check[tf];
			if (arrayChecks.length == 0) {
				tf.text = " ";
			}else{
				for (var i:int = 0; i < arrayChecks.length; i++) 
				{
					if (i == 0) tf.text = "• " + arrayChecks[i].label;
					else tf.text += "\n• " + arrayChecks[i].label;
				}
			}
			
			if (textUp.indexOf(tf) >= 0) {
				var ptInicial:Point = textUpInicial[tf];
				tf.y = ptInicial.x - (tf.height - ptInicial.y);
			}
			
			if (bordaSelected) drawRectangle(tf, campo_fundo[tf], bordaRectSelected);
			else drawRectangle(tf, campo_fundo[tf], bordaRectNormal);
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
				ch.enabled = false;
			}
		}
		
		private function unlockCheckboxes():void 
		{
			for (var i:int = 1; i <= 18; i++) 
			{
				var ch:CheckBox = this["ch" + i + "_s"];
				ch.enabled = true;
			}
			
			for each (var item:CheckBox in checksUsados) 
			{
				if(campo_check[campoSelected].indexOf(item) < 0) item.enabled = false;
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
			
			status.x = new Object();
			status.c = new Object();
			//status.camposText = new Object();
			
			for (var i:int = 1; i <= 18; i++) 
			{
				status.x["ch" + i] = this["ch" + i + "_s"].selected;
				if (i <= 8) {
					if (campo_check[this["campo" + i + "_s"]].length == 0) {
						status.c["c" + i] = "v";
					}else {
						status.c["c" + i] = "";
						for (var j:int = 0; j < campo_check[this["campo" + i + "_s"]].length; j++) 
						{
							status.c["c" + i] += (j > 0 ? "," : "") + campo_check[this["campo" + i + "_s"]][j].name;
						}
					}
					//status.camposText["campo" + i] = this["campo" + i].text;
				}
			}
			
			return status;
		}
		
		override public function restoreStatus(status:Object):void 
		{
			checksUsados = new Vector.<CheckBox>();
			
			for (var i:int = 1; i <= 18; i++) 
			{
				this["ch" + i].selected = status.x["ch" + i + "_s"];
				
				if (i <= 8) {
					if (status.c["c" + i] == "v") {
						campo_check[this["campo" + i + "_s"]] = [];
					}else {
						var camposCheck:Array = String(status.c["c" + i]).split(",");
						for (var j:int = 0; j < camposCheck.length; j++) {
							var check:CheckBox = this[camposCheck[j]];
							campo_check[this["campo" + i + "_s"]].push(check);
							checksUsados.push(check);
						}
					}
					
					updateTextField(this["campo" + i + "_s"], false);
					//this["campo" + i].text = status.camposText["campo" + i];
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
					this["campo" + i + "_s"].text = " ";
					drawRectangle(this["campo" + i + "_s"], campo_fundo[this["campo" + i + "_s"]], bordaRectNormal);
				}
			}
			
			//if (campoSelected != null) {
				//drawRectangle(campoSelected, campo_fundo[campoSelected], bordaRectNormal);
				//campoSelected = null;
				//stage.focus = null;
			//}
			
			campoSelected = null;
			stage.focus = null;
			
			checksUsados = new Vector.<CheckBox>();
		}
		
		private var resp:Dictionary;
		public function criaResposta():void
		{
			resp = new Dictionary();
			
			resp[campo1_s] = [ch1];
			resp[campo2_s] = [ch3];
			resp[campo3_s] = [ch4, ch10, ch13, ch12, ch6];
			resp[campo4_s] = [ch2, ch16];
			resp[campo5_s] = [ch5, ch14];
			resp[campo6_s] = [ch17, ch9, ch11, ch12, ch6];
			resp[campo7_s] = [ch7, ch8, ch15];
			resp[campo8_s] = [ch18];
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
			var achou:Boolean;
			
			for each (var selecionado:CheckBox in campo_check[campo]) 
			{
				achou = false;
				for each (var resposta:CheckBox in resp[campo]) 
				{
					if (selecionado == resposta) {
						certas++;
						achou = true;
						break;
					}
				}
				if (achou) {
					selecionado.filters = [];
				}else {
					selecionado.filters = [wrongFilter];
				}
			}
			
			return certas;
		}
		
	}
	
}