package net.lanelife.framework.cmp.login
{
	import flash.events.Event;
	
	public class LoginEvent extends Event
	{
		
		public static const LOGIN:String = "Login_event";
		public static const CONNECT_SERVER_SUCCESS:String = "connect_server_success";
		public static const CONNECT_SERVER_FAULT:String = "connect_server_fault";
		public static const LOGIN_SUCCESS:String = "login_success_event";
		public static const LOGIN_FAULT:String = "login_fault_event";
		
		
		public var account:String;
		public var password:String;
		public var userName:String;
		public var face:String;
		
		public function LoginEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}