package net.lanelife.framework.desktop.events
{
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * 关于工作区的事件 
	 * @author <a href="xusenhai@163.com">xusenhai@163.com</a>
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 */
	public class CanvasSelectionEvent extends Event
	{
		/**
		 * 当选择结束的时候可以触发此事件 
		 */
		public static const SELECTION_END:String = "selectionEnd";
		
		/**
		 * 开始选择的坐标点 
		 */
		public var selectionBeginPoint:Point;
		
		/**
		 * 结束选择的坐标点 
		 */
		public var selectionEndPoint:Point;
		
		/**
		 * 构造方法 
		 * @see flash.events.Event
		 * @param type
		 * 			事件类型
		 * @param beginPoint
		 * 			开始的坐标点
		 * @param endPoint
		 * 			结束的坐标点
		 * @param bubbles
		 * @param cancelable
		 * 
		 */
		public function CanvasSelectionEvent(type:String, beginPoint:Point,endPoint:Point,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.selectionBeginPoint = beginPoint;
			this.selectionEndPoint = endPoint;
		}
	}
}