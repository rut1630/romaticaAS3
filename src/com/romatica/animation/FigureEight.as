/**
 * -------------------------------------------------------
 * copyright(c). romatica.com
 * @author itoz (http://www.romatica.com/)
 * @version 3.0
 * -------------------------------------------------------
 * -2010.8.5 コンストラクタに　direction(回転方向指定)を追加
 * -2010.8.20 パッケージ変更
 * -2010.8.20 _startFrag追加
 * -2010.8.20 setDebug() セッターdebugを追加
 */
package com.romatica.animation
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * 8の字に動く座標を取得.
	 * ポイントの参照はFigureEight.point.xなど。
	 * @example : 
	 *  <listing version="3.0">
	 *  var _fig8 : FigureEight= addChild(new FigureEight(100, 5, 0,true,true)) as FigureEight;
	 *  _fig8.x = stage.stageWidth/2;
	 *  _fig8.y = stage.stageHeight/2;
	 *  		
	 *  // ポイントのローカル座標　
	 *  _fig8.point.x;
	 *  _fig8.point.y;
	 *  // 親の階層から見たポイント座標　
	 *  _fig8.offsetPoint.x;
	 *  _fig8.offsetPoint.y;
	 *  </listing>
	 */
	public class FigureEight extends Sprite
	{
		private var _startFrag : Boolean;
		private var _p : Point;
		private var _offsetPoint : Point;
		private var _r : Number;
		private var _s : Number;
		private var _ang : Number;
		private var _direction : int;
		private var _debug : Boolean;
		private var _d : Sprite;

		// **********************************************************************
		/**
		 * コンストラクタ.
		 *  @paran  R 　半径
		 *  @paran  Speed　　増える角度
		 *  @paran  ang　初期角度
		 *  @paran  direction　trueで正の方向　falseで負の方向にrotationが増える
		 *  @paran  debug　デバッグモード
		 */
		public function FigureEight(R : Number, Speed : Number, ang : Number, direction : Boolean = true, debug : Boolean = false)
		{
			_startFrag = false;
			_direction = (direction) ? 1 : -1;
			_r = R;
			_s = Speed * _direction;
			_ang = ang;
			setDebug (debug);
			_p = new Point ();
			_offsetPoint = new Point ();
			start ();
		}

		/**
		 * デバッグモードセット.
		 */
		private function setDebug(debug : Boolean):void
		{
			if (debug) {
				if(_d == null) {
					_d = addChild (new Sprite ()) as Sprite;
					_d.graphics.beginFill (0xcc0000);
					_d.graphics.drawCircle (0, 0, 2);
					_d.graphics.endFill ();
				}
				_d.visible = true;
			} else {
				if(_d != null) {
					_d.visible = debug;
				}
			}
			_debug = debug;
		}

		/**
		 * アップデート
		 */
		public function onEnter(e : Event):void
		{
			if (_ang >= 360)
				_ang = 360 - _ang;
			// 360を超えたら
			if (_ang <= -360)
				_ang = 360 + _ang;
			// -360を超えたら

			var rad : Number = _ang * Math.PI / 180;
			_p.x = Math.sin (rad) * _r;
			_p.y = Math.sin (rad * 2) * _r / 2;
			_offsetPoint.x = this.x + _p.x ;
			_offsetPoint.y = this.y + _p.y;
			_ang += _s;
			if(!_debug)
				return;
			_d.x = _p.x;
			_d.y = _p.y;
			// trace("[FigureEight] : x= " +_d.x+" / y= "+_d.y)
		}

		/**
		 * 
		 */
		public function remove():void
		{
			stop ();
			_p = null;
			if (_debug) {
				_d = null;
				removeChild (_d);
			}
		}

		/**
		 * 
		 */
		public function stop():void
		{
			if(!_startFrag) {
				return;
			}
			_startFrag = false;
			if(this.hasEventListener (Event.ENTER_FRAME)) {
				removeEventListener (Event.ENTER_FRAME, onEnter);
			}
		}

		/**
		 * 
		 */
		public function start():void
		{
			if(_startFrag) {
				return;
			}
			_startFrag = true;
			addEventListener (Event.ENTER_FRAME, onEnter);
		}

		public function get point():Point
		{
			return _p;
		}

		public function set debug(debug : Boolean) : void
		{
			_debug = debug;
			setDebug (_debug);
		}

		public function get offsetPoint() : Point
		{
			return _offsetPoint;
		}
	}
}
