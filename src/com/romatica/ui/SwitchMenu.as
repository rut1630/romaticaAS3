/**
 * -------------------------------------------------------
 * copyright(c). romatica.com
 * @author itoz
 * @version 1.0
 * -------------------------------------------------------
 * -2010.12.28 トグルモード追加
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
	 *  
	 */
	public class SwitchMenu extends Sprite 
	{
		private var _menuArr : Array;			//ボタンMC配列
		private var _setEventFlag : Boolean;	//ボタン群にマウスイベントが設定されているかどうか
		private var _selectId : int=-1;			//選択されているボタンのID　何も選択されていない場合は-1;
		private var _toggleMode : Boolean;
		//======================================================================
		/**
		 * コンストラクタ
		 * @paran menuMCArr ボタンMC配列
		 */
		public function SwitchMenu(menuMCArr : Array,toggleMode:Boolean =false) 
		{
			_toggleMode = toggleMode;//選択されたボタンを、再選択でクリアきるかどうか
			_menuArr = menuMCArr;
			try{
				var i : int;
				var max : int = _menuArr.length;
				if(max <2) throw new ArgumentError("コンストラクタ引数に2つ以上のMCの入った配列を指定して下さい");  
				for (i = 0;i < max;i++) {
					var menu : MovieClip = _menuArr[i];
					menu._select = false;
					menu._ID = i;
					var overArea:MovieClip = menu.overArea_mc;
					if(overArea == null) throw new ArgumentError((i+1)+"番目に指定したメニューMC内に overArea_mc を設置して下さい");  
					overArea.buttonMode = true;
				}
			} catch(error : Error) {
				trace( error.message );
			}
			addEvents();
		}

		////////////////////////////////////////////////////////////////////////
		//----------------------------------------------------------------------
		//                                                              getter
		/** 
		 * 現在選択されているボタンナンバー 
		 * @default -1
		 */
		public function get selectId() : int {return _selectId;}
		
		////////////////////////////////////////////////////////////////////////
		//----------------------------------------------------------------------
		//                                   　　　　　　　　　　　　　ボタンを選択状態に
		/**
		 * ボタンをセレクト状態にする.（IDはコンストラクタで渡した配列の位置）
		 * 第2引数で、セレクト時のイベントを配信するかどうか指定できる。
		 * @param id 
		 * @param eventMode 
		 */
		public function selectBtn( id: int, eventMode : Boolean = true) : void
		{
			selectBtnChanger(id, eventMode);
		}

		////////////////////////////////////////////////////////////////////////
		//----------------------------------------------------------------------
		//                                                              ＞リセット
		/**
		 * 全てのボタンを選択されていない状態にする。
		 */
		public function reset() : void
		{
			var ii : int;
			var max : int = _menuArr.length;
			for (ii = 0;ii < max;ii++) {
				var checkBtn : MovieClip = _menuArr[ii];
				if (checkBtn._select) {
					checkBtn.gotoAndPlay("out");
				} else {
					checkBtn.gotoAndPlay("up");
				}
				checkBtn.mouseChildren = true;
				checkBtn.buttonMode = true;
				checkBtn._select = false;
			}
			_selectId=-1;
		}
		

		////////////////////////////////////////////////////////////////////////
		//----------------------------------------------------------------------
		//                                                            イベント設定
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
			selectBtnChanger(trg._ID);
		}

		//----------------------------------------------------------------------
		//                                                         　　　 ＞オーバー
		private function onOver(e : MouseEvent = null) : void 
		{
			var menu : MovieClip = MovieClip((e.target as MovieClip).parent);
			if (!menu._select) {
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
			if (!menu._select) {
				menu.gotoAndPlay("out");
				var outEvent:SwitchMenuEvent = new SwitchMenuEvent(SwitchMenuEvent.OUT);
				outEvent.id = menu._ID;
				outEvent.targetMenu = menu;
				dispatchEvent(outEvent);
			}
		}


		////////////////////////////////////////////////////////////////////////
		//                                                      セレクトチェンジャー
		/**
		 * @param ID 選択したいボタンID
		 * @param eventMode 選択時のイベントを配信するかどうか
		 */
		private function selectBtnChanger(ID : int , eventMode : Boolean = true) : void 
		{
			_selectId = ID;
			var i : int;
			var max : int = _menuArr.length;
			for (i = 0;i < max;i++) {
				var menu : MovieClip = _menuArr[i];
				if (ID == i) {
					//[トグルモード]選択されたボタンを、再選択でクリアきるかどうか
					if(_toggleMode){
						if (menu._select) {
							reset();
						}
						else {
							menu.gotoAndPlay( "select" );
							menu._select = true;
						}
					}
					else {
						menu.mouseChildren = false;
						menu.overArea_mc.buttonMode = false;
						menu._select = true;
						menu.gotoAndPlay( "select" );
					}
				}
				else {
					menu.mouseChildren = true;
					if (menu._select) {
						menu.gotoAndPlay( "out" );
					}
					else {
						menu.gotoAndPlay( "up" );
					}
					menu.overArea_mc.buttonMode = true;
					menu._select = false;
				}
			}
			//イベント配信モードなら配信
			if (eventMode) {
				var selectEvent:SwitchMenuEvent = new SwitchMenuEvent(SwitchMenuEvent.SELECTED);
				selectEvent.id = _selectId;
				selectEvent.targetMenu = _menuArr[_selectId];
				dispatchEvent(selectEvent);
			}
		}
	}
}