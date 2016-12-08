package net.lanelife.framework.desktop
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public dynamic class MessageBoxItem
	{
		public var type:Number;
		public var windowId:Number;
		public var icon:String;
		public var text:String;
		public var messages:ArrayCollection = new ArrayCollection();
		
		public static var TYPE_EMPLOYEE_MESSAGE:Number = 1;
		public static var TYPE_TEAM_MESSAGE:Number = 2;
		public static var TYPE_SYSTEM_MESSAGE:Number = 3;
		
	}
}