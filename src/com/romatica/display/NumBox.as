/**
 *============================================================
 * copyright(c) 2011
 * @author  itoz
 * 2011/02/28
 *============================================================
 */
package com.romatica.display
{
    import flash.display.IBitmapDrawable;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.display. DisplayObject;
    import flash.display.Sprite;

    /**
     * 画像数字ボックス
     */
    public class NumBox extends Sprite
    {
        private var _imageVec : Vector.<Bitmap>;

        public function NumBox()
        {
            _imageVec = new Vector.<Bitmap>(9);
        }

        // ======================================================================
        /**
         * 0〜9までの数字、DisplayObjectが入った配列を渡す
         * @param arr
         */
        public function setImages(arr : Array) : void
        {
            try {
                for (var i : int = 0; i < 10; i++) {
                    var trg : Object = arr[i] as Object;
                    var bmd : BitmapData = new BitmapData(trg.width, trg.height, true, 0x00ffffff);
                    bmd.draw(trg as IBitmapDrawable);
                    var bm : Bitmap = new Bitmap(bmd,"auto",true);
                    bm.visible = false;
                    addChild(bm);
                    bm.cacheAsBitmap = true;
                    _imageVec[i] = bm;
                }
            } catch(error : Error) {
                trace(error.message);
            }
        }

        // ======================================================================
        /**
         * 数値表示
         * @param n 表示したい数値
         */
        public function goto(n : int) : void
        {
            for (var i : int = 0; i < 10; i++) {
                var bm : Bitmap = _imageVec[i] as Bitmap;
                if (n == i) {
                    bm.visible = true;
                }
                else {
                    bm.visible = false;
                }
            }
        }

        // ======================================================================
        /**
         * remove.
         */
        public function remove() : void
        {
            if (_imageVec != null) {
                for (var i : int = 0; i < _imageVec.length; i++) {
                    var bm : Bitmap = _imageVec[i];
                    if (bm != null) {
                        if (this.contains(bm)) {
                            this.removeChild(bm);
                        }
                        bm.bitmapData.dispose();
                        bm = null;
                    }
                }
            }
            _imageVec=null;
        }
    }
}
