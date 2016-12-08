package net.lanelife.framework.cw
{
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;

	public class CursorMgr
	{
		[Embed(source="assets/cursor/ns.png")]
		public static const NS:Class;
		[Embed(source="assets/cursor/ew.png")]
		public static const EW:Class;
		[Embed(source="assets/cursor/nesw.png")]
		public static const NESW:Class;
		[Embed(source="assets/cursor/nwse.png")]
		public static const NWSE:Class;
		
		public static const SIDE_OTHER:Number = 0;
		public static const SIDE_TOP:Number = 1;
		public static const SIDE_BOTTOM:Number = 2;
		public static const SIDE_LEFT:Number = 4;
		public static const SIDE_RIGHT:Number = 8;
		
		private static var currentType:Class = null;
		
		public static function setCursor(type:Class, xOffset:Number = 0, yOffset:Number = 0):void
		{
			if(currentType != type){
				currentType = type;
				CursorManager.removeCursor(CursorManager.currentCursorID);
				if(type != null){
					CursorManager.setCursor(type, CursorManagerPriority.MEDIUM, xOffset, yOffset);
				}
			}
		}
		
	}
}