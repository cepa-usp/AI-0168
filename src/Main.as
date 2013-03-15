package 
{
	import cepa.ai.AI;
	import cepa.ai.AIInstance;
	import cepa.ai.AIObserver;
	import cepa.ai.IPlayInstance;
	import cepa.eval.ProgressiveEvaluator;
	import cepa.tutorial.CaixaTextoNova;
	import cepa.tutorial.Tutorial;
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
	public class Main extends MovieClip implements AIObserver, AIInstance
	{
		private var ai:AI;
		private var layerAtividade:Sprite = new Sprite();
		private var eval:ProgressiveEvaluator;
		private var btAval:SimpleButton;
		
		/*
		 * Filtro de conversão para tons de cinza.
		 */
		protected const GRAYSCALE_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
			0.2225, 0.7169, 0.0606, 0, 0,
			0.2225, 0.7169, 0.0606, 0, 0,
			0.2225, 0.7169, 0.0606, 0, 0,
			0.0000, 0.0000, 0.0000, 1, 0
		]);
		
		protected function lock(bt:*):void
		{
			bt.filters = [GRAYSCALE_FILTER];
			bt.alpha = 0.5;
			bt.mouseEnabled = false;			
		}
		
		protected function unlock(bt:*):void
		{
			bt.filters = [];
			bt.alpha = 1;
			bt.mouseEnabled = true;
		}
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			ai = new AI(this);
			ai.container.messageLabel.visible = false;
			ai.addObserver(this);
			ai.container.optionButtons.addAllButtons();
			ai.container.setMessageTextVisible(false);
			ai.container.setAboutScreen(new AboutScreen168());
			ai.container.setInfoScreen(new InstScreen168());
			
			eval = new ProgressiveEvaluator(ai);
			eval.minimumScoreForAcceptance = .7
			eval.minimumTrialsForParticipScore = 4;
			ai.evaluator = eval;
			
			ai.container.addChild(layerAtividade);
			
			configuraMenuNavegacao();
			iniciaTelas();
			addListeners();
			
			criaTutorial();
			
			ai.initialize();
			
			//onTutorialClick();
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
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			btAval = btAvaliar;
			layerAtividade.addChild(btAval);
			btAval.addEventListener(MouseEvent.CLICK, avaliaTela);
		}
		
		private function avaliaTela(e:MouseEvent):void 
		{
			ai.container.messageBox("Você acertou " + indiceTela[indiceNavegacao].avaliar() + " itens.", null);
		}
		
		private function keyHandler(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.R) {
				
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
			
			telas[0].visible = true;
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
			if (indiceNavegacao < indiceNavegacaoMax) {
				descarregaTela(indiceNavegacao);
				
				indiceNavegacao++;
				navegacao.info.text = "Parte " + indiceNavegacao + " de " + indiceNavegacaoMax;
				if (indiceNavegacao == indiceNavegacaoMax) {
					lock(navegacao.avancar);
					btAval.visible = false;
				}
				
				carregaTela(indiceNavegacao);
			}
			unlock(navegacao.voltar);
		}
		
		private function f_voltar(e:MouseEvent):void 
		{
			if (indiceNavegacao > indiceNavegacaoMin) {
				descarregaTela(indiceNavegacao);
				
				indiceNavegacao--;
				navegacao.info.text = "Parte " + indiceNavegacao + " de " + indiceNavegacaoMax;
				if (indiceNavegacao == indiceNavegacaoMin) lock(navegacao.voltar);
				
				carregaTela(indiceNavegacao);
				btAval.visible = true;
			}
			unlock(navegacao.avancar);
		}
		
		private function descarregaTela(indice:int):void 
		{
			indiceTela[indiceNavegacao].visible = false;
		}
		
		private function carregaTela(indice:int):void 
		{
			indiceTela[indiceNavegacao].visible = true;
		}
		
		/*override */public function reset(e:MouseEvent = null):void 
		{
			for (var i:int = 0; i < telas.length - 1; i++) 
			{
				telas[i].reset();
			}
		}
		
		/* INTERFACE cepa.ai.AIObserver */
		
		public function onResetClick():void 
		{
			reset(null);
		}
		
		public function onScormFetch():void 
		{
			
		}
		
		public function onScormSave():void 
		{
			
		}
		
		public function onStatsClick():void 
		{
			
		}
		
		public function onTutorialClick():void 
		{
			tutorial.iniciar(stage, true);
		}
		
		public function onScormConnected():void 
		{
			
		}
		
		public function onScormConnectionError():void 
		{
			
		}
		
		/* INTERFACE cepa.ai.AIInstance */
		
		public function getData():Object 
		{
			return new Object();
		}
		
		public function readData(obj:Object)
		{
			
		}
		
		public function createNewPlayInstance():IPlayInstance 
		{
			return new PlayInstance168();
		}
		
	}

}