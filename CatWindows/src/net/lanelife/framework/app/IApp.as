package net.lanelife.framework.app
{
	import flash.events.IEventDispatcher;   
	
	public interface IApp extends IEventDispatcher {   
		
		function getAppName():String;   
		
		function getAuthor():String;
		
		function start():void;
	}
}