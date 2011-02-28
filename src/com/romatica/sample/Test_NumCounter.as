/**
 *============================================================
 * copyright(c) 2011
 * @author  itoz
 * 2011/02/28
 *============================================================
 */
package com.romatica.sample
{
    import com.romatica.events.CountEvent;
    import com.romatica.utils.NumCounter;
    import flash.display.Sprite;

    /**
     * NumCounterテストクラス
     */
    public class Test_NumCounter extends Sprite
    {
        private var _counter : NumCounter;
        public function Test_NumCounter()
        {
        	_counter = new NumCounter(0,100);
        	_counter.addEventListener(CountEvent.COUNT_START, onCountStart);
        	_counter.addEventListener(CountEvent.COUNT_PROGRESS, onCount);
        	_counter.addEventListener(CountEvent.COUNT_COMPLETE, onCountComplete);
        	_counter.start(20);
        }

        private function onCountComplete(event : CountEvent) : void
        {
        	trace("[complete ] "+event.count);
        }

        private function onCountStart(event : CountEvent) : void
        {
        	trace("[start ] "+event.count);
        }

        private function onCount(event : CountEvent) : void
        {
        	trace("[progress ] "+event.count);
        }
    }
}
