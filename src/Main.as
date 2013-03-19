package 
{
	import BaseAssets.BaseMain;
	import BaseAssets.events.BaseEvent;
	import BaseAssets.status.SaveAPI;
	import BaseAssets.tutorial.CaixaTextoNova;
	import BaseAssets.tutorial.Tutorial;
	import flash.display.SimpleButton;
	import flash.filters.ColorMatrixFilter;
	import fl.controls.CheckBox;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Main extends BaseMain
	{
		private var btAval:SimpleButton;
		private var saveAPI:SaveAPI;
		private var pontuacao:Dictionary = new Dictionary();
		private var tentativas:Dictionary = new Dictionary();
		private var finalizada:Dictionary = new Dictionary();
		private var maxPontosTela:Dictionary = new Dictionary();
		private var titulos:Dictionary = new Dictionary();
		private var maxTentativas:int = 3;
		
		public function Main() 
		{
			
		}
		
		override protected function init():void 
		{
			configuraMenuNavegacao();
			iniciaTelas();
			addListeners();
			
			criaTutorial();
			
			saveAPI = new SaveAPI();
			
			var status:Object = saveAPI.recoverStatus();
			
			if (status != null) recoverStatus(status);
			else {
				carregaTela(1);
				iniciaTutorial();
			}
			
		}
		
		private function recoverStatus(status:Object):void 
		{
			if (status.tela1) indiceTela[1].restoreStatus(status.tela1);
			if (status.tela2) indiceTela[2].restoreStatus(status.tela2);
			if (status.tela3) indiceTela[3].restoreStatus(status.tela3);
			
			indiceNavegacao = status.indiceNavegacao;
			
			finalizada[1] = status.finalizada.tela1;
			finalizada[2] = status.finalizada.tela2;
			finalizada[3] = status.finalizada.tela3;
			
			pontuacao[1] = status.pontuacao.tela1;
			pontuacao[2] = status.pontuacao.tela2;
			pontuacao[3] = status.pontuacao.tela3;
			
			tentativas[1] = status.tentativas.tela1;
			tentativas[2] = status.tentativas.tela2;
			tentativas[3] = status.tentativas.tela3;
			
			carregaTela(indiceNavegacao);
		}
		
		private function saveStatus():void
		{
			var status:Object = new Object();
			
			status.tela1 = indiceTela[1].saveStatus();
			status.tela2 = indiceTela[2].saveStatus();
			status.tela3 = indiceTela[3].saveStatus();
			
			status.finalizada = new Object();
			status.pontuacao = new Object();
			status.tentativas = new Object();
			
			status.indiceNavegacao = indiceNavegacao;
			
			status.finalizada.tela1 = finalizada[1];
			status.finalizada.tela2 = finalizada[2];
			status.finalizada.tela3 = finalizada[3];
			
			status.pontuacao.tela1 = pontuacao[1];
			status.pontuacao.tela2 = pontuacao[2];
			status.pontuacao.tela3 = pontuacao[3];
			
			status.tentativas.tela1 = tentativas[1];
			status.tentativas.tela2 = tentativas[2];
			status.tentativas.tela3 = tentativas[3];
			
			saveAPI.saveStatus(status);
		}
		
		private var tutorial:Tutorial;
		private function criaTutorial():void 
		{
			tutorial = new Tutorial();
			tutorial.adicionarBalao("Veja aqui as orientações.", new Point(350, 200), CaixaTextoNova.RIGHT, CaixaTextoNova.CENTER);
			tutorial.adicionarBalao("Veja aqui as orientações.", new Point(400, 150), CaixaTextoNova.RIGHT, CaixaTextoNova.CENTER);
			tutorial.adicionarBalao("Veja aqui as orientações.", new Point(450, 100), CaixaTextoNova.RIGHT, CaixaTextoNova.CENTER);
			tutorial.adicionarBalao("Veja aqui as orientações.", new Point(450, 300), CaixaTextoNova.RIGHT, CaixaTextoNova.CENTER);
		}
		
		private function addListeners():void 
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			btAval = btAvaliar;
			layerAtividade.addChild(btAval);
			btAval.addEventListener(MouseEvent.CLICK, avaliaTela);
		}
		
		private function avaliaTela(e:MouseEvent):void 
		{
			//feedbackScreen.setText("Você acertou " + indiceTela[indiceNavegacao].avaliar() + " itens.");
			if(!finalizada[indiceNavegacao]){
				feedbackScreen.okCancelMode = true;
				var restantes:int = maxTentativas - tentativas[indiceNavegacao] + 1;
				if (restantes == 1) feedbackScreen.setText("Essa é sua última tentativa, tem certeza que deseja realizar a avaliação?");
				else feedbackScreen.setText("Você possui " + restantes + " tentativas, tem certeza que deseja realizar a avaliação?");
				feedbackScreen.addEventListener(BaseEvent.OK_SCREEN, avaliar);
				feedbackScreen.addEventListener(BaseEvent.CANCEL_SCREEN, cancelAval);
			}else {
				feedbackScreen.okCancelMode = false;
				if (pontuacao[indiceNavegacao] == maxPontosTela[indiceNavegacao]) {
					feedbackScreen.setText("Você já acertou o exercício, vá para a próxima tela.");
				}else {
					feedbackScreen.setText("Você não possui mais tentativas nessa tela.");
				}
				
			}
		}
		
		private function cancelAval(e:BaseEvent):void 
		{
			feedbackScreen.removeEventListener(BaseEvent.OK_SCREEN, avaliar);
			feedbackScreen.removeEventListener(BaseEvent.CANCEL_SCREEN, cancelAval);
		}
		
		private function avaliar(e:BaseEvent):void 
		{
			feedbackScreen.removeEventListener(BaseEvent.OK_SCREEN, avaliar);
			feedbackScreen.removeEventListener(BaseEvent.CANCEL_SCREEN, cancelAval);
			feedbackScreen.okCancelMode = false;
			
			pontuacao[indiceNavegacao] = indiceTela[indiceNavegacao].avaliar();
			var feedText:String = "Você fez " + pontuacao[indiceNavegacao] + " pontos (" + Math.round((pontuacao[indiceNavegacao]/maxPontosTela[indiceNavegacao]) * 100) + "%).";
			
			if (pontuacao[indiceNavegacao] == maxPontosTela[indiceNavegacao]) {
				finalizada[indiceNavegacao] = true;
				feedText += "\nAgora que você finalizou essa tela ela não poderá mais ser alterada. Vá para a próxima tela.";
			}else {
				if (tentativas[indiceNavegacao] == 3) {
					finalizada[indiceNavegacao] = true;
					feedText += "\nVocê não possui mais tentativas nessa tela. Vá para a próxima tela.";
				}else {
					tentativas[indiceNavegacao]++;
					var restantes:int = maxTentativas - tentativas[indiceNavegacao] + 1;
					if (restantes == 1) {
						feedText += "\nVocê possui mais " + restantes + " tentativa nessa tela.";
					}else{
						feedText += "\nVocê possui mais " + restantes + " tentativas nessa tela.";
					}
				}
			}
			
			feedbackScreen.setText(feedText);
			carregaTela(indiceNavegacao);
		}
		
		private function keyHandler(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.R) {
				trace("recuperando");
				recoverStatus(saveAPI.recoverStatus());
			}else if (e.keyCode == Keyboard.S) {
				trace("salvando");
				saveStatus();
			}
		}
		
		//Telas:
		private var telas:Vector.<MovieClip> = new Vector.<MovieClip>();
		private var indiceTela:Dictionary = new Dictionary();
		
		private function iniciaTelas():void 
		{
			telas.push(new Tela1());
			telas.push(new Tela2());
			telas.push(new Tela3());
			telas.push(new Tela4());
			
			for each (var item:MovieClip in telas) 
			{
				item.x = navegacao.x;
				item.y = navegacao.y + navegacao.height + 5;
				layerAtividade.addChild(item);
				item.visible = false;
			}
			
			indiceTela[1] = telas[0];
			indiceTela[2] = telas[1];
			indiceTela[3] = telas[2];
			indiceTela[4] = telas[3];
			
			pontuacao[1] = 0;
			pontuacao[2] = 0;
			pontuacao[3] = 0;
			
			maxPontosTela[1] = 5;
			maxPontosTela[2] = 8;
			maxPontosTela[3] = 18;
			
			tentativas[1] = 1;
			tentativas[2] = 1;
			tentativas[3] = 1;
			
			finalizada[1] = false;
			finalizada[2] = false;
			finalizada[3] = false;
			
			titulos[1] = "Associe o nome do grande grupo de plantas ao respectivo quadro";
			titulos[2] = "Associe a característica ou nome que melhor descreve o grande grupo de plantas";
			titulos[3] = "Associe o conjunto de sinapomorfias ao respectivo grande grupo de plantas";
			titulos[4] = "Cladograma completo";
			
			indiceTela[1].addEventListener("checkClicked", checkClicked);
			indiceTela[2].addEventListener("checkClicked", checkClicked);
			indiceTela[3].addEventListener("checkClicked", checkClicked);
			
			//telas[0].visible = true;
			//carregaTela(1);
		}
		
		private function checkClicked(e:Event):void 
		{
			saveStatus();
		}
		
		//Dados navegação:
		private var indiceNavegacao:int = 1;
		private var indiceNavegacaoMin:int = 1;
		private var indiceNavegacaoMax:int = 4;
		
		private function configuraMenuNavegacao():void 
		{
			navegacao.avancar.addEventListener(MouseEvent.CLICK, f_avancar);
			navegacao.voltar.addEventListener(MouseEvent.CLICK, f_voltar);
			TextField(navegacao.info).defaultTextFormat = new TextFormat("Arial", 18, 0x000000, true);
			lock(navegacao.voltar);
			
			layerAtividade.addChild(informacoes);
			layerAtividade.addChild(navegacao);
		}
		
		private function f_avancar(e:MouseEvent):void 
		{
			if (!finalizada[indiceNavegacao]) {
				feedbackScreen.okCancelMode = false;
				feedbackScreen.setText("Você precisa finalizar essa tela antes de prosseguir.");
				return;
			}
			
			if (indiceNavegacao < indiceNavegacaoMax) {
				descarregaTela(indiceNavegacao);
				
				indiceNavegacao++;
				
				carregaTela(indiceNavegacao);
			}
			//unlock(navegacao.voltar);
		}
		
		private function f_voltar(e:MouseEvent):void 
		{
			if (indiceNavegacao > indiceNavegacaoMin) {
				descarregaTela(indiceNavegacao);
				
				indiceNavegacao--;
				
				carregaTela(indiceNavegacao);
			}
			//unlock(navegacao.avancar);
		}
		
		private function descarregaTela(indice:int):void 
		{
			indiceTela[indiceNavegacao].visible = false;
			//saveStatus();
		}
		
		private function carregaTela(indice:int):void 
		{
			navegacao.info.text = "Parte " + indiceNavegacao + " de " + indiceNavegacaoMax;
			indiceTela[indiceNavegacao].visible = true;
			if (indiceNavegacao == 4) {
				informacoes.info.text = titulos[indiceNavegacao];
				informacoes.tentativa.text = "";
				informacoes.pontos.text = "";
				lock(navegacao.avancar);
				unlock(navegacao.voltar);
				btAval.visible = false;
			}else {
				if (finalizada[indiceNavegacao]) {
					indiceTela[indiceNavegacao].mouseChildren = false;
					indiceTela[indiceNavegacao].mouseEnabled = false;
				}
				informacoes.info.text = titulos[indiceNavegacao];
				informacoes.tentativa.text = "Tentativa " + tentativas[indice] + " de " + maxTentativas;
				informacoes.pontos.text = pontuacao[indice] + " pontos";
				if (indiceNavegacao == 1) {
					lock(navegacao.voltar);
					unlock(navegacao.avancar);
				}else {
					unlock(navegacao.voltar);
					unlock(navegacao.avancar);
				}
				btAval.visible = true;
			}
		}
		
		override public function reset(e:MouseEvent = null):void 
		{
			for (var i:int = 0; i < telas.length - 1; i++) 
			{
				if(i <= 2) telas[i].reset();
			}
		}
		
		override public function iniciaTutorial(e:MouseEvent = null):void 
		{
			tutorial.iniciar(stage, true);
		}
		
	}

}