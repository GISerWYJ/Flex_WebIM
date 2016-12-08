package net.lanelife.framework.desktop.events
{
	import flash.events.Event;
	
	import net.lanelife.framework.desktop.basenodes.XBaseNode;

	/**
	 * 关于节点的事件
	 * @author <a href="xusenhai@163.com">xusenhai@163.com</a>
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 */
	public class NodeEvent extends Event
	{
		public static const NODE_SELECTED:String = "nodeSelected";
		public static const NODE_UNSELECTED:String = "nodeUnSelected";
		public var node:XBaseNode;
		public function NodeEvent(type:String, n:XBaseNode,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			node = n;
		}
	}
}