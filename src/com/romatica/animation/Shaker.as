/**
 *============================================================
 * copyright(c) 2011
 * @author  author
 * 2011/02/25
 *============================================================
 */
package com.romatica.animation
{
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    /**
     * @author itoz
     */
    public class Shaker extends Sprite
    {
        private var _moveScope : Number;
        private var _timer : Timer;
        private var _doArr : Array;

        public function Shaker(doc : DisplayObjectContainer = null)
        {
            if (doc != null) {
                init(doc);
            }
        }

        // ======================================================================
        /**
         * start.
         */
        public function init(dispObj : DisplayObjectContainer, indentLevel : Number = 0) : void
        {
            _doArr = [];
            setTargets(dispObj, indentLevel);
        }

        // ======================================================================
        /**
         * startShake.
         * @param moveScope 初期位置からの移動範囲
         * @param time 何ミリ秒ごとにシェイクするか
         */
        public function startShake(moveScope : Number = 1.2, time : Number = 100) : void
        {
            if (_timer == null ) {
            }
            else {
                return;
                // if (_timer.running) return;
            }
            _moveScope = moveScope;
            _timer = new Timer(time, 0);
            _timer.addEventListener(TimerEvent.TIMER, onTimer);
            _timer.start();
        }

        // ======================================================================
        /**
         * stopShake.
         */
        public function stopShake() : void
        {
            if (_timer != null) {
                if (_timer.hasEventListener(TimerEvent.TIMER)) {
                    _timer.removeEventListener(TimerEvent.TIMER, onTimer)
                }
                _timer.stop();
                _timer.reset();
                _timer = null;
            }
            if (_doArr != null) {
                for (var i : int = 0; i < _doArr.length; i++) {
                    var sobj : ShakeObject = _doArr[i]  as ShakeObject;
                    sobj.x = sobj.defX;
                    sobj.y = sobj.defY;
                }
            }
        }

        private function setTargets(dispObj : DisplayObjectContainer, indentLevel : Number) : void
        {
            for (var ii : uint = 0; ii < dispObj.numChildren; ii++) {
                var doc : DisplayObjectContainer = dispObj.getChildAt(ii) as DisplayObjectContainer;
                if (doc is DisplayObjectContainer) {
                    (doc as MovieClip).defX = doc.x;
                    (doc as MovieClip).defY = doc.y;
                    _doArr.push(doc);
                    setTargets(doc as DisplayObjectContainer, indentLevel + 1);
                }
                else {
                    // trace(padIndent(indentLevel)+obj);
                }
            }
        }
          private function padIndent(indents : int) : String
        {
            var indent : String = "";
            for (var ii : uint = 0; ii < indents; ii++) {
                indent += "     ";
            }
            return indent;
        }

        private function onTimer(event : TimerEvent) : void
        {
            for (var i : int = 0;i < _doArr.length;i++) {
                var doc : MovieClip = _doArr[i] as MovieClip;
                if (doc != null) {
                    doc.x = doc.defX + (_moveScope * Math.random() - (_moveScope / 2));
                    doc.y = doc.defY + (_moveScope * Math.random() - (_moveScope / 2));
                }
            }
        }
    }
}
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;

class ShakeObject extends MovieClip
{
    public var defX : Number;
    public var defY : Number;

    public function ShakeObject(dispObjCont : DisplayObjectContainer) : void
    {
        defX = dispObjCont.x;
        defY = dispObjCont.y;
    }
}
