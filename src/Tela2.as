package 
{
	import fl.controls.CheckBox;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
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
		private var campo_check:Dictionary = new Dictionary();
		
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
			lockCheckboxes();
			
			setTimeout(sortPositions, 1);
		}
		
		private var alturaCheck:int = 68;
		private function sortPositions():void 
		{
			var checks:Array = [];
			for (var i:int = 1; i <= 8; i++) 
			{
				checks.push(this["ch" + i + "_s"]);
			}
			
			var dist:int = 15;
			var alturaTotal:Number = dist;
			
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
		
		private var textConfig:TextFormat = new TextFormat("Arial", 14, 0x000000);
		private var textConfigCh5:TextFormat = new TextFormat("Arial", 12, 0x000000);
		
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
				checksUsados.push(check);
				
			}else {
				campo_check[campoSelected][0].selected = false;
				checksUsados.splice(checksUsados.indexOf(campo_check[campoSelected][0]), 1);
				campo_check[campoSelected].splice(0, 1);
			}
			
			
			updateTextField(campoSelected);
			dispatchEvent(new Event("checkClicked"));
		}
		
		
		private function updateTextField(tf:TextField, bordaSelected:Boolean = true):void
		{
			var arrayChecks:Array = campo_check[tf];
			
			if (arrayChecks.length == 0) {
				tf.text = " \n ";
			}else{
				for (var i:int = 0; i < arrayChecks.length; i++) 
				{
					if (arrayChecks[i] == ch5) {
						tf.defaultTextFormat = textConfigCh5;//, 42, 69);
					}else {
						tf.defaultTextFormat = textConfig;
					}
					tf.text = arrayChecks[i].label;
					if (tf.width < 40) {
						tf.text += "\n ";
					}
				}
			}
			
			if (bordaSelected) drawRectangle(tf, campo_fundo[tf], bordaRectSelected);
			else drawRectangle(tf, campo_fundo[tf], bordaRectNormal);
			//drawRectangle(tf, campo_fundo[tf], bordaRectSelected);
		}
		
		
		private function stageClick(e:MouseEvent):void 
		{
			if (campoSelected == null) return;
			if (e.target is TextField) return;
			if (e.target is CheckBox) return;
			if (stage.mouseX < 184) return;
			
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
			ch1.enabled = false;
			ch2.enabled = false;
			ch3.enabled = false;
			ch4.enabled = false;
			ch5.enabled = false;
			ch6.enabled = false;
			ch7.enabled = false;
			ch8.enabled = false;
		}
		
		private function unlockCheckboxes():void 
		{
			ch1.enabled = true;
			ch2.enabled = true;
			ch3.enabled = true;
			ch4.enabled = true;
			ch5.enabled = true;
			ch6.enabled = true;
			ch7.enabled = true;
			ch8.enabled = true;
			
			for each (var item:CheckBox in checksUsados) 
			{
				if (campo_check[campoSelected].indexOf(item) < 0) item.enabled = false;
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
			
			/*campo1.autoSize = TextFieldAutoSize.LEFT;
			campo1.multiline = true;
			campo1.text = " \n ";
			campo2.autoSize = TextFieldAutoSize.LEFT;
			campo2.multiline = true;
			campo2.text = " \n ";
			campo3.autoSize = TextFieldAutoSize.LEFT;
			campo3.multiline = true;
			campo3.text = " \n ";
			campo4.autoSize = TextFieldAutoSize.LEFT;
			campo4.multiline = true;
			campo4.text = " \n ";
			campo5.autoSize = TextFieldAutoSize.LEFT;
			campo5.multiline = true;
			campo5.text = " \n ";
			campo6.autoSize = TextFieldAutoSize.LEFT;
			campo6.multiline = true;
			campo6.text = " \n ";
			campo7.autoSize = TextFieldAutoSize.LEFT;
			campo7.multiline = true;
			campo7.text = " \n ";
			campo8.autoSize = TextFieldAutoSize.LEFT;
			campo8.multiline = true;
			campo8.text = " \n ";*/
			
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
			
		}
		
		override public function saveStatus():Object 
		{
			var status:Object = new Object();
			
			status.x = new Object();
			status.c = new Object();
			//status.camposText = new Object();
			
			for (var i:int = 1; i <= 8; i++) 
			{
				status.x["ch" + i] = this["ch" + i].selected;
				if (i <= 8) {
					if (campo_check[this["campo" + i]].length == 0) {
						status.c["c" + i] = "v";
					}else {
						status.c["c" + i] = "";
						for (var j:int = 0; j < campo_check[this["campo" + i]].length; j++) 
						{
							status.c["c" + i] += (j > 0 ? "," : "") + campo_check[this["campo" + i]][j].name;
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
			
			for (var i:int = 1; i <= 8; i++) 
			{
				this["ch" + i].selected = status.x["ch" + i];
				
				if (i <= 8) {
					if (status.c["c" + i] == "v") {
						campo_check[this["campo" + i]] = [];
					}else {
						var camposCheck:Array = String(status.c["c" + i]).split(",");
						for (var j:int = 0; j < camposCheck.length; j++) {
							var check:CheckBox = this[camposCheck[j]];
							campo_check[this["campo" + i]].push(check);
							checksUsados.push(check);
						}
					}
					
					updateTextField(this["campo" + i], false);
					//this["campo" + i].text = status.camposText["campo" + i];
				}
			}
		}
		
		override public function reset():void 
		{
			for (var i:int = 1; i <= 8; i++) 
			{
				this["ch" + i + "_s"].selected = false;
				this["ch" + i + "_s"].filters = [];
				if(i <= 8){
					campo_check[this["campo" + i]] = [];
					this["campo" + i].text = " \n ";
					drawRectangle(this["campo" + i], campo_fundo[this["campo" + i]], bordaRectNormal);
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
					campo_check[campo][0].filters = [];
					//break;
				}else {
					campo_check[campo][0].filters = [wrongFilter];
				}
				
			//}
			
			return certas;
		}
		
	}
	
}