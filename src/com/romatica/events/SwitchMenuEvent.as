/**
 * -------------------------------------------------------
 * copyright(c). romatica.com
 * @author itoz (http://www.romatica.com/)
 * @version 1.0
 * -------------------------------------------------------
 *
 */
package com.romatica.events
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * SwitchMenuクラスによってイベントが発生した場合に送出されます。.
	 */
	public class SwitchMenuEvent extends Event
	{
		/**
		 * @eventType メニューが選択された場合のtypeプロパティ
		 */
		public static const SELECTED : String = "selected";
		/**
		 * @eventType メニューがマウスオーバーされた場合のtypeプロパティ
		 */
		public static const OVER : String = "over";
		/**
		 * @eventType メニューがマウスアウトされた場合のtypeプロパティ
		 */
		public static const OUT : String = "out";
		/**
		 * ボタンのID
		 */
		public var id:int;
		/**
		 * ボタン選択状態のbit
		 */
		public var bit:uint;		//選択されているボタンたちのビット 	例1011
		/**
		 * ボタンMC
		 */
		public var targetMenu:MovieClip;
		/**
		 * コンストラクタ
		 */
		public function SwitchMenuEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}
