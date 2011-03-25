/**
 *============================================================
 * copyright(c) 2011 www.romatica.com
 * @author  itoz
 * 2011/03/25
 *============================================================
 */
package com.romatica.air.android.event
{
	import flash.events.Event;

    /**
     *  CameraRollEvent.as
     */
    public class CameraRollEvent extends Event
    {
        public static const SAVE_SUCCESS : String = "SAVE_SUCCESS";
        public static const SAVE_ERROR : String = "SAVE_ERROR";
        public function CameraRollEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
        {
            super(type, bubbles, cancelable);
        }
    }
}
