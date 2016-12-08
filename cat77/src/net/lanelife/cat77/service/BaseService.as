package net.lanelife.cat77.service
{
	import net.lanelife.framework.remoting.DataService;
	import net.lanelife.framework.remoting.DataType;
	import net.lanelife.framework.remoting.api.IInvokeResponder;

	public class BaseService
	{
		protected var instance:DataService;
		
		public function BaseService(dest:String)
		{
			instance = DataService.getInstance(dest, DataType.AMF)
		}
		
		public function set FaultMessage(value:String):void {
			instance.FaultMessage = value;
		}
		
		protected function invoke(url:String, ...arg):IInvokeResponder {
			return instance.send(url, arg);
		}
	}
}