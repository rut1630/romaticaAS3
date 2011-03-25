/**
 *============================================================
 * copyright(c) 2011
 * @author  itoz
 * 2011/03/25
 *============================================================
 */
package com.romatica.air.android.cameraui
{
    /**
     *  CameraUIController.as
     */
    public class CameraUIController
    {
    	
    	protected var _exit:Boolean=true;
    	
    	public function CameraUIController():void{
        }

        public function get exit() : Boolean
        {
            return _exit;
        }

        public function set exit(exit : Boolean) : void
        {
            _exit = exit;
        }
    	
    }
}
