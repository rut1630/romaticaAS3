/**
 *============================================================
 * copyright(c). romatica.com
 * @author  itoz
 * @version 0.0.1 2011.1.17
 *============================================================
 *2011.3.24  correctExifOrientメソッド追加　：eixfのOrientation(回転情報)から、正の位置に補正したBitmapDataを返す.
 */
package com.romatica.utils
{
    import flash.display.BitmapData;
    import flash.errors.IllegalOperationError;
    import flash.geom.Matrix;
	/**
	 * ビットマップデータユーティリティクラス
	 */
	public class BitmapDataUtil
	{
		public function BitmapDataUtil ()
		{
			throw new IllegalOperationError( "this class can not create instance." );
		}

		/**
		 * BMDの縦か横の長いほうを基準に、指定した値まで（比率はそのままに）リサイズしたBMDを返す
		 */
		public static function reseizeKeepRatio (trgBMD : BitmapData , size : int) : BitmapData
		{
			var bmdW 	: uint	 = trgBMD.width;		//ターゲットBMDの幅
			var bmdH 	: uint	 = trgBMD.height;		//ターゲットBMDの高さ
			var maxLeng : Number = (bmdW > bmdH ) ? bmdW : bmdH;	//ターゲットのどちらか長いほう
			var magnif 	: Number = size / maxLeng;					// 縮小率
			//
			var ww : Number = trgBMD.width  * magnif; //実際適用する幅サイズ
			var hh : Number = trgBMD.height * magnif; //実際適用する高さサイズ

			var bmd:BitmapData = new BitmapData( size, size, true, 0x00ffffff );
			bmd.draw( trgBMD, new Matrix( magnif, 0, 0, magnif, (size / 2 - ww / 2), (size / 2 - hh / 2) ) ,null,null,null,true);
			return bmd;
		}
		
        /**
         * EixfのOrientation(回転情報)から、正の位置に補正したBitmapDataを返す.
         * @param bitmapData 補正前のBitmapData
         * @param exifOrient　exifのOrient情報 1~6
         * @see http://sylvana.net/jpegcrop/exif_orientation.html
         */
        public static function correctExifOrient(bitmapData : BitmapData, exifOrient : int) : BitmapData
        {
            var correctBMD : BitmapData;
            var mat : Matrix = new Matrix();
            switch(exifOrient) {
                case 2:
                    // trace(exifOrient  + " : 左右反転している");
                    correctBMD = new BitmapData(bitmapData.width, bitmapData.height);
                    mat.a = -1;
                    mat.translate(bitmapData.width, 0);
                    break;
                case 3:
                    // trace(exifOrient  + " : 180°回転している");
                    correctBMD = new BitmapData(bitmapData.width, bitmapData.height);
                    mat.rotate(180 * (Math.PI / 180));
                    mat.translate(bitmapData.width, bitmapData.height);
                    break;
                case 4:
                    // trace(exifOrient + " : 上下反転している");
                    correctBMD = new BitmapData(bitmapData.width, bitmapData.height);
                    mat.d = -1;
                    mat.translate(0, bitmapData.height);
                    break;
                case 5:
                    // trace(exifOrient + " : 上下反転 > 時計回りに90°回転している ");
                    correctBMD = new BitmapData(bitmapData.height, bitmapData.width);
                    mat.a = -1;
                    mat.rotate(-90 * (Math.PI / 180));
                    break;
                case 6:
                    // trace(exifOrient + " : 反時計回りに90°回転している");
                    correctBMD = new BitmapData(bitmapData.height, bitmapData.width);
                    mat.rotate(90 * (Math.PI / 180));
                    mat.translate(bitmapData.height, 0);
                    break;
                case 7:
                    // trace(exifOrient  + " : 上下反転 > 反時計回りに90°回転 している");
                    correctBMD = new BitmapData(bitmapData.height, bitmapData.width);
                    mat.d = -1;
                    mat.rotate(-90 * (Math.PI / 180));
                    mat.translate(bitmapData.height, bitmapData.width);
                    break;
                case 8:
                    // trace(exifOrient  + " : 時計回りに90°回転している");
                    correctBMD = new BitmapData(bitmapData.height, bitmapData.width);
                    mat.rotate(-90 * (Math.PI / 180));
                    mat.translate(0, bitmapData.width);
                    break;
                default :
                    // trace(exifOrient + " :通常 or 回転情報がありません");
                    correctBMD = new BitmapData(bitmapData.width, bitmapData.height);
                    break;
            }
            correctBMD.draw(bitmapData, mat);
            return correctBMD;
        }
	}
}
