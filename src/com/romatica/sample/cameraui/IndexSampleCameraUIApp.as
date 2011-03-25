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
    import com.romatica.sample.cameraui.ViewSampleCameraUIApp

    import flash.desktop.NativeApplication;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageAspectRatio;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.media.CameraUI;

    /**
     * com.romatica.air.android.cameraui 
     * パッケージのサンプル
     */
    public class IndexSampleCameraUIApp extends Sprite
    {
        private var _model      : CameraUIModel;
        private var _view       : MyCameraUIView;
        private var _controller : CameraUIController;
        public function IndexSampleCameraUIApp()
        {
        	addEventListener(Event.ADDED_TO_STAGE, onAdded);
        }

        private function onAdded(event : Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAdded);
            stage.addEventListener(Event.DEACTIVATE, onDeactivate);
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.setAspectRatio(StageAspectRatio.PORTRAIT);
            if (!CameraUI.isSupported) {
                return;
            }

            _model = new CameraUIModel();
            _controller = new CameraUIController();
            _view = new ViewSampleCameraUIApp(_model, _controller);
            addChild(_view);

            _view.setCameraUI();
        }

        private function onDeactivate(event : Event) : void
        {
            if (_controller.exit) {
                NativeApplication.nativeApplication.exit();
            }
        }
    }
}
