
/**
 *============================================================
 * copyright(c). 
 * @author  itoz
 *============================================================
 *
 */
package com.romatica.events
{
	import flash.events.Event;

	/**
	 * 
	 * <p></p>
	 * <pre></pre>
	 * @example :
	 * <listing version="3.0"></listing>
	 */
	public class FadeEvent extends Event
	{
		public static const FADEOUT_COMPLETE : String = "FADEOUT_COMPLETE";
		public static const FADEOUT_START : String = "FADEOUT_START";
		public static const FADEIN_START : String = "FADEIN_START";
		public static const FADEIN_COMPLETE : String = "FADEIN_COMPLETE";
		public function FadeEvent (type : String , bubbles : Boolean = false , cancelable : Boolean = false)
		{
			super( type , bubbles , cancelable );
		}
	}
}
