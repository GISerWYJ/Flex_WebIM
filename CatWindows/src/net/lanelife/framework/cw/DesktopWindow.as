package net.lanelife.framework.cw
{
	import net.lanelife.framework.cw.events.TaskbarButtonEvent;
	import net.lanelife.framework.cw.events.WindowEvent;
	import net.lanelife.framework.cw.events.WindowEventDispatcher;

	public class DesktopWindow extends Window
	{
		/**
		 * 任务栏按钮 
		 */
		public var taskbarButton:TaskbarButton;
		
		private var _taskbarButtonLabel:String = "";
		
		/**
		 * 任务栏按钮文本。
		 * 如果此文本为空，则修改title将同时修改任务栏按钮文本。
		 * 如果此文本不为空，则修改title将不会同时修改任务栏按钮文本。
		 * @return 
		 * 
		 */
		public function get taskbarButtonLabel():String
		{
			return _taskbarButtonLabel;
		}
		public function set taskbarButtonLabel(value:String):void
		{
			_taskbarButtonLabel = value;
			taskbarButton.label = value;
		}
		
		
		private var _taskbarButtonVisible:Boolean = true;
		
		public function get taskbarButtonVisible():Boolean
		{
			return taskbarButton.visible;
		}
		
		public function set taskbarButtonVisible(value:Boolean):void
		{
			_taskbarButtonVisible = value;
			if(value)
				taskbarButton.show();
			else
				taskbarButton.hide();
		}
		
		override public function set title(value:String):void 
		{
			super.title = value;
			
			if (taskbarButtonLabel=="")
				taskbarButton.label = title;
		}
		
		override public function set icon(value:Object):void
		{
			super.icon = value;
			
			if (iconDisplay)
			{
				if (icon!=null)
				{
					taskbarButton.icon = icon;
				}
			}
		}

		override protected function beforeInit():void {
			this.taskbarButton = new TaskbarButton(this);
		}
		
		public function DesktopWindow(title:String=null, owner:Window=null)
		{
			super(title, owner);
		}
		
		override protected function beforeCreate():void {
			super.beforeCreate();
			
			WindowEventDispatcher.getInstance().dispatchEvent(
				new TaskbarButtonEvent(TaskbarButtonEvent.TASKBAR_BUTTON_CREATE, taskbarButton)
			);
		}
		
		override protected function beforeDestroy():void {
			super.beforeDestroy();
			
			WindowEventDispatcher.getInstance().dispatchEvent(
				new TaskbarButtonEvent(TaskbarButtonEvent.TASKBAR_BUTTON_DESTROY, taskbarButton)
			);
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
		
			if (instance == iconDisplay)
			{
				if (icon!=null)
				{
					taskbarButton.icon = icon;
				}
			}
		}
	}
}