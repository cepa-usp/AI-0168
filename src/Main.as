package 
{
	import BaseAssets.BaseMain;
	import BaseAssets.events.BaseEvent;
	import BaseAssets.status.SaveAPI;
	import BaseAssets.tutorial.CaixaTextoNova;
	import BaseAssets.tutorial.Tutorial;
	import BaseAssets.tutorial.TutorialEvent;
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
		private var pesoTela:Dictionary = new Dictionary();
		private var maxTentativas:int = 3;
		private var tutorialCompleted:Boolean = false;
		
		public function Main() 
		{
			
		}
		
		override protected function init():void 
		{
			configuraMenuNavegacao();
			iniciaTelas();
			addListeners();
			addListenerBarras();
			
			criaTutorial();
			
			saveAPI = new SaveAPI();
			
			var status:Object = saveAPI.recoverStatus();
			
			if (status != null) {
				recoverStatus(status);
			}
			else {
				carregaTela(1);
			}
			
			if(!tutorialCompleted) iniciaTutorial();
			
			//stage.addEventListener(MouseEvent.CLICK, showPosition);
		}
		
		private function showPosition(e:MouseEvent):void 
		{
			trace(stage.mouseX, stage.mouseY);
		}
		
		private var barra_ret:Dictionary = new Dictionary();
		public function addListenerBarras():void
		{
			ret1.visible = false;
			ret2.visible = false;
			ret3.visible = false;
			ret4.visible = false;
			ret5.visible = false;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, verifyPosition);
			
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
		
		private function verifyPosition(e:MouseEvent):void 
		{
			for (var i:int = 1; i <= 5; i++) 
			{
				if (MovieClip(this["barra" + i]).hitTestPoint(stage.mouseX, stage.mouseY)) {
					barra_ret[this["barra" + i]].visible = true;
				}else {
					barra_ret[this["barra" + i]].visible = false;
				}
			}
		}
		
		private function recoverStatus(status:Object):void 
		{
			if (status.a) indiceTela[1].restoreStatus(status.a);
			if (status.b) indiceTela[2].restoreStatus(status.b);
			if (status.c) indiceTela[3].restoreStatus(status.c);
			
			tutorialCompleted = status.tc1;
			tutoAvancarOk = status.tc1a;
			tuto2Completed = status.tc2;
			tuto3Completed = status.tc3;
			
			indiceNavegacao = status.i;
			
			finalizada[1] = status.f.a;
			finalizada[2] = status.f.b;
			finalizada[3] = status.f.c;
			
			if (finalizada[1]) indiceTela[1].avaliar();
			if (finalizada[2]) indiceTela[2].avaliar();
			if (finalizada[3]) indiceTela[3].avaliar();
			
			pontuacao[1] = status.p.a;
			pontuacao[2] = status.p.b;
			pontuacao[3] = status.p.c;
			
			tentativas[1] = status.t.a;
			tentativas[2] = status.t.b;
			tentativas[3] = status.t.c;
			
			carregaTela(indiceNavegacao);
		}
		
		private function saveStatus():void
		{
			var status:Object = new Object();
			
			status.tc1 = tutorialCompleted;
			status.tc1a = tutoAvancarOk;
			status.tc2 = tuto2Completed;
			status.tc3 = tuto3Completed;
			
			status.a = indiceTela[1].saveStatus();
			status.b = indiceTela[2].saveStatus();
			status.c = indiceTela[3].saveStatus();
			
			status.f = new Object();
			status.p = new Object();
			status.t = new Object();
			
			status.i = indiceNavegacao;
			
			status.f.a = finalizada[1];
			status.f.b = finalizada[2];
			status.f.c = finalizada[3];
			
			status.p.a = pontuacao[1];
			status.p.b = pontuacao[2];
			status.p.c = pontuacao[3];
			
			status.t.a = tentativas[1];
			status.t.b = tentativas[2];
			status.t.c = tentativas[3];
			
			saveAPI.saveStatus(status);
		}
		
		private var tutorial:Tutorial;
		private var tutorialAvancar:Tutorial;
		private var tutorialParte2:Tutorial;
		private var tutorialParte3:Tutorial;
		private function criaTutorial():void 
		{
			tutorial = new Tutorial();
			
			tutorial.adicionarBalao("Veja aqui as orientações sobre esta atividade interativa.", new Point(745, 632), CaixaTextoNova.RIGHT, CaixaTextoNova.LAST);
			tutorial.adicionarBalao("Seu objetivo nesta atividade é completar o cladograma.", new Point(417, 226), CaixaTextoNova.BOTTOM, CaixaTextoNova.CENTER);
			tutorial.adicionarBalao("Faremos isso em quatro passos sequenciais.", new Point(94, 33), CaixaTextoNova.TOP, CaixaTextoNova.FIRST);
			tutorial.adicionarBalao("Leia aqui o enunciado de cada um dos passos.", new Point(361, 30), CaixaTextoNova.TOP, CaixaTextoNova.CENTER);
			tutorial.adicionarBalao("Para preencher este campo, por exemplo, clique nele...", new Point(245, 411), CaixaTextoNova.BOTTOM, CaixaTextoNova.CENTER);
			tutorial.adicionarBalao("… e escolha o(s) item(ns) que deve(m) ser associado(s) a ele.", new Point(173, 162), CaixaTextoNova.LEFT, CaixaTextoNova.CENTER);
			tutorial.adicionarBalao("Repita este processo para todos os campos, até utilizar todos os itens da lista.", new Point(248, 499), CaixaTextoNova.BOTTOM, CaixaTextoNova.CENTER);
			tutorial.adicionarBalao("Quando tiver terminado, pressione este botão para verificar sua resposta.", new Point(95, 653), CaixaTextoNova.BOTTOM, CaixaTextoNova.FIRST);
			tutorial.adicionarBalao("Os itens incorretos serão descados em vermelho (os itens corretos permanecerão em preto).", new Point(177, 117), CaixaTextoNova.LEFT, CaixaTextoNova.CENTER);
			tutorial.adicionarBalao("Em cada passo você tem três tentativas. Use-as para aprimorar seu desempenho.", new Point(683, 33), CaixaTextoNova.TOP, CaixaTextoNova.LAST);
			tutorial.adicionarBalao("Sua pontuação é igual ao número de itens que você acertou.", new Point(750, 33), CaixaTextoNova.TOP, CaixaTextoNova.LAST);
			tutorial.adicionarBalao("Quando você tiver acertado todos os itens ou encerrado o número de tentativas, pressione este botão para avançar.", new Point(163, 30), CaixaTextoNova.TOP, CaixaTextoNova.FIRST);
			
			tutorialAvancar = new Tutorial();
			tutorialAvancar.adicionarBalao("No modo de revisão você não pode alterar o cladograma.", new Point(682, 36), CaixaTextoNova.TOP, CaixaTextoNova.LAST);
			tutorialAvancar.adicionarBalao("Clique aqui para prosseguir.", new Point(164, 27), CaixaTextoNova.TOP, CaixaTextoNova.FIRST);
			
			tutorialParte2 = new Tutorial();
			tutorialParte2.adicionarBalao("No segundo passo da atividade, cada campo pode conter apenas um item da lista à esquerda.", new Point(462, 216), CaixaTextoNova.TOP, CaixaTextoNova.CENTER);
			
			tutorialParte3 = new Tutorial();
			tutorialParte3.adicionarBalao("No terceiro passo da atividade, cada campo pode conter mais de um item da lista à esquerda.", new Point(455, 432), CaixaTextoNova.BOTTOM, CaixaTextoNova.CENTER);
		}
		
		private function addListeners():void 
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			btAval = btAvaliar;
			layerAtividade.addChild(btAval);
			btAval.addEventListener(MouseEvent.CLICK, avaliaTela);
		}
		
		private var mudou:Boolean = true;
		private function avaliaTela(e:MouseEvent):void 
		{
			//feedbackScreen.setText("Você acertou " + indiceTela[indiceNavegacao].avaliar() + " itens.");
			if (!mudou) {
				feedbackScreen.okCancelMode = false;
				feedbackScreen.setText("Não houve alteração desde a tentativa anterior, que por sua vez indicou haver erros no cladograma. Procure corrigí-los antes de reavaliar.");
			}else{
				if (indiceTela[indiceNavegacao].checksUsados.length < maxPontosTela[indiceNavegacao]) {
					feedbackScreen.okCancelMode = false;
					feedbackScreen.setText("Todos os itens à esquerda devem ser inseridos no cladograma antes de avaliar.");
				}else{
					if(!finalizada[indiceNavegacao]){
						feedbackScreen.okCancelMode = true;
						feedbackScreen.setText("Confirma a avaliação do cladograma?");
						feedbackScreen.addEventListener(BaseEvent.OK_SCREEN, avaliar);
						feedbackScreen.addEventListener(BaseEvent.CANCEL_SCREEN, cancelAval);
					}else {
						feedbackScreen.okCancelMode = false;
						if (pontuacao[indiceNavegacao] == maxPontosTela[indiceNavegacao]) {
							feedbackScreen.setText("Você já acertou o exercício, vá para a próxima tela.");
						}else {
							feedbackScreen.setText("Você não possui mais tentativas nessa tela.");
						}
						feedbackScreen.addEventListener(BaseEvent.OK_SCREEN, okScreenTuto);
					}
				}
			}
		}
		
		private function cancelAval(e:BaseEvent):void 
		{
			feedbackScreen.removeEventListener(BaseEvent.OK_SCREEN, avaliar);
			feedbackScreen.removeEventListener(BaseEvent.CANCEL_SCREEN, cancelAval);
		}
		
		private var tutoAvancarOk:Boolean = false;
		private function avaliar(e:BaseEvent):void 
		{
			feedbackScreen.removeEventListener(BaseEvent.OK_SCREEN, avaliar);
			feedbackScreen.removeEventListener(BaseEvent.CANCEL_SCREEN, cancelAval);
			feedbackScreen.okCancelMode = false;
			
			pontuacao[indiceNavegacao] = indiceTela[indiceNavegacao].avaliar();
			
			var feedText:String;
			var needTuto:Boolean = false;
			if (pontuacao[indiceNavegacao] == maxPontosTela[indiceNavegacao]) {
				finalizada[indiceNavegacao] = true;
				feedText = "Parabéns! Você acertou todos os itens deste passo. Prossiga para o próximo passo da atividade.";
				needTuto = true;
			}else {
				feedText = "Você acertou " + pontuacao[indiceNavegacao] + " dos " + maxPontosTela[indiceNavegacao] + " itens existentes.";
				if (tentativas[indiceNavegacao] == 3) {
					finalizada[indiceNavegacao] = true;
					feedText += "\nOs itens incorretos foram destacados em vermelho e não há mais tentativas neste passo para corrigí-los. Veja as respostas certas no próximo passo.";
					needTuto = true;
				}else {
					mudou = false;
					tentativas[indiceNavegacao]++;
					var restantes:int = maxTentativas - tentativas[indiceNavegacao] + 1;
					if (restantes == 1) {
						feedText += "\nOs itens incorretos foram indicados no cladograma. Use essas informações para corrigí-lo e faça uma nova avaliação (você ainda tem " + restantes + " tentativa neste passo).";
					}else{
						feedText += "\nOs itens incorretos foram indicados no cladograma. Use essas informações para corrigí-lo e faça uma nova avaliação (você ainda tem " + restantes + " tentativas neste passo).";
					}
				}
			}
			
			saveAPI.score = Math.round((pontuacao[1] / maxPontosTela[1] * 100) * pesoTela[1] + (pontuacao[2] / maxPontosTela[2] * 100) * pesoTela[2] + (pontuacao[3] / maxPontosTela[3] * 100) * pesoTela[3])
			
			feedbackScreen.setText(feedText);
			if (needTuto) {
				if (!tutoAvancarOk) {
					feedbackScreen.addEventListener(BaseEvent.OK_SCREEN, okScreenTuto);
					tutoAvancarOk = true;
				}
			}
			carregaTela(indiceNavegacao);
			saveStatus();
		}
		
		private function okScreenTuto(e:Event):void
		{
			feedbackScreen.removeEventListener(BaseEvent.OK_SCREEN, okScreenTuto);
			tutorialAvancar.iniciar(stage, true);
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
			
			pesoTela[1] = 1/3;
			pesoTela[2] = 1/3;
			pesoTela[3] = 1/3;
			
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
			mudou = true;
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
				if (tentativas[indiceNavegacao] == 1) {
					feedbackScreen.okCancelMode = false;
					feedbackScreen.setText("Você precisa finalizar esse passo antes de prosseguir.");
				}else{
					feedbackScreen.okCancelMode = true;
					feedbackScreen.addEventListener(BaseEvent.OK_SCREEN, avanca);
					feedbackScreen.addEventListener(BaseEvent.CANCEL_SCREEN, naoAvanca);
					var restantes:int = maxTentativas - tentativas[indiceNavegacao] + 1;
					feedbackScreen.setText("Atenção: você ainda tem " + restantes + (restantes == 1 ? " tentativa" : " tentativas") + " para aprimorar seu desempenho neste passo da atividade. Se você optar por avançar para o próximo passo agora, não será possível melhorar seu resultado depois. Você realmente deseja prosseguir?");
				}
			}else{
				if (indiceNavegacao < indiceNavegacaoMax) {
					descarregaTela(indiceNavegacao);
					
					indiceNavegacao++;
					
					carregaTela(indiceNavegacao);
				}
				//unlock(navegacao.voltar);
			}
		}
		
		private function avanca(e:BaseEvent):void 
		{
			feedbackScreen.removeEventListener(BaseEvent.OK_SCREEN, avanca);
			feedbackScreen.removeEventListener(BaseEvent.CANCEL_SCREEN, naoAvanca);
			finalizada[indiceNavegacao] = true;
			descarregaTela(indiceNavegacao);
			indiceNavegacao++;
			carregaTela(indiceNavegacao);
		}
		
		private function naoAvanca(e:BaseEvent):void 
		{
			feedbackScreen.removeEventListener(BaseEvent.OK_SCREEN, avanca);
			feedbackScreen.removeEventListener(BaseEvent.CANCEL_SCREEN, naoAvanca);
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
		
		private var textFormatRevisao:TextFormat = new TextFormat();
		private var textFormatNormal:TextFormat = new TextFormat();
		private var tuto2Completed:Boolean = false;
		private var tuto3Completed:Boolean = false;
		private function carregaTela(indice:int):void 
		{
			navegacao.info.text = "Passo " + indiceNavegacao + " de " + indiceNavegacaoMax;
			indiceTela[indiceNavegacao].visible = true;
			if (indiceNavegacao == 4) {
				informacoes.info.text = titulos[indiceNavegacao];
				informacoes.tentativa.text = "";
				informacoes.pontos.text = "";
				informacoes.fundoPonto.visible = false;
				lock(navegacao.avancar);
				unlock(navegacao.voltar);
				btAval.visible = false;
			}else {
				informacoes.fundoPonto.visible = true;
				if (finalizada[indiceNavegacao]) {
					indiceTela[indiceNavegacao].mouseChildren = false;
					indiceTela[indiceNavegacao].mouseEnabled = false;
					textFormatRevisao.color = 0x800000;
					informacoes.tentativa.defaultTextFormat = textFormatRevisao;
					informacoes.tentativa.text = "Modo de\nrevisão";
				}else {
					indiceTela[indiceNavegacao].mouseChildren = true;
					indiceTela[indiceNavegacao].mouseEnabled = true;
					textFormatNormal.color = 0x000000;
					informacoes.tentativa.defaultTextFormat = textFormatNormal;
					informacoes.tentativa.text = "Tentativa:\n" + tentativas[indice] + " de " + maxTentativas;
					
					if (indice == 2) {
						if (!tuto2Completed) {
							tutorialParte2.iniciar(stage, true);
							tuto2Completed = true;
							saveStatus();
						}
					}
					if (indice == 3) {
						if(!tuto3Completed){
							tutorialParte3.iniciar(stage, true);
							tuto3Completed = true;
							saveStatus();
						}
					}
				}
				informacoes.info.text = titulos[indiceNavegacao];
				informacoes.pontos.text = "Pontos:\n" + pontuacao[indice] + " de " + maxPontosTela[indice];
				if (indiceNavegacao == 1) {
					lock(navegacao.voltar);
					unlock(navegacao.avancar);
				}else {
					unlock(navegacao.voltar);
					unlock(navegacao.avancar);
				}
				btAval.visible = true;
			}
			
			saveStatus();
		}
		
		override public function reset(e:MouseEvent = null):void 
		{
			for (var i:int = 0; i < telas.length - 1; i++) 
			{
				if(i <= 2) telas[i].reset();
			}
			
			descarregaTela(indiceNavegacao);
			indiceNavegacao = 1;
			
			pontuacao[1] = 0;
			pontuacao[2] = 0;
			pontuacao[3] = 0;
			
			tentativas[1] = 1;
			tentativas[2] = 1;
			tentativas[3] = 1;
			
			finalizada[1] = false;
			finalizada[2] = false;
			finalizada[3] = false;
			
			carregaTela(indiceNavegacao);
		}
		
		override public function iniciaTutorial(e:MouseEvent = null):void 
		{
			tutorial.removeEventListener(TutorialEvent.FIM_TUTORIAL, tutorialFinalizado);
			tutorial.iniciar(stage, true);
			tutorial.addEventListener(TutorialEvent.FIM_TUTORIAL, tutorialFinalizado);
		}
		
		private function tutorialFinalizado(e:TutorialEvent):void 
		{
			tutorial.removeEventListener(TutorialEvent.FIM_TUTORIAL, tutorialFinalizado);
			if (e.last) tutorialCompleted = true;
			saveStatus();
		}
		
	}

}