/**
 *============================================================
 * copyright(c) 2011
 * @author  itoz
 * 2011/03/23
 *============================================================
 */
package com.romatica.utils
{
    import jp.shichiseki.exif.IFD;
    import jp.shichiseki.exif.ExifInfo;
    /**
     *  ExifConvert.as
     */
    public class ExifConvert
    {
        public static function object(exif : ExifInfo,debug:Boolean = false) : Object
        {
            var obj : Object=new Object();
            if (exif.ifds.primary) {
                obj["primary"] = createInfoObject(exif.ifds.primary);
            }
            if (exif.ifds.exif) {
                obj["exif"] = createInfoObject(exif.ifds.exif);
            }
            if (exif.ifds.gps) {
                // sectionArr.push({"sectionTtitle":"gps", "arr":createInfo(exif.ifds.gps)});
                obj["gps"] = createInfoObject(exif.ifds.gps);
            }
            if (exif.ifds.interoperability) {
                obj["interoperability"] = createInfoObject(exif.ifds.interoperability);
                // sectionArr.push({"sectionTtitle":"interoperability", "arr":createInfo(exif.ifds.interoperability)});
            }
            if (exif.ifds.thumbnail) {
                obj["thumbnail"] = createInfoObject(exif.ifds.thumbnail);
            }
            if (debug) {
                for (var i : String in obj) {
                    trace("[ " + i + " ] --------------------------------------------/" + "\n");
                    var underObj : Object = obj[i];
                    for (var j : String in underObj) {
                        trace(j + " / " + underObj[j] + "\n");
                    }
                }
            }
            return obj;
        }

        private  static  function createInfoObject(ifd : IFD) : Object
        {
            if (!ifd) return null;
            var obj : Object =new Object();
            for (var entry:String in ifd) {
                obj[entry] = ifd[entry];
               
            }
            return obj;
        }
        
        // ======================================================================
        /**
         * 回転補正　　　　
         */
        //
        public static function rotateAngle(_orientation : int) : int
        {
            var rotateAngle : int;

            switch(_orientation) {
                case 1:
                    // _orientLabel.text += ( _orientation + " : 通常");
                    rotateAngle = 0;
                    break;
                case 2:
                    // _orientLabel.text += (_orientation + " : 左右反転");
                    break;
                case 3:
                    // _orientLabel.text += (_orientation + " : 180°回転");
                    rotateAngle = 180;
                    break;
                case 4:
                    // _orientLabel.text += (_orientation + " : 上下反転");
                    break;
                case 5:
                    // _orientLabel.text += (_orientation + " : 上下反転 > 時計回りに90°回転 ");
                    break;
                case 6:
                    // _orientLabel.text += (_orientation + " : 反時計回りに90°回転");
                    rotateAngle = 90;
                    break;
                case 7:
                    // _orientLabel.text += (_orientation + " : 上下反転 > 反時計回りに90°回転 ");
                    break;
                case 8:
                    // _orientLabel.text += (_orientation + " : 時計回りに90°回転");
                    rotateAngle = -90;
                    break;
                default :
                    // _orientLabel.text += (_orientation + " : 回転情報がありません");
                    rotateAngle = 0;
                    break;
            }
            return rotateAngle;
        }


//        public static function array(exif : ExifInfo) : Array
//        {
//        	 var sectionArr : Array = [];
//            if (exif.ifds.primary) {
//                sectionArr.push({"title":"primary", "arr":createInfoArray(exif.ifds.primary)});
//            }
//            if (exif.ifds.exif) {
//                sectionArr.push({"title":"exif", "arr":createInfoArray(exif.ifds.exif)});
//            }
//            if (exif.ifds.gps) {
//                sectionArr.push({"title":"gps", "arr":createInfoArray(exif.ifds.gps)});
//            }
//            if (exif.ifds.interoperability) {
//                sectionArr.push({"title":"interoperability", "arr":createInfoArray(exif.ifds.interoperability)});
//            }
//            if (exif.ifds.thumbnail) {
//                sectionArr.push({"title":"thumbnail", "arr":createInfoArray(exif.ifds.thumbnail)});
//            }
//            return sectionArr;
//        }
//
//        // ======================================================================
//        /**
//         * Exif 情報を配列に
//         */
//        private  static  function createInfoArray(ifd : IFD) : Array
//        {
//            if (!ifd) return null;
//            var arr : Array = [];
//            for (var entry:String in ifd) {
//                arr.push({"label":entry + "    :    " + ifd[entry]});
//                // trace(entry + ":" + ifd[entry]);
//                // if (entry == "Orientation") {
//                // //                    _orientation = ifd[entry];// 回転方向
//                // }
//            }
//            return arr;
//        }
        
    }
}
