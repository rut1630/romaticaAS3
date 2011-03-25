/**
 *============================================================
 * copyright(c) 2011 www.romatica.com
 * @author  itoz
 * 2011/03/25
 *============================================================
 */
package com.romatica.air.android.cameraroll
{
    import com.romatica.air.android.event.CameraRollEvent;
    import flash.display.BitmapData;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.media.CameraRoll;

    /**
     *  CameraRollModel.as
     */
    public class CameraRollModel extends EventDispatcher
    {
        private var _cameraRoll : CameraRoll;
        public function CameraRollModel(target : IEventDispatcher = null)
        {
            super(target);
        }
        
        // ======================================================================
        /**
         * カメラロールに保存
         */
        public function save(bitmapData : BitmapData) : void
        {
            if (_cameraRoll == null) {
                // ★カメラロール作成
                _cameraRoll = new CameraRoll();
            }
            // 　保存
            if (CameraRoll.supportsAddBitmapData) {
            	_cameraRoll.addEventListener(Event.COMPLETE, onImageSaveComplete);
            	_cameraRoll.addEventListener(ErrorEvent.ERROR, onImageSaveError);
                _cameraRoll.addBitmapData(bitmapData);
               
            }else{
            	//この機種ではCameraRollに保存できません
            	dispatchEvent(new CameraRollEvent(CameraRollEvent.SAVE_ERROR));
            }
        }

        // ======================================================================
        //
        // 画像CameraRollに保存完了
        //
        private function onImageSaveComplete(event : Event) : void
        {
            dispatchEvent(new CameraRollEvent(CameraRollEvent.SAVE_SUCCESS))
        }

        // ======================================================================
        //
        // 画像CameraRollに保存エラー
        //
        private function onImageSaveError(event : ErrorEvent) : void
        {
            dispatchEvent(new CameraRollEvent(CameraRollEvent.SAVE_ERROR))
        }
    }
}
