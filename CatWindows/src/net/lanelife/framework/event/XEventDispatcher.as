package net.lanelife.framework.event
{
	import flash.events.IEventDispatcher;
	
	public class XEventDispatcher
	{
		private static var instance : XEventDispatcher;  
		private var eventDispatcher : IEventDispatcher;
		
		/**
		 * Returns the single instance of the dispatcher
		 */ 
		public static function getInstance() : XEventDispatcher 
		{
			if ( instance == null )
				instance = new XEventDispatcher();
			
			return instance;
		}
		
		public static function getNewInstance() : XEventDispatcher 
		{
			return new XEventDispatcher;
		}
		
		/**
		 * Constructor.
		 */
		public function XEventDispatcher( target:IEventDispatcher = null ) 
		{
			eventDispatcher = new flash.events.EventDispatcher( target );
		}
		
		/**
		 * Adds an event listener.
		 */
		public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ) : void 
		{
			eventDispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		/**
		 * Removes an event listener.
		 */
		public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ) : void 
		{
			eventDispatcher.removeEventListener( type, listener, useCapture );
		}
		
		/**
		 * Dispatches a cairngorm event.
		 */
		public function dispatchEvent( event:XEvent ) : Boolean 
		{
			return eventDispatcher.dispatchEvent( event );
		}
		
		/**
		 * Returns whether an event listener exists.
		 */
		public function hasEventListener( type:String ) : Boolean 
		{
			return eventDispatcher.hasEventListener( type );
		}
		
		/**
		 * Returns whether an event will trigger.
		 */
		public function willTrigger(type:String) : Boolean 
		{
			return eventDispatcher.willTrigger( type );
		}
	}
}