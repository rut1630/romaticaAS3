/**
 *　copyright (c) www.romatica.com
 */
package com.romatica.sample
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	/**
	 * ImageLoadQueueクラス サンプル.
	 * 
	 * 意図的に2枚の画像をロードエラーにしスキップ確認しています。
	 * 
	 * 6枚目と最後の画像は同じURLを指定しているので、
	 * 6枚目ロード完了時点で、最後の画像のコンプリートリスナも実行されます
	 * 
	 * @author itoz
	 */
	[SWF(backgroundColor="#dfdfdf", frameRate="31", width="600", height="500")]
	public class Test_ImageLoadQueueSample extends Sprite
	{
		private var _imageURLArr : Array;

		public function Test_ImageLoadQueueSample()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			createImageUrlArr();//画像URL配列作成
			//イメージラッパークラス作成
			for (var i : int = 0; i < _imageURLArr.length; i++) {
				var wrap : ImageWrapper = addChild(new ImageWrapper( _imageURLArr[i] )) as ImageWrapper;
				wrap.x = i%6*100;
				wrap.y = int(i/ 6)*100;
				wrap.load();//ロードスタート
			}
		}

		private function createImageUrlArr() : void
		{
			//[image sample] http://www.flickr.com/photos/27231396@N00/sets/72157594369370072/with/293882771/
			_imageURLArr = [];
			_imageURLArr.push( "http://farm1.static.flickr.com/101/294206457_34836cc9be_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/101/293881879_ee571df061_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/101/293882767_7a550b4dff_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/102/293887744_7101766784_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/102/293884284_7a909af92b_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/117/293886441_b069d9510c_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/103/293887057_61868a0915_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/103/293886453_adf6c7feb0_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/104/293881218_49627300ab_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/104/293882768_0c9e164c43_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/104/293885057_f02a25e126_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/104/293888515_289f7aaf02_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/105/293887054_5621128a3a_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/106/293886450_600db8183f_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/107/294206977_a8ff9b0588_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/107/294206464_811de58cb5_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/109/293882760_db5b3ee167_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/111/293886438_9ac230c229_o.jpg");
			_imageURLArr.push( "hoge");
			_imageURLArr.push( "http://farm1.static.flickr.com/112/293888511_16f925385d_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/112/293887061_04762bf706_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/112/294207351_ac5be4fd50_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/113/293881217_d886fa8c3e_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/114/293881875_59f2cc7a99_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/116/294207352_ff0e3d89a2_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/116/293881214_dc4811ab56_o.jpg");
			_imageURLArr.push( "hogehoge");
			_imageURLArr.push( "http://farm1.static.flickr.com/117/293884279_29b853a595_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/121/293887064_e87b852954_o.jpg");
			_imageURLArr.push( "http://farm1.static.flickr.com/117/293886441_b069d9510c_o.jpg");
		}
	}
}
import com.romatica.events.ImageLoadQueueEvent;
import com.romatica.loader.ImageLoadQueue;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.text.TextField;



class ImageWrapper extends Sprite
{
	private var _imageLoadQueue : ImageLoadQueue;
	private var _tf : TextField;
	private var _url : String;
	private var _rotater : LoadProgressRotater;
	public function ImageWrapper(url : String)
	{
		_url =url;
		_tf = addChild( new TextField() ) as TextField;
		//ImageLoadQueueインスタンス取得
		_imageLoadQueue = ImageLoadQueue.getInstance();
		//ロードサークル
		_rotater= addChild(new LoadProgressRotater(0xaaaaaa))as LoadProgressRotater;
		_rotater.x = _rotater.y =50-6;
	}
	/** ロード開始*/
	public function load():void
	{
		//add()でキューに追加 load()でロードキュースタート
		_imageLoadQueue.add( _url, compFunc , onProgress, onOpen,onError );
		_imageLoadQueue.load();
	}
	/** ロードストップ*/
	public function stop():void
	{
		_imageLoadQueue.stop(_url);
	}
	/** ロードオープン*/
	private function onOpen(event:ImageLoadQueueEvent):void
	{
		trace("[open] "+event.url);
		_tf.text = "0%";
	}
	/**ロードプログレス*/
	private function onProgress(event : ImageLoadQueueEvent) : void
	{
		//bytesTotal bytesLoaded のほかpercentのプロパティもあります
		trace(" [progress]"+" : "+int( event.percent ) + "%");
		_tf.text = int( event.percent ) + "% "+event.url ;
	}
	/**
	 * ロードコンプリート
	 * ImageLoadQueueEvent.bitmapDataにロード画像のコピーが返ってきます。
	 */
	private function compFunc(event : ImageLoadQueueEvent):void
	{
		trace("[complete] "+event.url);
		removeChild(_tf);
		_rotater.remove();
		var bitmap : Bitmap = addChild(new Bitmap( event.bitmapData ))as Bitmap;
		bitmap.smoothing = true;
		bitmap.width = bitmap.height=100;
	}
	/** ロードエラー*/
	private function onError(event : ImageLoadQueueEvent) : void
	{
		trace("[error] "+event.text + " : "+event.url);
		_tf.text = "[ERROR]>SKIP";
		_rotater.remove();
	}
}

class LoadProgressRotater extends Sprite
{
	private var _speed : Number;
	
	public function LoadProgressRotater(color:Number =0x000000,radius:Number =12,points:Number = 8,speed:Number = 5){
		this.graphics.beginFill(color);
		var r:Number =radius;
		var max:int = points;
		_speed = speed;
		for (var i : int = 0; i < max; i++) {
			var ang:Number = (360/max)*i;
			var rad:Number = ang *(Math.PI/180);
			var xx:Number = Math.cos( rad)*r;
			var yy:Number = Math.sin( rad)*r;
			this.graphics.drawCircle(xx,yy,1.5);
		}
		this.graphics.endFill();
		strat();
	}
	private function strat():void{
		this.addEventListener(Event.ENTER_FRAME, onRotation);
	}
	private function onRotation(event : Event) : void
	{
		if(this.rotation >360){
			this.rotation -=360;
		}
		this.rotation +=_speed;
	}
	public function remove():void{
		this.removeEventListener(Event.ENTER_FRAME,onRotation);
		this.graphics.clear();
	}
}
