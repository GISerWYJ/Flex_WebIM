package net.lanelife.framework.cw.events
{
	import flash.events.Event;
	
	import net.lanelife.framework.cw.TrayIcon;
	
	public class TrayIconEvent extends Event
	{
		public static const TRAY_ICON_CREATE:String = "trayIconCreate";
		public static const TRAY_ICON_DESTROY:String = "trayIconDestroy";
		
		public var trayIcon:TrayIcon;
		
		public function TrayIconEvent(type:String, trayIcon:TrayIcon)
		{
			super(type);
			this.trayIcon = trayIcon;
		}
	}
}