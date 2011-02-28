/**
 * -------------------------------------------------------
 * copyright(c)2011 romatica.com
 * @author itoz (http://www.romatica.com/)
 * @version 1.0
 * -------------------------------------------------------
 *
 */
package com.romatica.events
{
    import flash.events.DataEvent;
	/**
	 * NumCounterクラスによってイベントが発生した場合に送出されます。.
     */
    public class CountEvent extends DataEvent
	{
		
		/**
		 * @eventType カウントイベント
		 */
		public static const COUNT_PROGRESS : String = "COUNT";
		/**
		 * @eventType カウントイベントスタート
		 */
		public static const COUNT_START : String = "COUNT_START";
		/**
		 * @eventType カウントイベントコンプリート
		 */
		public static const COUNT_COMPLETE : String = "COUNT_COMPLETE";
		/**
		 * 現在のカウント数テキスト
		 */
		private var _count:String;
		
		/**
		 * コンストラクタ
         */
        public function CountEvent(type : String, countStr : String, bubbles : Boolean = false, cancelable : Boolean = false)
        {
            super(type, bubbles, cancelable, countStr);
            _count = data;
        }

        public function get count() : String
        {
            return _count;
        }
	}
}
