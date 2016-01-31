package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import com.greensock.TweenMax;
	
	
	public class Main extends MovieClip {
		
		private const YOUR_SITE:String = "http://activeden.net/user/duquekarl?ref=duquekarl";
		
		private const TIME_WALK:Number = 0.1;
		private const TIME_PUSH:Number = 0.5;
		private var TIME_MOV:Number = 0.5;
		
		private const g:int = 1;	// grass
		private const T:int = 16;	// Tree (block)
		private const P:int = 32;	// Player
		private const L:int = 64;   // Light (goal position)
		private const I:int = 128;	// Idol (box)
		private const LI:int = L+I;
		private const LP:int = L+P;
		
		private const ROWS:int = 10;
		private const COLS:int = 10;
		private const TILE_W:int = 50;
		private const TILE_H:int = 41;
		
		private const LEVELS:Array = [
			// Level 1
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, T, T, T, T, 0, 0, 0,
			 0, 0, T, g, g, g, g, T, 0, 0,
			 0, 0, T, g, g, L, g, T, 0, 0,
			 0, 0, T, g, I, P, g, T, 0, 0,
			 0, 0, T, g, T, g, g, T, 0, 0,
			 0, 0, 0, T, T, T, T, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 
			// Level 2
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, T, T, T, T, T, T, T, 0,
			 0, 0, T, g, g, g, g, g, T, 0,
			 0, 0, T, g, L, I, T, g, T, 0,
			 0, 0, T, g,LI,LI, P, g, T, 0,
			 0, 0, T, g, g, g, g, g, T, 0,
			 0, 0, T, T, T, T, T, T, T, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 
			 // Level 3
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, T, T, T, T, T, T, T, T, 0,
			 0, T, g, g, g, g, g, g, T, 0,
			 0, T, g, L,LI,LI, I, P, T, 0,
			 0, T, g, g, g, g, g, g, T, 0,
			 0, T, T, T, T, T, g, g, T, 0,
			 0, 0, 0, 0, 0, T, T, T, T, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 
			 // Level 4
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, T, T, T, T, T, T, T, 0,
			 0, 0, T, g, g, g, g, g, T, 0,
			 0, 0, T, g, L, I, L, g, T, 0,
			 0, T, T, g, I, P, I, g, T, 0,
			 0, T, g, g, L, I, L, g, T, 0,
			 0, T, g, g, g, g, g, g, T, 0,
			 0, T, T, T, T, T, T, T, T, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 
			 // Level 5
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, T, T, T, T, 0, 0, 0, 0,
			 0, 0, T, g, L, T, 0, 0, 0, 0,
			 0, 0, T, g, g, T, T, T, 0, 0,
			 0, 0, T,LI, P, g, g, T, 0, 0,
			 0, 0, T, g, g, I, g, T, 0, 0,
			 0, 0, T, g, g, T, T, T, 0, 0,
			 0, 0, T, T, T, T, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 
			 // Level 6
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, T, T, T, T, 0, 0, 0, 0,
			 T, T, T, g, g, T, T, T, T, 0,
			 T, g, g, g, g, g, I, g, T, 0,
			 T, g, T, g, g, T, I, g, T, 0,
			 T, g, L, g, L, T, P, g, T, 0,
			 T, T, T, T, T, T, T, T, T, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 
			 // Level 7
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, T, T, T, T, T, T, T, 0,
			 0, 0, T, g, g, g, g, g, T, 0,
			 0, 0, T, g, L, I, L, g, T, 0,
			 0, 0, T, g, I, L, I, g, T, 0,
			 0, 0, T, g, L, I, L, g, T, 0,
			 0, 0, T, g, I, L, I, g, T, 0,
			 0, 0, T, g, g, P, g, g, T, 0,
			 0, 0, T, T, T, T, T, T, T, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 
			  // Level 8
			[0, 0, 0, T, T, T, T, T, T, 0,
			 0, 0, 0, T, g, L, L, P, T, 0,
			 0, 0, 0, T, g, I, I, g, T, 0,
			 0, 0, 0, T, T, g, T, T, T, 0,
			 0, T, T, T, T, g, T, 0, 0, 0,
			 0, T, g, g, g, g, T, T, T, 0,
			 0, T, g, T, g, g, g, g, T, 0,
			 0, T, g, g, g, g, T, g, T, 0,
			 0, T, T, T, g, g, g, g, T, 0,
			 0, 0, 0, T, T, T, T, T, T, 0],
			 
			  // Level 9
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, T, T, T, T, T, 0, 0, 0,
			 0, 0, T, L, g, g, T, T, 0, 0,
			 0, 0, T, P, I, I, g, T, 0, 0,
			 0, 0, T, T, g, g, g, T, 0, 0,
			 0, 0, 0, T, T, g, g, T, 0, 0,
			 0, 0, 0, 0, T, T, L, T, 0, 0,
			 0, 0, 0, 0, 0, T, T, T, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 
			  // Level 10
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, T, T, T, T, T, T, 0,
			 0, 0, 0, T, g, g, g, g, T, 0,
			 0, 0, 0, T, g, T, T, P, T, 0,
			 0, T, T, T, g, T, g, I, T, T,
			 0, T, g, L, L, T, g, I, g, T,
			 0, T, g, g, g, g, g, g, g, T,
			 0, T, g, g, T, T, T, T, T, 0,
			 0, T, T, T, T, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 
			 // Level 11
			[0, 0, T, T, T, T, 0, 0, 0, 0,
			 0, 0, T, L, g, T, T, 0, 0, 0,
			 0, 0, T, L, P, g, T, 0, 0, 0,
			 0, 0, T, L, g, I, T, 0, 0, 0,
			 0, 0, T, T, I, g, T, T, T, 0,
			 0, 0, 0, T, g, I, g, g, T, 0,
			 0, 0, 0, T, g, g, g, g, T, 0,
			 0, 0, 0, T, g, g, T, T, T, 0,
			 0, 0, 0, T, g, g, T, 0, 0, 0,
			 0, 0, 0, T, T, T, T, 0, 0, 0],
			 
			 // Level 12
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, T, T, T, T, T, 0, 0, 0, 0,
			 0, T, g, g, g, T, T, 0, 0, 0,
			 0, T, g, I, g, g, T, 0, 0, 0,
			 0, T, T, g, I, g, T, T, T, T,
			 0, 0, T, T, T, P, L, g, g, T,
			 0, 0, T, g, g, g, L, T, g, T,
			 0, 0, T, g, g, g, g, g, g, T,
			 0, 0, T, T, T, T, T, T, T, T,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 
			 // Level 13
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, T, T, T, T, T, T, T, 0,
			 0, 0, T, g, g, g, g, g, T, 0,
			 0, 0, T, g, T, g, T, g, T, 0,
			 0, 0, T, L, g, I,LI, P, T, 0,
			 0, 0, T, g, g, g, T, T, T, 0,
			 0, 0, T, T, T, T, T, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 
			 // Level 14
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, T, T, T, T, T, 0, 0, 0, 0,
			 0, T, g, g, g, T, T, T, T, 0,
			 0, T, g, g, g, g, g, g, T, 0,
			 T, T, g, T, T, g, g, g, T, 0,
			 T, L, g, L, T, g, P, I, T, T,
			 T, g, g, g, T, g, I, I, g, T,
			 T, g, g, L, T, g, g, g, g, T,
			 T, T, T, T, T, T, T, T, T, T,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 
			 // Level 15
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, T, T, T, T, T, 0, 0, 0,
			 0, 0, T, g, P, g, T, 0, 0, 0,
			 0, 0, T, L, L, L, T, 0, 0, 0,
			 0, 0, T, I, I, I, T, T, 0, 0,
			 0, 0, T, g, g, g, g, T, 0, 0,
			 0, 0, T, g, g, g, g, T, 0, 0,
			 0, 0, T, T, T, T, T, T, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 
			  // Level 16
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, T, T, T, T, T, T, T, 0,
			 0, 0, T, g, g, g, g, g, T, 0,
			 0, 0, T, L, g, L, g, g, T, 0,
			 0, 0, T, g, T, T, g, T, T, 0,
			 0, 0, T, g, g, I, g, T, 0, 0,
			 0, 0, T, T, T, I, g, T, 0, 0,
			 0, 0, 0, 0, T, P, g, T, 0, 0,
			 0, 0, 0, 0, T, g, g, T, 0, 0,
			 0, 0, 0, 0, T, T, T, T, 0, 0],
			 
			 // Level 17
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, T, T, T, T, T, T, T, T, 0,
			 0, T, g, g, g, L, L, g, T, 0,
			 0, T, g, g, P, I, I, g, T, 0,
			 0, T, T, T, T, T, g, T, T, 0,
			 0, 0, 0, 0, T, g, g, T, 0, 0,
			 0, 0, 0, 0, T, g, g, T, 0, 0,
			 0, 0, 0, 0, T, g, g, T, 0, 0,
			 0, 0, 0, 0, T, g, g, T, 0, 0,
			 0, 0, 0, 0, T, T, T, T, 0, 0],
			 
			  // Level 18
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, T, T, T, T, 0, 0, 0, 0,
			 0, 0, T, g, g, T, T, T, T, 0,
			 0, 0, T, g, L, g, L, g, T, 0,
			 0, 0, T, g, I, I, T, P, T, 0,
			 0, 0, T, T, g, g, g, g, T, 0,
			 0, 0, 0, T, T, T, T, T, T, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 
			 // Level 19
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, T, T, T, T, T, 0, 0, 0,
			 0, 0, T, g, g, g, T, T, T, 0,
			 0, 0, T, L, g, L, g, g, T, 0,
			 0, 0, T, g, g, g, T, g, T, 0,
			 0, 0, T, T, g, T, g, g, T, 0,
			 0, 0, 0, T, P, I, I, g, T, 0,
			 0, 0, 0, T, g, g, g, g, T, 0,
			 0, 0, 0, T, g, g, T, T, T, 0,
			 0, 0, 0, T, T, T, T, 0, 0, 0],
			 
			 // Level 20
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, T, T, T, T, T, T, 0, 0,
			 0, 0, T, g, g, g, L, T, 0, 0,
			 0, 0, T, g, T, T, g, T, T, 0,
			 0, 0, T, g, g, I, I, P, T, 0,
			 0, 0, T, g, T, g, g, g, T, 0,
			 0, 0, T, L, g, g, T, T, T, 0,
			 0, 0, T, T, T, T, T, T, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 
			 // Level 21
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			 0, 0, T, T, T, T, T, 0, 0, 0,
			 0, 0, T, g, g, g, T, 0, 0, 0,
			 0, 0, T, g, P, g, T, 0, 0, 0,
			 0, 0, T, g, I, I, T, T, T, 0,
			 0, 0, T, T, L, g, L, g, T, 0,
			 0, 0, 0, T, g, g, g, g, T, 0,
			 0, 0, 0, T, T, T, T, T, T, 0,
			 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
			 
			 ];
			 
			 
		private const TOTAL_LEVELS:int = LEVELS.length;		 
			 
		private var instructions:instructions_mc = new instructions_mc();
		private var winScreen:win_screen_mc = new win_screen_mc();
		private var tilesContainer:Sprite;
		private var player:player_mc = new player_mc();
		
		private var currentLevel:Array = [];
		private var level:int = 1; //TOTAL_LEVELS; //1;
		private var lightsLevel:int = 0;
		private var lightsCompleted:int = 0;
		
		private var startTime:int;
		private var oldTime:int;
		private var keyPressed:Object = {};
		
		private var moves:int;
		private var movingPlayer:Boolean = false;
		
		private var savedGame:SharedObject;
		private var fileSaved:String = "magic_idols";


		//[F001] Main
		public function Main() {
			// constructor code
			loadGames();
			showInstructions();
			prepareGameButtons();
		}
		
		
		//[F002] Load saved games
		private function loadGames():void {
			savedGame = SharedObject.getLocal(fileSaved);
			if (savedGame.data.level) {
				// Load Data
				level = savedGame.data.level;
			}
			savedGame.close();
		}
		

		//[F003] Save game progress
		private function saveGame():void {
			savedGame = SharedObject.getLocal(fileSaved);
			
			// Save Data
			savedGame.data.level = level;
			
			savedGame.close();
		}


		//[F004] Show Instructions
		private function showInstructions():void {
			addChild(instructions);
			instructions.buttonMode = true;
			instructions.mouseChildren = false;
			instructions.addEventListener(MouseEvent.CLICK, removeInstructions);
		}
		
		
		//[F005] Remove Instructions
		private function removeInstructions(e:MouseEvent):void {
			removeChild(instructions);
			prepareGame();
		}
		
		
		//[F006] Prepare Game Buttons
		private function prepareGameButtons():void {
			game.restart.buttonMode = true;
			game.restart.mouseChildren = false;
			game.your_logo.buttonMode = true;
			game.restart.addEventListener(MouseEvent.CLICK, restartLevel);
			game.your_logo.addEventListener(MouseEvent.CLICK, onClickLogo);
		}
		
		
		//[F007] Click on Logo -> opens an HTML link on a new tab
		private function onClickLogo(e:MouseEvent) {
			var url:URLRequest = new URLRequest( YOUR_SITE );
			navigateToURL(url, "_blank");
		}
		
		
		//[F008] Prepare Game
		private function prepareGame():void {
			game.txt_level.text = "LEVEL:  ".concat(level);
			game.txt_lights.text = "0/0";
			game.txt_moves.text = "MOVES:  0";
			game.txt_time.text = "TIME:  0";
			lightsLevel = 0;
			lightsCompleted = 0;
			oldTime = 0;
			moves = 0;
			
			loadLevel();
			startGame();
		}
		
		
		//[F009] Load Level Tiles
		private function loadLevel():void {
			tilesContainer = new Sprite();
			addChildAt(tilesContainer, numChildren-1);
			
			var isLight:Boolean;

			// Create all the tiles
			for (var i:int = 0; i < ROWS; i++) {
				for (var j:int = 0; j < COLS; j++) {
					currentLevel[i*COLS + j] = 0;
						
					switch (LEVELS[level - 1][i*COLS + j]) {
						case 0:
						break;
						case L:	// Goal position (light)
							currentLevel[i*COLS + j] = g;
							isLight = true; 
							addTile(new tile_mc(), i, j, isLight);
						break;
						case T: // BLOCKING tile (trees, water)
							currentLevel[i*COLS + j] = T;
							addTile(new tile_mc(), i, j);
							addTile(new tree_mc(), i, j);
						break;
						case I:	// IDOL
							currentLevel[i*COLS + j] = g;
							addTile(new tile_mc(), i, j);
							addTile(new idol_mc(), i, j);
						break;
						case LI:	// Light+Idol
							currentLevel[i*COLS + j] = g;
							isLight = true; 
							addTile(new tile_mc(), i, j, isLight);
							addTile(new idol_mc(), i, j, isLight);
						break;
						//case 0: tile.gotoAndStop(3);
						case g:	// Walkable (grass)
							currentLevel[i*COLS + j] = g;
							addTile(new tile_mc(), i, j);
						break;
						case P:	// Player start position (is walkable)
							currentLevel[i*COLS + j] = g;
							addTile(new tile_mc(), i, j);
							addPlayer(i, j);
						break;
						
						default: break;
					}
				}
			}
			// Align to center of the screen
			tilesContainer.x = (stage.stageWidth - TILE_W*COLS)*0.5 + TILE_W*0.5;
			tilesContainer.y = (stage.stageHeight - TILE_H*ROWS)*0.5 + TILE_H*0.5;
			
			// Init Lights text
			game.txt_lights.text = "".concat(lightsCompleted).concat("/").concat(lightsLevel);
		}


		//[F010] Add a level tile
		private function addTile(tile:MovieClip, i:int, j:int, isLight:Boolean = false):void {
			// Choose the different themes: forest - brown - sea
			tile.gotoAndStop(1);
			if (level >= 14) {
				tile.gotoAndStop(3);
			} else if (level >= 7) {
				tile.gotoAndStop(2);
			} 
			
			tile.width = TILE_W;
			if (tile is tree_mc && tile.currentFrame != 3) {
				tile.width *= 0.75;
			// Chest
			} else if (tile is idol_mc) {
				tile.width *= 0.8;
				tile.i = i;
				tile.j = j;
				tile.name = "idol_" + i + "_" + j;
				tile.onLight = isLight;
				tile.eyes.visible = isLight;
				if (isLight) {
					lightsCompleted++;
				}
			// Floor tile (may be Light)
			} else if (tile is tile_mc) {
				tile.isLight.visible = isLight;
				tile.name = i + "_" + j;
				if (isLight) {
					lightsLevel++;
				}
			}
			tile.scaleY = tile.scaleX;
			tile.x = 0 + j*TILE_W;
			tile.y = 0 + i*TILE_H;
			tilesContainer.addChild(tile);
		}
		
		
		//[F011] Create Player
		private function addPlayer(i:int, j:int):void {
			player.gotoAndStop(1);
			player.width = TILE_W;
			//player.width *= 0.8;
			player.scaleY = player.scaleX;
			player.x = 0 + j*TILE_W;
			player.y = 0 + i*TILE_H;
			player.j = j;
			player.i = i;
			tilesContainer.addChild(player);
		}

		
		//[F012] Starts the game
		private function startGame():void {
			startTime = getTimer();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		
		//[F013] Reads keyboard presses
		private function keyDown(e:KeyboardEvent) {
			switch(e.keyCode) {
				case Keyboard.LEFT:
					walk(-1, 0);
					keyPressed.left = true;
				break;
				case Keyboard.RIGHT:
					walk(1, 0);
					keyPressed.right = true;
				break;
				case Keyboard.UP:
					walk(0, -1);
					keyPressed.up = true;
				break;
				case Keyboard.DOWN:
					walk(0, 1);
					keyPressed.down = true;
				break;
				case Keyboard.R:
					restartLevel();
				break;
				case Keyboard.N:
					// Can't move more!
					//stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
					//stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);			
					//winLevel();
				break;
			}
		}


		//[F014] Reads keys released
		private function keyUp(e:KeyboardEvent) {
			switch(e.keyCode) {
				case Keyboard.LEFT:
					keyPressed.left = ! true;
					break;
				case Keyboard.RIGHT:
					keyPressed.right = ! true;
					break;
				case Keyboard.UP:
					keyPressed.up = ! true;
					break;
				case Keyboard.DOWN:
					keyPressed.down = ! true;
					break;
			}
		}


		//[F015] Enter Frame!
		private function enterFrame(e:Event) {
			stage.focus = stage;
			var timeEllapsed:int = (getTimer() - startTime) * 0.001;
			if (timeEllapsed > oldTime) {
				oldTime = timeEllapsed;
				game.txt_time.text = "TIME:  ".concat( timeString(timeEllapsed) );
			}
		}

		
		//[F016] Convert a time (in seconds) to a String (m:ss)
		private function timeString(t:int):String {
			// Seconds
			const SEC_PER_MIN:int = 60;
			if (t < SEC_PER_MIN) return t.toString();
			// Min
			var s:int = t % SEC_PER_MIN;
			var m:int = t / SEC_PER_MIN;
			var secString:String;
			var minString:String;
			if (s < 10) {
				secString = "0".concat(s);
			} else {
				secString = s.toString();
			}
			minString = m.toString();
			return minString.concat(":", secString);
		}
		
		
		//[F017] Make the player walk (if he is not moving already!)
		private function walk(incX:int, incY:int):void {
			if (movingPlayer) return;
			
			var idol:idol_mc;
			var row:int = player.i + incY;
			var col:int = player.j + incX;
			var newTile:int = getTile(row, col);
			
			switch(newTile) {
				case g:
					idol = tilesContainer.getChildByName("idol_" + row + "_" + col) as idol_mc;
					if (idol) {
						pushIdol(incX, incY);
					} else {
						TIME_MOV = TIME_WALK;
						movePlayerTo(incX, incY);
					}
				break;
			}
			

			// Look up/down
			if (incY > 0) {
				player.gotoAndStop(3);	// walk up
				player.scaleX *= (player.scaleX < 0 ? -1 : 1);
			} else if (incY < 0) {
				player.gotoAndStop(5);
				player.scaleX *= (player.scaleX < 0 ? -1 : 1);
			}
			
			// Look left/right
			if (incX > 0) {
				player.gotoAndStop(1);
				player.scaleX *= (player.scaleX < 0 ? 1 : -1);
			} else if (incX < 0) {
				player.gotoAndStop(1);
				player.scaleX *= (player.scaleX < 0 ? -1 : 1);
			}
			

		}
		
		
		//[F018] Gets the value of a tile
		private function getTile(r:int, c:int):int {
			return (currentLevel[r*COLS + c]);
		}
		
		
		//[F019] Moves Player To ...X,Y...		
		private function movePlayerTo(incX:int, incY:int):void {
			movingPlayer = true;
			
			var oldIndex:int = tilesContainer.getChildIndex( tilesContainer.getChildByName(player.i + "_" + player.j) as tile_mc );
			player.i += incY;
			player.j += incX;
			var index:int = tilesContainer.getChildIndex( tilesContainer.getChildByName(player.i + "_" + player.j) as tile_mc );
			
			var newPlayerX:int = 0 + player.j*TILE_W; 
			var newPlayerY:int = 0 + player.i*TILE_H;
			
			tilesContainer.removeChild(player);
			tilesContainer.addChildAt(player, Math.max(index+1, oldIndex+1) );
			
			// Move smooth
			TweenMax.to(player, TIME_MOV, {x:newPlayerX, y:newPlayerY, onComplete:finishMoving});
			TweenMax.delayedCall(TIME_MOV, setIndex, [player, index+1]);
			animWalk();
			
			// Update moves
			moves++;
			game.txt_moves.text = "MOVES:  ".concat(moves);
		}
		
		
		//[F020] Finished moving
		private function finishMoving():void {
			movingPlayer = false;
		}
		
		
		//[F021] Walk Animation
		private function animWalk():void {
			const TOTAL_WALK_FRAMES:int = 2;
			
			const ANIMATION:int = (player.currentFrame - 1) / TOTAL_WALK_FRAMES;	// Frames 1-2 are ANIMATION 0 (side), 3-4 are ANIMATION 1 (front), 5-6 are ANIMATION 2 (back)
			const IDLE_FRAME:int = ANIMATION * TOTAL_WALK_FRAMES + 1;	// Idle (ANIM0) = 1, Idle (anim1) = 3, Idle(anim2) = 5
			var animFrame:int = player.currentFrame - IDLE_FRAME; 
			
			// If the current frame is 2, 4, 6 (walking animation),
			// then set the player frame to the "Idle" frames 1, 3, 5
			if (animFrame > 0) {	// Player is animating
				if (!movingPlayer) {
					player.gotoAndStop( IDLE_FRAME );
					return;
				}
			}
			
			// The player is walking, animate him
			animFrame = (animFrame + 1) % TOTAL_WALK_FRAMES;
			player.gotoAndStop( IDLE_FRAME + animFrame );
			TweenMax.to(this, 0.1, {onComplete:animWalk});
		}
		
		
		//[F022] Push an Idol
		private function pushIdol(incX:int, incY:int):void {
			var row:int = player.i + incY*2;
			var col:int = player.j + incX*2;
			var newTile:int = getTile(row, col);
			
			if (newTile == g &&
				! tilesContainer.getChildByName("idol_" + row + "_" + col) ) {
				TIME_MOV = TIME_PUSH;
				movePlayerTo(incX, incY);
				moveChestTo(incX, incY);
			}
		}


		//[F023] Move Chest To ..X,Y..		
		private function moveChestTo(incX:int, incY:int):void {
			var idol:idol_mc = tilesContainer.getChildByName("idol_" + player.i + "_" + player.j) as idol_mc;
			
			var oldTile:tile_mc = tilesContainer.getChildByName(idol.i + "_" + idol.j) as tile_mc;
			var oldIndex:int = tilesContainer.getChildIndex( oldTile );
			idol.i = player.i + incY;
			idol.j = player.j + incX;
			var newTile:tile_mc = tilesContainer.getChildByName(idol.i + "_" + idol.j) as tile_mc;
			var index:int = tilesContainer.getChildIndex( newTile );
			
			var newChestX:int = 0 + idol.j*TILE_W;
			var newChestY:int = 0 + idol.i*TILE_H;
			idol.name = "idol_" + idol.i + "_" + idol.j;
			
			tilesContainer.removeChild(idol);
			tilesContainer.addChildAt(idol, Math.max(index+1, oldIndex+1) );
			
			// Move smooth
			TweenMax.to(idol, TIME_MOV, {x:newChestX, y:newChestY, onComplete:checkWin, onCompleteParams:[idol]});
			TweenMax.delayedCall(TIME_MOV, setIndex, [idol, index+1]);
		}

		
		//[F024] Changes the index of Tile
		private function setIndex(obj:MovieClip, index:int):void {
			tilesContainer.removeChild(obj);
			tilesContainer.addChildAt(obj, index);
		}
		
		
		//[F025] Check if the last move of idol is: Win Level
		private function checkWin(idol:idol_mc):void {
			// New tile where the idol will land
			var newTile:tile_mc = tilesContainer.getChildByName(idol.i + "_" + idol.j) as tile_mc;
			if (idol.onLight) {
				idol.onLight = false;
				lightsCompleted--;
				idol.eyes.visible = false;
			}
			if (newTile.isLight.visible) {
				lightsCompleted++;
				idol.onLight = true;
				idol.eyes.visible = true;
			}
			
			// Show the number of lights
			game.txt_lights.text = "".concat(lightsCompleted).concat("/").concat(lightsLevel);
				
			// Win Level!!!
			if (lightsCompleted == lightsLevel) {
				// Can't move anymore!
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
				stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			
				player.gotoAndStop(7);
			
				TweenMax.delayedCall(0.5, winLevel);
			}
		}


		//[F026] You win!
		private function winLevel():void {
			// Remove old
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			while (tilesContainer.numChildren > 0) {
				tilesContainer.removeChildAt(0);
			}
			
			// Increment your level!
			level++;
			
			// Add the winning screen
			var timeEllapsed:int = (getTimer() - startTime) * 0.001;
			winScreen.win_text.txtMoves.text = moves;
			winScreen.win_text.txtTime.text = "".concat( timeString(timeEllapsed) );
			TweenMax.fromTo(winScreen, 1, {alpha:0}, {alpha:1, onComplete:addWinListeners});
			winScreen.alpha = 0;
			addChild(winScreen);
		}

		
		//[F027] If you click the WIN SCREEN, go to the Next Level
		private function addWinListeners():void {
			winScreen.addEventListener(MouseEvent.CLICK, nextLevel);
		}
		
		
		//[F028] Next Level: Save progress and prepare the game for the next level
		private function nextLevel(e:MouseEvent):void {
			winScreen.removeEventListener(MouseEvent.CLICK, nextLevel);
			removeChild(winScreen);
			if (level <= TOTAL_LEVELS) {
				prepareGame();		
				// Save Progress
				saveGame();
			} else {
				level = 1;
				showInstructions();
			}
		}

		
		//[F029] Restart Level
		private function restartLevel(e:MouseEvent = null):void {
			TweenMax.killAll();
			movingPlayer = false;
			// Remove old
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			while (tilesContainer.numChildren > 0) {
				tilesContainer.removeChildAt(0);
			}
			// Start the level (again)
			prepareGame();		
		}


	}
	
}
