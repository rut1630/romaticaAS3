/**
 * -------------------------------------------------------
 * copyright(c). romatica.com
 * @author itoz
 * @version 1.0
 * -------------------------------------------------------
 */
package com.romatica.utils
{
	import flash.net.SharedObject;
	/**
	 * CheckAccessTimeFromShardObject
	 * 前回のアクセスから指定時間以上経過したか確認する。
	 * @see http://wonderfl.net/c/gdbi
	 */
	public class AccessTimeCheck
	{
		
		public function AccessTimeCheck():void{}
		// **********************************************************************
		/**
		 * @param 	str 		ShardObjectを判別するID		 * @param 	min 		単位分　この時間経過したかどうか調べる
		 * @return 	Boolean  	min分以内だとtrue　min分以上or初アクセスだとfalse　
		 */
		public static function check(str:String,min:Number):Boolean{
			var bool : Boolean;
			// 初めてのアクセスか判断
			var so:SharedObject = SharedObject.getLocal( str );
			if (so.data.savedValue == undefined) {
				bool = false;
			} else {
				// 前回アクセスから今回アクセスの時間差(分)を取得
				var nowDate : Date = new Date();
				var nowTime : Number = nowDate.getTime();
				var preTime : Number = so.data["accessTime"];
				var diffTime : Number = (nowTime - preTime) / 1000 / 60;
				//Logger.info( "[前回からの時間差(分)] " + (diffTime) );
				if(diffTime < min) {
					// min分以内なら
					bool = true;
				} else {
					// min分以上なら
					bool = false;
				}
			}
			// so再セット
			so.data.savedValue = str;
			var now : Date = new Date();
			so.data["accessTime"] = now.getTime();
			//
			return bool;
		}
		
		// **********************************************************************
		/**
		 * shardObjectを消去
		 * @param str 消去したいShardObjectのID
		 */
		public static function clear (str : String) : void
		{
			var so : SharedObject = SharedObject.getLocal( str );
			if (so.data.savedValue != undefined)
				delete so.data.savedValue;
		}
	}
}
