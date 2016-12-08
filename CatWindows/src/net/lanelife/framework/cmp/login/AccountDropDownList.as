package net.lanelife.framework.cmp.login
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.DropDownList;
	import spark.components.TextInput;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	import spark.utils.LabelUtil;
	
	[Event(name="accountChange", type="flash.events.Event")]
	
	public class AccountDropDownList extends DropDownList
	{
		[SkinPart(required="true")]
		public var textDisplay:TextInput;
		
		public var textField:String = "";
		
		private var _text:String = "";
		[Bindable]
		public function get text():String
		{
			return textDisplay.text;
		}

		public function set text(value:String):void
		{
			_text = value;
			textDisplay.text = value;
		}
		
		
		public function AccountDropDownList()
		{
			super();
			this.addEventListener(IndexChangeEvent.CHANGE, changeHandler);
			this.addEventListener(FocusEvent.FOCUS_IN, focusHandler);
		}
		
		private function focusHandler(event:FocusEvent):void
		{
			textDisplay.setFocus();
		}
		
		private function changeHandler(event:IndexChangeEvent):void
		{
			textDisplay.text = LabelUtil.itemToLabel(selectedItem, textField, labelFunction);
			textDisplay.selectAll();
			dispatchEvent(new Event("accountChange"));
		}
		
		
		private function textChangeHandler(event:TextOperationEvent):void
		{
			this.selectedIndex = -1;
			var txt:String = event.target.text;
			var len:Number = txt.length;
			if (dataProvider)
			{
				if (lastStartPosition<currStartPosition)
				{
					for(var i:Number=0; i<dataProvider.length; i++)
					{
						var userid:String = dataProvider.getItemAt(i).userid;
						if (userid.substring(0,len)==txt)
						{
							this.selectedIndex = i;
							textDisplay.text = userid;
							if(userid.length!=len)
								textDisplay.selectRange(len,userid.length);
							break;
						}
					}
				}
				else
				{
					for(var j:Number=0; j<dataProvider.length; j++)
					{
						if (dataProvider.getItemAt(j).userid==txt)
						{
							this.selectedIndex = j;
							break;
						}
					}
				}
			}
			dispatchEvent(new Event("accountChange"));
		}
		
		
		private var currStartPosition:Number = 0;
		private var lastStartPosition:Number = 0;
		
		private function textSelectionChangeHandler(event:FlexEvent):void
		{
			lastStartPosition = currStartPosition
			
			var start:Number = event.target.selectionAnchorPosition;
			start = (start<event.target.selectionActivePosition)?start:event.target.selectionActivePosition;
			
			currStartPosition = start;
			
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if (instance == textDisplay)
			{
				textDisplay.addEventListener(TextOperationEvent.CHANGE, textChangeHandler);
				textDisplay.addEventListener(FlexEvent.SELECTION_CHANGE, textSelectionChangeHandler);
			}
		}
	}
}