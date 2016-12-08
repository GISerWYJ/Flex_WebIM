package net.lanelife.framework.cw
{
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	
	import spark.components.ToggleButton;
	
	public class StartButton extends ToggleButton
	{
		[Bindable]
		/**
		 * 按钮为 up 状态时的图标。 
		 * @return 
		 * 
		 */
		public var upIcon:Object;
		
		[Bindable]
		/**
		 * 按钮为 over 状态时的图标。 
		 * @return 
		 * 
		 */
		public var overIcon:Object;
		
		[Bindable]
		/**
		 * 按钮为 down 状态时的图标。
		 * @return 
		 * 
		 */
		public var downIcon:Object;
		
		[Bindable]
		/**
		 * 按钮为 selected 状态时的图标。 
		 * @return 
		 * 
		 */
		public var selectedIcon:Object;
		
		public function StartButton()
		{
			super();
			FlexGlobals.topLevelApplication.parent.addEventListener(MouseEvent.MOUSE_DOWN, parent_mouseDownHandler);
		}
		
		public static var display:Boolean = false;
		
		private function parent_mouseDownHandler(event:MouseEvent):void
		{
			if (!display)
				this.selected = false;
		}
	}
}