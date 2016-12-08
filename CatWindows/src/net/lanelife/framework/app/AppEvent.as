package net.lanelife.framework.app
{
	import flash.events.Event;
	
	import net.lanelife.framework.util.Map;
	
	public class AppEvent extends Event
	{
		public static const APP_LOAD_SUCCESS:String = "app_load_success";
		
		public var apps:Map;
		
		public function AppEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}