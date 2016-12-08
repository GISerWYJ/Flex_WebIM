package net.lanelife.framework.cw
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.graphics.BitmapFill;
	
	import spark.components.Button;
	import spark.components.Image;
	import spark.components.PopUpAnchor;
	
	public class TaskbarButton extends Button
	{
		
		[SkinState("active")]
		[SkinState("flashes")]
		
		[SkinPart(required="false")]
		/**
		 * 定义任务栏图标外观的外观部件。 
		 */
		public var iconImage:Image;
		
		[SkinPart(required="false")]
		public var previewImage:BitmapFill;
		
		[SkinPart(required="false")]
		public var popupAnchor:PopUpAnchor;
		
		[Bindable]
		public var window:Window;
		
		public function TaskbarButton(window:Window)
		{
			super();
			this.window = window;
			this.addEventListener(MouseEvent.CLICK, taskbarButton_clickHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, taskbarButton_mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, taskbarButton_mouseOutHandler);
		}
		
		public function show():void{
			this.visible = true;
			this.includeInLayout = true;
		}
		
		public function hide():void{
			this.visible = false;
			this.includeInLayout = false;
		}
		
		protected function taskbarButton_mouseOverHandler(event:MouseEvent):void
		{
			if (popupAnchor)
				popupAnchor.displayPopUp = true;
			
			if (previewImage)
			{
				var bitmapData:BitmapData = new BitmapData(this.window.contentGroup.width, this.window.contentGroup.height);
				bitmapData.draw(this.window.contentGroup);
				if (bitmapData)
					previewImage.source = new Bitmap(bitmapData);
			}
		}
		protected function taskbarButton_mouseOutHandler(event:MouseEvent):void
		{
			if (popupAnchor)
				popupAnchor.displayPopUp = false;
		}
		
		protected function taskbarButton_clickHandler(event:MouseEvent):void
		{
			if (window==WindowManager.front || window.disabled)
			{
				//循环判断该窗口的子窗口是否为焦点窗口，是则隐藏该窗口，否则显示该窗口
				if (window.disabled)
				{
					var flag:Boolean = false;
					for (var i:Number=0; i<window.ownedWindows.length; i++)
					{
						if (window.ownedWindows[i]==WindowManager.front)
						{
							flag = true;
						}
					}
					if (flag)
						window.hide();
					else
						window.show();
				}
				else
				{
					window.hide(); //如果该窗口是焦点窗口则隐藏
				}
			}
			else
			{
				window.show(); //如果该窗口非焦点窗口则显示
			}
		}
		
		private var _active:Boolean;

		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			_active = value;
			invalidateSkinState();
		}
		
		private var _flashes:Boolean;

		public function get flashes():Boolean
		{
			return _flashes;
		}

		public function set flashes(value:Boolean):void
		{
			_flashes = value;
			invalidateSkinState();
		}
		
		private var _icon:Object;
		
		/**
		 * 任务栏图标。  
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
			if (iconImage)
			{
				if (icon!=null)
				{
					iconImage.source = icon;
					iconImage.visible = true;
					iconImage.includeInLayout = true;
					iconImage.smooth = true;
				}
				else
				{
					iconImage.visible = false;
					iconImage.includeInLayout = false;
				}
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if (instance == iconImage)
			{
				if (icon!=null)
				{
					iconImage.source = icon;
					iconImage.visible = true;
					iconImage.includeInLayout = true;
					iconImage.smooth = true;
				}
				else
				{
					iconImage.visible = false;
					iconImage.includeInLayout = false;
				}
			}
		}
		
		
		override protected function getCurrentSkinState():String
		{
			if (active)
				return "active";
			if (flashes)
				return "flashes";
			return super.getCurrentSkinState();
		}

	}
}