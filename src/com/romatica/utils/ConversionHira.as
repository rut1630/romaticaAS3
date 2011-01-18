/**
 *============================================================
 * copyright(c). 
 * @author  itoz
 *============================================================
 *
 */
package com.romatica.utils
{
	public class ConversionHira
    {
        private static var __table:Object;
		private static const ROMA_HIRA_TABLE : Object = {
            a:"あ",  i:"い",  u:"う",  e:"え",  o:"お",
            
            ka:"か", ki:"き", ku:"く", ke:"け", ko:"こ",
            kya:"きゃ", kyi:"きぃ", kyu:"きゅ", kye:"きぇ", kyo:"きょ",
            kwa:"くぁ", kwi:"くぃ",            kwe:"くぇ", kwo:"くぉ",
            
            ga:"が", gi:"ぎ", gu:"ぐ", ge:"げ", go:"ご",
            gya:"ぎゃ", gyi:"ぎぃ", gyu:"ぎゅ", gye:"ぎぇ", gyo:"ぎょ",
            gwa:"ぐぁ",
            
            sa:"さ", si:"し", su:"す", se:"せ", so:"そ",
            sya:"しゃ", syi:"しぃ", syu:"しゅ", sye:"しぇ", syo:"しょ",
            sha:"しゃ", shi:"し", shu:"しゅ", she:"しぇ", sho:"しょ",
            
            za:"ざ", zi:"じ", zu:"ず", ze:"ぜ", zo:"ぞ",
            zya:"じゃ", zyi:"じぃ", zyu:"じゅ", zye:"じぇ", zyo:"じょ",
            
            ta:"た", ti:"ち", tu:"つ", te:"て", to:"と",
            tya:"ちゃ", tyi:"ちぃ", tyu:"ちゅ", tye:"ちぇ", tyo:"ちょ",
            twa:"とぁ", twi:"とぃ", twu:"とぅ", twe:"とぇ", two:"とぉ",
            tsa:"つぁ", tsi:"つぃ", tsu:"つ", tse:"つぇ", tso:"つぉ",
            tha:"てゃ", thi:"てぃ", thu:"てゅ", the:"てぇ", tho:"てょ",
            
            da:"だ", di:"ぢ", du:"づ", de:"で", "do":"ど",
            dya:"ぢゃ", dyi:"ぢぃ", dyu:"ぢゅ", dye:"ぢぇ", dyo:"ぢょ",
            dwa:"どぁ", dwi:"どぃ", dwu:"どぅ", dwe:"どぇ", dwo:"どぉ",
            dha:"でゃ", dhi:"でぃ", dhu:"でゅ", dhe:"でぇ", dho:"でょ",
            
            na:"な", ni:"に", nu:"ぬ", ne:"ね", no:"の",
            nya:"にゃ", nyi:"にぃ", nyu:"にゅ", nye:"にぇ", nyo:"にょ",
            nn:"ん",
            
            ha:"は", hi:"ひ", hu:"ふ", he:"へ", ho:"ほ",
            hya:"ひゃ", hyi:"ひぃ", hyu:"ひゅ", hye:"ひぇ", hyo:"ひょ",
            hwa:"ふぁ", hwi:"ふぃ",          hwe:"ふぇ", hwo:"ふぉ",
            
            ba:"ば", bi:"び", bu:"ぶ", be:"べ", bo:"ぼ",
            bya:"びゃ", byi:"びぃ", byu:"びゅ", bye:"びぇ", byo:"びょ",
            
            pa:"ぱ", pi:"ぴ", pu:"ぷ", pe:"ぺ", po:"ぽ",
            pya:"ぴゃ", pyi:"ぴぃ", pyu:"ぴゅ", pye:"ぴぇ", pyo:"ぴょ",
            
            ma:"ま", mi:"み", mu:"む", me:"め", mo:"も",
            mya:"みゃ", myi:"みぃ", myu:"みゅ", mye:"みぇ", myo:"みょ",
            
            ya:"や", yi:"い", yu:"ゆ", ye:"いぇ", yo:"よ",
             
            ra:"ら", ri:"り", ru:"る", re:"れ", ro:"ろ",
            rya:"りゃ", ryi:"りぃ", ryu:"りゅ", rye:"りぇ", ryo:"りょ",
            
            wa:"わ", wi:"うぃ", wu:"う", we:"うぇ", wo:"を",
            wyi:"ゐ", wye:"ゑ",
            
            ca:"か", ci:"し", cu:"く", ce:"せ", co:"こ",
            cya:"ちゃ", cyi:"ちぃ", cyu:"ちゅ", cye:"ちぇ", cyo:"ちょ",
            cha:"ちゃ", chi:"ち", chu:"ちゅ", che:"ちぇ", cho:"ちょ",
            
            va:"ゔぁ", vi:"ゔぃ", vu:"ゔ", ve:"ゔぇ", vo:"ゔぉ",
            vya:"ゔゃ", vyi:"ゔぃ", vyu:"ゔゅ", vye:"ゔぇ", vyo:"ゔょ",
            
            qa:"くぁ", qi:"くぃ", qu:"く", qe:"くぇ", qo:"くぉ",
            
            fa:"ふぁ", fi:"ふぃ", fu:"ふ", fe:"ふぇ", fo:"ふぉ",
            fya:"ふゃ", fyi:"ふぃ", fyu:"ふゅ", fye:"ふぇ", fyo:"ふょ",
            
            ja:"じゃ", ji:"じ", ju:"じゅ", je:"じぇ", jo:"じょ",
            jya:"じゃ", jyi:"じ", jyu:"じゅ", jye:"じぇ", jyo:"じょ",
            
            la:"ぁ", li:"ぃ", lu:"ぅ", le:"ぇ", lo:"ぉ",
            lya:"ゃ", lyi:"ぃ", lyu:"ゅ", lye:"ぇ", lyo:"ょ",
            lwa:"ゎ",
            ltu:"っ",
            ltsu:"っ",
            
            xa:"ぁ", xi:"ぃ", xu:"ぅ", xe:"ぇ", xo:"ぉ",
            xya:"ゃ", xyi:"ぃ", xyu:"ゅ", xye:"ぇ", xyo:"ょ",
            xwa:"ゎ",
            xtu:"っ",
            xtsu:"っ"
    	};
    	
        private static function _initTable():void
        {
            __table = ROMA_HIRA_TABLE;
            for (var key:String in __table) {
                var numChars:int = key.length;
                for (var i:int = 1; i < numChars; i++) {
                    __table[key.substr(0, i)] = true;
                }
            }
        }
        
        public static function changeHira(str:String):String
        {
			if (__table == null) {
				_initTable();
			}
            
            //str = str.toLowerCase();//★小文字になおさない！2010.12.27
            
			var currentChar 	: String,
				lastChar 		: String = "",
				pendingChars	: String = "",
//				currentHira 	: String = "",
				result 			: String = "";
            var numChars:int = str.length;

			for (var charIndex : int = 0; charIndex < numChars; charIndex++) {
				lastChar = currentChar;
				currentChar = str.charAt( charIndex );
                
                // irregular
                if (_isAlphabet(currentChar) == false) {
                    result += (pendingChars + currentChar);
                    pendingChars = "";
                    continue;
                }
                
                // correct
                if (__table[pendingChars + currentChar] is String) {
                    result += __table[pendingChars + currentChar];
                    pendingChars = "";
                    continue;
                }
                
                // pending
                if (__table[pendingChars + currentChar] == true) {
                    pendingChars += currentChar;
                    continue;
                }
                
                // tttttttt
                if (currentChar == lastChar && !_isBoin(currentChar)) {
                    result += (pendingChars.length == 1) ?
                        "っ" : 
                        pendingChars.substring(pendingChars.length - 1) + "っ";
                    pendingChars = currentChar;
                    continue;
                }
                
                // wrong
                pendingChars += currentChar;
                do {
                    result += (pendingChars.charAt(0) == "n") ? "ん" : pendingChars.charAt(0);
                    pendingChars = pendingChars.substr(1);
                } while (__table[pendingChars] == false);
                
                if (__table[pendingChars] is String) {
                    result += __table[pendingChars];
                    pendingChars = "";
                }
            }
            result += pendingChars;
            
            return result;
        }
        
        private static function _isBoin(char:String):Boolean
        {
            return (char == "a" ||
                    char == "i" ||
                    char == "u" ||
                    char == "e" ||
                    char == "o");
        }
        
        private static const codeOfa:int = "a".charCodeAt();
        private static const codeOfz:int = "z".charCodeAt();
        
        private static function _isAlphabet(char:String):Boolean
        {
            var code:Number = char.charCodeAt(0);
            return (code >= codeOfa && code <= codeOfz);
        }
    
    }
}

