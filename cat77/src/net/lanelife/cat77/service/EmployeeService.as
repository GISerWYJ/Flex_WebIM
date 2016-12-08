package net.lanelife.cat77.service
{
	
	import flash.utils.ByteArray;
	
	import net.lanelife.cat77.vo.Employee;
	import net.lanelife.framework.remoting.api.IInvokeResponder;

	public class EmployeeService extends BaseService
	{
		public function EmployeeService()
		{
			super("employeeService");
		}
		
		private static var _instance:EmployeeService;
		
		public static function getInstance():EmployeeService {
			if(_instance == null) {
				_instance = new EmployeeService;
			}
			return _instance;
		}
		
		public static function login(employee:Employee):IInvokeResponder
		{
			return getInstance().invoke("login", employee);
		}
		
		public static function changeStatus(employee:Employee, status:Number):IInvokeResponder
		{
			return getInstance().invoke("changeStatus", employee, status);
		}
		
		public static function find(id:Number):IInvokeResponder
		{
			return getInstance().invoke("find", id);
		}
		
		public static function save(employee:Employee):IInvokeResponder
		{
			return getInstance().invoke("save", employee);
		}
		
		public static function remove(employee:Employee):IInvokeResponder
		{
			return getInstance().invoke("remove", employee.id);
		}
		
		public static function update(employee:Employee, emp:Employee):IInvokeResponder
		{
			return getInstance().invoke("update", employee, emp);
		}
		
		public static function updateFace(employee:Employee, face:String, picture:ByteArray):IInvokeResponder
		{
			return getInstance().invoke("updateFace", employee, face, picture);
		}
		
		public static function updatePhoto(employee:Employee, photoData:ByteArray):IInvokeResponder
		{
			return getInstance().invoke("updatePhoto", employee, photoData);
		}
		
		public static function getTeamEmployee(employee:Employee):IInvokeResponder
		{
			return getInstance().invoke("getTeamEmployee", employee);
		}
		
		public static function changePassword(employee:Employee, oldPassword:String, newPassword:String):IInvokeResponder
		{
			return getInstance().invoke("changePassword", employee, oldPassword, newPassword);
		}
	}
}