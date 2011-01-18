/**
 * -------------------------------------------------------
 * copyright(c). romatica.com
 * @author itoz
 * @version 1.0
 * -------------------------------------------------------
 */
package com.romatica.utils{
	import flash.errors.IllegalOperationError;
	/**
	 * Date ユーティリティクラス
	 */
	public class DateUtil
	{
		
		public function DataUitl():void{
			throw new IllegalOperationError("this class can not create instance!");
		}
		
		/**
		 * 2つのDateクラスの差を求め、日、時、分、秒、ミリ秒、を取得.
		 * @data1 ターゲットDate
		 * @data2 対象Date
		 * @debug トレース出力有り無し
		 * @return Object d,h,m,s,msが入っている。
		 * 
		 * @example : 
		 *  <listing version="3.0">
		 *  //現在の時刻から2012/1/1 0:0:0 までの差(日/時/分/秒/ミリ秒)を求める
		 *  import com.romatica.utils.DateUtil;
		 *  var nowDate : Date = new Date();
		 *  var trgDate : Date = new Date( 2012, 1 - 1, 1, 0, 0, 0, 0 );
		 *  var diffDate : Object = DateUtil.diff( trgDate, nowDate, true );
		 *  trace("[残り]"  + diffDate["d"]+"日 " 
		 *  					+ diffDate["h"]+"時間 "
		 *  					+ diffDate["m"]+"分 "
		 *  					+ diffDate["s"]+"秒 "
		 *  					+ diffDate["ms"]+"ミリ秒 ");
		 *  </listing>
		 */
		public static function diff(date1:Date,date2:Date,debug:Boolean = false):Object
		{
			if(debug)trace("-　DIFF DATE　---------------------------");
			var obj:Object=new Object();
			var trg1MillSecond : Number = date1.getTime();
			var trg2MillSecond : Number = date2.getTime();
			
			if(debug)trace("	[ " +date2.getFullYear()+"."
									+(date2.getMonth()+1)+"."
									+date2.getDate()+" / "
									+date2.getHours()+":"
									+date2.getMinutes()+":"
									+date2.getSeconds()+":"
									+date2.getMilliseconds()+" ]"+"　から");
									
			if(debug)trace("	[ " +date1.getFullYear()+"."
									+(date1.getMonth()+1)+"."
									+date1.getDate()+" / "
									+date1.getHours()+":"
									+date1.getMinutes()+":"
									+date1.getSeconds()+":"
									+date1.getMilliseconds()+" ]"+"　まで、残り");
			
			var diffMillSec :Number = trg1MillSecond - trg2MillSecond;// 残り総ミリ秒
			var diffDate :int = diffMillSec / (24*60*60*1000);// 残り総日数
			var diffHour :int = diffMillSec / (60*60*1000);//残り総時間
			var diffMin :int = diffMillSec / (60*1000);//残り総分
			var diffSec : int = diffMillSec / 1000;// 残り総秒
			
			// -----------------------------------------------------------------
			//
			//　　総時間から残りの、日、時、分、秒、ミリ秒に変換
			//
			obj["d"] = diffDate;
			obj["h"] = int( diffHour - (diffDate * 24) );
			obj["m"] = int( diffMin - (diffHour * 60) );
			obj["s"] = int( diffSec - (diffMin * 60) );
			obj["ms"] = int( diffMillSec - (diffSec * 1000) );
			
			if(debug)trace("	[　"+obj["d"]+"日 " 
									+obj["h"]+"時間 "
									+obj["m"]+"分 "
									+obj["s"]+"秒 "
									+obj["ms"]+"ミリ秒"+" ]");
				
			return obj;
		}
	}
}
