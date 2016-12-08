package net.lanelife.framework.cw
{
	/**
	 * @author Darkness
	 * @version 1.0 保持官方Alert.show()签名基本兼容
	 * @data 2011-06-29
	 */
	public class Alert
	{
		[Bindable]
		[Embed(source="/net/lanelife/framework/cw/assets/images/plaint.png")]
		public static var ICON:Class;
		
		public static function show(text:String = "", title:String = "",
									flags:uint = 0x4 /* Prompt.OK */, 
									parent:* = null, 
									closeHandler:Function = null, 
									iconClass:Class = null, 
									defaultButtonFlag:uint = 0x4 /* Prompt.OK */,
									moduleFactory:* = null):void {
			
			Prompt.buttonAlign = "center";
			Prompt.show(null, text, title, flags, closeHandler, ICON, defaultButtonFlag);
		}
	}
}