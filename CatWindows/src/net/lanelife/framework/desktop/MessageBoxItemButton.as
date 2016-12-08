package net.lanelife.framework.desktop
{
	import spark.components.Button;
	
	public class MessageBoxItemButton extends Button
	{
		[Bindable]
		public var messageBoxItem:MessageBoxItem;
		
		public function MessageBoxItemButton()
		{
			super();
		}
	}
}