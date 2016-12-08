package net.lanelife.framework.component
{
	import flash.events.MouseEvent;
	
	import mx.core.mx_internal;
	
	import spark.components.VScrollBar;
	import spark.core.IViewport;
	
	use namespace mx_internal;
	
	/**
	 * 默认滚动速度太慢，重新实现
	 */
	public class VerticalScrollBar extends VScrollBar
	{
		override mx_internal function mouseWheelHandler(event:MouseEvent):void
		{
			const vp:IViewport = viewport;
			if (event.isDefaultPrevented() || !vp || !vp.visible)
				return;
			var delta:Number = event.delta;
			var direction:Number = 0;
			var distance:Number = 40;
			if (delta < 0){
				direction = 1;
			} else if (delta == 0){
				direction = 0;
			} else {
				direction = -1;
			}
			vp.verticalScrollPosition += distance * direction;
			event.preventDefault();
		}
	}
}