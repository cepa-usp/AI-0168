package 
{
	import BaseAssets.BaseMain;
	import BaseAssets.events.BaseEvent;
	import BaseAssets.tutorial.CaixaTexto;
	//import com.adobe.serialization.json.JSON;
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
		
		public function Main() 
		{
			
		}
		
		override protected function init():void 
		{
			configuraMenuNavegacao();
			iniciaTelas();
			addListeners();
			
			//iniciaTutorial();
		}
		
		private function addListeners():void 
		{
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
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
				if (indiceNavegacao == indiceNavegacaoMax) lock(navegacao.avancar);
				
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
		
		override public function reset(e:MouseEvent = null):void 
		{
			for (var i:int = 0; i < telas.length - 1; i++) 
			{
				telas[i].reset();
			}
		}
		
		//---------------- Tutorial -----------------------
		
		private var balao:CaixaTexto;
		private var pointsTuto:Array;
		private var tutoBaloonPos:Array;
		private var tutoPos:int;
		private var tutoSequence:Array;
		
		override public function iniciaTutorial(e:MouseEvent = null):void  
		{
			blockAI();
			
			tutoPos = 0;
			if(balao == null){
				balao = new CaixaTexto();
				layerTuto.addChild(balao);
				balao.visible = false;
				
				tutoSequence = ["Veja aqui as orientações.",
								"Esta é uma função polinomial do segundo grau escolhida aleatoriamente.",
								"Arraste este ponto para a posição do vértice da função (arraste-o de volta para a tabela ou pressione 'delete' para removê-lo do plano cartesiano).",
								"Arraste estes pontos para as posições das raízes (se houver).",
								"Indique a concavidade da curva.",
								"Indique se o vértice é um máximo ou um mínimo da função.",
								"Pressione este botão para verificar sua resposta.",
								"Pressione este botão para criar um novo exercício."];
				
				pointsTuto = 	[new Point(650, 535),
								new Point(560 , 20),
								new Point(420 , 486),
								new Point(550 , 486),
								new Point(275 , 508),
								new Point(275 , 556),
								new Point(452 , 565),
								new Point(575 , 565)];
								
				tutoBaloonPos = [[CaixaTexto.RIGHT, CaixaTexto.LAST],
								[CaixaTexto.TOP, CaixaTexto.LAST],
								[CaixaTexto.BOTTON, CaixaTexto.CENTER],
								[CaixaTexto.BOTTON, CaixaTexto.LAST],
								[CaixaTexto.LEFT, CaixaTexto.LAST],
								[CaixaTexto.LEFT, CaixaTexto.LAST],
								[CaixaTexto.BOTTON, CaixaTexto.CENTER],
								[CaixaTexto.BOTTON, CaixaTexto.LAST]];
			}
			balao.removeEventListener(BaseEvent.NEXT_BALAO, closeBalao);
			
			balao.setText(tutoSequence[tutoPos], tutoBaloonPos[tutoPos][0], tutoBaloonPos[tutoPos][1]);
			balao.setPosition(pointsTuto[tutoPos].x, pointsTuto[tutoPos].y);
			balao.addEventListener(BaseEvent.NEXT_BALAO, closeBalao);
			balao.addEventListener(BaseEvent.CLOSE_BALAO, iniciaAi);
		}
		
		private function closeBalao(e:Event):void 
		{
			tutoPos++;
			if (tutoPos >= tutoSequence.length) {
				balao.removeEventListener(BaseEvent.NEXT_BALAO, closeBalao);
				balao.visible = false;
				iniciaAi(null);
			}else {
				balao.setText(tutoSequence[tutoPos], tutoBaloonPos[tutoPos][0], tutoBaloonPos[tutoPos][1]);
				balao.setPosition(pointsTuto[tutoPos].x, pointsTuto[tutoPos].y);
			}
		}
		
		private function iniciaAi(e:BaseEvent):void 
		{
			balao.removeEventListener(BaseEvent.CLOSE_BALAO, iniciaAi);
			balao.removeEventListener(BaseEvent.NEXT_BALAO, closeBalao);
			unblockAI();
		}
		
	}

}