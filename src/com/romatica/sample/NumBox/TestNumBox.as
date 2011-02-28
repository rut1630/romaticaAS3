/**
 *============================================================
 * copyright(c) 2011 www.romatica.com
 * @author  itoz
 * 2011/02/28
 *============================================================
 */
package com.romatica.sample.NumBox
{
    import com.romatica.display.NumBox;

    import flash.display.Sprite;

    /**
     * NumBoxテストクラス
     */
     [SWF(backgroundColor="#FFFFFF", frameRate="31", width="640", height="480")]
    public class TestNumBox extends Sprite
    {
    	
    	[Embed(source="com/romatica/sample/NumBox/assets/num0.png")]
    	private var NumText0 : Class;
    	
    	[Embed(source="com/romatica/sample/NumBox/assets/num1.png")]
    	private var NumText1 : Class;
    	
    	[Embed(source="com/romatica/sample/NumBox/assets/num2.png")]
    	private var NumText2 : Class;
    	
    	[Embed(source="com/romatica/sample/NumBox/assets/num3.png")]
    	private var NumText3 : Class;
    	
    	[Embed(source="com/romatica/sample/NumBox/assets/num4.png")]
    	private var NumText4 : Class;
    	
    	[Embed(source="com/romatica/sample/NumBox/assets/num5.png")]
    	private var NumText5 : Class;
    	
    	[Embed(source="com/romatica/sample/NumBox/assets/num6.png")]
    	private var NumText6 : Class;
    	
    	[Embed(source="com/romatica/sample/NumBox/assets/num7.png")]
    	private var NumText7 : Class;
    	
    	[Embed(source="com/romatica/sample/NumBox/assets/num8.png")]
    	private var NumText8 : Class;
    	
    	[Embed(source="com/romatica/sample/NumBox/assets/num9.png")]
    	private var NumText9 : Class;
    	
    	
        private var _numBox1 : NumBox;
        private var _numBox2 : NumBox;
        private var _numBox3 : NumBox;
        public function TestNumBox()
        {
        	
        	var numImages:Array = [new NumText0()
        	                  ,new NumText1()
        	                  ,new NumText2()
        	                  ,new NumText3()
        	                  ,new NumText4()
        	                  ,new NumText5()
        	                  ,new NumText6()
        	                  ,new NumText7()
        	                  ,new NumText8()
        	                  ,new NumText9()
        	];
        	
        	// ----------------------------------------------------------------
        	
        	_numBox1 =addChild( new NumBox()) as NumBox;
        	_numBox1.setImages(numImages);
        	_numBox2 =addChild( new NumBox()) as NumBox;
        	_numBox2.setImages(numImages);
        	_numBox2.x = 30;
        	_numBox3 =addChild( new NumBox()) as NumBox;
        	_numBox3.setImages(numImages);
        	_numBox3.x = 60;
        	// ----------------------------------------------------------------
        	_numBox1.goto(2);
        	_numBox2.goto(5);
        	_numBox3.goto(6);
        }
    }
}
