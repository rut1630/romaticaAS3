/**
 * -------------------------------------------------------
 * copyright(c). romatica.com
 * @author itoz
 * @version 1.0
 * -------------------------------------------------------
 * -2010.8.20 パッケージ変更
 * -2011.1.18 スタティックメソッドに変更
 */
package com.romatica.net
{
	import flash.errors.IllegalOperationError;
	import flash.net.LocalConnection;

	/**	 * このswfの場所がサーバーならtrue,ローカルならfalseを返す.	 * @example :	 * var _domain:Boolean =  CheckDomain.check();
	 */
	public class CheckDomain
	{
		function CheckDomain ()
		{
			throw new IllegalOperationError( "this class can not create instance!" );
		}

		// ====================================================================================================		/**
		 * サーバーかローカルか判断
		 *  @return Boolean true:サーバー/false:ローカル
		 */
		public static function check () : Boolean
		{
			var _myURL : String = new LocalConnection().domain;
			var BOOL : Boolean;
			if (_myURL.substr( 0 , 5 ) == "local" ) {
				BOOL = false;// local
			}
			else {
				BOOL = true;// server
			}
			return BOOL;
		}
	}
}