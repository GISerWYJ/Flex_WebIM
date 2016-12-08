/**
 * @author 许森海
 * @langversion 3.0
 * @playerversion Flash 10
 * @playerversion AIR 1.5
 * @productversion Flex 4
 */
package net.lanelife.framework.desktop.basenodes
{
	import mx.controls.Image;
	
	/**
	 * @author xusenhai@163.com
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 */
	public class XImageNode extends XBaseNode
	{
		private var _image:Image;
		public function XImageNode()
		{
			super();
			this._image=new Image();
			this.addElement(_image);
		}
		
		public function get source():Object
		{
			return this._image.source;
		}
		
		public function set source(value:Object):void
		{
			_image.source=value;
		}
		
	}
}