package 
{
	import fl.controls.CheckBox;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
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
		private var campo_check:Dictionary = new Dictionary();
		
		private var textUp:Array;
		private var textUpInicial:Dictionary = new Dictionary();
		
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
			criaResposta();
			
			textUp = [campo1, campo3];
			textUpInicial[campo1] = new Point(campo1.y, campo1.height);
			textUpInicial[campo3] = new Point(campo3.y, campo3.height);
			
			setTimeout(sortPositions, 1);
		}
		
		private var alturaCheck:int = 70;
		private function sortPositions():void 
		{
			var checks:Array = [];
			for (var i:int = 1; i <= 5; i++) 
			{
				checks.push(this["ch" + i]);
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
					if (i == 0) tf.text = arrayChecks[i].label;
					else tf.text += "\nou " + arrayChecks[i].label;
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
		}
		
		private function unlockCheckboxes():void 
		{
			ch1.enabled = true;
			ch2.enabled = true;
			ch3.enabled = true;
			ch4.enabled = true;
			ch5.enabled = true;
			
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
			
		}
		
		override public function saveStatus():Object 
		{
			var status:Object = new Object();
			
			status.x = new Object();
			status.c = new Object();
			//status.camposText = new Object();
			
			for (var i:int = 1; i <= 5; i++) 
			{
				status.x["ch" + i] = this["ch" + i].selected;
				if (i <= 3) {
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
			
			for (var i:int = 1; i <= 5; i++) 
			{
				this["ch" + i].selected = status.x["ch" + i];
				
				if (i <= 3) {
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
			for (var i:int = 1; i <= 5; i++) 
			{
				this["ch" + i].selected = false;
				this["ch" + i].filters = [];
				if(i <= 3){
					campo_check[this["campo" + i]] = [];
					this["campo" + i].text = " ";
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