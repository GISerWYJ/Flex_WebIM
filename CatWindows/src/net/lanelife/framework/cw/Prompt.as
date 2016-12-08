package net.lanelife.framework.cw
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.core.mx_internal;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	
	import spark.components.Application;
	import spark.components.Button;
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.Label;
	
	
	/**
	 * @author Darkness
	 * @version 1.1 修正show(parent:Window)方法中parent不能为null的问题，如果设置成null，则全屏居中显示
	 */
	public class Prompt extends Window
	{
		public static const YES:uint = 0x0001;
		public static const NO:uint = 0x0002;
		public static const OK:uint = 0x0004;
		public static const CANCEL:uint= 0x0008;
		
		public static var yesLabel:String = "是";
		public static var noLabel:String = "否";
		public static var okLabel:String = "确定";
		public static var cancelLabel:String = "取消";
		
		public static var buttonHeight:Number = 22;
		public static var buttonWidth:Number = 65;
		public static var buttonAlign:String = "right";
		
		public var buttonFlags:uint = OK;
		public var defaultButtonFlag:uint = OK;
		[Bindable]
		public var iconObject:Object;
		public var text:String = "";
		
		public var defaultSelectedButton:Button;
		
		private var buttons:Array = [];
		private var defaultButtonChanged:Boolean = false;
		
		[SkinPart(required="false")]
		/**
		 * 位于  Prompt 控件中文本左侧的图标的外观组件。
		 */
		public var promptIconDisplay:Image;
		
		[SkinPart(required="false")]
		/**
		 * 在  Prompt 控件中显示的文本字符串的外观组件。
		 */
		public var textDisplay:Label;
		
		[SkinPart(required="false")]
		/**
		 * Prompt 控件中显示按钮的外观组件。
		 */
		public var buttonsGroup:HGroup;
		
		public static function show(parent:Window, 
									text:String = "", 
									title:String = "",
									flags:uint = 0x4 /* Prompt.OK */, 
									closeHandler:Function = null, 
									iconObject:Object = null, 
									defaultButtonFlag:uint = 0x4 /* Prompt.OK */):Prompt
		{
			var prompt:Prompt = new Prompt();
			if (flags & Prompt.OK||
				flags & Prompt.CANCEL ||
				flags & Prompt.YES ||
				flags & Prompt.NO)
			{
				prompt.buttonFlags = flags;
			}
			
			if (defaultButtonFlag == Prompt.OK ||
				defaultButtonFlag == Prompt.CANCEL ||
				defaultButtonFlag == Prompt.YES ||
				defaultButtonFlag == Prompt.NO)
			{
				prompt.defaultButtonFlag = defaultButtonFlag;
			}
			
			prompt.createButtons();
			
			prompt.text = text;
			prompt.title = title;
			prompt.iconObject = iconObject;
			
			prompt.modal = true;
			prompt.ownerWindow = parent;
			
			if(parent != null) {
				prompt.icon = prompt.ownerWindow.icon;
			}
			
			prompt.minimizable = false;
			prompt.maximizable = false;
			prompt.resizable = false;
			
			if (closeHandler != null)
				prompt.addEventListener(CloseEvent.CLOSE, closeHandler);
			
			prompt.addEventListener(FlexEvent.CREATION_COMPLETE,static_creationCompleteHandler);
			
			prompt.show();
			
			return prompt;
		}
		
		private static function static_creationCompleteHandler(event:FlexEvent):void
		{
			var prompt:Prompt = Prompt(event.target);
			prompt.removeEventListener(FlexEvent.CREATION_COMPLETE, static_creationCompleteHandler);
			prompt.setActualSize(prompt.getExplicitOrMeasuredWidth(),prompt.getExplicitOrMeasuredHeight());
			var p:Point = new Point();
			
			if(prompt.ownerWindow != null) {
				p.x = (prompt.ownerWindow.width - prompt.getExplicitOrMeasuredWidth())/2 + prompt.ownerWindow.x;
				p.y = (prompt.ownerWindow.height - prompt.getExplicitOrMeasuredHeight())/2 + prompt.ownerWindow.y;
			} else {
				p.x = (FlexGlobals.topLevelApplication.width - prompt.getExplicitOrMeasuredWidth())/2;
				p.y = (FlexGlobals.topLevelApplication.height - prompt.getExplicitOrMeasuredHeight())/2
			}
			
			prompt.setPosition(p);
		}
		
		public function createButtons():void
		{
			var label:String;
			var button:Button;
			
			if (buttonFlags & Prompt.OK)
			{
				label = String(Prompt.okLabel);
				button = createButton(label, "OK");
				if (defaultButtonFlag == Prompt.OK)
					defaultSelectedButton = button;
			}
			
			if (buttonFlags & Prompt.YES)
			{
				label = String(Prompt.yesLabel);
				button = createButton(label, "YES");
				if (defaultButtonFlag == Prompt.YES)
					defaultSelectedButton = button;
			}
			
			if (buttonFlags & Prompt.NO)
			{
				label = String(Prompt.noLabel);
				button = createButton(label, "NO");
				if (defaultButtonFlag == Prompt.NO)
					defaultSelectedButton = button;
			}
			
			if (buttonFlags & Prompt.CANCEL)
			{
				label = String(Prompt.cancelLabel);
				button = createButton(label, "CANCEL");
				if (defaultButtonFlag == Prompt.CANCEL)
					defaultSelectedButton = button;
			}
			
			if (!defaultSelectedButton && buttons.length)
				defaultSelectedButton = buttons[0];
			
			if (defaultSelectedButton)
			{
				defaultButtonChanged = true;
				invalidateProperties();
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (defaultButtonChanged && defaultSelectedButton)
			{
				defaultButtonChanged = false;
				defaultSelectedButton.setFocus();
			}
		}
		
		private function createButton(label:String, name:String):Button
		{
			var button:Button = new Button();
			button.label = label;
			button.name = name;
			button.addEventListener(MouseEvent.CLICK, clickHandler);
			button.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			button.setActualSize(Prompt.buttonWidth, Prompt.buttonHeight);
			buttons.push(button);
			return button;
		}
		
		override protected function bringToFront():void
		{
			super.bringToFront();
			if (defaultSelectedButton)
			{
				defaultSelectedButton.setFocus();
			}
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			var name:String = Button(event.currentTarget).name;
			removePrompt(name);
		}
		
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ESCAPE)
			{
				if ((buttonFlags & Prompt.CANCEL) || !(buttonFlags & Prompt.NO))
					removePrompt("CANCEL");
				else if (buttonFlags & Prompt.NO)
					removePrompt("NO");
			}
		}
		
		private function removePrompt(buttonPressed:String):void
		{
			var closeEvent:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
			if (buttonPressed == "YES")
				closeEvent.detail = Prompt.YES;
			else if (buttonPressed == "NO")
				closeEvent.detail = Prompt.NO;
			else if (buttonPressed == "OK")
				closeEvent.detail = Prompt.OK;
			else if (buttonPressed == "CANCEL")
				closeEvent.detail = Prompt.CANCEL;
			dispatchEvent(closeEvent);
			close();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if (instance == promptIconDisplay)
			{
				promptIconDisplay.source = iconObject;
			}
			else if(instance == textDisplay)
			{
				textDisplay.text = text;
			}
			else if(instance == buttonsGroup)
			{
				buttonsGroup.horizontalAlign = Prompt.buttonAlign;
				for (var i:Number=0; i<buttons.length; i++)
				{
					buttonsGroup.addElement(buttons[i]);
				}
			}
		}
		
		
		public function Prompt()
		{
			super();
		}
	}
}