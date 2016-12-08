package net.lanelife.framework.cw
{
	import mx.collections.ArrayCollection;

	public class TrayIconManager
	{
		private static var instance:TrayIconManager;
		
		public static var list:ArrayCollection = new ArrayCollection();
		
		public function TrayIconManager()
		{
		}
		
		public static function getInstance():TrayIconManager
		{
			if (instance==null)
				instance = new TrayIconManager();
			return instance;
		}
		
		public function register(trayIcon:TrayIcon):void
		{ 
			if (trayIcon.manager)
			{
				trayIcon.manager.unregister(trayIcon);
			}
			trayIcon.manager = this;
			list.addItem(trayIcon);
		}
		
		public function unregister(trayIcon:TrayIcon):void
		{
			trayIcon.manager = null;
			if (list.getItemIndex(trayIcon)>-1)
				list.removeItemAt(list.getItemIndex(trayIcon));
		}
		
		public static function get(id:String):TrayIcon
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
		
	}
}