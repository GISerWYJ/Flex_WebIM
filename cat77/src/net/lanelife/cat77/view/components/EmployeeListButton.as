package net.lanelife.cat77.view.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.lanelife.cat77.vo.Employee;
	
	import spark.components.Button;
	import spark.components.Image;
	
	[Event(name="faceMouseOver",type="flash.events.Event")]
	[Event(name="faceMouseOut",type="flash.events.Event")]
	
	public class EmployeeListButton extends Button
	{
		[Bindable]
		public var employee:Employee;
		
		[SkinPart(required="true")]
		public var faceDisplay:Image;
		
		public function EmployeeListButton()
		{
			super();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			
			super.partAdded(partName, instance);
			
			if (instance == faceDisplay)
			{
				faceDisplay.addEventListener(MouseEvent.MOUSE_OVER, function(event:MouseEvent):void{
					dispatchEvent(new Event("faceMouseOver"));
				});
				faceDisplay.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):void{
					dispatchEvent(new Event("faceMouseOut"));
				});
			}
		}
	}
}