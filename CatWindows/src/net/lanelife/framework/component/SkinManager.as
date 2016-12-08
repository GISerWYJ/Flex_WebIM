package net.lanelife.framework.component
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import mx.controls.Alert;
	import mx.graphics.BitmapFillMode;
	import mx.managers.CursorManager;
	
	import net.lanelife.framework.cw.Window;
	import net.lanelife.framework.desktop.WebOS;

	public class SkinManager
	{
		private static var skinPicLoaderContext:LoaderContext = new LoaderContext();
		
		/**
		 * 更新Window背景皮肤
		 */
		public static function changeSkin(skin:Object, fillModel:String=BitmapFillMode.SCALE):void
		{
			loadSkin(skin, function(event:Event):void {
				CursorManager.removeBusyCursor();
				Window.BACKGROUND_BITMAP = null;
				Window.BACKGROUND_BITMAP = DisplayObject(LoaderInfo(event.target).loader);
				Window.BACKGROUND_BITMAP_FILLMODEL = fillModel;
			}, fillModel);
		}
		
		/**
		 * 更新WEB OS 桌面背景
		 */
		public static function changeDesktopBackground(skin:Object, fillModel:String=BitmapFillMode.SCALE):void
		{
			loadSkin(skin, function(event:Event):void {
				CursorManager.removeBusyCursor();
				WebOS.BACKGROUND_BITMAP = null;
				WebOS.BACKGROUND_BITMAP = DisplayObject(LoaderInfo(event.target).loader);
				WebOS.BACKGROUND_BITMAP_FILLMODEL = fillModel;
			}, fillModel);	
		}
		
		/**
		 * 加载skin
		 */
		public static function loadSkin(skin:Object, fun:Function, fillModel:String=BitmapFillMode.SCALE):void {
			
			if (skin is uint)
			{
				Window.BACKGROUND_BITMAP = null;
				Window.CHROME_COLOR = skin as uint;
			}
			else
			{
				var skinPicLoader:Loader = new Loader();
				skinPicLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, fun);
				skinPicLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, skinPicLoader_ioErrorHandler);
				skinPicLoaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
				CursorManager.setBusyCursor();
				skinPicLoader.load(new URLRequest(String(skin)), skinPicLoaderContext);
			}
		}
		
		private static function skinPicLoader_ioErrorHandler(event:Event):void
		{
			CursorManager.removeBusyCursor();
			Window.BACKGROUND_BITMAP = null;
			Alert.show("加载外观图像失败,系统将使用默认外观!","错误提示");
		}
	}
}