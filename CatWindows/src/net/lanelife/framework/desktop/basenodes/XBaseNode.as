/**
 * @author 许森海
 * @langversion 3.0
 * @playerversion Flash 10
 * @playerversion AIR 1.5
 * @productversion Flex 4
 */
package net.lanelife.framework.desktop.basenodes
{
	import flash.events.Event;
	
	import mx.events.ToolTipEvent;
	import mx.graphics.GradientEntry;
	import mx.graphics.LinearGradient;
	import mx.utils.UIDUtil;
	
	import net.lanelife.framework.desktop.events.NodeEvent;
	import net.lanelife.framework.desktop.util.math.MathD;
	
	import spark.components.Group;
	import spark.primitives.Rect;

	/**
	 * 基础的节点类,在创建一个节点的时候您可以选择设置它的宽,高等等,如果您需要为其添加图片以及其他组件的话,请继承此类完成操作即可.
	 * @author <a href="xusenhai@163.com">xusenhai@163.com</a>
	 * @see spark.components.Group
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 */
	public class XBaseNode extends Group 
	{
		private var _itemId:String;
		private var _childNodes:Array=[];
		private var _parentNode:XBaseNode;
		private var _centerX:Number=0;
		private var _centerY:Number=0;
		private var _angle:Number=0;
		private var _radius:Number=10;
		private var _r:Number = 60;
		private var _label:String="名称";
		private var _imgURL:String="net/lanelife/framework/desk/assets/images/icon.png";
		/**
		 * 是否正在拖拽中
		 */
		public var isDraging:Boolean=false;
		
		private var _isSelected:Boolean=false;
		/**
		 * 桌面图标双击时调用的函数
		 **/
		private var _deskFunction:Function;
		/**
		 * 桌面图标双击时调用的函数
		 **/
		public function get deskFunction():Function
		{
			return _deskFunction;
		}
		
		public function set deskFunction(value:Function):void
		{
			_deskFunction = value;
		}
		
		/**
		 * 整拖时的X修正值
		 */
		public var selectionXOffset:Number;
		
		/**
		 * 整拖时的Y修正值
		 */
		public var selectionYOffset:Number;
		
		/**
		 * 构造方法
		 *
		 */
		public function XBaseNode()
		{
			fillGraphics();
			//			this.alpha = .7;
			callLater(updatePoints);
		}
		[Bindable]
		public function get imgURL():String
		{
			return _imgURL;
		}

		public function set imgURL(value:String):void
		{
			_imgURL = value;
		}
		[Bindable]
		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			_label = value;
		}

		/**
		 * 数值越大，字节点的空隙越大
		 */
		public function get r():Number
		{
			return _r;
		}
		
		public function set r(value:Number):void
		{
			_r = value;
		}
		
		/**
		 * 填充节点的方法,如果要实现自己的填充方法,请继承此类并重写此函数
		 *
		 */
		protected function fillGraphics():void
		{
			var rect:Rect=new Rect();
			rect.percentHeight=100;
			rect.percentWidth=100;
			rect.radiusX=3;
			rect.radiusY=3;
			
			var fill:LinearGradient=new LinearGradient();
			fill.rotation=90;
			
			var entry_1:GradientEntry=new GradientEntry(0x007ac9);
			var entry_2:GradientEntry=new GradientEntry(0x003d7f);
			fill.entries=[entry_1, entry_2];
			
			rect.fill=fill;
			this.addElement(rect);
			
			callLater(updatePoints);
		}
		
		/**
		 * 刷新当前节点的中心坐标值
		 *
		 */
		public function updatePoints():void
		{
			if (this.width && this.height)
			{
				this._centerX=this.x + this.width / 2;
				this._centerY=this.y + this.height / 2;
				this.dispatchEvent(new Event("cpChanged"));
			}
		}
		
		/**
		 * 将节点设置为选中状态
		 * 此方法会触发NodeEvent.NODE_SELECTED事件
		 * @see cn.com.fri.core.event.NodeEvent
		 */
		public function select():void
		{
			this._isSelected=true;
			this.filters.pop();
			//			this.alpha = 1;
			this.dispatchEvent(new NodeEvent(NodeEvent.NODE_SELECTED, this));
		}
		
		/**
		 * 将节点设置为非选中状态
		 * 此方法会触发NodeEvent.NODE_UNSELECTED事件
		 * @see cn.com.fri.core.event.NodeEvent
		 */
		public function unselect():void
		{
			this.filters=[];
			this._isSelected=false;
			//			this.alpha = .7;
			this.dispatchEvent(new NodeEvent(NodeEvent.NODE_UNSELECTED, this));
		}
		
		override public function move(x:Number, y:Number):void
		{
			super.move(x, y);
			this.updatePoints();
		}
		
		
		/**
		 * 节点的ID值
		 */
		public function get itemId():String
		{
			if(this._itemId == null)
			{
				this._itemId = UIDUtil.createUID();
			}
			return this._itemId;
		}
		
		/**
		 * @private
		 */
		public function set itemId(id:String):void
		{
			this._itemId=id;
		}
		
		/**
		 * 添加一个字节点
		 * @param node
		 *
		 */
		public function addChildNode(node:XBaseNode):void
		{
			this._childNodes.push(node);
			node.parentNode=this;
		}
		
		/**
		 * 删除一个字节点
		 * @param node
		 *
		 */
		public function removeChildNode(node:XBaseNode):void
		{
			node.parentNode=null;
			this._childNodes.splice(this._childNodes.indexOf(node), 1);
		}
		
		/**
		 * 节点的中心X坐标
		 * @return 一个数字(Number)
		 *
		 */
		public function get centerX():Number
		{
			return _centerX;
		}
		
		/**
		 * @private
		 */
		public function set centerX(value:Number):void
		{
			_centerX=value;
		}
		
		/**
		 * 节点的中心Y坐标
		 */
		public function get centerY():Number
		{
			return _centerY;
		}
		
		/**
		 * @private
		 */
		public function set centerY(value:Number):void
		{
			_centerY=value;
		}
		
		/**
		 * 该节点是否已被选中
		 */
		public function get isSelected():Boolean
		{
			return _isSelected;
		}
		
		/**
		 * 该节点的父节点
		 */
		public function get parentNode():XBaseNode
		{
			return _parentNode;
		}
		
		/**
		 * @private
		 */
		public function set parentNode(value:XBaseNode):void
		{
			_parentNode=value;
		}
		
		public function get childNodes():Array
		{
			return _childNodes;
		}
		
		/**
		 * 设定半径和角度
		 *
		 */
		public function initMathD():void
		{
			var count:int=this.childNodes.length;
			if (count <= 2)
			{
				count=3
			}
			this.angle=360 / count;
			this.radius=(this.height + _r) / MathD.sin(angle);
			if (count <= 2)
			{
				radius+=100;
			}
		}
		
		/**
		 * 角度,用于计算格式化该节点下的子节点的位置
		 */
		public function get angle():Number
		{
			return _angle;
		}
		
		/**
		 * @private
		 */
		public function set angle(value:Number):void
		{
			_angle=value;
		}
		
		/**
		 * 半径,用于计算格式化该节点下的字节的位置
		 */
		public function get radius():Number
		{
			return _radius;
		}
		
		/**
		 * @private
		 */
		public function set radius(value:Number):void
		{
			_radius=value;
		}
		
		
	}
}