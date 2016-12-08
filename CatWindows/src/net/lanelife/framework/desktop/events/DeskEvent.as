package net.lanelife.framework.desktop.events
{
	import flash.events.Event;

	/**
	 * 桌面图标排列
	 * @author <a href="xusenhai@163.com">xusenhai@163.com</a>
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 */
	public class DeskEvent extends Event
	{
		public static const NODE_HX:String = "nodehx";
		public var xh:String;
		public function DeskEvent(type:String,xh:String=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.xh=xh;
		}
	}
}