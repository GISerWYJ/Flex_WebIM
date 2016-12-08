package net.lanelife.cat77.service
{
	
	import net.lanelife.cat77.vo.Manager;
	import net.lanelife.framework.remoting.api.IInvokeResponder;

	public class ManagerService extends BaseService
	{
		public function ManagerService()
		{
			super("managerService");
		}
		
		private static var _instance:ManagerService;
		
		public static function getInstance():ManagerService {
			if(_instance == null) {
				_instance = new ManagerService;
			}
			return _instance;
		}
		
		public static function login(manager:Manager):IInvokeResponder
		{
			return getInstance().invoke("login", manager);
		}
		
		public static function save(manager:Manager):IInvokeResponder
		{
			return getInstance().invoke("save", manager);
		}
	}
}