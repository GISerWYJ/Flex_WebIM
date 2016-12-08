package net.lanelife.cat77.view.components
{
	import spark.components.supportClasses.ItemRenderer;
	
	public class EmployeeNodeItemRenderer extends ItemRenderer
	{
		[SkinState("closed")]
		[SkinState("expand")]
		
		private var _closed:Boolean = true;
		
		public function EmployeeNodeItemRenderer()
		{
			super();
		}
		
		public function get closed():Boolean
		{
			return _closed;
		}
		
		public function set closed(value:Boolean):void
		{
			_closed = value;
			setCurrentState(getCurrentRendererState());
		}
		
		override protected function getCurrentRendererState():String
		{
			if (_closed) {
				return "closed";
			} else {
				return "expand";
			}
		}
	}
}