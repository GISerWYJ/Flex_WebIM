package net.lanelife.cat77.service
{
	
	import net.lanelife.cat77.WebIMAppContext;
	import net.lanelife.cat77.vo.Message;
	import net.lanelife.framework.remoting.api.IInvokeResponder;

	public class MessageService extends BaseService
	{
		public function MessageService()
		{
			super("messageService");
		}
		
		private static var _instance:MessageService;
		
		public static function getInstance():MessageService {
			if(_instance == null) {
				_instance = new MessageService;
			}
			return _instance;
		}
		
		/**
		 * 发送消息 
		 * @param message
		 */
		public static function send(message:Message):IInvokeResponder
		{
			return getInstance().invoke("send", message);
		}
		
		/**
		 * 分发各种类型消息 
		 * @param value
		 */
		public static function dispatch(value:String, appContext:WebIMAppContext):void
		{
			var message:XML = new XML(value);
			if (message.type=="waitShakeHands") { //等待握手
				appContext.waitShakeHands();
			} else if (message.type=="shakeHands") { //成功握手
				appContext.changeStatus(appContext.employee.status); //成功握手后改变在线状态
			} else if (message.type=="changeStatus") { //状态改变
				appContext.updateEmployeeStatus(message.id, message.status);
				appContext.refreshTeamEmployees();
			} else if (message.type=="forceOffline") { //强制离线
				appContext.forceOffline();
			} else if (message.type=="updateProfile") { //资料更新
				appContext.updateEmployeeProfile(message.id, message.username, message.sign);
			} else if (message.type=="updateFace") { //头像更新
				appContext.updateEmployeeFace(message.id, message.face);
			} else if (message.type=="updatePhoto") { //照片更新
				appContext.updateEmployeePhoto(message.id, message.photo);
			} else if (message.type=="message") { //普通消息
				appContext.processMessage(message);
			} else if (message.type=="teamMessage") { //群消息
				appContext.processTeamMessage(message);
			} else if (message.type=="inTeam") { //入群
				appContext.inTeam(message);
			} else if (message.type=="outTeam") { //出群
				appContext.outTeam(message);
			} else if (message.type=="quitTeam") { //退群
				appContext.quitTeam(message);
			} else if (message.type=="dissolveTeam") { //退群
				appContext.dissolveTeam(message.id);
			} else if (message.type=="systemMessage") { //系统消息
				appContext.processSystemMessage(message);
			}
		}
		
		public static function getOfflineMessage(appContext:WebIMAppContext):IInvokeResponder
		{
			return getInstance().invoke("getAndUpdateOfflineMessage", appContext.employee);
		}
	}
}