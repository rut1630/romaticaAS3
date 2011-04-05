/**
 *============================================================
 * copyright(c). www.romatica.com
 * @author  itoz
 *============================================================
 *
 */
package com.romatica.display
{
	import com.romatica.events.FadeEvent;
	import flash.display.Sprite;

	/**
	 * モーダルウィンドウ (主に継承して使う)
	 * @example :継承コピペ用
	 * <listing version="3.0">
	 *  override protected function init() : void{super.init();}
	 *  override public function fadeIn() : void{super.fadeIn();}
	 *  override public function fadeOut() : void{super.fadeOut();}
	 *  override protected function fadeInComplete() : void{super.fadeInComplete();}
	 *  override protected function fadeOutComplete() : void{super.fadeOutComplete();}
	 * </listing>
	 */

        	
	public class ModalWindow extends Sprite
	{
		protected var _cover : Sprite;
		public function ModalWindow ()
		{
			_cover = addChild( new Sprite() ) as Sprite;
		}
		
		protected function  init(initObj:Object = null):void{
		
		}
		
		// ======================================================================
		/**
		 *フェードイン
		 */
		public function fadeIn () : void
		{
			dispatchEvent( new FadeEvent( FadeEvent.FADEIN_START ) );
		}

		// ======================================================================
		/**
		 *フェードインコンプリート
		 */
		protected function fadeInComplete () : void
		{
			dispatchEvent( new FadeEvent( FadeEvent.FADEIN_COMPLETE ) );
		}

		// ======================================================================
		/**
		 *フェードアウト
		 */
		public function fadeOut () : void
		{
			dispatchEvent( new FadeEvent( FadeEvent.FADEOUT_START ) );
		}

		// ======================================================================
		/**
		 *フェードアウトコンプリート
		 */
		protected function fadeOutComplete () : void
		{
			dispatchEvent( new FadeEvent( FadeEvent.FADEOUT_COMPLETE ) );
		}
		
		
        public function remove() : void
        {
            if (_cover != null) {
                if (this.contains(_cover)) {
					this.removeChild(_cover );
				}
				_cover = null;
			}
		}
	}
}
