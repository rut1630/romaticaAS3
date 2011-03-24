/**
 *============================================================
 * copyright(c) 2011
 * @author  itoz
 * 2011/03/23
 *============================================================
 */
package com.romatica.air
{
    import flash.utils.ByteArray;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.filesystem.File;
    /**
     *  IOByteArray.as
     *  アプリケーションストレージディレクトリに、
     *  ByteArrayを[保存][取り出し][消去]する。
     */
    public class IOByteArray
    {
    	// ======================================================================
    	/**
    	 * ByteArrayを書きこみ　　　　
    	 */
         public static function write(byteArray : ByteArray, filename : String) : void
        {
            var appStorageDir : File = File.applicationStorageDirectory;
            var f : File = appStorageDir.resolvePath( filename);
            var s : FileStream = new FileStream();
            try {
                s.open(f, FileMode.WRITE);
                s.writeBytes(byteArray);
            } catch(e : Error) {
            	 e.message = "[ERROR IOByteArray.write] " + e.message;
                throw e;
            } finally {
                s.close();
            }
        }

        // ======================================================================
        /**
         * ByteArrayを読み込み　　
         */
        public static function read(filename : String) : ByteArray
        {
            var appStorageDir : File = File.applicationStorageDirectory;
            var f : File = appStorageDir.resolvePath(filename);
            var data : ByteArray ;
            var s : FileStream = new FileStream();
            try {
                s.open(f, FileMode.READ);
                data = new ByteArray();
                s.readBytes(data);
            } catch (e : Error) {
//                e.message = "[ERROR IOByteArray.read] " +e.message;
//                throw e;
            } finally {
                s.close();
            }
            return data;
            
        }

        // ======================================================================
        /**
         * 保存されているByteArrayデータを消す　　　　
         */
        public static function clear(filename : String) : void
        {
            var appStorageDir : File = File.applicationStorageDirectory;
            var f : File = appStorageDir.resolvePath(filename);
            try {
                f.deleteFile();
            } catch(e : Error) {
                e.message = "[ERROR IOByteArray.clear] " + e.message;
                throw e;
            }
        }
    }
}
