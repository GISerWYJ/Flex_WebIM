
package net.lanelife.cat77.service
{
	import net.lanelife.framework.remoting.api.IInvokeResponder;
	

	public class ServerSettingsService extends BaseService
	{
		public function ServerSettingsService()
		{
			super("serverSettingsService");
		}
		
//		private static var _instance:ServerSettingsService;
		
//		public static function getInstance():ServerSettingsService {
//			if(_instance == null) {
//				_instance = new ServerSettingsService;
//			}
//			return _instance;
//		}
		
		public function find():IInvokeResponder
		{
			return super.invoke("find");
		}
	}
}