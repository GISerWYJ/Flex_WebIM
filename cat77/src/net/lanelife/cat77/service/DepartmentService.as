package net.lanelife.cat77.service
{
	
	import net.lanelife.cat77.vo.Department;
	import net.lanelife.framework.remoting.api.IInvokeResponder;

	public class DepartmentService extends BaseService
	{
		public function DepartmentService()
		{
			super("departmentService");
		}
		
		private static var _instance:DepartmentService;
		
		public static function getInstance():DepartmentService {
			if(_instance == null) {
				_instance = new DepartmentService;
			}
			return _instance;
		}
		
		public static function findAll():IInvokeResponder
		{
			return getInstance().invoke("findAll");
		}
		
		public static function save(department:Department):IInvokeResponder
		{
			return getInstance().invoke("save", department);
		}
		
		public static function remove(department:Department):IInvokeResponder
		{
			return getInstance().invoke("remove", department.id);
		}
		
	}
}