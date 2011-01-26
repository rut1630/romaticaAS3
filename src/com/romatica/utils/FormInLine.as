/** * ------------------------------------------------------- * copyright(c). romatica.com * @author itoz * @version 1.1 * ------------------------------------------------------- *  -2010.8.16　パッケージ変更 *  -2011.1.25 private var _TD _TR 削除 */package com.romatica.utils
{
	import flash.errors.IllegalOperationError;	import flash.geom.Point;
		/**	 * 列の縦横に整列させたXとYを返す	 */
	public class FormInLine
	{
		public function FormInLine()
		{			throw new IllegalOperationError("this class can not create instance!");		}

		// ////////////////////////////////////////////////////////////////////////////////////////////////////		/**		 * [幅]と[高さ]と[表状の位置ID]からPointを取得		 * @paran : ww　　　サムネイル横幅		 * @paran : hh　　　サムネイル縦幅		 * @paran : ID　　 サムネイルの並び位置		 * @paran : xpcs 　横の最大個数		 * ---------------------------------		 * 例）　		 * 		 * 　　　├ww┤		 *  　┬┏━┓		 *   hh┃　┃		 *  　┴┗━┛		 * 　		 * 　	├─────４─────┤（xpcs）		 * 　　┬┏━┳━┳━┳━┓		 * 　　│┃０┃１┃２┃３┃		 * 　　│┣━╋━╋━╋━┫		 * 　　3┃４┃５┃６┃７┃		 * 　　│┣━╋━╋━╋━┫		 * 　　│┃８┃９┃10┃11┃		 * 　　┴┗━┻━┻━┻━┛		  * @example : 		 *  <listing version="3.0">		 * for (var i : int = 0; i < 12; i++) {		 * 	FormInLine.getPoint(50,50,i,4)		 * }		 *  </listing>		 */		public static function getPoint(ww : Number, hh : Number, ID : int, xpcs : int):Point
		{			
			var td:int = Math.floor(ID / xpcs);
			var tr:int = (ID - (td * xpcs));
			return new Point(tr * ww, td * hh);
		}
	}
}