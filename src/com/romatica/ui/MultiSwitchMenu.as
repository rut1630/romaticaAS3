/**
 * -------------------------------------------------------
 * copyright(c). romatica.com
 * @author itoz
 * @version 1.0
 * -------------------------------------------------------
 */
 
package com.romatica.ui
{
	import com.romatica.events.SwitchMenuEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * カレント切り替えメニューを実装するクラス.
	 * <p>MC内最前面に、オーバーエリアを指定する（透明な）MCを配置し、overArea_mcという名前を付けてください。
	 * 各状態でup,over,select,outというフレームラベルにgotoAndPlay()します。（フレームラベルがなくても動作します）</p>
	 */
	public class MultiSwitchMenu extends Sprite 
	{
		private var _menuArr : Array;			//ボタンMC配列
		private var _setEventFlag : Boolean;	//ボタン群にマウスイベントが設定されているかどうか
		//
		private var _bitArr : Array;// 1,2,4,8,16等をいれる
		private var _selectBit : uint = 0;
		private var _disableBit : uint;//1が機能　0が不機能のbit　例　10101010
		//======================================================================
		/**
		 * コンストラクタ
		 * @paran menuMCArr ボタンMC配列
		 */
		public function MultiSwitchMenu(menuMCArr : Array) 
		{
			_menuArr = menuMCArr;
			_bitArr = [];
			try{
				var i : int;
				var max : int = _menuArr.length;
				if(max <2) throw new ArgumentError("コンストラクタ引数に2つ以上のMCの入った配列を指定して下さい");  
				for (i = 0;i < max;i++) {
					var menu : MovieClip = _menuArr[i];
					menu.select = false;
					menu._ID = i;
					menu.bit=Math.pow(2,(max-1 - i));//ビットを持たせる
					_bitArr.push(menu.bit);
					//trace(	i+"  / " + menu.bit + "/" +menu.bit.toString(2))
					var overArea:MovieClip = menu.overArea_mc;
					if(overArea == null) throw new ArgumentError((i+1)+"番目に指定したメニューMC内に overArea_mc を設置して下さい");  
					overArea.buttonMode = true;
				}
				//ボタン有効化チェックビット。 全部１に（）
				_disableBit=Math.pow(2,max)-1;
				addEvents();
			} catch(error : Error) {
				trace( error.message );
			}
		}

		////////////////////////////////////////////////////////////////////////
		//----------------------------------------------------------------------
		//                                                              getter
		/** 
		 * 現在選択されている配置ビット
		 * @default 0
		 */
		public function get selectBit() : uint {return _selectBit;}
		
		////////////////////////////////////////////////////////////////////////
		//----------------------------------------------------------------------
		//                                   　　　　　　　　　　　　　ボタンを選択状態に
		/**
		 * ボタンをセレクト状態にする.
		 * 第2引数で、セレクト時のイベントを配信するかどうか指定できる。
		 * @param bit 
		 * @param eventMode 
		 */
		public function selectBtn( bit: uint, eventMode : Boolean = true) : void
		{
			selectBtnChanger(bit, eventMode);
		}

		////////////////////////////////////////////////////////////////////////
		//----------------------------------------------------------------------
		//                                                              ＞リセット
		/**
		 * 全てのボタンを選択されていない状態にする。
		 */
		public function reset() : void
		{
			disableChanger(Math.pow(2,_menuArr.length)-1);
			selectBtnChanger(0,false);
		}
		

		////////////////////////////////////////////////////////////////////////
		//----------------------------------------------------------------------
		//                                                            イベント設定
		//
		/**
		 * ボタン群にマウスイベントを設定する
		 */
		public function addEvents() : void
		{
			if(_setEventFlag) return;
			var i : int;
			var max : int = _menuArr.length;
			for (i= 0;i < max;i++) {
				var overArea : MovieClip = _menuArr[i].overArea_mc;
				overArea.mouseChildren = false;
				overArea.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
				overArea.addEventListener(MouseEvent.ROLL_OVER, onOver, false, 0, true);
				overArea.addEventListener(MouseEvent.ROLL_OUT, onOut, false, 0, true);
			}
			_setEventFlag = true;
		}
		
		

		////////////////////////////////////////////////////////////////////////
		//----------------------------------------------------------------------
		//                                                             イベント削除
		//
		/**
		 * ボタン群のマウスイベントを全て削除する。
		 * 一時的にボタン群を不機能にしたい場合、など。
		 */
		public function removeEvents() : void
		{
			if(!_setEventFlag) return;
			var i : int;
			var max : int = _menuArr.length;
			for (i = 0;i < max;i++) {
				var overArea : MovieClip = _menuArr[i].overArea_mc;
				overArea.buttonMode = false;
				overArea.mouseChildren = false;
				if(overArea.hasEventListener(MouseEvent.CLICK)){
					overArea.removeEventListener(MouseEvent.CLICK, onClick);
				}
				if(overArea.hasEventListener(MouseEvent.ROLL_OVER)){
					overArea.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				}
				if(overArea.hasEventListener(MouseEvent.ROLL_OUT)){
					overArea.removeEventListener(MouseEvent.ROLL_OUT, onOut);
				}
			}
			_setEventFlag = false;
		}
		
		
		////////////////////////////////////////////////////////////////////////
		/**
		 * リムーブ.
		 * イベント削除し、配列を空に
		 */
		public function remove() : void
		{
			removeEvents();
			_menuArr = null;
		}
		
		////////////////////////////////////////////////////////////////////////
		//----------------------------------------------------------------------
		//                                                          　　 ＞クリック
		private function onClick(e : MouseEvent = null) : void 
		{
			var trg : MovieClip= MovieClip((e.target as MovieClip).parent);
			var bit:uint;  
			if ((_selectBit & trg.bit) ==  trg.bit) {
				//trace( "すでに選択済み選択解除" +(_selectBit & trg.bit));
				bit = (_selectBit ^ trg.bit);
			} else {
				//trace( "選択されていなかった" );
				bit = (_selectBit | trg.bit);
			}
			selectBtnChanger(bit);
			
		}

		//----------------------------------------------------------------------
		//                                                         　　　 ＞オーバー
		private function onOver(e : MouseEvent = null) : void 
		{
			var menu : MovieClip = MovieClip((e.target as MovieClip).parent);
			if (!menu.select) {
				menu.gotoAndPlay("over");
				var overEvent:SwitchMenuEvent = new SwitchMenuEvent(SwitchMenuEvent.OVER);
				overEvent.id = menu._ID;
				overEvent.targetMenu = menu;
				dispatchEvent(overEvent);
			}
		}

		//----------------------------------------------------------------------
		//                                                             　　＞アウト
		private function onOut(e : MouseEvent ) : void 
		{
			var menu : MovieClip= MovieClip((e.target as MovieClip).parent);
			if (!menu.select) {
				menu.gotoAndPlay("out");
				var outEvent:SwitchMenuEvent = new SwitchMenuEvent(SwitchMenuEvent.OUT);
				outEvent.id = menu._ID;
				outEvent.targetMenu = menu;
				dispatchEvent(outEvent);
			}
		}
		////////////////////////////////////////////////////////////////////////
		//                                                      ディザブルチェンジャー
		/**
		 * @param bit 不機能にしたいbit
		 * @param eventMode 選択時のイベントを配信するかどうか
		 */
		public function disableChanger(bit:uint):void
		{
			for (var i : int = 0; i < _bitArr.length; i++) {
				var checkBit:uint = _bitArr[i];
				//trace(""+(checkBit.toString(2)) +"/"+(bit.toString(2)));
				var menu : MovieClip = _menuArr[i];
				var over : MovieClip = _menuArr[i].overArea_mc;
				if((bit&checkBit)!=checkBit){
					// 0なら不機能に
					over.visible = false;
					over.buttonMode = false;
					menu.select = false;
					menu.mouseChildren = false;
					menu.gotoAndPlay("disable");
				}else{
					//1なら機能に
					over.visible = true;
					over.buttonMode = true;
					menu.mouseChildren = true;
					if((_disableBit & checkBit)!=checkBit){
						//trace("前回不機能だったので、UPに戻す");
						menu.gotoAndPlay("up");
					}
				}
			}
			_disableBit = bit;
		}
		
		////////////////////////////////////////////////////////////////////////
		//                                                      セレクトチェンジャー
		/**
		 * @param bit 選択したいボタン配置bit
		 * @param eventMode 選択時のイベントを配信するかどうか
		 */
		private function selectBtnChanger(bit : uint , eventMode : Boolean = true) : void 
		{
			_selectBit = bit;
			for (var i : int = 0; i < _bitArr.length; i++) {
				var checkBit : uint = _bitArr[i];
				if((_disableBit&checkBit)==checkBit){
					var menu : MovieClip = _menuArr[i];
					if ((bit & checkBit) == checkBit) {
//						trace( "			該当" );
						if(!menu.select){
//							trace("  前回選択状態じゃなかった"+i);
							menu.select = true;
							menu.gotoAndPlay("select");
						}
					}else{
//						trace(	"			該当しない");
						if(menu.select){
							menu.gotoAndPlay("out");
						} else {
							menu.gotoAndPlay("up");
						}
						menu.select = false;
					}
				}else{
//					trace("不機能 なにもしない　"+(_disableBit.toString(2)+ "/ " +(checkBit.toString(2))))
				}
			}
			
			//イベント配信モードなら配信
			if (eventMode) {
				var selectEvent:SwitchMenuEvent = new SwitchMenuEvent(SwitchMenuEvent.SELECTED);
				selectEvent.bit = _selectBit;
				dispatchEvent(selectEvent);
			}
		}
	}
}