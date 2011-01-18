/**
 * -------------------------------------------------------
 * copyright(c). romatica.com
 * @author itoz
 * @version 1.0
 * -------------------------------------------------------
 */
package com.romatica.events
{
	import flash.events.Event;
	/**
	 * XMLLoadQueueクラスによってイベントが発生した場合に送出されます。
	 */
	public class XMLLoadQueueEvent extends Event
	{
		/**
		 * @eventType XMLロード完了された場合のtypeプロパティ
		 */
		public static const COMPLETE:String="COMPLETE";
		/**
		 * @eventType XMLロードプログレスのtypeプロパティ
		 */
		public static const PROGRESS : String = "PROGRESS";
		/**
		 * @eventType XMLロードエラーのtypeプロパティ
		 */
		public static const ERROR : String = "ERROR";
		/**
		 * @eventType XMLロードオープンのtypeプロパティ
		 */
		public static const OPEN : String = "OPEN";
		
		public var xml:XML;
		public var url:String;
		public var bytesLoaded:Number;
		public var bytesTotal:Number;
		public var percent:Number;
		public var text:String;
		/**
		 * コンストラクタ
		 */
		public function XMLLoadQueueEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super( type, bubbles, cancelable );
		}
	}
}
