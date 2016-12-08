package net.lanelife.framework.cw
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import net.lanelife.framework.cw.events.TrayIconEvent;
	import net.lanelife.framework.cw.events.WindowEventDispatcher;
	
	import spark.components.Button;
	import spark.components.Image;
	
	public class TrayIcon extends Button
	{
		
		public var manager:TrayIconManager;
		
		public var display:Boolean;
		
		[SkinPart(required="true")]
		/**
		 * 定义托盘图标的外观部件。 
		 */
		public var trayIconDisplay:Image;
		
		public function TrayIcon(display:Boolean=true)
		{
			super();
			this.display = display;
			this.manager = this.manager || TrayIconManager.getInstance();
			this.manager.register(this);
			
			WindowEventDispatcher.getInstance().dispatchEvent(
				new TrayIconEvent(TrayIconEvent.TRAY_ICON_CREATE, this)
			);
			
		}
		
		/**
		 * 设置此 TrayIcon 的图像，建议使用16x16像素的图片。
		 * @param source
		 * 
		 */
		public function setImage(source:Object):void
		{
			trayIconDisplay.source = source;
		}
		
		private var timer:Timer;
		
		/**
		 * 开始闪烁 此 TrayIcon 的图像。 
		 * @param delay 间隔时间，默认为1000毫秒。
		 * 
		 */
		public function startFlashImage(delay:Number=1000):void
		{
			if (timer) {
				stopFlashImage();
				timer = null;
			}
			timer = new Timer(delay);
			timer.addEventListener(TimerEvent.TIMER, timer_timerHandler);
			timer.start();
		}
		
		/**
		 * 停止闪烁 此 TrayIcon 的图像。
		 * 
		 */
		public function stopFlashImage():void
		{
			if (timer) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, timer_timerHandler);
				trayIconDisplay.visible = true;
			}
		}
		
		protected function timer_timerHandler(event:TimerEvent):void
		{
			trayIconDisplay.visible = !trayIconDisplay.visible;
		}
		
		public function destroy():void
		{
			if (this.manager)
			{
				WindowEventDispatcher.getInstance().dispatchEvent(
					new TrayIconEvent(TrayIconEvent.TRAY_ICON_DESTROY, this)
				);
				this.manager.unregister(this);
			}
		}
	}
}