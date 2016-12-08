package net.lanelife.framework.cw
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Menu;
	import mx.core.FlexGlobals;
	import mx.events.MenuEvent;
	import mx.events.SandboxMouseEvent;
	
	import net.lanelife.framework.cw.events.TaskbarButtonEvent;
	import net.lanelife.framework.cw.events.WindowEvent;
	import net.lanelife.framework.cw.events.WindowEventDispatcher;
	
	import spark.components.BorderContainer;
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.SkinnableContainer;
	import spark.core.IDisplayText;
	
	[Event(name="windowOpened",type="net.lanelife.framework.cw.events.WindowEvent")]
	[Event(name="windowClosed",type="net.lanelife.framework.cw.events.WindowEvent")]
	[Event(name="windowFocusIn",type="net.lanelife.framework.cw.events.WindowEvent")]
	
	/**
	 * Cat Window V1.0
	 * @author 蓝易 Lane
	 * 
	 */
	public class Window extends SkinnableContainer
	{
		[Bindable]
		/**
		 * 全局窗口主要颜色。
		 * @return 
		 * 
		 */
		public static var CHROME_COLOR:uint = 0x009fea;
		
		[Bindable]
		/**
		 * 全局窗口填充图。
		 * @return 
		 * 
		 */
		public static var BACKGROUND_BITMAP:Object;
		
		[Bindable]
		public static var BACKGROUND_BITMAP_FILLMODEL:Object;
		
		[Bindable]
		/**
		 * 全局内容区域背景透明度。
		 * @return 
		 * 
		 */
		public static var CONTENT_BACKGROUND_ALPHA:Number = 0.88;
		
		/**
		 * 光标在窗口边缘处变换的感应距离。
		 */
		public static var MOUSE_INDUCTION_MARGIN:Number = 4;
		
		[Bindable]
		/**
		 * 窗口主要颜色，此属性优先于 Window.CHROME_COLOR。
		 * @return 
		 * 
		 */
		public var chromeColor:uint;
		
		[Bindable]
		/**
		 * 窗口填充图，此属性优先于 Window.BACKGROUND_BITMAP。
		 * @return 
		 * 
		 */
		public var backgroundBitmap:Object;
		
		[Bindable]
		/**
		 * 内容区域背景透明度，此属性优先于 Window.CONTENT_BACKGROUND_ALPHA。
		 * @return 
		 * 
		 */
		public var contentBackgroundAlpha:Number;
		
		/**
		 * 管理该窗口的WindowManager的引用。
		 */
		public var manager:WindowManager;
		
		/**
		 * 是否可拖动窗口。
		 */
		public var draggable:Boolean = true;
		
		/**
		 * 标志该窗口是否为模式窗口。
		 */
		public var modal:Boolean = false;
		
		/**
		 * 此窗口当前拥有的所有窗口
		 */
		public var ownedWindows:ArrayCollection = new ArrayCollection();
		
		/**
		 * 是否可改变窗口大小 
		 */
		public var resizable:Boolean = true;
		

		/**
		 * 当前正在改变大小的窗口。 
		 */
		private static var resizer:Window;
		
		/**
		 * 当前鼠标形状。 
		 */
		private var cursorState:Number = 0;
		
		
		
		
		[SkinPart(required="false")]
		/**
		 * 定义容器中标题文本的外观的外观部件。 
		 */
		public var titleDisplay:IDisplayText;
		
		[SkinPart(required="false")]
		/**
		 * 定义窗口图标外观的外观部件。 
		 */
		public var iconDisplay:Image;
		
		[SkinPart(required="false")]
		/**
		 * 定义容器中最小化按钮外观的外观部件。
		 */
		public var minimizeButton:Button;
		
		[SkinPart(required="false")]
		/**
		 * 定义容器中最大化按钮外观的外观部件。
		 */
		public var maximizeButton:Button;
		
		[SkinPart(required="false")]
		/**
		 * 定义容器中还原按钮外观的外观部件。
		 */
		public var restoreButton:Button;
		
		[SkinPart(required="false")]
		/**
		 * 定义容器中关闭按钮外观的外观部件。
		 */
		public var closeButton:Button;
		
		[SkinPart(required="false")]
		/**
		 * 用户必须单击并拖动才可移动窗口的区域。
		 */
		public var moveArea:InteractiveObject;
		
		[SkinPart(required="false")]
		/**
		 * 标题栏弹出菜单的外观部件，用户通过点击该部件弹出菜单。
		 */
		public var titleBarMenuTrigger:Group;
		
		[SkinPart(required="true")]
		/**
		 * 窗口禁用时的遮罩层，这是一个必要的外观部件。
		 */
		public var maskLayer:BorderContainer;
		
		
		protected function beforeInit():void {
			
		}
		
		public function Window(title:String=null, owner:Window=null)
		{
			super();
			
			beforeInit();
			
			this.minWidth = 250;
			this.minHeight = 100;
			this.title = title;
			this.ownerWindow = owner;
			this.manager = this.manager || WindowManager.getInstance();
			this.manager.register(this);
			init();
		}
		
		private var _ownerWindow:Window;
		
		/**
		 * 拥有此窗口的所有者窗口。
		 */
		public function get ownerWindow():Window
		{
			return _ownerWindow;
		}
		public function set ownerWindow(value:Window):void
		{
			_ownerWindow = value;
			if (ownerWindow)
			{
				ownerWindow.addOwnedWindow(this);
			}
		}

		/**
		 * 初始化窗口，分发windowCreateEvent、taskbarButtonCreateEvent。
		 * 
		 */
		private function init():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, window_mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, window_mouseMoveHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, window_mouseOutHandler);
			FlexGlobals.topLevelApplication.parent.addEventListener(MouseEvent.MOUSE_UP, parent_mouseUpHandler);
			FlexGlobals.topLevelApplication.parent.addEventListener(MouseEvent.MOUSE_MOVE, parent_mouseMoveHandler);
			//this.visible = false;
			//this.includeInLayout = false;
		}
		
		private var originalSize:Dimension;
		private var originalPos:Point;
		private var originalMousePos:Point;
		/**
		 * 处理窗口鼠标按下事件，置前该窗口。 
		 * @param event
		 * 
		 */
		protected function window_mouseDownHandler(event:MouseEvent):void
		{
			if(disabled)
			{
				SystemSound.DING.play();
			}
			show();
			if (this.cursorState != CursorMgr.SIDE_OTHER)
			{
				resizer = this;
				resizer.originalSize = this.getSize();
				resizer.originalPos = this.getPosition();
				resizer.originalMousePos = this.localToGlobal(new Point(resizer.mouseX, resizer.mouseY));
			}
			//停止事件传播 
			event.stopPropagation();
		}
		protected function window_mouseMoveHandler(event:MouseEvent):void
		{
			if (resizer == null && !disabled && resizable)
			{
				var px:Number = FlexGlobals.topLevelApplication.parent.mouseX; 
				var py:Number = FlexGlobals.topLevelApplication.parent.mouseY;
				//右下
				if(px >= (this.x + this.width - Window.MOUSE_INDUCTION_MARGIN) && py >= (this.y + this.height - Window.MOUSE_INDUCTION_MARGIN))
				{
					CursorMgr.setCursor(CursorMgr.NWSE, -6, -6);
					this.cursorState = CursorMgr.SIDE_RIGHT | CursorMgr.SIDE_BOTTOM;
				}
					//左上
				else if(px <= (this.x + Window.MOUSE_INDUCTION_MARGIN) && py <= (this.y + Window.MOUSE_INDUCTION_MARGIN))
				{
					CursorMgr.setCursor(CursorMgr.NWSE, -10, -10);
					this.cursorState = CursorMgr.SIDE_LEFT | CursorMgr.SIDE_TOP;
				}
					//左下
				else if(px <= (this.x + Window.MOUSE_INDUCTION_MARGIN) && py >= (this.y + this.height - Window.MOUSE_INDUCTION_MARGIN))
				{
					CursorMgr.setCursor(CursorMgr.NESW, -10, -6);
					this.cursorState = CursorMgr.SIDE_LEFT | CursorMgr.SIDE_BOTTOM;
				}
					//右上
				else if(px >= (this.x + this.width - Window.MOUSE_INDUCTION_MARGIN) && py <= (this.y + Window.MOUSE_INDUCTION_MARGIN))
				{
					CursorMgr.setCursor(CursorMgr.NESW, -6, -10);
					this.cursorState = CursorMgr.SIDE_RIGHT | CursorMgr.SIDE_TOP;
				}
					//右
				else if(px >= (this.x + this.width - Window.MOUSE_INDUCTION_MARGIN))
				{
					CursorMgr.setCursor(CursorMgr.EW, -8, 0);
					this.cursorState = CursorMgr.SIDE_RIGHT;
				}
					//左
				else if(px <= (this.x + Window.MOUSE_INDUCTION_MARGIN))
				{
					CursorMgr.setCursor(CursorMgr.EW, -14, 0);
					this.cursorState = CursorMgr.SIDE_LEFT;
				}
					//下
				else if(py >= (this.y + this.height - Window.MOUSE_INDUCTION_MARGIN))
				{
					CursorMgr.setCursor(CursorMgr.NS, 0, -10);
					this.cursorState = CursorMgr.SIDE_BOTTOM;
				}
					//上
				else if(py <= (this.y + Window.MOUSE_INDUCTION_MARGIN))
				{
					CursorMgr.setCursor(CursorMgr.NS, 0, -14);
					this.cursorState = CursorMgr.SIDE_TOP;
				}
				else
				{
					CursorMgr.setCursor(null, 0, 0);
					this.cursorState = CursorMgr.SIDE_OTHER;
				}
			}
		}
		protected function window_mouseOutHandler(event:MouseEvent):void
		{
			if (resizer == null)
			{
				CursorMgr.setCursor(null, 0, 0);
				this.cursorState = CursorMgr.SIDE_OTHER;
			}
		}
		protected function parent_mouseUpHandler(event:MouseEvent):void
		{
			resizer = null;
		}
		protected function parent_mouseMoveHandler(event:MouseEvent):void
		{
			if (resizer != null && resizable)
			{
				var px:Number = FlexGlobals.topLevelApplication.parent.mouseX - resizer.originalMousePos.x;
				var py:Number = FlexGlobals.topLevelApplication.parent.mouseY - resizer.originalMousePos.y;
				
				switch(this.cursorState)
				{
					case CursorMgr.SIDE_RIGHT | CursorMgr.SIDE_BOTTOM :
						resizer.setSize(
							new Dimension(resizer.originalSize.width + px > this.minWidth ? resizer.originalSize.width + px : this.minWidth,
								resizer.originalSize.height + py > this.minHeight ? resizer.originalSize.height + py : this.minHeight)
						);
						break;
					case CursorMgr.SIDE_LEFT | CursorMgr.SIDE_TOP:
						resizer.setPosition(
							new Point(px < resizer.originalSize.width - this.minWidth ? resizer.originalPos.x + px : resizer.x,
								py < resizer.originalSize.height - this.minHeight ? resizer.originalPos.y + py : resizer.y)
						);
						resizer.setSize(
							new Dimension(resizer.originalSize.width - px > this.minWidth ? resizer.originalSize.width - px : this.minWidth,
								resizer.originalSize.height - py > this.minHeight ? resizer.originalSize.height - py : this.minHeight)
						);
						break;
					case CursorMgr.SIDE_LEFT | CursorMgr.SIDE_BOTTOM:
						resizer.x = px < resizer.originalSize.width - this.minWidth ? resizer.originalPos.x + px: resizer.x;
						resizer.setSize(
							new Dimension(resizer.originalSize.width - px > this.minWidth ? resizer.originalSize.width - px : this.minWidth,
								resizer.originalSize.height + py > this.minHeight ? resizer.originalSize.height + py : this.minHeight)
						);
						break;
					case CursorMgr.SIDE_RIGHT | CursorMgr.SIDE_TOP:
						resizer.y = py < resizer.originalSize.height - this.minHeight ? resizer.originalPos.y + py : resizer.y;
						resizer.setSize(
							new Dimension(resizer.originalSize.width + px > this.minWidth ? resizer.originalSize.width + px : this.minWidth,
								resizer.originalSize.height - py > this.minHeight ? resizer.originalSize.height - py : this.minHeight)
						);
						break;
					case CursorMgr.SIDE_RIGHT:
						resizer.width = resizer.originalSize.width + px > this.minWidth ? resizer.originalSize.width + px : this.minWidth;
						break;
					case CursorMgr.SIDE_LEFT:
						resizer.x = px < resizer.originalSize.width - this.minWidth ? resizer.originalPos.x + px : resizer.x;
						resizer.width = resizer.originalSize.width - px > this.minWidth ? resizer.originalSize.width - px : this.minWidth;
						break;
					case CursorMgr.SIDE_BOTTOM:
						resizer.height = resizer.originalSize.height + py > this.minHeight ? resizer.originalSize.height + py : this.minHeight;
						break;
					case CursorMgr.SIDE_TOP:
						resizer.y = py < resizer.originalSize.height - this.minHeight ? resizer.originalPos.y + py : resizer.y;
						resizer.height = resizer.originalSize.height - py > this.minHeight ? resizer.originalSize.height - py : this.minHeight;
						break;
				}
			}
		}
		
		/**
		 * 添加该窗口拥有的子窗口。
		 * @param window
		 * 
		 */
		private function addOwnedWindow(window:Window):void
		{
			if (ownedWindows.getItemIndex(window)<0)
			{
				ownedWindows.addItem(window);
			}
		}
		
		/**
		 * 删除该窗口拥有的子窗口。
		 * @param window
		 * 
		 */
		private function removeOwnedWindow(window:Window):void
		{
			if (ownedWindows.getItemIndex(window)!=-1)
			{
				ownedWindows.removeItemAt(ownedWindows.getItemIndex(window));
			}
		}
		
		private var _disabled:Boolean = false;

		/**
		 * 是否禁用此窗口，不响应任何鼠标键盘事件
		 * @return 
		 * 
		 */
		public function get disabled():Boolean
		{
			return _disabled;
		}
		public function set disabled(value:Boolean):void
		{
			_disabled = value;
			maskLayer.visible = value;
			maskLayer.includeInLayout = value;
		}

		
		protected var created:Boolean = false;
		
		protected function beforeCreate():void {
			WindowEventDispatcher.getInstance().dispatchEvent(
				new WindowEvent(WindowEvent.WINDOW_CREATE, this)
			);
		}
		
		/**
		 * 使窗口可见，并将窗口带到最前面。 
		 * 
		 */
		public function show():void
		{
			if (!created)
			{
				beforeCreate();
				created = true;
				dispatchEvent(new WindowEvent(WindowEvent.WINDOW_OPENED, this));
			}
			if (modal && ownerWindow)
			{
				ownerWindow.disabled = true;
			}
			toFront();
		}
		
		/**
		 * 将此窗口置于前端，并可以将其设为焦点 Window，如果该窗口为模式窗口则调用其所有者窗口的show方法，如果该窗口拥有模式子窗口，则将其所有模式子窗口置于前端 
		 * 
		 */
		public function toFront():void
		{
			if (modal && ownerWindow) { //如果该窗口为模式窗口，则将其所有者窗口显示。
				ownerWindow.show();
			}else{
				bringToFront();
				//循环该窗口拥有的子窗口，如果子窗口为模式窗口则将子窗口置前。
				for (var i:Number=0; i<ownedWindows.length; i++)
				{
					if (ownedWindows[i].modal)
						ownedWindows[i].bringToFront();
				}
			}
		}
		
		/**
		 * 内部调用，将此窗口置于前端，并可以将其设为焦点 Window
		 * 
		 */
		protected function bringToFront():void
		{
			if (this.manager.bringToFront(this))
			{
				this.visible = true;
				this.includeInLayout = true;
				this.focusEnabled = true;
				this.setFocus();
				dispatchEvent(new WindowEvent(WindowEvent.WINDOW_FOCUS_IN, this));
			}
		}
		
		/**
		 * 以 Dimension 对象的形式返回窗口的大小。Dimension 对象的 height 字段包含此窗口的高度，而 Dimension 对象的 width 字段则包含此窗口的宽度。
		 * @return 
		 * 
		 */
		public function getSize():Dimension
		{
			return new Dimension(this.width, this.height);
		}
		
		/**
		 * 调整窗口的大小，使其宽度为 d.width，高度为 d.height。 
		 * @param d
		 * 
		 */
		public function setSize(d:Dimension):void
		{
			this.width = d.width;
			this.height = d.height;
		}
		
		/**
		 * 以 Point 对象的形式返回窗口原点的坐标。Point 对象的 x 字段包含此窗口原点的 x 坐标，而 Point 对象的 y 字段则包含此窗口原点的 y 坐标。
		 * @return 
		 * 
		 */
		public function getPosition():Point
		{
			return new Point(this.x, this.y);
		}
		
		/**
		 * 调整窗口原点的坐标，使其当前x坐标为 p.x，当前y坐标为 p.y。 
		 * @param p
		 * 
		 */
		public function setPosition(p:Point):void
		{
			this.x = p.x;
			this.y = p.y;
		}
		
		private var _title:String = "";
		
		[Bindable]
		/**
		 * 标题栏中显示的标题。 
		 * @return 
		 * 
		 */
		public function get title():String 
		{
			return _title;
		}
		
		public function set title(value:String):void 
		{
			_title = value;
			if (titleDisplay)
				titleDisplay.text = title;
		}
		
		private var _icon:Object;

		[Bindable]
		/**
		 * 窗口图标 
		 * @return 
		 * 
		 */
		public function get icon():Object
		{
			return _icon;
		}
		
		public function set icon(value:Object):void
		{
			_icon = value;
			if (iconDisplay)
			{
				if (icon!=null)
				{
					iconDisplay.source = icon;
					iconDisplay.visible = true;
					iconDisplay.includeInLayout = true;
					iconDisplay.smooth = true;
				}
				else
				{
					iconDisplay.visible = false;
					iconDisplay.includeInLayout = false;
				}
			}
		}
		
		
		/**
		 * 标题栏菜单 
		 */
		private var titleBarMenu:Menu;
		
		protected function titleBarMenuTrigger_clickHandler(event:MouseEvent):void
		{
			var mdp:Array = [
				{label:"还原", functionName:"restore", enabled:(!visible || maximized) ? true : false},
				{label:"最小化", functionName:"minimize", enabled:(visible) ? true : false},
				{label:"最大化", functionName:"maximize", enabled:(maximized||!maximizable) ? false : true},
				{label:"关闭", functionName:"close"}
			]
			
			titleBarMenu = Menu.createMenu(this, mdp, false);
			titleBarMenu.width = 100;
			
			titleBarMenu.addEventListener(MenuEvent.ITEM_CLICK, titleBarMenu_itemClickHandler);
			
			var p:Point = new Point();
			p.x = titleBarMenuTrigger.x;
			p.y = titleBarMenuTrigger.y;
			p = titleBarMenuTrigger.localToGlobal(p);
			titleBarMenu.show(p.x-5, p.y + titleBarMenuTrigger.height - 5);
			
		}
		
		protected function titleBarMenu_itemClickHandler(event:MenuEvent):void
		{
			this[event.item.functionName]();
		}
		
		/**
		 * 当用户在移动区域按下鼠标按钮，相对于该窗口原水平位置的水平位置。
		 */
		private var offsetX:Number;
		/**
		 * 当用户在移动区域按下鼠标按钮，相对于该窗口原垂直位置的垂直位置。
		 */
		private var offsetY:Number;
		
		/**
		 * 处理移动区域鼠标按下事件，当用户开始拖动窗口时调用。
		 * @param event
		 * 
		 */
		protected function moveArea_mouseDownHandler(event:MouseEvent):void
		{
			if (!draggable)
				return;
			
			offsetX = event.stageX - x;
			offsetY = event.stageY - y;
			
			var sbRoot:DisplayObject = systemManager.getSandboxRoot();
			sbRoot.addEventListener(MouseEvent.MOUSE_MOVE, moveArea_mouseMoveHandler, true);
			sbRoot.addEventListener(MouseEvent.MOUSE_UP, moveArea_mouseUpHandler, true);
			sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, moveArea_mouseUpHandler)
			systemManager.deployMouseShields(true); 
		}
		
		/**
		 * 处理移动区域鼠标移动事件，如果没有正在改变大小的窗口则可以移动窗口。
		 * @param event
		 * 
		 */
		protected function moveArea_mouseMoveHandler(event:MouseEvent):void
		{
			if (resizer == null)
			{
				var afterBounds:Rectangle = new Rectangle(Math.round(event.stageX - this.offsetX),Math.round(event.stageY - this.offsetY),width,height);
				var point:Point = new Point();
				point.x = afterBounds.x;
				point.y = (afterBounds.y<0)?0:(afterBounds.y>parent.height-60)?parent.height-60:afterBounds.y;
				setPosition(point);
			}
		}
		
		/**
		 * 处理移动区域鼠标松开事件，删除移动区域的事件侦听。
		 * @param event
		 * 
		 */
		protected function moveArea_mouseUpHandler(event:Event):void
		{
			var sbRoot:DisplayObject = systemManager.getSandboxRoot();
			sbRoot.removeEventListener(MouseEvent.MOUSE_MOVE, moveArea_mouseMoveHandler, true);
			sbRoot.removeEventListener(MouseEvent.MOUSE_UP, moveArea_mouseUpHandler, true);
			sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, moveArea_mouseUpHandler);
			offsetX = NaN;
			offsetY = NaN;
		}
		
		/**
		 * 处理移动区域双击事件，在最大化和还原之间切换。
		 * @param event
		 * 
		 */
		protected function moveArea_doubleClickHandler(event:MouseEvent):void
		{
			toggleMaximize();
		}
		
		
		private var _minimizable:Boolean = true;

		/**
		 * 是否显示最小化按钮 
		 * @return 
		 * 
		 */
		public function get minimizable():Boolean
		{
			return _minimizable;
		}

		public function set minimizable(value:Boolean):void
		{
			_minimizable = value;
			if (minimizeButton)
			{
				minimizeButton.visible = value;
				minimizeButton.includeInLayout = value;
			}
		}

		/**
		 * 处理最小化按钮单击事件，最小化该窗口。 
		 * @param event
		 * 
		 */
		protected function minimizeButton_clickHandler(event:MouseEvent):void
		{
			if (minimizable)
				minimize();
		}
		
		/**
		 * 最小化窗口，调用hide()隐藏窗口。
		 * 
		 */
		public function minimize():void
		{
			hide();
		}
		
		/**
		 * 隐藏此窗口、此窗口的子组件，以及它拥有的所有模式子窗口。调用 show() 可以重新使窗口及其子组件可见。
		 * 
		 */
		public function hide():void
		{
			if(visible)
			{
				visible = false;
				includeInLayout = false;
			}
			for (var i:Number=0; i<ownedWindows.length; i++)
			{
				if (ownedWindows[i].modal)
					ownedWindows[i].hide();
			}
			WindowManager.changeFront();
		}
		
		private var _maximizable:Boolean = true;

		/**
		 * 是否显示最大化按钮。
		 * @return 
		 * 
		 */
		public function get maximizable():Boolean
		{
			return _maximizable;
		}

		public function set maximizable(value:Boolean):void
		{
			_maximizable = value;
			if (maximizeButton)
			{
				maximizeButton.visible = value;
				maximizeButton.includeInLayout = value;
			}
		}
		
		/**
		 * 处理最大化按钮单击事件， 最大化该窗口。
		 * @param event
		 * 
		 */
		protected function maximizeButton_clickHandler(event:MouseEvent):void
		{
			if (maximizable)
				maximize();
		}
		
		/**
		 * 标志该窗口是否为最大化状态。
		 */
		private var maximized:Boolean = false;
		/**
		 * 窗口还原的大小。
		 */
		private var restoreSize:Dimension;
		/**
		 * 窗口还原的位置。 
		 */
		private var restorePos:Point;
		
		/**
		 * 最大化窗口。
		 * @return 
		 * 
		 */
		public function maximize():void
		{
			if (!maximized)
			{
				if (maximizable)
				{
					restoreSize = getSize();
					restorePos = getPosition();
					
					if (maximizeButton)
					{
						maximizeButton.visible = false;
						maximizeButton.includeInLayout = false;
					}
					if (restoreButton)
					{
						restoreButton.visible = true;
						restoreButton.includeInLayout = true;
					}
					this.left = 0;
					this.right = 0;
					this.top = 0;
					this.bottom = 0;
					maximized = true;
				}
			}
		}
		
		/**
		 * 处理还原按钮单击事件，还原该窗口。 
		 * @param event
		 * 
		 */
		protected function restoreButton_clickHandler(event:MouseEvent):void
		{
			restore();
		}
		
		/**
		 * 还原窗口。 
		 * 
		 */
		public function restore():void
		{
			if (maximized)
			{
				if (maximizable)
				{
					if (maximizeButton)
					{
						maximizeButton.visible = true;
						maximizeButton.includeInLayout = true;
					}
					if (restoreButton)
					{
						restoreButton.visible = false;
						restoreButton.includeInLayout = false;
					}
					this.left = null;
					this.right = null;
					this.top = null;
					this.bottom = null;
					setSize(restoreSize);
					setPosition(restorePos);
					restoreSize = null;
					restorePos = null;
					maximized = false;
				}
			}
		}
		
		/**
		 * 在最大化和还原之间切换。
		 * @return 
		 * 
		 */
		public function toggleMaximize():void
		{
			this[maximized ? 'restore' : 'maximize']();
		}
		
		/**
		 * 在显示和隐藏之间切换。 
		 * 
		 */
		public function toggle():void
		{
			this[visible ? 'hide' : 'show']();
		}
		
		/**
		 * 处理关闭按钮单击事件，关闭窗口。 
		 * @param event
		 * 
		 */
		protected function closeButton_clickHandler(event:MouseEvent):void
		{
			close();
		}
		
		/**
		 *  关闭此窗口。
		 * 
		 */
		public function close():void
		{
			if (ownerWindow)
			{
				//当窗口关闭时，所有者窗口要移除此窗口并判断是否还有模式子窗口，如果没有则启用所有者窗口。
				ownerWindow.removeOwnedWindow(this);
				var flag:Boolean = false;
				for (var i:Number=0; i<ownerWindow.ownedWindows.length; i++)
				{
					if (ownerWindow.ownedWindows[i].modal)
						flag = true;
				}
				ownerWindow.disabled = flag;
			}
			//如果拥有子窗口则将子窗口全部关闭。
			var l:ArrayCollection = new ArrayCollection(ownedWindows.toArray());
			for (var j:Number=0; j<l.length; j++)
			{
				l[j].close();
			}
			dispatchEvent(new WindowEvent(WindowEvent.WINDOW_CLOSED, this));
			destroy();
		}
		
		/**
		 * 窗体销毁前的一些处理
		 */
		protected function beforeDestroy():void {
			WindowEventDispatcher.getInstance().dispatchEvent(
				new WindowEvent(WindowEvent.WINDOW_DESTROY, this)
			);
		}
		
		/**
		 *  销毁此窗口。
		 * 
		 */
		private function destroy():void
		{
			if (this.manager)
			{
				beforeDestroy();
				this.manager.unregister(this);
				created = false;
				WindowManager.changeFront();
			}
		}
		
		
		/**
		 * 添加外观部件。
		 * @param partName 部件名称
		 * @param instance 部件实例
		 * 
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			
			super.partAdded(partName, instance);
			
			if (instance == titleDisplay)
			{
				titleDisplay.text = title;
			}
			else if (instance == iconDisplay)
			{
				if (icon!=null)
				{
					iconDisplay.source = icon;
					iconDisplay.visible = true;
					iconDisplay.includeInLayout = true;
					iconDisplay.smooth = true;
				}
				else
				{
					iconDisplay.visible = false;
					iconDisplay.includeInLayout = false;
				}
			}
			else if (instance == maskLayer)
			{
				maskLayer.visible = false;
				maskLayer.includeInLayout = false;
			}
			else if (instance == titleBarMenuTrigger)
			{
				titleBarMenuTrigger.addEventListener(MouseEvent.CLICK, titleBarMenuTrigger_clickHandler);
			}
			else if (instance == moveArea)
			{
				moveArea.addEventListener(MouseEvent.MOUSE_DOWN, moveArea_mouseDownHandler);
				moveArea.doubleClickEnabled = true;
				moveArea.addEventListener(MouseEvent.DOUBLE_CLICK, moveArea_doubleClickHandler);
			}
			else if (instance == minimizeButton)
			{
				minimizeButton.focusEnabled = false;
				minimizeButton.addEventListener(MouseEvent.CLICK, minimizeButton_clickHandler);
				minimizeButton.visible = minimizeButton.includeInLayout = minimizable;
			}
			else if (instance == maximizeButton)
			{
				maximizeButton.focusEnabled = false;
				maximizeButton.addEventListener(MouseEvent.CLICK, maximizeButton_clickHandler);
				maximizeButton.visible = maximizeButton.includeInLayout = maximizable;
			}
			else if (instance == restoreButton)
			{
				restoreButton.visible = false;
				restoreButton.includeInLayout = false;
				restoreButton.focusEnabled = false;
				restoreButton.addEventListener(MouseEvent.CLICK, restoreButton_clickHandler);
			}
			else if (instance == closeButton)
			{
				closeButton.focusEnabled = false;
				closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler);
			}
		}
	}
}