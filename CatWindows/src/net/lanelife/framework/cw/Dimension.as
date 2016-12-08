package net.lanelife.framework.cw
{
	/**
	 * Dimension 类封装单个对象中组件的宽度和高度。 
	 * @author Lane
	 * 
	 */
	public class Dimension
	{
		public var width:Number;
		public var height:Number;
		
		/**
		 * 构造一个 Dimension，并将其初始化为指定宽度和高度。
		 * @param width 指定宽度
		 * @param height 指定高度
		 * 
		 */
		public function Dimension(width:Number, height:Number)
		{
			this.width = width;
			this.height = height;
		}
	}
}