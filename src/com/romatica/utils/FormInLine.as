/** * ------------------------------------------------------- * copyright(c). romatica.com * @author itoz * @version 1.0 * ------------------------------------------------------- *  -2010.8.16　パッケージ変更 */package com.romatica.utils
{
	import flash.errors.IllegalOperationError;	import flash.geom.Point;
		/**	 * 列の縦横に整列させたXとYを返す	 */
	public class FormInLine
	{
		public static var _TD : int;
		// X		public static var _TR : int;
		// Y		public function FormInLine()
		{			throw new IllegalOperationError("this class can not create instance!");		}

		// ////////////////////////////////////////////////////////////////////////////////////////////////////		// ----------------------------------------------------------------------------------------------------		// ＞位置計算		// 		// @paran : ww　　　サムネイル横幅		// @paran : hh　　　サムネイル縦幅		// @paran : ID　　 サムネイルの並び位置（1から数える）		//TODO IDは0から数えるのでは？　あとで確認する。		// @paran : xpcs 　横の最大個数		// @paran : ypcs 　縦の最大個数		// ---------------------------------		// 例）　		// 　　　├ww┤		//  　┬┏━┓		//   hh┃　┃		//  　┴┗━┛		// 　		// 　	├─────４─────┤（xpcs）		// 　　┬┏━┳━┳━┳━┓		// 　　│┃１┃２┃３┃４┃		// 　　│┣━╋━╋━╋━┫		// 　　3┃５┃６┃７┃８┃		// 　　│┣━╋━╋━╋━┫		// 　　│┃９┃10┃11┃12┃		// 　　┴┗━┻━┻━┻━┛		// （ypcs）
		public static function getPoint(ww : Number, hh : Number, ID : int, xpcs : int, ypcs : int):Point
		{
			_TD = Math.floor(ID / xpcs);
			_TR = (ID - (_TD * xpcs));
			return new Point(_TR * ww, _TD * hh);
		}
	}
}