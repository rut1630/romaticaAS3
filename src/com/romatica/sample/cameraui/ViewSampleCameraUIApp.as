/**
 *============================================================
 * copyright(c) 2011 www.romatica.com
 * @author  itoz
 * 2011/03/25
 *============================================================
 */
package com.romatica.sample.cameraui
{
    import com.romatica.air.android.cameraui.CameraUIController;
    import com.romatica.air.android.cameraui.CameraUIModel;
    import com.romatica.air.android.cameraui.CameraUIView;
    import com.romatica.air.android.event.CameraUIEvent;

    import flash.display.Bitmap;
    import flash.text.TextField;


    /**
     * com.romatica.air.android.cameraui 
     * パッケージのサンプル
     */
    public class ViewSampleCameraUIApp extends CameraUIView
    {
        public function ViewSampleCameraUIApp(model : CameraUIModel, controller : CameraUIController)
        {
            super(model, controller);
        }

        // ======================================================================
        /**
         * onImageLoadComplete
         */
        override protected function onImageLoadComplete(event : CameraUIEvent) : void
        {
            super.onImageLoadComplete(event);
            addChild(new Bitmap(_loadedBMD));
            var _tf : TextField = addChild(new TextField()) as TextField;
            _tf.text = _loadedBMD.width + "/" + _loadedBMD.height;
            _tf.scaleX = _tf.scaleY = 3;
            addChild(_tf);
        }
    }
}
