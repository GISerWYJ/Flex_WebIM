package net.lanelife.framework.app
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;
	
	import net.lanelife.framework.util.Map;

	public class AppManager extends EventDispatcher
	{
		private static var apps:Map = new Map;
		
		// 所有app的计数器
		private static var appCounts:Number = 0;
		
		// 加载成功app数
		private static var appLoadSuccessCounts:Number = 0;
		
		private static var _instance:AppManager;
		
		private static function getInstance():AppManager {
			
			if(_instance == null) {
				_instance = new AppManager;
			}
			
			return _instance;
		}
		
		public static function installApp(appName:String):void {
			appCounts++;
			
			preloadModule(appName + ".swf");
		}
		
		public static function getApps():Map {
			
			return apps;
		}
		
		public static function getApp(appName:String): IApp {
			return apps.get(appName) as IApp;
		}
		
		/**
		 * 预加载app
		 */
		private static function preloadModule(moduleName:String):void {
			
			var module:IModuleInfo = ModuleManager.getModule(moduleName);   
			
			module.addEventListener(ModuleEvent.READY, onModuleReadyUseModuleManager);   
			module.addEventListener(ModuleEvent.ERROR, function(event:ModuleEvent):void{
				Alert.show(event.errorText);
			});
			
			module.load();  
		}

		private static function onModuleReadyUseModuleManager(event:Event):void{   
		  
			var me:ModuleEvent = event as ModuleEvent;     
			var module:IApp = me.module.factory.create() as IApp;         
			apps.put(module.getAppName(), module);
			
			appLoadSuccessCounts++;
			
			FlexGlobals.topLevelApplication.addElement(module);
			
			checkLoadAppSuccess();
		}
		
		/**
		 * 加载所有app成功后执行方法
		 */
		public static function onLoadApp(fun:Function):void {
			
			checkLoadAppSuccess();
			
			getInstance().addEventListener(AppEvent.APP_LOAD_SUCCESS, fun);
		}
		
		public static function checkLoadAppSuccess():void {
			if(appCounts == appLoadSuccessCounts) {// 加载所有app成功
				var e:AppEvent = new AppEvent(AppEvent.APP_LOAD_SUCCESS);
				e.apps = apps;
				
				getInstance().dispatchEvent(e);
			}
		}
		
		//setup,ready,unload,progress,error
		private function onModuleProgress (e:ModuleEvent) : void {   
			
			trace ("ModuleEvent.PROGRESS received: " + e.bytesLoaded + " of " + e.bytesTotal + " loaded.");   
		}  

	}
}