//package com.romatica.utils
//{
//	/**
//	 * 
//	 * <p></p>
//	 * <pre></pre>
//	 * @example :
//	 * <listing version="3.0"></listing>
//	 */
//	public class ConversionHira
//	{
//		
//		
//		private static const ROMAJI:Array = [
//		
//			"a","i","u","e","o"
//			
//			,"ka","ki","ku","ke","ko"
//			,"ga","gi","gu","ge","go"
//
//			,"sa","si","shi","su","se","so"
//			,"za","zi","ji","zu","ze","zo"
//			
//			,"ta","ti","chi","tu","tsu","te","to"
//			,"da","di","du","de","do"
//			,"dha","dhi","dhu","dhe","dho"
//			,"tsa","tsi","tse","tso"
//			,"tha","thi","thu","the","tho"
//			
//			,"na","ni","nu","ne","no"
//			,"ha","hi","hu","fu","he","ho"
//			,"ba","bi","bu","be","bo"
//			,"pa","pi","pu","pe","po"
//			,"fa","fi","fe","fo"
//			
//			,"ma","mi","mu","me","mo"
//			,"ya","yu","yo"
//			,"ra","ri","ru","re","ro"
//			,"wa","wi","we","wo"
//			,"nn"
//			
//			,"va","vi","vu","ve","vo"
//
//			,"kya","kyi","kyu","kye","kyo","kwa"
//			,"gya","gyi","gyu","gye","gyo","gwa"
//
//			,"sha","sya","syi","shu","syu","she","sye","sho","syo"
//			,"zya","ja","zyi","ji","zyu","ju","zye","je","zyo","jo"
//
//			
//			,"tya","cha","tyi","chi","tyu","chu","tye","che","tyo","cho","twu"
//			,"dya","dyi","dyu","dye","dyo","dwu"
//
//			,"nya","nyi","nyu","nye","nyo"
//			
//			,"hya","hyi","hyu","hye","hyo"
//			,"bya","byi","byu","bye","byo"
//			,"pya","pyi","pyu","pye","pyo"
//			
//			,"fya","fyi","fyu","fye","fyo"
//			
//			,"mya","myi","myu","mye","myo"
//			
//			,"rya","ryi","ryu","rye","ryo"
//		]
//		
//		
//		 private static const HIRAGANA : Array = [
//		 
//		 
//		 		"あ","い","う","え","お",
//		 		"か","き","く","け","こ",
//		 		"が","ぎ","ぐ","げ","ご",
//		 		"さ","し","し","す","せ","そ",
//		 		"ざ","じ","じ","ず","ぜ","ぞ",
//		 		"た","ち","ち","つ","つ","て","と",
//		 		"だ","ぢ","づ","で","ど",
//		 		"でゃ","でぃ","でゅ","でぇ","でょ",
//		 		"つぁ","つぃ","つぇ","つぉ",
//		 		"てゃ","てぃ","てゅ","てぇ","てょ",
//		 		"な","に","ぬ","ね","の",
//		 		"は","ひ","ふ","ふ","へ","ほ",
//		 		"ば","び","ぶ","べ","ぼ",
//		 		"ぱ","ぴ","ぷ","ぺ","ぽ",
//		 		"ふぁ","ふぃ","ふぇ","ふぉ",
//		 		"ま","み","む","め","も",
//		 		"や","ゆ","よ",
//		 		"ら","り","る","れ","ろ",
//		 		"わ","うぃ","うぇ","を",
//		 		"ん",
//		 		"ゔぁ","ゔぃ","ゔ","ゔぇ","ゔぉ",
//		 		"きゃ","きぃ","きゅ","きぇ","きょ","くぁ",
//		 		"ぎゃ","ぎぃ","ぎゅ","ぎぇ","ぎょ","ぐぁ",
//		 		"しゃ","しゃ","しぃ","しゅ","しゅ","しぇ","しぇ","しょ","しょ",
//		 		"じゃ","じゃ","じぃ","じぃ","じゅ","じゅ","じぇ","じぇ","じょ","じょ",
//		 		"ちゃ","ちゃ","ちぃ","ちぃ","ちゅ","ちゅ","ちぇ","ちぇ","ちょ","ちょ","とぅ",
//		 		"ぢゃ","ぢぃ","ぢゅ","ぢぇ","ぢょ","どぅ",
//		 		"にゃ","にぃ","にゅ","にぇ","にょ",
//		 		"ひゃ","ひぃ","ひゅ","ひぇ","ひょ",
//		 		"びゃ","びぃ","びゅ","びぇ","びょ",
//		 		"ぴゃ","ぴぃ","ぴゅ","ぴぇ","ぴょ",
//		 		"ふゃ","ふぃ","ふゅ","ふぇ","ふょ",
//		 		"みゃ","みぃ","みゅ","みぇ","みょ",
//		 		"りゃ","りぃ","りゅ","りぇ","りょ"
//		 ];
//		 
//		
//		public static function changeHira(romaji:String):String{
//			var result:String="";
////			trace(romaji.split())
//for (var i : int = 0; i < romaji.length; i++) {
//	romaji[i] ==
//}
////			for (var i : int = 0; i < 5; i++) {
////				ROMAJI[i]
////			}
//			
//			
//			return result;
//			
//			
//		}
//	}
//}
