package net.lanelife.cat77.service
{
	
	import mx.collections.ArrayCollection;
	
	import net.lanelife.cat77.WebIMAppContext;
	import net.lanelife.cat77.vo.TeamMessage;
	import net.lanelife.framework.remoting.api.IInvokeResponder;

	public class TeamMessageService extends BaseService
	{
		private static var model:WebIMAppContext = WebIMAppContext.getInstance();
		
		public function TeamMessageService()
		{
			super("teamMessageService");
		}
		
		private static var _instance:TeamMessageService;
		
		public static function getInstance():TeamMessageService {
			if(_instance == null) {
				_instance = new TeamMessageService;
			}
			return _instance;
		}
		
		public static function send(message:TeamMessage, teamEmployees:ArrayCollection):IInvokeResponder
		{
			return getInstance().invoke("send", message, teamEmployees);
		}
		
		public static function getOfflineTeamMessage():IInvokeResponder
		{
			return getInstance().invoke("getOfflineTeamMessage", model.employee);
		}
	}
}