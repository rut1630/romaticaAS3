/**
 *============================================================
 * copyright(c) 2011 www.romatica.com
 * @author  itoz
 * 2011/03/25
 *============================================================
 * This class use ExifInfo
 * @see http://code.shichiseki.jp/as3/ExifInfo/
 * @see http://code.shichiseki.jp/as3/ExifInfo/asdoc/index.html
 */
package com.romatica.air.android.cameraui
{
    import jp.shichiseki.exif.ExifInfo;
    import jp.shichiseki.exif.ExifLoader;

    import com.romatica.air.android.event.CameraUIEvent;
    import com.romatica.utils.BitmapDataUtil;
    import com.romatica.utils.ExifConvert;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.media.MediaPromise;
    import flash.net.URLRequest;

    /**
     *  CameraUIModel.as
     */
    public class CameraUIModel extends EventDispatcher
    {
        private var _mediapromise : MediaPromise;
        private var _loaderExif : ExifLoader;
        private var _loaderPhoto : Loader;
        private var _exifObj : Object;
        
        public function CameraUIModel(target : IEventDispatcher = null)
        {
            super(target);
        }

        // ======================================================================
        /**
         * EixfとPhoto ロード開始　　　
         */
        public function load(mp : MediaPromise) : void
        {
            if (_mediapromise != null) {
                _mediapromise.close();
                _mediapromise = null;
            }
            _mediapromise = mp;
            this.addEventListener(CameraUIEvent.EXIF_LOAD_COMPLETE, loadPhotoImage);
            loadExif();
        }

        // ======================================================================
        /**
         * EXIFデータロード開始　　　
         */
        public function loadExif() : void
        {
            // 前のデータがあれば消す
            removeLoader(_loaderExif);
            _loaderExif = null;
            _loaderExif = new ExifLoader();
            _loaderExif.addEventListener(Event.COMPLETE, onExifLoadComplete);
            _loaderExif.load(new URLRequest(_mediapromise.file.url));
        }

        // ======================================================================
        /**
         * EXIFデータロード完了　　　　
         */
        private function onExifLoadComplete(event : Event) : void
        {
            var exif : ExifInfo = _loaderExif.exif ;
            _exifObj = ExifConvert.object(exif, false); // Object形式にパース
            dispatchEvent(new CameraUIEvent(CameraUIEvent.EXIF_LOAD_COMPLETE, null, _exifObj));
        }
        
        // ======================================================================
        /**
         * Exifの回転情報を取得
         */
        public function get orientation() : int
        {
            var orient : int ;
            if (_exifObj != null) {
                // 回転情報
                orient = _exifObj["primary"]["Orientation"];
            }else{
            	orient = NaN;
            }
            return orient;
        }


        // ======================================================================
        /**
         * 撮影画像読み込み開始
         */
        private function loadPhotoImage(event : CameraUIEvent) : void
        {
        	 removeEventListener(CameraUIEvent.EXIF_LOAD_COMPLETE, loadPhotoImage);
            // 前のデータがあれば消す
            removeLoader(_loaderPhoto);
            _loaderPhoto=null;
            _loaderPhoto = new Loader();
            _loaderPhoto.addEventListener(IOErrorEvent.IO_ERROR, loadPhotoError);
            _loaderPhoto.contentLoaderInfo.addEventListener(Event.COMPLETE, onPhotoLoadComplete);
            _loaderPhoto.loadFilePromise(_mediapromise);
        }

        // ======================================================================
        /**
         * 撮影画像読み込み完了
         */
        private function onPhotoLoadComplete(event : Event) : void
        {
            _loaderPhoto.removeEventListener(IOErrorEvent.IO_ERROR, loadPhotoError);
            _loaderPhoto.contentLoaderInfo.removeEventListener(Event.COMPLETE, onPhotoLoadComplete);
            
            var bmd : BitmapData = (_loaderPhoto.content as Bitmap).bitmapData;
            // 　Exifから回転補正
            bmd = BitmapDataUtil.correctExifOrient(bmd, orientation);
        	dispatchEvent(new CameraUIEvent(CameraUIEvent.IMAGE_LOAD_COMPLETE, bmd,_exifObj));
        }

        // ======================================================================
        /**
         * 撮影画像読み込みエラー
         */
        private function loadPhotoError(event : IOErrorEvent) : void
        {
            // trace("撮影画像読み込みに失敗しました");
            dispatchEvent(event);
        }

        // ======================================================================
        /**
         * ExifObjトレース確認
         */
        public function traceExifObj() : void
        {
            if (_exifObj == null) return;
            for (var i : String in _exifObj) {
                trace("[ " + i + " ] --------------------------------------------/" + "\n");
                var underObj : Object = _exifObj[i];
                for (var j : String in underObj) {
                    trace(j + " / " + underObj[j] + "\n");
                }
            }
        }

        // ======================================================================
        /**
         * ローダーを消す
         */
        private function removeLoader(loader : Loader) : void
        {
            if (loader != null) {
                if (loader.contentLoaderInfo && loader.contentLoaderInfo.bytesLoaded < loader.contentLoaderInfo.bytesTotal) {
                    loader.close();
                }
                loader = null;
            }
        }

        // ======================================================================
        /**
         *リムーブ
         */
        public function remove() : void
        {
            removeLoader(_loaderExif);
            removeLoader(_loaderPhoto);
            _loaderExif = null;
            _loaderPhoto = null;
            if (_mediapromise != null) {
                _mediapromise.close();
                _mediapromise = null;
            }
        }
    }
}
