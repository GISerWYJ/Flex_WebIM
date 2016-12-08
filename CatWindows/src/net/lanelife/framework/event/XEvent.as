package net.lanelife.framework.event
{

	import flash.events.Event;
	
	public class XEvent extends Event
	{
		/**
		 * The data property can be used to hold information to be passed with the event
		 * in cases where the developer does not want to extend the CairngormEvent class.
		 * However, it is recommended that specific classes are created for each type
		 * of event to be dispatched.
		 */
		public var data : *;
		
		/**
		 * Constructor, takes the event name (type) and data object (defaults to null)
		 * and also defaults the standard Flex event properties bubbles and cancelable
		 * to true and false respectively.
		 */
		public function XEvent( type : String, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, bubbles, cancelable );
		}

		public function setData(data:*):XEvent {
			this.data = data;
			return this;
		}
		
		/**
		 * Dispatch this event via the Cairngorm event dispatcher.
		 */
		public function dispatch() : Boolean
		{
			return XEventDispatcher.getInstance().dispatchEvent( this );
		}
	}
}