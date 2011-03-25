/**
 *============================================================
 * copyright(c) 2011 www.romatica.com
 * @author  itoz
 * 2011/03/25
 *============================================================
 */
package com.romatica.air.android.cameraui
{
    import com.romatica.air.android.event.CameraUIEvent;

    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MediaEvent;
    import flash.media.CameraUI;
    import flash.media.MediaPromise;
    import flash.media.MediaType;

    /**
     *  CameraUIView.as
     */
    public class CameraUIView extends Sprite
    {
        protected var _loadedBMD : BitmapData;
        private var _cameraUI : CameraUI;
        protected var _model : CameraUIModel;
        protected var _controller : CameraUIController;

        public function CameraUIView(model : CameraUIModel,controller:CameraUIController)
        {
            addEventListener(Event.ADDED_TO_STAGE, onInit);
            _model = model;
            _model.addEventListener(CameraUIEvent.IMAGE_LOAD_COMPLETE, onImageLoadComplete);
            _controller = controller;
            
        }

        // ======================================================================
        /**
         * 初期化
         */
        private function onInit(event : Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onInit);
        }

        // ======================================================================
        /**
         * CameraUIを起動
         */
         public  function setCameraUI() : void
        {
            _cameraUI = new CameraUI();
            _cameraUI.addEventListener(ErrorEvent.ERROR, onIOError);
            _cameraUI.addEventListener(MediaEvent.COMPLETE, returnCameraUI);
            _controller.exit = false;
            _cameraUI.launch(MediaType.IMAGE);
        }

        // ======================================================================
        /**
         * CameraUIから戻ってきた　　
         */
         protected function returnCameraUI(event : MediaEvent) : void
        {
            _controller.exit = true;
            _cameraUI.removeEventListener(ErrorEvent.ERROR, onIOError);
            _cameraUI.removeEventListener(MediaEvent.COMPLETE, returnCameraUI);
            var mediapromise : MediaPromise = event.data as MediaPromise;
            _model.load(mediapromise);
        }

        // ======================================================================
        /**
         * CameraUI error
         */
        protected function onIOError(event : IOErrorEvent) : void
        {
            // _tf.text = String(event);
        }
        
        // ======================================================================
        /**
         * 撮影画像が読み込み完了した
         */
        protected function onImageLoadComplete(event : CameraUIEvent) : void
        {
            _loadedBMD = event.bitmapData;
        }

        // ======================================================================
        /**
         * リテイク　　
         */
        protected function retake() : void
        {
            clearBMD();
            setCameraUI();
        }

        // ======================================================================
        /**
         * ビットマップデータクリア
         */
        private function clearBMD() : void
        {
            if (_loadedBMD != null) {
                _loadedBMD.dispose();
                _loadedBMD = null;
            }
        }

        // ======================================================================
        /**
         * リムーブ
         */
        protected function remove() : void
        {
            clearBMD();
        }
    }
}
