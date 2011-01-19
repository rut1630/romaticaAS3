/**
 * -------------------------------------------------------
 * copyright(c). romatica.com
 * @author itoz
 * @version 1.0
 * -------------------------------------------------------
 * 	-2010.3 　スプライトhitareaの領域をレクタングルで指定するように変更
 * 	-2010.3 　コンストラクタ第6引数に「clickFunc」を追加
 * 	-2010.3	ボタンを「機能させる/機能させなくする」ファンクションを追加
 * 	-2010.8 　パッケージをridからcom.romaticaへ変更
 */
package com.romatica.ui {
	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	dynamic public class SimpleButtonEvents extends MovieClip {

		public var _btn : MovieClip;
		private var _clickFunc : Function;
		private var hit : Sprite;

		/**
		 * コンストラクタMCをシンプルにボタン化.
		 * 	※第一引数のムービークリップ内には、フレームラベルとして「over」と「out」を設置。(なくてもよい)
		 * @param	btn:MovieClip			対象のボタンDisplayObject
		 * @param	hitRect:Rectangle		ヒットエリア作成用レクタングル
		 * @param	onClickFunc:Function	クリック時リスナーファンクション
		 */
		public function SimpleButtonEvents(btn : MovieClip, hitRect : Rectangle, clickFunc : Function) {
			try {
				_btn = btn;
				_clickFunc = clickFunc;
				mouseChildren = false;
				//hitarea rectangle
				hit = new Sprite( );
				var g : Graphics= hit.graphics;
				g.beginFill( 0xcc0000 );
				g.drawRect( hitRect.x, hitRect.y, hitRect.width, hitRect.height );
				g.endFill( );
				hit.visible = false;
				hit.alpha = 0.5;
				hit.name = "hit_area";
				hit.mouseEnabled = false;
				_btn.addChild( hit );
				_btn.hitArea = hit;
				_btn.buttonMode=false;
				setON( );
			}catch(err : Error) {
				trace( "ERROR : SimpleButtonEvent >" + _btn );
			}
		}

		/**
		 * ボタン機能を有効にする
		 */
		public function setON () : void
		{
			if (_btn.buttonMode == false) {
				_btn.gotoAndPlay( "stay" );
				_btn.alpha = 1;
				_btn.buttonMode = true;
				_btn.addEventListener( MouseEvent.ROLL_OVER , onOver , false , 0 , true );
				_btn.addEventListener( MouseEvent.ROLL_OUT , onOut , false , 0 , true );
				_btn.addEventListener( MouseEvent.CLICK , _clickFunc , false , 0 , true );
			}
		}

		/**
		 * ボタン機能を無効にする
		 */
		public function setOFF () : void
		{
			if (_btn.buttonMode) {
				_btn.gotoAndPlay( "stay" );
				_btn.alpha = 0.5;
				_btn.buttonMode = false;
				_btn.removeEventListener( MouseEvent.ROLL_OVER , onOver );
				_btn.removeEventListener( MouseEvent.ROLL_OUT , onOut );
				_btn.removeEventListener( MouseEvent.CLICK , _clickFunc );
			}
		}

		private function onOver (e : MouseEvent) : void
		{
			_btn.gotoAndPlay( "over" );
		}

		private function onOut (e : MouseEvent) : void
		{
			_btn.gotoAndPlay( "out" );
		}

		public function remove () : void
		{
			setOFF();
			_btn.removeChild( hit );
			hit = null;
		}
	}
}