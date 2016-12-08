package net.lanelife.framework.cw.events
{
	import flash.events.Event;
	
	import net.lanelife.framework.cw.Window;
	
	public class WindowEvent extends Event
	{
		
		/**
		 * 窗口创建事件，在首次调用 show 方法时分发 ，将在侦听该事件的容器中添加此窗口。
		 */
		public static const WINDOW_CREATE:String = "windowCreate";
		/**
		 * 窗口深度改变事件，当鼠标在窗口中按下时分发， 将在侦听该事件的容器中改变该窗口在容器中的深度。
		 */
		public static const WINDOW_DEPTH_CHANGE:String = "windowDepthChange";
		/**
		 * 窗口销毁事件，在调用 destroy 方法时分发， 将在侦听该事件的容器中删除此窗口。
		 */
		public static const WINDOW_DESTROY:String = "windowDestroy";
		/**
		 * 窗口打开事件，仅在首次调用 show 方法才传递此事件。  
		 */
		public static const WINDOW_OPENED:String = "windowOpened";
		/**
		 * 窗口关闭事件， 调用 close 方法传递此事件。  
		 */
		public static const WINDOW_CLOSED:String = "windowClosed";
		
		/**
		 * 窗口获得焦点事件。 
		 */
		public static const WINDOW_FOCUS_IN:String = "windowFocusIn";
		
		public var window:Window;
		
		public function WindowEvent(type:String, window:Window)
		{
			super(type);
			this.window = window;
		}

	}
}