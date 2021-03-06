/**
 *============================================================
 * copyright(c). www.romatica.com
 * @author  itoz
 * @version 0.0.1
 *============================================================
 * -2011.2.11　クラス作成 
 */
package com.romatica.progression.commands.lists
{
	import jp.progression.commands.Func;
	import jp.progression.commands.Wait;
	import jp.progression.commands.lists.SerialList;

	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * TextFieldに1文字づつ、ストリングを追加していくアニメーションコマンドリスト
	 */
	public class TextAddAnimationList extends SerialList
	{
		private var _initObj 	: Object;
		private var _textField 	: TextField;
		private var _text 		: String;
		private var _speed 		: Number;
		private var _textFormat : TextFormat;
		private var _addCount : int;
		
		/**
		 * TextFieldに1文字づつ、ストリングを追加していくアニメーションコマンドリスト
		 * @param initObj
		 * @param textField
		 * @param text
		 * @param speed
		 * @param textFormat
		 */
		 function TextAddAnimationList (initObj:Object,
		 								textField:TextField,
		 								text:String,
		 								speed:Number =0.03,
		 								textFormat:TextFormat = null)
		{
			super( initObj);
			
			_initObj	= initObj;
			_textField	= textField;
			_text 		= text;
			_speed		= speed;
			_textFormat	= textFormat;
			_addCount =0;
			addCommand(
				function():void{
					if( _text.length >_addCount){
	                    for (var j : int = 0; j < _text.length; j++) {
	                    	_addCount++;
	                    	addCommand(new Wait(_speed));
	                    	addCommand(
	                            new Func(
	                                function(num:int):void{
	                                    _textField.appendText( _text.charAt(num));
	                                    if(_textFormat!=null) _textField.setTextFormat(_textFormat);
	                                },[j]
	                            )
	                        );
						}
					}
	            }
			);
		}
		
		/**
		 * インスタンスのコピー
		 */
//		override public function clone():Command {
//			return new TextAddAnimationList( _initObj,_textField, _text,_speed,_textFormat);
//		}
	}
}
