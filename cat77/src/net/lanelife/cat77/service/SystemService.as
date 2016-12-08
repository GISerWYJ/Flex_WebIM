package net.lanelife.cat77.service
{
	
	import net.lanelife.cat77.WebIMAppContext;
	import net.lanelife.framework.remoting.api.IInvokeResponder;

	public class SystemService extends BaseService
	{
		private static var model:WebIMAppContext = WebIMAppContext.getInstance();
		
		public function SystemService()
		{
			super("systemMessageService");
		}
		
		private static var _instance:SystemService;
		
		public static function getInstance():SystemService {
			if(_instance == null) {
				_instance = new SystemService;
			}
			return _instance;
		}
		
		public static function getOfflineSystemMessage():IInvokeResponder
		{
			return getInstance().invoke("getAndUpdateOfflineSystemMessage", model.employee);
		}
	}
}
