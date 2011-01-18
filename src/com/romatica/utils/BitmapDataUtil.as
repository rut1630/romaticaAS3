/**
 *============================================================
 * copyright(c). romatica.com
 * @author  itoz
 * @version 0.0.1 2011.1.17
 *============================================================
 *
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
	}
}
