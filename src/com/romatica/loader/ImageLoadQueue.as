/**
 * -------------------------------------------------------
 * copyright(c). romatica.com
 * @author itoz (http://www.romatica.com/)
 * @version 2.0
 * -------------------------------------------------------
 */
package com.romatica.loader
{
	import com.romatica.events.ImageLoadQueueEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	/**
	 * 複数画像を非同期で順にロードしていくImageLoadQueue(イメージロードキュー)クラス.
	 * <p>大量の画像ロード時、一気にロードすると高負荷になるので、非同期で一つづつLoadしたい時など</p>
	 * 
	 * <ul>
	 * <li>（シングルトンなので）どの階層からでも、キューに追加でき、読み込まれた画像はグローバルに保管されどこからでも取得できる。</li>
	 * <li>途中ロードエラーが起きてもスキップして順次ロードする（どのURLでエラーが起きたか取得可能）。</li>
	 * <li>ロード完了時、コンプリートイベントで「画像のコピー」を返す（グローバルに保管された画像は変更されない）。</li>
	 * <li>ロード完了済URLをadd()した場合、保管された画像のコピーがコンプリートイベントで返される。</li>
	 * <li>同じURLを複数add()した場合、登録された全てのリスナー関数が同時実行される。
	 *   （例えばhoge.jpgを3回add()すると、1番目がロード完了後、3つのコンプリートリスナー関数が同時実行される）</li>
	 * <li>任意のタイミングでロードストップできる。</li>
	 * </ul>
	 * 
	 * @example :3枚の画像を読み込んでランダム位置に表示 
	 *  <listing version="3.0">
	 * _imageLoadQueue = ImageLoadQueue.getInstance();
	 * _imageLoadQueue.debug=false;//トレース確認したい時true
	 * _imageLoadQueue.add("images/1.png",onComplete,onProgress,onOpen);
	 * _imageLoadQueue.add("images/2.png",onComplete,onProgress,onOpen);
	 * _imageLoadQueue.add("images/3.png",onComplete,onProgress,onOpen,onError);
	 * _imageLoadQueue.load();
	 * 
	 * private function onComplete(event:ImageLoadQueueEvent):void{
	 * 	trace("[complete] "+event.url)
	 * 	var bm:Bitmap = addChild(new Bitmap(event.bitmapData)) as Bitmap;
	 * 	bm.x = 300 ~~* Math.random();//&#42;
	 * 	bm.y = 300 ~~* Math.random();
	 * 	bm.smooth = true;
	 * }
	 * 
	 * private function onProgress(event:ImageLoadQueueEvent):void{
	 * 	//event.bytesLoaded
	 * 	//event.bytesTotal
	 *  trace("[progress] "+event.url +" : "+event.percent+"%");
	 * }
	 * 
	 * private function onOpen(event:ImageLoadQueueEvent):void{
	 * trace("[open] "+event.url )
	 * }
	 * 
	 * private function onError(event:ImageLoadQueueEvent):void{
	 * trace("[error] "+event.url +"/"+event.text)
	 * }
	 *  </listing>
	 */
	public class ImageLoadQueue 
	{
		public static var instance :  ImageLoadQueue=null;
		private static var callGetInstance:Boolean = false;
		// ********************************************************************** 
		private var _debug:Boolean = false;
		private var _nowLoadURL : String;
		// ********************************************************************** 
		private var _loader : Loader;
		private var _loading : Boolean = false;					// キューが実行中か
		private var _queues : Array;							// キューURL配列。完了後随時消していく
		private var _loadedURLArray : Array;					// 一度でも読み完了したことのあるURL配列
		private var _loadCheckDictionary : Dictionary;			// ロード完了ディクショナリ、URLでアクセスする
		// ********************************************************************** 
		private var _bitmapdataDictionary : Dictionary;
		// ********************************************************************** 
		private var _completeFunctionsDictionary : Dictionary;
		private var _progressFunctionsDictionary : Dictionary;
		private var _openFunctionsDictionary : Dictionary;
		private var _errorFunctionsDictionary : Dictionary;
		// ********************************************************************** 
		
		/**
		 * ImageLoadQueueインスタンスを取得
		 */
		public static function getInstance():ImageLoadQueue{
			if( instance == null ) {
				callGetInstance=true;
				ImageLoadQueue.instance = new ImageLoadQueue();
			}
			return instance;
		}
		
		/**
		 * ImageLoadQueue はシングルトンクラスなので、コンストラクタの直接呼び出しは禁止されています。
		 * 
		 */
		public function ImageLoadQueue()
		{
			if(callGetInstance){
				if(_debug)trace("[CREATE SingleTon ImageLoadQueue]　");
				callGetInstance=false;
				_queues = new Array();
				_bitmapdataDictionary = new Dictionary();
				_loadCheckDictionary = new Dictionary();
				_completeFunctionsDictionary= new Dictionary();
				_progressFunctionsDictionary= new Dictionary();
				_openFunctionsDictionary= new Dictionary();
				_errorFunctionsDictionary= new Dictionary();
				_loadedURLArray = new Array();
			}else{
				throw new Error("ImageLoadQueue はシングルトンクラスなので、コンストラクタの直接呼び出しは禁止されています。ImageLoadQueue.getInstance()して下さい");
			}
		}
		
		// ======================================================================
		/**
		 * ロードキューに追加。
		 * @param url 読み込みURL
		 * @param compFunc コンプリートリスナ関数
		 * @param progressFunc プログレスリスナ関数
		 * @param openFunc オープンリスナ関数
		 * @param errorFunc エラーリスナ関数
		 */
		public function add(url : String, compFunc : Function, progressFunc:Function = null , openFunc:Function=null,errorFunc:Function = null):void
		{
			//if(url=="")return;
			// -----------------------------------------------------------------
			// ▼キューに追加
			if(_completeFunctionsDictionary[url] == undefined) {
				//キューに無い
				_queues.push( url );
				_completeFunctionsDictionary[url] = new Array();
				_progressFunctionsDictionary[url]=new Array();
				_openFunctionsDictionary[url]=new Array();
				_errorFunctionsDictionary[url]=new Array();
			}
			// -----------------------------------------------------------------
			// ▼  コンプリートファンクション配列をディクショナリに追加
			_completeFunctionsDictionary[url].push(compFunc);
			// -----------------------------------------------------------------
			// ▼  プログレスファンクション配列をディクショナリに追加
			if(progressFunc !=null){
				_progressFunctionsDictionary[url].push(progressFunc);
			}
			// -----------------------------------------------------------------
			// ▼  オープンファンクション配列をディクショナリに追加
			if(openFunc !=null){
				_openFunctionsDictionary[url].push(openFunc);
			}
			// -----------------------------------------------------------------
			// ▼  エラーファンクション配列をディクショナリに追加
			if(errorFunc !=null){
				_errorFunctionsDictionary[url].push(errorFunc);
			}
		}
		// ======================================================================
		/**
		 * キューのURLを順に読み込み開始。
		 * load中にloadされても何もしない
		 */
		public function load() : void
		{
			if(_loading) return;
			_loading = true;
			var url : String = _queues[0];
			if(url==null) return;
			_nowLoadURL =url;
			 //すでにロード完了している
			 if(_loadCheckDictionary[url]!=undefined){
				if(!_loadCheckDictionary[url]) {
					if(_debug)trace( "[ALREADY LOADED!] : " + url );
					_doCompleteFunctions(url);	// URLに紐づくコンプリートファンクションすべて実行
					_deleteHeadQueue();			// キューの先頭削除
					_checkNextQueue();			//次のキューあるか？
					return;
				}
			}
			//ロード完了していない
			_loadCheckDictionary[url]=false;	//ロード完了待ち
			if(_loader == null){
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, _loadCompleteHandler );
				_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, _loadErrorHandler );
				_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, _loadProgressHandler );
				_loader.contentLoaderInfo.addEventListener( Event.OPEN, _loadOpenHandler );
			}
			_loader.load( new URLRequest( _queues[0] ), new LoaderContext( true ) );
			if(_debug)trace("▼読み込み開始　"+_nowLoadURL+"   /");
		}

	
		// ======================================================================
		/**
		 * 引数のURLを読み込み中止する。
		 * URLが、ロード前ならキューから削除、ロード中ならロードスキップ、ロード済みなら何もしない。
		 * @param url 
		 */
		public function stop(url : String) : void
		{
			if(_debug)trace("	------------------------------------- /");
			if(_debug)trace("	▽キューから削除スタート　="+url+"  /");
			// urlがキューにあるか？
			var find:Boolean =false;
			for (var i : int = 0; i < _queues.length; i++) {
				var _checkURL:String = _queues[i];
				if(_checkURL == url){
					if(_debug)trace("	キューに "+url+" が見つかりました ");
					find=true;
					//　▼ロード完了記録を破棄
					_loadCheckDictionary[url] =null;
					delete _loadCheckDictionary[url];
					//　▼コンプリートファンクションを消す
					_completeFunctionsDictionary[url] = null;
					delete _completeFunctionsDictionary[url] ;
					//　▼プログレスファンクションを消す
					_progressFunctionsDictionary[url] = null;
					delete _progressFunctionsDictionary[url] ;
					//　▼オープンファンクションを消す
					_openFunctionsDictionary[url] = null;
					delete _openFunctionsDictionary[url] ;
					//　▼エラーファンクションを消す
					_errorFunctionsDictionary[url] = null;
					delete _errorFunctionsDictionary[url] ;
					//　▼今読み込み中？
					if(url ==_nowLoadURL){
						if(_debug)trace("		▽まさしく今読み込み中だった ");
						if(_debug)trace("			ローダークローズする ");
						//@see　http://blog.img8.com/archives/2008/11/004211.html
						if (_loader.contentLoaderInfo && _loader.contentLoaderInfo.bytesLoaded <_loader.contentLoaderInfo.bytesTotal)
						{
							_loader.close();
						}
						_loader.unload();
						if(_debug)trace("			ローダー消す/");
						_loaderRemoveEventListeners();
						_loader=null;
						if(_debug)trace("		　	キュー先頭から抜く/");
						_deleteHeadQueue();
						if(_debug)trace("	次のキューあるかチェック/");
						_checkNextQueue();
					}else{
						if(_debug)trace("		▽今読み込み中ではない 　 /");
						// ▼キューから削除
						var queues:Array =_queues.slice();
						var splitArr:Array=queues.splice(i);
						splitArr.shift();
						_queues=queues.concat(splitArr);
					}
					if(_debug)trace("	[×]キューから削除しました　="+url+"  /");
					if(_debug)trace("	------------------------------------- /");
					return;
				}
			}
			if(!find){
				if(_debug)trace("	キューに "+url+" は見つかりませんでした ");
			}
			if(_debug)trace("	------------------------------------- /");
		}
		// ======================================================================
		/**
		 * すべてのロードを停止し、キューも削除する
		 */
		public function allStop() : void
		{
			if(_debug)trace( "	▽[ALL STOP] : すべてのロードを停止スタート"  );
			_loaderRemoveEventListeners();
			for (var i : int = 0; i < _queues.length; i++) {
				var trgURL:String = _queues[i];
				_queues[i]=null;
				stop(trgURL);
			}
			_queues=new Array();
			if(_debug)trace( "	◇[ALL STOP] : すべてのロードを停止しました" );
		}

		// ======================================================================
		/**
		 * 全てのロードを停止し、キューも削除し、保持しているすべてのBitmapを解放する
		 */
		public function allClear() : void
		{
			if(_debug)trace( "▽[ALL BitmapData Dispose] : 保持しているすべての画像Disposeスタート"  );
			allStop();
			for (var i : int = 0; i < _loadedURLArray.length; i++) {
				var trgBMD:BitmapData = _bitmapdataDictionary[_loadedURLArray[i]] as BitmapData;
				if(trgBMD != null){
					trgBMD.dispose();
					if(_debug)trace( trgBMD+"をdisposeしました");
				}
			}
			_loadedURLArray=new Array();
			if(_debug)trace( "◇[ALL BitmapData Dispose] : 保持しているすべての画像Dispose完了"  );
		}
		// _____________________________________________________________________
		//　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
		//　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　ローダーイベントリムーブ & 消去 
		//　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
		private function _loaderRemoveEventListeners():void{
			if(_loader !=null){
				if(_loader.contentLoaderInfo.hasEventListener( Event.COMPLETE)){
					_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, _loadCompleteHandler );
				}
				if(_loader.contentLoaderInfo.hasEventListener(  IOErrorEvent.IO_ERROR)){
					_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, _loadErrorHandler );
				}
				if(_loader.contentLoaderInfo.hasEventListener( ProgressEvent.PROGRESS)){
					_loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, _loadProgressHandler );
				}
				if(_loader.contentLoaderInfo.hasEventListener(Event.OPEN)){
					_loader.contentLoaderInfo.removeEventListener( Event.OPEN, _loadOpenHandler );
				}
				_loader=null;
			}
		}
		
		// _____________________________________________________________________
		//　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
		//　　　　　　　　　　　　　　　　　　　　　　　　      オープンファンクションすべて実行。
		//　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
		private function _loadOpenHandler(event : Event) : void
		{
			if(_debug)trace("[OPEN] : "+_queues[0]);
			var url : String = _queues[0];
			//event
			var open:ImageLoadQueueEvent=new ImageLoadQueueEvent(ImageLoadQueueEvent.OPEN);
			open.url = url;
			//
			if(_openFunctionsDictionary[url] !=null){
				var i:int;
				var max:int = _openFunctionsDictionary[url].length;
				for ( i  = 0; i < max; i++) {
					var openFunc : Function = _openFunctionsDictionary[url][i];
					openFunc(open);
				}
			}
		}
		
		// _____________________________________________________________________
		//　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
		//　　　　　　　　　　　　　　　　　　　　　　　　ロードプログレスファンクションすべて実行。
		//　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
		private function _loadProgressHandler(event : ProgressEvent) : void
		{
			var url:String  =  _queues[0];
			//event
			var progress : ImageLoadQueueEvent = new ImageLoadQueueEvent( ImageLoadQueueEvent.PROGRESS );
			progress.url = url;
			progress.bytesLoaded = event.bytesLoaded ;
			progress.bytesTotal=event.bytesTotal ;
			progress.percent = (event.bytesLoaded / event.bytesTotal * 100);
			if(_progressFunctionsDictionary[url] !=null){
				var i : int;
				var max:int = _progressFunctionsDictionary[url].length;
				for ( i  = 0; i < max; i++) {
					var compFnc:Function = _progressFunctionsDictionary[url][i];
					//登録されているプログレスファンクションを実行
					compFnc(progress);
				}
			}
			if(_debug)trace( "[Progress] :"+ (progress.bytesLoaded/ progress.bytesTotal * 100) + " %　["  + progress.url +"　　/");
		}
		// _____________________________________________________________________
		//
		//　											コンプリートファンクションすべて実行。
		//
		private function _doCompleteFunctions(url:String):void{
			if(_completeFunctionsDictionary[url] !=null){
				var bmd:BitmapData = _bitmapdataDictionary[url];
				var i : int;
				var max:int = _completeFunctionsDictionary[url].length;
				for ( i  = 0; i < max; i++) {
					//event
					var complete : ImageLoadQueueEvent = new ImageLoadQueueEvent( ImageLoadQueueEvent.COMPLETE );
					complete.url = url;
					complete.bitmapData = bmd.clone();//BitmapDataの複製
					var compFunc:Function = _completeFunctionsDictionary[url][i];
					//コンプリート関数実行。
					compFunc(complete);
				}
			}
			_deleteFunctions(url);
		}
		// _____________________________________________________________________
		//
		//　											　　URLに紐づくリスナをすべて消去。
		//
		private function _deleteFunctions(url:String):void{
			//コンプリートリスナ消す
			if(_completeFunctionsDictionary[url] !=null){
				_completeFunctionsDictionary[url]=null;
				delete _completeFunctionsDictionary[url];
			}
			// プログレスリスナ消す
			if(_progressFunctionsDictionary[url] !=null){
				_progressFunctionsDictionary[url] = null;
				delete _progressFunctionsDictionary[url];
			}
			// オープンリスナ消す
			if(_openFunctionsDictionary[url] !=null){
				_openFunctionsDictionary[url] = null;
				delete _openFunctionsDictionary[url];
			}
			// エラーリスナ消す
			if(_errorFunctionsDictionary[url] !=null){
				_errorFunctionsDictionary[url] = null;
				delete _errorFunctionsDictionary[url];
			}
		}
			
		// _____________________________________________________________________
		//　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
		//　　　　　　　　　　　　　　　　　　　　　　　　      エラーファンクションすべて実行。
		//　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
		private function _loadErrorHandler(event : IOErrorEvent) : void
		{
			var url : String = _queues[0];
			if(_debug)trace( "[×]LOAD ERROR: " + url +"　　が読み込めませんでした"+"   /");
			//event
			var error:ImageLoadQueueEvent=new ImageLoadQueueEvent(ImageLoadQueueEvent.ERROR);
			error.url = url;
			error.text = event.text;
			//
			if(_errorFunctionsDictionary[url] !=null){
				var i:int;
				var max:int = _errorFunctionsDictionary[url].length;
				for ( i  = 0; i < max; i++) {
					var errorFunc : Function = _errorFunctionsDictionary[url][i];
					errorFunc(error);
				}
			}
			stop(url);
		}
		// _____________________________________________________________________
		//
		// 　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　ロードイベント
		//
		private function _loadCompleteHandler(event : Event) : void
		{
			if(_debug)trace("	●読み込み完了 ="+_nowLoadURL+"   /"+_loader);
			var url : String = _queues[0];
			var bmd : BitmapData = Bitmap( _loader.content ).bitmapData;
			_loadCheckDictionary[url] = true; // ロード完了を記録
			_bitmapdataDictionary[url] = bmd; // イメージを保持
			_loadedURLArray .push(url) ;
			_doCompleteFunctions(url);// URLに紐づく、コンプリートアクション全てを実行
			_deleteHeadQueue();// キューの先頭削除
			_checkNextQueue();//次のキューあるか？
		}
		
		// _____________________________________________________________________
		//　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
		//　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　  　キューの先頭を削除
		//　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
		private function _deleteHeadQueue():void
		{
			_queues.shift(); // キューから削除
			_nowLoadURL=null; 
		}
		// _____________________________________________________________________
		//
		// 　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　次のキューがあるか？
		private function _checkNextQueue():void{
			_loading = false;
			if(_debug)trace( '[?] 次のキューがあるか >' + (_queues[0] ) );
			if(_queues.length != 0) {
				load();	
			} else {
				if(_debug)trace( "◆ [COMPLETE QUEUE!]" );
				_loaderRemoveEventListeners();//ローダーとイベント消す
				_loader=null;
			}
		}
		// _____________________________________________________________________
		/**
		 * ロード状況をトレース確認
		 */
		public function set debug(debug : Boolean) : void
		{
			_debug = debug;
		}
	}
}