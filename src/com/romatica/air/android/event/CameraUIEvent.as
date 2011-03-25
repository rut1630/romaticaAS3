/**
 *============================================================
 * copyright(c) 2011 www.romatica.com
 * @author  itoz
 * 2011/03/25
 *============================================================
 */
package com.romatica.air.android.event
{
    import flash.display.BitmapData;
    import flash.events.Event;

    /**
     *  CameraUIEvent.as
     */
    public class CameraUIEvent extends Event
    {
        public static const EXIF_LOAD_COMPLETE : String = "EXIF_LOAD_COMPLETE";
        public static const IMAGE_LOAD_COMPLETE : String = "IMAGE_LOAD_COMPLETE";
        public static const THUMBNAIL_LOAD_COMPLETE : String = "THUMBNAIL_LOAD_COMPLETE";
        // public static const IMAGE_LOAD_ERROR : String = "IMAGE_LOAD_ERROR";
        // public static const THUMBNAIL_LOAD_ERROR : String = "THUMBNAIL_LOAD_ERROR";
        private var _bitmapData : BitmapData;
        private var _exifObject : Object;

        public function CameraUIEvent(type : String, bmd : BitmapData = null, exifObject : Object = null, bubbles : Boolean = false, cancelable : Boolean = false)
        {
            super(type, bubbles, cancelable);
            _bitmapData = bmd;
            _exifObject = exifObject;
        }

        public function get exifObject() : Object
        {
            return _exifObject;
        }

        public function get bitmapData() : BitmapData
        {
            return _bitmapData;
        }
    }
}
