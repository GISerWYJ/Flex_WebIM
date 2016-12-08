package net.lanelife.framework.desktop.mediators
{

	
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	
	import mx.controls.Alert;
	import mx.controls.Menu;
	import mx.core.IVisualElement;
	
	import net.lanelife.framework.cw.container.WindowsContainer;
	import net.lanelife.framework.desktop.basenodes.XBaseNode;
	import net.lanelife.framework.desktop.events.CanvasSelectionEvent;
	import net.lanelife.framework.desktop.events.NodeEvent;
	import net.lanelife.framework.desktop.mediators.iface.impl.Mediator;
	import net.lanelife.framework.desktop.util.RightClickManager;
	
	import spark.effects.Move;

	/**
	 * <p>主要为XBaseCanvas提供中介
	 * @author <a href="xusenhai@163.com">xusenhai@163.com</a>
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 */
	public class BaseCanvasMediator extends Mediator
	{

		/**
		 * 注册与Facade当中的名称，请勿重复
		 */
		public static const NAME:String="BaseCanvasMediator";
		private var _baseCanvas:WindowsContainer;
		private var selectedFilter:GlowFilter;
		private var _allNodes:Array=[];
		private var _selectedNodes:Array=[];
		private var _firstSelectedItem:XBaseNode;
		private var moveEffect:Move;
		/**
		 * 构造方法，需要一个显示对象作为这个中介者的中介对象。
		 *
		 */
		public function BaseCanvasMediator(el:IVisualElement)
		{
			super(el);
			selectedFilter=new GlowFilter(0xFBDF2F);
			moveEffect=new Move();
			this._baseCanvas=el as WindowsContainer;
			this._baseCanvas.addEventListener(CanvasSelectionEvent.SELECTION_END, onCanvasSelectionEnd);
			this._baseCanvas.addEventListener(MouseEvent.MOUSE_DOWN, onCanvasMouseDown);
		}

		override public function get name():String
		{
			return NAME;
		}


		/**
		 *
		 * @return
		 *
		 */
		public function get view():WindowsContainer
		{
			return this._baseCanvas;
		}

		/**
		 * 根据节点ID获取节点
		 * @param itemId
		 * @return
		 *
		 */
		public function getNodeById(itemId:String):WindowsContainer
		{
			return null;
		}

		/**
		 * 添加一个节点
		 * @param node
		 *
		 */
		protected var rightClickRegisted:Boolean = false; 
		public function addNode(node:XBaseNode):void
		{
			this._allNodes.push(node);
			view.addElement(node);
			//params.wmode = "opaque";//屏蔽系统右键菜单的关键
			if (!rightClickRegisted)  
			{  
				RightClickManager.regist();  
				rightClickRegisted = true;  
			} 
			node.addEventListener(RightClickManager.RIGHT_CLICK,RightClickHandler);
			node.addEventListener(MouseEvent.CLICK,removeMenu);
			
			node.addEventListener(MouseEvent.MOUSE_DOWN, onNodeMouseDown);
			node.addEventListener(NodeEvent.NODE_SELECTED, onNodeSelecte);
			node.addEventListener(NodeEvent.NODE_UNSELECTED, onNodeUnselected);
		}
		//mx:Tree控件右击事件
		
		private function RightClickHandler(event:ContextMenuEvent):void
		{
			event.stopPropagation();
			if(_baseCanvas.menu!=null){
				_baseCanvas.menu.hide();
				_baseCanvas.menu=null;
			} 
			var menuItem:Object;
			menuItem = new Object;  
			menuItem.label = '删除1'; //菜单项名称
			_baseCanvas.menuItems=new Array();
			_baseCanvas.menuItems.push(menuItem);
			_baseCanvas.menu = Menu.createMenu(_baseCanvas,_baseCanvas.menuItems, false);
			_baseCanvas.menu.variableRowHeight = true;
			var point:Point = new Point(_baseCanvas.mouseX,_baseCanvas.mouseY);  
			point = _baseCanvas.localToGlobal(point);   
			_baseCanvas.menu.show(point.x,point.y);  //显示右键菜单
		}
	
		private function removeMenu(event:MouseEvent):void 
		{  
			if(_baseCanvas.menu!=null)  
			{  
				_baseCanvas.menu.hide();
				_baseCanvas.menu=null;  
			}  
		}
		/**
		 * 选中界面重所有的节点 
		 * 
		 */
		public function selectedAllNodes():void
		{
			for each(var node:XBaseNode in this._allNodes)
			{
				if(node.isSelected)
				{
					continue;
				}
				node.select();
				selectedNodes.push(node);
			}
			view.isSelection = true;
		}

		/**
		 * 删除一个节点
		 * @param node
		 *
		 */
		public function removeNode(node:XBaseNode):void
		{
			_allNodes.splice(_allNodes.indexOf(node), 1);
			if (node.parentNode)
			{
				node.parentNode.removeChildNode(node);
			}
			var arr:Array=[];
			
			arr=null;
			view.removeElement(node);
//			Memory.gc();
		}
		
		/**
		 * 根据数组删除节点 
		 * @param nodes
		 * 
		 */
		public function removeNodes(nodes:Array):void
		{
			for each (var node:XBaseNode in nodes)
			{
				this.removeNode(node);
			}
		}
		/**
		 * 所有的节点
		 *
		 */
		public function get allNodes():Array
		{
			return _allNodes;
		}


		/**
		 * 
		 */
		public function clearSelectionNodes():void
		{
			for each (var n:XBaseNode in _selectedNodes)
			{
				n.unselect();
			}
			this._selectedNodes=[];
		}

		/**
		 *
		 * @param beginPoint
		 * @param endPoint
		 *
		 */
		public function setSelectionNodes(beginPoint:Point, endPoint:Point):void
		{
			for each (var n:XBaseNode in _allNodes)
			{
				if (beginPoint.x < endPoint.x && beginPoint.y < endPoint.y)
				{
					if (n.centerX > beginPoint.x && n.centerY > beginPoint.y && n.centerX < endPoint.x && n.centerY < endPoint.y)
					{
						n.select();
						selectedNodes.push(n);
					}
				}
				if (beginPoint.x > endPoint.x && beginPoint.y > endPoint.y)
				{
					if (n.centerX > endPoint.x && n.centerY > endPoint.y && n.centerX < beginPoint.x && n.centerY < beginPoint.y)
					{
						n.select();
						selectedNodes.push(n);
					}
				}
				if (beginPoint.x < endPoint.x && beginPoint.y > endPoint.y)
				{
					if (n.centerX > beginPoint.x && n.centerY < beginPoint.y && n.centerX < endPoint.x && n.centerY > endPoint.y)
					{
						n.select();
						selectedNodes.push(n);
					}
				}
				if (beginPoint.x > endPoint.x && beginPoint.y < endPoint.y)
				{
					if (n.centerX < beginPoint.x && n.centerY > beginPoint.y && n.centerY < endPoint.y && n.centerX > endPoint.x)
					{
						n.select();
						selectedNodes.push(n);
					}
				}
			}
			view.isSelection=true;
		}
		/**
		 * 当面板停止选择的时候
		 * @param e
		 *
		 */
		private function onCanvasSelectionEnd(e:CanvasSelectionEvent):void
		{
			this.setSelectionNodes(e.selectionBeginPoint, e.selectionEndPoint);
		}

		/**
		 * 当鼠标在节点上按下后
		 * @private
		 * @param e
		 *
		 */
		private function onNodeMouseDown(e:MouseEvent):void
		{
			e.stopPropagation();
			var node:XBaseNode=e.currentTarget as XBaseNode;
//			node.setFocus();//不要用这个，有问题。具体什么问题我忘掉了。
			//Mouse.hide();
			//view.cursorManager.setCursor(GIconManager.CURSOR_DRAG_ARROW, 2, -12, -12);
			node.addEventListener(MouseEvent.MOUSE_UP, onNodeMouseUp);
			view.setElementIndex(node, view.numElements - 1);
			view.stage.addEventListener(MouseEvent.MOUSE_MOVE, onNodeMouseMove);
			if (view.isSelection && node.isSelected)
			{
				_firstSelectedItem=node;
				var leftNode:XBaseNode=findLeftNode();
				var topNode:XBaseNode=findTopNode();
				var bottomNode:XBaseNode=findBottomNode();
				var rightNode:XBaseNode=findRightNode();
				var lx:Number=node.x - leftNode.x;
				var ly:Number=node.y - topNode.y;
				var w:Number;
				if (rightNode == _firstSelectedItem)
				{
					w=view.width - _firstSelectedItem.width - lx;
				}
				else
				{
					w=leftNode.x + (view.width - rightNode.x - rightNode.width);
				}
				var h:Number;
				if (bottomNode == _firstSelectedItem)
				{
					h=view.height - _firstSelectedItem.height - ly;
				}
				else
				{
					h=topNode.y + (view.height - bottomNode.y - bottomNode.height);
				}
				node.startDrag(false, new Rectangle(lx, ly, w, h));
				node.isDraging=true;

				var xOffset:Number=node.x;
				var yOffset:Number=node.y;
				for each (var baseNode:XBaseNode in this.selectedNodes)
				{
					if (baseNode == node)
					{
						continue;
					}
					else
					{
						baseNode.selectionXOffset=xOffset - baseNode.x;
						baseNode.selectionYOffset=yOffset - baseNode.y;
					}
				}
				view.addEventListener(Event.ENTER_FRAME, dragAllHandler);
				return;
			}
			clearSelectionNodes();
			node.select();
			selectedNodes.push(node);


			node.startDrag(false, new Rectangle(0, 0, view.width - node.width, view.height - node.height));
			node.isDraging=true;
		}


		/**
		 * 节点在拖动的时候,随时改变节点的中心坐标点.
		 * @param e
		 *
		 */
		private function onNodeMouseMove(e:MouseEvent):void
		{
			this._selectedNodes[0].updatePoints();
		}



		/**
		 * 当鼠标在节点上松开后
		 * @private
		 * @param e
		 *
		 */
		private function onNodeMouseUp(e:MouseEvent):void
		{
			var node:XBaseNode=e.currentTarget as XBaseNode;
			view.cursorManager.removeAllCursors();
			Mouse.show();
			node.stopDrag();
			node.removeEventListener(MouseEvent.MOUSE_UP, onNodeMouseUp);
			view.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onNodeMouseMove);
			if (view.isSelection)
			{
				view.removeEventListener(Event.ENTER_FRAME, dragAllHandler);
			}
		}
		private function onNodeSelecte(e:NodeEvent):void
		{
			var node:XBaseNode=e.currentTarget as XBaseNode;
			node.filters=node.filters.concat(selectedFilter);
		}
		private function onNodeUnselected(e:NodeEvent):void
		{
			var node:XBaseNode=e.currentTarget as XBaseNode;
			node.filters=[];
		}

		private function onCanvasMouseDown(e:MouseEvent):void
		{
			clearSelectionNodes();
			_firstSelectedItem=null;
		}

		private function findTopNode():XBaseNode
		{
			var topNode:XBaseNode;
			for each (var n:XBaseNode in _selectedNodes)
			{
				if (n == _firstSelectedItem)
				{
					continue;
				}
				var len:Number=_firstSelectedItem.y - n.y;
				if (len >= 0)
				{
					if (topNode != null)
					{
						var len2:Number=_firstSelectedItem.y - topNode.y;
						if (len2 >= 0)
						{
							if (len > len2)
							{
								topNode=n;
							}
						}
					}
					else
					{
						topNode=n;
					}
				}
			}
			if (topNode == null)
			{
				return _firstSelectedItem;
			}
			return topNode;
		}

		private function findLeftNode():XBaseNode
		{
			var leftNode:XBaseNode;
			for each (var n:XBaseNode in _selectedNodes)
			{
				if (n == _firstSelectedItem)
				{
					continue;
				}
				var len:Number=_firstSelectedItem.x - n.x;
				if (len >= 0)
				{
					if (leftNode != null)
					{
						var len2:Number=_firstSelectedItem.x - leftNode.x;
						if (len2 >= 0)
						{
							if (len > len2)
							{
								leftNode=n;
							}
						}
					}
					else
					{
						leftNode=n;
					}
				}
			}
			if (leftNode == null)
			{
				return _firstSelectedItem;
			}
			return leftNode;
		}

		private function findBottomNode():XBaseNode
		{
			var bottomNode:XBaseNode;
			for each (var n:XBaseNode in _selectedNodes)
			{
				if (n == _firstSelectedItem)
				{
					continue;
				}
				var len:Number=n.y - _firstSelectedItem.y;
				if (len >= 0)
				{
					if (bottomNode != null)
					{
						var len2:Number=bottomNode.y - _firstSelectedItem.y;
						if (len2 >= 0)
						{
							if (len > len2)
							{
								bottomNode=n;
							}
						}
					}
					else
					{
						bottomNode=n;
					}
				}
			}
			if (bottomNode == null)
			{
				return _firstSelectedItem;
			}
			return bottomNode;
		}

		private function findRightNode():XBaseNode
		{
			var rightNode:XBaseNode;
			for each (var n:XBaseNode in _selectedNodes)
			{
				if (n == _firstSelectedItem)
				{
					continue;
				}
				var len:Number=n.x - _firstSelectedItem.x;
				if (len >= 0)
				{
					if (rightNode != null)
					{
						var len2:Number=rightNode.x - _firstSelectedItem.x;
						if (len2 >= 0)
						{
							if (len > len2)
							{
								rightNode=n;
							}
						}
					}
					else
					{
						rightNode=n;
					}
				}
			}
			if (rightNode == null)
			{
				return _firstSelectedItem;
			}
			return rightNode;
		}

		private function dragAllHandler(e:Event):void
		{
			for each (var n:XBaseNode in this._selectedNodes)
			{
				if (n != _firstSelectedItem)
				{
					n.move(_firstSelectedItem.x - n.selectionXOffset, _firstSelectedItem.y - n.selectionYOffset);
				}
			}
		}

		/**
		 * 被选中的恶节点集合
		 * @return
		 *
		 */
		public function get selectedNodes():Array
		{
			return _selectedNodes;
		}

		/**
		 * @private
		 */
		public function set selectedNodes(a:Array):void
		{
			this._selectedNodes=a;
		}

		/**
		 * 格式化所给节点的子节点
		 * @param parentNode
		 *
		 */
		public function formateNode(vh:String):void
		{
			if (_allNodes.length == 0)
			{
				return;
			}
			var i:int,j:int=0;
			var xT:Number, yT:Number;
			var node:XBaseNode;
			moveEffect.stop();
			if(vh=="V"){
				for each (node in _allNodes)
				{
					moveEffect.target=node;
					moveEffect.xFrom=node.x;
					moveEffect.yFrom=node.y;
					xT=node.width*j;
					yT=node.height*i;
					xT=xT<0?0:xT;
					yT=yT<0?0:yT;
					if (xT > view.width){
						xT=view.width - node.width;
					}
					if (yT+node.height>view.height){
						j++;
						i=0;
						xT=node.width*j;
						yT=node.height*i;
					}
					moveEffect.xTo=xT;
					moveEffect.yTo=yT;
					moveEffect.play();
					i++;
				}
			}
			else{
				for each (node in _allNodes)
				{
					moveEffect.target=node;
					moveEffect.xFrom=node.x;
					moveEffect.yFrom=node.y;
					xT=node.width*i;
					yT=node.height*j;
					xT=xT<0?0:xT;
					yT=yT<0?0:yT;
					if (xT+node.width> view.width){
						j++;
						i=0;
						xT=node.width*i;
						yT=node.height*j;
					}
					if (yT>view.height){
					
						yT=view.height - node.height;
					}
					moveEffect.xTo=xT;
					moveEffect.yTo=yT;
					moveEffect.play();
					i++;
				}
			}
		}
	}
}