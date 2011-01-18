/**
 * -------------------------------------------------------
 * copyright(c). romatica.com
 * @author itoz
 * @version 1.5
 * -------------------------------------------------------
 *  -2010.12.21 もろもろスタティックに
 * 　-2010.12.21 クラス名変更 ファンクション名変更
 */
package com.romatica.utils
{
	/**
	 * カタカナ文字列　＜-＞　平仮名文字列 相互変換クラス
	 * 該当文字がない場合、スルーして字列を生成しを返す
	 */
	public class MutalConversionKanaHira
	{
		private static const hiraAllString : String = "あいうえお" +
													  "かきくけこ" +
													  "さしすせそ" +
													  "たちつてと" +
													  "なにぬねの" +
													  "はひふへほ" +
													  "まみむめもやゆよらりるれろわをん" +
													  "がぎぐげござじずぜぞだぢづでどばびぶべぼ" +
													  "ぱぴぷぺぽ" +
													  "ぁぃぅぇぉっゃゅょゎー";
		private static const kanaAllString : String = "アイウエオ" +
													  "カキクケコ" +
													  "サシスセソ" +
													  "タチツテト" +
													  "ナニヌネノ" +
													  "ハヒフヘホ" +
													  "マミムメモ" +
													  "ヤユヨ" +
													  "ラリルレロ" +
													  "ワヲン" +
													  "ガギグゲゴザジズゼゾダヂヅデドバビブベボ" +
													  "パピプペポ" +
													  "ァィゥェォッャュョヮー";


		public function MutalConversionKanaHira():void{}
		
		// ======================================================================
		/**
		 * カタカナをひらがなに変換
		 */
		public static function changeHira (katakana : String) : String
		{
			var hiragana : String = "";
			for (var i : int = 0; i < katakana.length; i++) {
				var findNum : int = kanaAllString.indexOf( katakana.charAt( i ) );
				if (findNum != -1) {
					// みつかったら追加
					hiragana += hiraAllString.charAt( findNum );
				}
				else {
					// みつからなかったら、そのまま元を追加
					hiragana += katakana.charAt( i );
				}
			}
			return hiragana;
		}
		
		// ======================================================================
		/**
		 * ひらがなをカタカナに変換
		 */
		public static function changeKana(hiragana : String):String
		{
			var katakana : String = "";
			for (var i : int = 0; i < hiragana.length; i++) {
				var findNum : int = hiraAllString.indexOf( hiragana.charAt( i ) );
				if (findNum != -1) {
					// みつかったら追加
					katakana += kanaAllString.charAt( findNum );
				}
				else {
					// みつからなかったら、そのまま元を追加
					katakana += hiragana.charAt( i );
				}
			}
			return katakana;
		}
	}
}
