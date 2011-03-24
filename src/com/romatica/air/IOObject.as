/**
 * ============================================================
 * copyright(c). romatica.com
 * @author itoz (http://www.romatica.com/)
 * 2011/03/23
 *============================================================
 */
package com.romatica.air
{
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.filesystem.File;
    /**
     *  IOObject.as
     *  アプリケーションストレージディレクトリに、
     *  Objectを[保存][取り出し][消去]する。
     */
    public class IOObject extends Object
    {
    	// ======================================================================
    	/**
    	 * オブジェクトを書きこみ　　　　
    	 */
        public static function write(obj : Object, filename : String) : void
        {
            var appStorageDir : File = File.applicationStorageDirectory;
            var f : File = appStorageDir.resolvePath( filename);
            var s : FileStream = new FileStream();
            try {
                s.open(f, FileMode.WRITE);
                s.writeObject(obj);
            } catch(e : Error) {
            	 e.message = "[ERROR IOObject.write] " + e.message;
                throw e;
            } finally {
                s.close();
            }
        	
        }

        // ======================================================================
        /**
         * オブジェクトを読み込み　　
         */
        public static function read( filename : String) : Object
        {
            var appStorageDir : File = File.applicationStorageDirectory;
            var f : File = appStorageDir.resolvePath(filename);
            var obj : Object;
            var s : FileStream = new FileStream();
            try {
                s.open(f, FileMode.READ);
                obj = s.readObject();
            } catch (e : Error) {
                e.message = "[ERROR IOObject.read] " +e.message;
                throw e;
            } finally {
                s.close();
            }
            return obj;
            
        }

        // ======================================================================
        /**
         * 保存されているデータを消す　　　　
         */
        public static function clear(filename : String) : void
        {
            var appStorageDir : File = File.applicationStorageDirectory;
            var f : File = appStorageDir.resolvePath(filename);
            try {
                f.deleteFile();
            } catch(e : Error) {
                e.message = "[ERROR IOObject.clear] " + e.message;
                throw e;
            }
        }
    }
}