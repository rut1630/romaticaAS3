/**
 * -------------------------------------------------------
 * copyright(c). romatica.com
 * @author itoz
 * @version 0.1
 * -------------------------------------------------------
 */
package com.romatica.utils
{
	import flash.errors.IllegalOperationError;

	/**
	 * 数値ユーティリティクラス
	 */
	public class NumUtil
	{
		public function NumUtil() : void
		{
			throw new IllegalOperationError( "NumUtil class can not create instance." );
		}

		/**
		 * uintを指定した桁数分0を加えた文字列を返す.
		 * @example :
		 * <listing version="3.0">
		 * trace(NumUtil.addZero(1,5));//出力　00001
		 * trace(NumUtil.addZero(10,5));//出力　00010
		 * </listing>
		 */
		public static function addZero (n : uint , reed : int) : String
		{
			var result : String = "";
			var nleng : int = String( n ).length;
			for (var i : int = 0; i < (reed) - nleng; i++) {
				result += "0";
			}
			result += String( n );

			return result;
		}
	}
}
