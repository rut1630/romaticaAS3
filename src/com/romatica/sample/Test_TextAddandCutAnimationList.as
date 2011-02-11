/**
 *============================================================
 * copyright(c). www.romatica.com
 * @author  itoz
 * @version 0.0.1
 *============================================================
 * -2011.2.11　クラス作成 
 */
package com.romatica.sample
{
	import com.romatica.progression.commands.lists.TextAddAnimationList;
	import com.romatica.progression.commands.lists.TextCutAnimationList;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import jp.progression.commands.Trace;
	import jp.progression.commands.Wait;
	import jp.progression.commands.lists.LoopList;
	import jp.progression.commands.lists.SerialList;



	/**
	 * TextAddAnimationList と TextCutAnimationList テストクラス
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="700", height="100")]
	public class Test_TextAddandCutAnimationList extends Sprite
	{
		private var _tf 		: TextField;
		private var _tfm 		: TextFormat;
		private var _mainLoopList : SerialList;
		private var _addList 	: TextAddAnimationList;
		private var _cutList 	: TextCutAnimationList;


		public function Test_TextAddandCutAnimationList ()
		{
			init();

			var str:String = "welcome to [http://www.romatica.com/]";
			
			// ----------------------------------------------------------------
			//　text format
			_tfm = new TextFormat( null , 30 , 0x887041);
			_tfm.align = TextFormatAlign.CENTER;
			_tfm.letterSpacing = 1.3;
			_tfm.bold=true;
			
			// ----------------------------------------------------------------
			//　text field
			_tf = addChild( new TextField() ) as TextField;
			_tf.width = stage.stageWidth;
			_tf.y = 27;
			
			// ----------------------------------------------------------------
			//　テキストアドアニメーション
			_addList =new TextAddAnimationList(
				{
					onStart:function():void		{ trace( "	[add start]");_tf.text="";},
					onComplete:function():void	{ trace( "	[add complete]");_tf.text=str;},
					onInterrupt:function():void	{ trace( "	[add interrupt]");_tf.text=str;} 
				}
				,_tf
				,str
				,0.03
				,_tfm
			);
			
			// ----------------------------------------------------------------
			//　テキストカットアニメーション
			_cutList = new TextCutAnimationList(
				{
					onStart:function():void		{ trace( "	[cut start]");},
					onComplete:function():void	{ trace( "	[cut complete]");_tf.text="";},
					onInterrupt:function():void	{ trace( "	[cut interrupt]");_tf.text="";} 
				}
				, _tf
				,0.01
			);
			
			// ----------------------------------------------------------------
			//　メインの　ループリスト
			_mainLoopList = new LoopList(0);
			_mainLoopList.addCommand(
				new Trace("▼[loop start]")
				,_addList
				,new Wait(1.5)
				,_cutList
				,new Wait(1)
				,new Trace("■[loop complete]")
			);
			
			_mainLoopList.execute();//ループスタート
		}

		private function init () : void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			var gradType : String = GradientType.LINEAR;
			var gradColors : Array = [0xcccccc,0xffffff  ];
			var gradAlphas : Array = [1 , 1];
			var gradRadios : Array = [0 , 255];
			var gradMrx : Matrix = new Matrix();
			gradMrx.createGradientBox( 700 , 100 , Math.PI / 2 , 0 , 0 );
			var gradSpread : String = SpreadMethod.PAD;
			this.graphics.beginGradientFill( gradType , gradColors , gradAlphas , gradRadios , gradMrx , gradSpread );
			this.graphics.drawRect( 0 , 0 , 700 , 100 );
		}
	}
}
