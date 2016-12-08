package net.lanelife.cat77.service
{
	
	import mx.collections.ArrayCollection;
	
	import net.lanelife.cat77.WebIMAppContext;
	import net.lanelife.cat77.vo.Employee;
	import net.lanelife.cat77.vo.Team;
	import net.lanelife.framework.remoting.api.IInvokeResponder;

	public class TeamService extends BaseService
	{
		private static var model:WebIMAppContext = WebIMAppContext.getInstance();
		
		public function TeamService()
		{
			super("teamService");
		}
		
		private static var _instance:TeamService;
		
		public static function getInstance():TeamService {
			if(_instance == null) {
				_instance = new TeamService;
			}
			return _instance;
		}
		
		public static function save(team:Team, selectedTeamEmployees:ArrayCollection, deletedTeamEmployees:ArrayCollection):IInvokeResponder
		{
			return getInstance().invoke("save", team, selectedTeamEmployees, deletedTeamEmployees);
		}
		
		public static function quit(team:Team, manager:Employee):IInvokeResponder
		{
			return getInstance().invoke("quit", team, model.employee, manager);
		}
		
		public static function dissolve(team:Team, manager:Employee):IInvokeResponder
		{
			return getInstance().invoke("dissolve", team, manager);
		}
	}
}