package net.lanelife.framework.util
{
	public class Map
	{
		private var _keys:Array;
		private var values:Array;
		
		public function set keys(value:Array):void {
			_keys = value;
		}
		
		public function get keys():Array {
			return _keys
		}
		
		public function clear():void{
			keys=new Array();
			values=new Array();
		}
		public function Map(){
			keys=new Array();
			values=new Array();
		}

		public function put(key:Object,value:Object):void{
			for (var i:Number=0;i<keys.length;i++){
				if (keys[i]==key){
					values[i]=value;
					return ;
				}
			}
			keys.push(key);
			values.push(value);
			return ;
		}
		
		public function get(key:Object):Object{
			for (var i:Number=0;i<keys.length;i++)
				if (keys[i]==key)
					return values[i];
				return null;
		}
		
		public function getItemAt(index:int):Object{
			return values[index];
		}
		
		public function del(key:Object):Object{
			var result:Object=null;
			for (var i:Number=0;i<length;i++){
				if (keys[i]==key){
					result=values[i];
					keys[i]=keys[length-1];
					values[i]=values[length-1];
					keys.pop();
					values.pop();
					break;
				}
			}
			return result;
		}
		
		public function get length():Number{
			return keys.length;
		}
		
		public function toString():String{
			var s:String="";
			for (var i:Number=0;i<length;i++)
				s=s+"\n"+keys[i]+"="+values[i];
			return s;
		}
	}
}