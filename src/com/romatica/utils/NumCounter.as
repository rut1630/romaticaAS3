/**
 * -------------------------------------------------------
 * copyright(c)2011 romatica.com
 * @author itoz
 * @version 0.1
 * -------------------------------------------------------
 */
package com.romatica.utils
{
    import com.romatica.events.CountEvent;

    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

	/**
	 * 整数をカウントアップ、ダウンさせるクラス
     */
    public class NumCounter extends EventDispatcher
    {
        private var _startNum : int;
        private var _endNum : int;
        private var _addition : int;
        private var _diff : int;
        private var _timer : Timer;
        private var _stepInt:int;
        public function NumCounter(startNum:int,endNum:int) : void
		{
			_stepInt = startNum;//変化する数値
			_startNum = startNum;//スタート値
			_endNum = endNum;//終了値
			_diff  = Math.abs(_startNum - _endNum )/10;//差の絶対値
        }

        // ======================================================================
        /**
		 * カウントスタート
		 * @param speed ミリ秒
         */
        public function start(speed : int = 50,step:int = 1) : void
        {
			if(_timer != null) return;
			
			_addition = (_endNum > _startNum) ? step : -step;//加減する値
			
			_timer = new Timer( speed, _diff );
			_timer.addEventListener( TimerEvent.TIMER ,countHander);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onCountComplete)
			_timer.start();
			dispatchEvent(new CountEvent(CountEvent.COUNT_START,String(_stepInt) ));
        }
		// ======================================================================
		/**
		 * カウント中
		 */
        private function countHander(event : TimerEvent) : void
        {
        	if(_endNum <= _stepInt + _addition){
        		_stepInt = _endNum; 
        		dispatchEvent(new CountEvent(CountEvent.COUNT_PROGRESS,String(_stepInt)));
        		onCountComplete();
        	}else{
        		_stepInt += _addition;
        		dispatchEvent(new CountEvent(CountEvent.COUNT_PROGRESS,String(_stepInt)));
        	}
           
        }
		// ======================================================================
		/**
		 * カウントアップ終了
		 */
        private function onCountComplete(event : TimerEvent = null) : void
        {
        	stop();
        }
        
		// ======================================================================
        /**
         * ストップ
         */
        public function stop() : void
        {
            if (_timer != null) {
        		if(_timer.running){
        			_timer.stop();
        		}
        		if(_timer.hasEventListener( TimerEvent.TIMER )){
        			_timer.removeEventListener(TimerEvent.TIMER, countHander)
        		}
        		if(_timer.hasEventListener( TimerEvent.TIMER_COMPLETE )){
        			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onCountComplete)
        		}
        		_timer.reset();
                _timer = null;
            }
            _stepInt = _endNum;            // 終了した時、終了値を入れるかどうか
            dispatchEvent(new CountEvent(CountEvent.COUNT_COMPLETE, String(_stepInt)));
        }


		
	}
}
