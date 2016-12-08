package net.lanelife.framework.cw
{
	import mx.collections.ArrayCollection;
	
	import net.lanelife.framework.cw.events.WindowEvent;
	import net.lanelife.framework.cw.events.WindowEventDispatcher;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	
	public class WindowManager
	{
		private static var instance:WindowManager;
		/**
		 * 窗口集合 
		 */
		public static var list:ArrayCollection = new ArrayCollection();
		/**
		 * 在前面的窗口
		 */
		public static var front:Window;
		
		
		public function WindowManager()
		{
		}
		
		public static function getInstance():WindowManager
		{
			if (instance==null)
				instance = new WindowManager();
			return instance;
		}
		
		/**
		 * 在 WindowManager 中注册一个窗口。
		 * @param window 将注册的窗口
		 * 
		 */
		public function register(window:Window):void
		{
			if (window.manager)
			{
				window.manager.unregister(window);
			}
			window.manager = this;
			list.addItem(window);
		}
		
		/**
		 * 在 WindowManager 中注销一个窗口。
		 * @param window 将注销的窗口
		 * 
		 */
		public function unregister(window:Window):void
		{
			window.manager = null;
			if (list.getItemIndex(window)>-1)
				list.removeItemAt(list.getItemIndex(window));
		}
		
		/**
		 * 将窗口置于前端，并可以将其设为焦点 Window。
		 * @param window
		 * @return 
		 * 
		 */
		public function bringToFront(window:Window):Boolean
		{
			if (window!=front)
			{
				WindowEventDispatcher.getInstance().dispatchEvent(
					new WindowEvent(WindowEvent.WINDOW_DEPTH_CHANGE, window)
				);
				if (front)
				{
					if(front is DesktopWindow) {
						var _desktopWindow:DesktopWindow = DesktopWindow(front);
						_desktopWindow.taskbarButton.flashes = false;
						_desktopWindow.taskbarButton.active = false;
					}
				}
				front = window;
				
				if(front is DesktopWindow) {
					var _desktopWindow:DesktopWindow = DesktopWindow(front);
					_desktopWindow.taskbarButton.flashes = false;
					_desktopWindow.taskbarButton.active = true;
				}
				
				return true;
			}
			return false;
		}
		
		public static function changeFront():void{
			var l:ArrayCollection = new ArrayCollection(list.toArray());
			l.filterFunction = function(item:Window):Boolean
			{
				if (item.visible && !item.disabled) {
					if(item is DesktopWindow){
						var _desktopWindow:DesktopWindow = DesktopWindow(item);
						return _desktopWindow.taskbarButton.visible;
					}
					
					return true;
				}
					
				else
					return false;
			};
			var s:Sort = new Sort();
			s.fields = [new SortField("depth")];
			l.sort = s;
			l.refresh();
			if (l.length>0)
			{
				l[l.length-1].show();
			}
			else
			{
				if (front) {
					if(front is DesktopWindow){
						var _desktopWindow:DesktopWindow = DesktopWindow(front);
						_desktopWindow.taskbarButton.active = false;
						_desktopWindow = null;
					}
				}
				front = null;
			}
		}
		
		
		public static function get(id:String):Window
		{
			for (var i:Number=0; i<list.length; i++)
			{
				if (list[i].id == id)
				{
					return list[i];
				}
			}
			return null;
		}
		
		/**
		 * 隐藏所有窗口。
		 * 
		 */
		public static function hideAll():void
		{
			for (var i:Number=0; i<list.length; i++)
			{
				if (list[i].visible)
					list[i].hide();
			}
		}
		
		/**
		 * 显示所有窗口。 
		 * 
		 */
		public static function showAll():void
		{
			for (var i:Number=0; i<list.length; i++)
			{
				if (!list[i].visible)
					list[i].show();
			}
		}
	}
}