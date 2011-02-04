/** * ------------------------------------------------------- * copyright(c). romatica.com * @author itoz (http://www.romatica.com/) * @version 1.0.4 * ------------------------------------------------------- * -2010.12.22　クラス名を変更 * -2011.1.24  ロード済みURLがaddされたら、即XMLを返すように変更 * -2011.2.3   ロード済みURLがaddされたら、即XMLを返すように変更下部分を削除し、各イベントを全て実行するときforのmaxを動的に取得するように変更 */package com.romatica.loader{	import com.romatica.events.XMLLoadQueueEvent;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.events.ProgressEvent;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.utils.Dictionary;	
	/**	 * 複数のXMLを非同期で順にロードしていくクラス。.	 */
	public class XMLLoadQueue implements ILoadQueue
	{
		public static var instance :  XMLLoadQueue=null;		private static var callGetInstance:Boolean = false;		// ********************************************************************** 		private var _debug:Boolean = false;		private var _nowLoadURL : String;		// ********************************************************************** 		private var _loader : URLLoader;		private var _loading : Boolean = false;					// キューが実行中か		private var _queues : Array;							// キューURL配列。完了後随時消していく		private var _loadedURLArray : Array;					// 一度でも読み完了したことのあるURL配列		private var _loadCheckDictionary : Dictionary;			// ロード完了ディクショナリ、URLでアクセスする		// ********************************************************************** 		private var _xmlDictionary : Dictionary;		// ********************************************************************** 		private var _completeFunctionsDictionary : Dictionary;		private var _progressFunctionsDictionary : Dictionary;		private var _openFunctionsDictionary : Dictionary;		private var _errorFunctionsDictionary : Dictionary;				/**		 * XMLLoadQueueインスタンスを取得		 */		public static function getInstance():XMLLoadQueue{			if( instance == null ) {				callGetInstance=true;				XMLLoadQueue.instance = new XMLLoadQueue();			}			return instance;		}				// ======================================================================		/**		 * XMLLoadQueue はシングルトンクラスなので、コンストラクタの直接呼び出しは禁止されています。
		 */
		public function XMLLoadQueue()
		{			if(callGetInstance){
				callGetInstance=false;
				// 初期化				_queues 					 = new Array();				_loadedURLArray 			 = new Array();				_xmlDictionary				 = new Dictionary();				_loadCheckDictionary		 = new Dictionary();				_completeFunctionsDictionary = new Dictionary();				_progressFunctionsDictionary = new Dictionary();				_openFunctionsDictionary 	 = new Dictionary();
				_errorFunctionsDictionary 	 = new Dictionary();			}else{				throw new Error("XMLLoadQueue class can not create Instance!");			}		}		// ======================================================================		/**		 * ロード状況をトレース確認		 * @default false		 */		public function set debug(debug : Boolean) : void { _debug = debug;}				
		// ======================================================================		/**		 * ロードキューに追加。		 * @param url 読み込みURL		 * @param compFunc 		コンプリートリスナ関数		 * @param progressFunc  プログレスリスナ関数		 * @param openFunc 		オープンリスナ関数		 * @param errorFunc 	エラーリスナ関数		 */
		public function add( url 			: String							,compFunc 		: Function							,progressFunc	: Function = null 							,openFunc		: Function = null							,errorFunc		: Function = null):void
		{			// -----------------------------------------------------------------			// ▼キューにない場合追加			if(_completeFunctionsDictionary[url] == undefined) {				if (_debug) trace( "[ADDED] : " + url );				_queues.push( url );				_completeFunctionsDictionary[url] = new Array();				_progressFunctionsDictionary[url] = new Array();				_openFunctionsDictionary[url]	  = new Array();				_errorFunctionsDictionary[url]	  = new Array();			}			// -----------------------------------------------------------------			// ▼  コンプリートファンクションをディクショナリの配列に追加			(_completeFunctionsDictionary[url] as Array).push( compFunc );			// -----------------------------------------------------------------			// ▼  プログレスファンクション配列をディクショナリに追加			if (progressFunc != null) {				(_progressFunctionsDictionary[url] as Array).push( progressFunc );			}			// -----------------------------------------------------------------			// ▼  オープンファンクション配列をディクショナリに追加			if (openFunc != null) {				(_openFunctionsDictionary[url] as Array).push( openFunc );			}			// -----------------------------------------------------------------			// ▼  エラーファンクション配列をディクショナリに追加			if (errorFunc != null) {				(_errorFunctionsDictionary[url] as Array).push( errorFunc );			}		}

		// ======================================================================		/**		 * キューのURLを順に読み込み開始。		 * load中にloadされても何もしない		 */
		public function load() : void
		{			if(_loading) return;			_loading = true;			var url : String = _queues[0];			if (url == null) return;			_nowLoadURL =url;			 //すでにロード完了している場合			 if(_loadCheckDictionary[url]!=undefined){				if(!_loadCheckDictionary[url]) {					if (_debug) trace( "[ALREADY LOADED!] : " + url );					_doCompleteFunctions(url);	// URLに紐づくコンプリートファンクションすべて実行					_deleteHeadQueue();			// キューの先頭削除					_checkNextQueue();			//次のキューあるか？					return;				}			}			//ロード完了していない場合			_loadCheckDictionary[url]=false;	//ロード完了待ち			if(_loader == null){				_loader = new URLLoader();				_loader.addEventListener( Event.COMPLETE,		 _loadCompleteHandler );				_loader.addEventListener( IOErrorEvent.IO_ERROR, _loadErrorHandler );				_loader.addEventListener( ProgressEvent.PROGRESS,_loadProgressHandler );				_loader.addEventListener( Event.OPEN, 			 _loadOpenHandler );			}			//読み込み開始			_loader.load( new URLRequest( _queues[0] ));			if (_debug) trace( "[LOAD START] " + _nowLoadURL);		}
		// ======================================================================		/**		 * URLの読み込み中止する。		 * @param url 読込中止したいURL		 * URLが、		 * ロード前ならキューから削除、		 * ロード中ならロードスキップ、		 * ロード済みなら何もしない。		 */		public function stop(url : String) : void		{			if(_debug)trace("	------------------------------------- /");			if(_debug)trace("	▽キューから削除スタート　="+url);			// urlがキューにあるか？			var i : int = _queues.indexOf( url );						if (i != -1) {				if (_debug) trace( "	キューに " + url + " が見つかりました" );				// 　▼ロード完了記録を破棄				_loadCheckDictionary[url] = null;				delete _loadCheckDictionary[url];				// 　▼コンプリートファンクションを消す				_completeFunctionsDictionary[url] = null;				delete _completeFunctionsDictionary[url] ;				// 　▼プログレスファンクションを消す				_progressFunctionsDictionary[url] = null;				delete _progressFunctionsDictionary[url] ;				// 　▼オープンファンクションを消す				_openFunctionsDictionary[url] = null;				delete _openFunctionsDictionary[url] ;				// 　▼エラーファンクションを消す				_errorFunctionsDictionary[url] = null;				delete _errorFunctionsDictionary[url] ;				// 　▼今読み込み中？				if (url == _nowLoadURL) {					// TODO 不具合チェックする					if (_debug) trace( "		▽まさしく今読み込み中だった" );					if (_debug) trace( "			ローダークローズする" );					if (_loader && _loader.bytesLoaded < _loader.bytesTotal) {						_loader.close();					}					if (_debug) trace( "			ローダー消す" );					_loaderRemoveEventListeners();					_loader = null;					if (_debug) trace( "		　	キュー先頭から抜く" );					_deleteHeadQueue();					if (_debug) trace( "	次のキューあるかチェック" );					_checkNextQueue();				}				else {					if (_debug) trace( "		▽今読み込み中ではない" );					// ▼キューから削除					var queues : Array = _queues.slice();					var splitArr : Array = queues.splice( i );					splitArr.shift();					_queues = queues.concat( splitArr );				}				if (_debug) trace( "	[×]キューから削除しました　=" + url );				if (_debug) trace( "	------------------------------------- /" );			}			else {				if (_debug) trace( "	キューに " + url + " は見つかりませんでした " );			}		}		// ======================================================================		/**		 * 指定のURLのXMLがロード済みなら、nullする。		 */		public function remove (url : String) : void		{			// すでにロード完了している?			if (_loadCheckDictionary[url] != undefined && _loadCheckDictionary[url]) {				// ロード完了している				if (_debug) trace( "[REMOVE START] : " + url );				_deleteFunctions( url );				// ▼ロード完了を破棄				_loadCheckDictionary[url] = null;				delete _loadCheckDictionary[url];				// ▼XMLを削除				_xmlDictionary[url] =null;				delete _xmlDictionary[url];				// ▼ロード済みURL配列から削除				var i : int = _loadedURLArray.indexOf( url );				if (i != -1) {					var loadeds : Array = _loadedURLArray.slice();					var splitArr : Array = loadeds.splice( i );					splitArr.shift();					_loadedURLArray = loadeds.concat( splitArr );				}				else {					if (_debug) trace( "[WARNING] : ロード済みURL配列から削除できませんでした" + url );				}			}			else {				//ロード完了していない。（キューにない。or ロード中。）			}		}		// ======================================================================		/**		 * すべてのロードを停止し、キューも削除する		 */		public function allStop() : void		{			if (_debug) trace( "	▽[ALL STOP] : すべてのロードを停止スタート" );			_loaderRemoveEventListeners();			for (var i : int = 0; i < _queues.length; i++) {				var trgURL : String = _queues[i];				_queues[i] = null;				stop( trgURL );			}			_queues = new Array();			if (_debug) trace( "	◇[ALL STOP] : すべてのロードを停止しました" );		}						// ======================================================================		/**		 * 全てのロードを停止し、キューも削除し、保持しているすべてのXMLを消去		 */		public function allClear () : void		{			if (_debug) trace( "▽[ALL XML Dispose] : 保持しているすべてのXMLを消去 スタート" );			allStop();			for (var i : int = 0; i < _loadedURLArray.length; i++) {				if ( _xmlDictionary[_loadedURLArray[i]] != null) {					_xmlDictionary[_loadedURLArray[i]] = null;					delete _xmlDictionary[_loadedURLArray[i]];					if (_debug) trace( "nullしました" );				}			}			_loadedURLArray = new Array();			if (_debug) trace( "◇[ALL XML Dispose] : 保持しているすべてのXMLを消去 完了" );		}						// _____________________________________________________________________		/**		 * 読み込み完了		 */		private function _loadCompleteHandler (event : Event) : void		{			if (_debug) trace( "[COMPLETE] ");			var url : String = _queues[0];			var xml : XML = new XML( (event.target as URLLoader).data ) ;			_loadCheckDictionary[url] = true;	// ロード完了を記録			_xmlDictionary[url] = xml;			// XMLを保持			_loadedURLArray.push(url);			//読み込み済みURLとして記録			_doCompleteFunctions(url);			// URLに紐づく、コンプリートアクション全てを実行			_deleteHeadQueue();					// キューの先頭削除			_checkNextQueue();					//次のキューあるか？		}				// _____________________________________________________________________		//　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　		//　　　　　　　　　　　　　　　　　　　　　　　　　　　ローダーイベント リムーブ & 消去 		//　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　		private function _loaderRemoveEventListeners () : void		{			if (_loader != null) {				if (_loader.hasEventListener( Event.COMPLETE )) {					_loader.removeEventListener( Event.COMPLETE , _loadCompleteHandler );				}				if (_loader.hasEventListener( IOErrorEvent.IO_ERROR )) {					_loader.removeEventListener( IOErrorEvent.IO_ERROR , _loadErrorHandler );				}				if (_loader.hasEventListener( ProgressEvent.PROGRESS )) {					_loader.removeEventListener( ProgressEvent.PROGRESS , _loadProgressHandler );				}				if (_loader.hasEventListener( Event.OPEN )) {					_loader.removeEventListener( Event.OPEN , _loadOpenHandler );				}				_loader = null;			}		}		// _____________________________________________________________________		/**		 * コンプリートファンクションすべて実行。		 */		private function _doCompleteFunctions (url : String) : void		{			if (_completeFunctionsDictionary[url] != null) {				var xml : XML = _xmlDictionary[url];				var i : int;				for ( i = 0; i < (_completeFunctionsDictionary[url] as Array).length; i++) {					// event					var complete : XMLLoadQueueEvent = new XMLLoadQueueEvent( XMLLoadQueueEvent.COMPLETE );					complete.url = url;					complete.xml = xml.copy();	//（XMLの複製）					var compFunc : Function = _completeFunctionsDictionary[url][i];					compFunc(complete);			//コンプリート関数実行。				}			}			_deleteFunctions( url );		}				// _____________________________________________________________________		/**		 * ロードプログレスファンクションすべて実行。		 */		private function _loadProgressHandler (event : ProgressEvent) : void		{			var url : String = _queues[0];			// event			var progress : XMLLoadQueueEvent = new XMLLoadQueueEvent( XMLLoadQueueEvent.PROGRESS );			progress.url = url;			progress.bytesLoaded = event.bytesLoaded ;			progress.bytesTotal = event.bytesTotal ;			progress.percent = (event.bytesLoaded / event.bytesTotal * 100);			if (_progressFunctionsDictionary[url] != null) {				var i : int;				for ( i = 0; i < (_progressFunctionsDictionary[url] as Array).length; i++) {					var progFnc : Function = _progressFunctionsDictionary[url][i];					progFnc( progress );// 登録されているプログレスファンクションを実行				}			}			if(_debug)trace( "[Progress] :" 							+ progress.bytesLoaded+"/"+ progress.bytesTotal +" : "							+ (progress.percent) + " %　["  							+ progress.url +"]");		}				// _____________________________________________________________________		/**		 * オープンファンクションすべて実行。		 */		private function _loadOpenHandler (event : Event) : void		{			if (_debug) trace( "[OPEN] : " + _queues[0] );			var url : String = _queues[0];			// event			var open : XMLLoadQueueEvent = new XMLLoadQueueEvent( XMLLoadQueueEvent.OPEN );			open.url = url;			if (_openFunctionsDictionary[url] != null) {				var i : int;				for ( i = 0; i < (_openFunctionsDictionary[url] as Array).length; i++) {					var openFunc : Function = _openFunctionsDictionary[url][i];					openFunc( open );				}			}		}						// _____________________________________________________________________		/**		 * エラーファンクションすべて実行。		 */		private function _loadErrorHandler(event : IOErrorEvent) : void		{			var url : String = _queues[0];			if (_debug) trace( "[× LOAD ERROR] : " + url );			// event			var error : XMLLoadQueueEvent = new XMLLoadQueueEvent( XMLLoadQueueEvent.ERROR );			error.url = url;			error.text = event.text;			if (_errorFunctionsDictionary[url] != null) {				var i : int;				for ( i = 0; i < (_errorFunctionsDictionary[url] as Array).length; i++) {					var errorFunc : Function = _errorFunctionsDictionary[url][i];					errorFunc( error );				}			}			stop( url );		}						// _____________________________________________________________________		/**		 * URLに紐づくリスナをすべて消去。		 * @param url このURLにひもづいているリスナを消去		 */		private function _deleteFunctions(url:String):void		{			//コンプリートリスナ消す			if(_completeFunctionsDictionary[url] !=null){				_completeFunctionsDictionary[url]=null;				delete _completeFunctionsDictionary[url];			}			// プログレスリスナ消す			if(_progressFunctionsDictionary[url] !=null){				_progressFunctionsDictionary[url] = null;				delete _progressFunctionsDictionary[url];			}			// オープンリスナ消す			if(_openFunctionsDictionary[url] !=null){				_openFunctionsDictionary[url] = null;				delete _openFunctionsDictionary[url];			}			// エラーリスナ消す			if(_errorFunctionsDictionary[url] !=null){				_errorFunctionsDictionary[url] = null;				delete _errorFunctionsDictionary[url];			}		}						// _____________________________________________________________________		/**		 * キューの先頭を削除		 */		private function _deleteHeadQueue () : void		{			_queues.shift();// キューから削除			_nowLoadURL = null;		}		// _____________________________________________________________________		/**		 * 次のキューがあるか？		 */		private function _checkNextQueue () : void		{			_loading = false;			if (_debug) trace( ' [? HAS NEXT ] >' + (_queues[0] !=undefined) );			if (_queues.length != 0) {				load();			}			else {				if (_debug) trace( "◆ [COMPLETE QUEUE!]" );				_loaderRemoveEventListeners();//ローダーとイベント消す				_loader=null;			}		}	}
}