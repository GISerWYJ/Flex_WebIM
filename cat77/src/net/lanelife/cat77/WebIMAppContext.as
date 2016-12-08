package net.lanelife.cat77
{
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.core.SoundAsset;
	import mx.events.CloseEvent;
	import mx.formatters.DateFormatter;
	import mx.utils.URLUtil;
	
	import net.lanelife.cat77.service.EmployeeService;
	import net.lanelife.cat77.service.MessageService;
	import net.lanelife.cat77.view.windows.CatIMLoginWindow;
	import net.lanelife.cat77.view.windows.ChatWindow;
	import net.lanelife.cat77.view.windows.EmployeeProfileWindow;
	import net.lanelife.cat77.view.windows.MainWindow;
	import net.lanelife.cat77.view.windows.SystemMessageWindow;
	import net.lanelife.cat77.view.windows.TeamChatWindow;
	import net.lanelife.cat77.vo.Employee;
	import net.lanelife.cat77.vo.Manager;
	import net.lanelife.cat77.vo.Message;
	import net.lanelife.cat77.vo.SystemMessage;
	import net.lanelife.cat77.vo.Team;
	import net.lanelife.cat77.vo.TeamEmployee;
	import net.lanelife.cat77.vo.TeamMessage;
	import net.lanelife.framework.cw.TrayIcon;
	import net.lanelife.framework.cw.TrayIconManager;
	import net.lanelife.framework.cw.WindowManager;
	import net.lanelife.framework.desktop.MessageBoxItem;
	import net.lanelife.framework.event.XEvent;
	import net.lanelife.framework.event.XEventDispatcher;
	import net.lanelife.framework.remoting.DataService;
	import net.lanelife.framework.remoting.DataType;
	
	[Bindable]
	public class WebIMAppContext
	{
		public var eventDispatcher:XEventDispatcher = XEventDispatcher.getNewInstance();
		
		public var tcpPort:int;
		/**
		 * 部门列表 
		 */
		public var departmentList:ArrayCollection = new ArrayCollection();
		
		/**
		 * 群列表 
		 */
		public var teamEmployeeList:ArrayCollection = new ArrayCollection();
		
		/**
		 * 当前用户 
		 */
		public var employee:Employee;
		
		/**
		 * 消息盒子条目列表
		 */
		public var messageBoxItemList:ArrayCollection = new ArrayCollection();
		
		/**
		 * 管理员 
		 */
		public var manager:Manager;
		
		
		[Embed('assets/sound/online.mp3')] 
		/**
		 * 员工上线声音 
		 */
		private var onlineSound:Class; 
		
		[Embed('assets/sound/message.mp3')] 
		/**
		 * 消息声音 
		 */
		private var messageSound:Class; 
		
		[Embed('assets/sound/system.mp3')] 
		/**
		 * 系统消息声音 
		 */
		private var systemSound:Class;
		
		
		
		/**
		 * 通过id取得员工
		 * @param id 员工id
		 * @return 员工对象，如果返回null代表找不到该员工
		 * 
		 */
		public function getEmployee(id:Number):Employee
		{
			for (var i:Number=0; i<departmentList.length; i++)
			{
				var employees:ArrayCollection = departmentList[i].employees;
				for (var j:Number=0; j<employees.length; j++)
				{
					if (employees[j].id==id)
					{
						return employees[j];
					}
				}
			}
			return null;
		}
		
		/**
		 * 通过窗口id取得消息盒子条目 
		 * @param windowId 窗口id
		 * @return 消息盒子条目，如果返回null代表找不到该消息盒子条目
		 * 
		 */
		public function getMessageBoxItem(type:Number, windowId:Number):MessageBoxItem
		{
			for (var i:Number=0; i<messageBoxItemList.length; i++)
			{
				if (messageBoxItemList[i].type==type && messageBoxItemList[i].windowId==windowId)
				{
					return messageBoxItemList[i];
				}
			}
			return null;
		}
		
		/**
		 * 等待握手，如果该帐号已在其他地方登录，则会将其强制下线
		 * 
		 */
		public function waitShakeHands():void
		{
			var timer:Timer = new Timer(3000, 1);   
			timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void{
//				CairngormEventDispatcher.getInstance().dispatchEvent(
//					new SocketEvent(SocketEvent.SOCKET_SHAKE_HANDS_EVENT) //等待三秒后再次分发握手事件
//				);
			});   
			timer.start();  
		}
		
		/**
		 * 强制下线 
		 * 
		 */
		public function forceOffline():void
		{
			closeSocket();
			Alert.okLabel = "确定";
			Alert.show("您的帐号在另一地方登录，您被迫下线。","下线通知",Alert.OK,null,function(event:CloseEvent):void{
				logout();
			});
		}
		
		/**
		 * 注销 
		 * 
		 */
		public function logout():void
		{
			closeSocket();
			
			departmentList.removeAll();
			employee = null;
			messageBoxItemList.removeAll();
			teamEmployeeList.removeAll();
			(WindowManager.get("mainWindow") as MainWindow).remove();
			TrayIconManager.get("mainWindowTrayIcon").destroy();
			
			FlexGlobals.topLevelApplication.currentState = "login";
			var loginWindow:CatIMLoginWindow = new CatIMLoginWindow();
			loginWindow.id = "loginWindow";
			loginWindow.isAutoLogin = false;
			loginWindow.show();
			
		}
		
		/**
		 * 改变在线状态 
		 */
		public function changeStatus(status:Number):void
		{
			var _instance:WebIMAppContext = this;
			
			EmployeeService.changeStatus(employee, status).addResultListener(function(data:Object):void {
				
				var employee:Employee = data.result as Employee;
				_instance.employee.status = employee.status;
				
				eventDispatcher.dispatchEvent(new XEvent(EventType.STATUS_CHANGE_SUCCESSFUL_EVENT).setData(employee));
				
			}).addFaultListener(function fault(info:Object):void {
				Alert.show("状态更换失败");
			});
		}
		
		/**
		 * 更新员工在线状态，如果是上线且不是自己则播放上线声音 
		 * @param id 员工id
		 * @param status 状态
		 * 
		 */
		public function updateEmployeeStatus(id:Number, status:Number):void
		{
			var emp:Employee = getEmployee(id);
			if (emp!=null)
			{
				emp.status = status;
				if (status==1 && id!=employee.id)
				{
					var onlineSoundAsset:SoundAsset = new onlineSound() as SoundAsset;
					onlineSoundAsset.play();
				}
			}
		}
		
		public function refreshTeamEmployees():void
		{
			for(var i:Number=0; i<teamEmployeeList.length; i++)
			{
				teamEmployeeList[i].team.teamEmployees.refresh();
			}
		}
		
		/**
		 * 更新员工资料 
		 * @param id
		 * @param username
		 * @param sign
		 * 
		 */
		public function updateEmployeeProfile(id:Number, username:String, sign:String):void
		{
			var emp:Employee = getEmployee(id);
			emp.username = username;
			emp.sign = sign;
		}
		
		/**
		 * 更新员工头像 
		 * @param id
		 * @param face
		 * 
		 */
		public function updateEmployeeFace(id:Number, face:String):void
		{
			getEmployee(id).face = face;
		}
		
		/**
		 * 更新员工照片 
		 * @param id
		 * @param face
		 * 
		 */
		public function updateEmployeePhoto(id:Number, photo:String):void
		{
			getEmployee(id).photo = photo;
		}
		
		/**
		 * 处理消息，对话窗口已打开则显示消息，否则加入消息盒子并托盘图标闪烁
		 * @param message
		 * 
		 */
		public function processMessage(message:XML):void
		{
			var msg:Message = new Message();
			var sender:Employee = getEmployee(message.sender.id);
			msg.sender = sender;
			msg.dt = DateFormatter.parseDateString(message.datetime);
			msg.content = message.content;
			
			var chatWindow:ChatWindow = WindowManager.get("chatWindow"+sender.id) as ChatWindow;
			if (chatWindow!=null) //如果与该人员的对话窗口已打开则显示消息
			{
				chatWindow.showMessage(msg);
				var messageSoundAsset:SoundAsset = new messageSound() as SoundAsset;
				messageSoundAsset.play();
				if (WindowManager.front!=chatWindow)
				{
					chatWindow.taskbarButton.flashes = true;
				}
			}
			else //如果未打开聊天窗口，则将消息加入消息盒子
			{
				pushMessageBoxItemMessage(MessageBoxItem.TYPE_EMPLOYEE_MESSAGE, msg);
			}
		}
		
		public function processTeamMessage(message:XML):void
		{
			var msg:TeamMessage = new TeamMessage();
			var sender:Employee = getEmployee(message.sender.id);
			msg.sender = sender;
			msg.team = getTeam(message.teamid);
			msg.dt = DateFormatter.parseDateString(message.datetime);
			msg.content = message.content;
			
			var teamChatWindow:TeamChatWindow = WindowManager.get("teamChatWindow"+msg.team.id) as TeamChatWindow;
			if (teamChatWindow!=null) //如果与该群的对话窗口已打开则显示消息
			{
				teamChatWindow.showMessage(msg);
				if (WindowManager.front!=teamChatWindow)
				{
					teamChatWindow.taskbarButton.flashes = true;
				}
				/*var messageSoundAsset:SoundAsset = new messageSound() as SoundAsset;
				messageSoundAsset.play(); 群消息暂不声音提醒*/
			}
			else //如果未打开聊天窗口，则将消息加入消息盒子
			{
				pushMessageBoxItemMessage(MessageBoxItem.TYPE_TEAM_MESSAGE, msg);
			}
		}
		
		public function processSystemMessage(message:XML):void
		{
			var msg:SystemMessage = new SystemMessage();
			msg.id = message.id;
			msg.dt = DateFormatter.parseDateString(message.datetime);
			msg.title = message.title;
			msg.content = message.content;
			pushMessageBoxItemMessage(MessageBoxItem.TYPE_SYSTEM_MESSAGE, msg);
		}
		
		/**
		 * 往消息盒子添加消息
		 * 
		 */
		public function pushMessageBoxItemMessage(type:Number, message:Object):void
		{
			var windowId:Number;
			var icon:String;
			var text:String;
			if (type==MessageBoxItem.TYPE_EMPLOYEE_MESSAGE)
			{
				windowId = message.sender.id;
				icon = message.sender.face;
				text = message.sender.username;
			}
			else if (type==MessageBoxItem.TYPE_TEAM_MESSAGE)
			{
				windowId = message.team.id;
				icon = message.team.icon;
				text = message.team.name;
			}
			else if (type==MessageBoxItem.TYPE_SYSTEM_MESSAGE)
			{
				windowId = message.id;
				icon = "images/sysmsg.png";
				text = message.title;
			}
			var messageBoxItem:MessageBoxItem = getMessageBoxItem(type, windowId);
			if (messageBoxItem==null) //如果消息盒子不存在该人员则创建新条目
			{
				messageBoxItem = new MessageBoxItem();
				messageBoxItem.type = type;
				messageBoxItem.appContext = this;
				messageBoxItem.windowId = windowId;
				messageBoxItemList.addItem(messageBoxItem); //往消息盒子添加条目
			}
			messageBoxItem.icon = icon;
			messageBoxItem.text = text;
			messageBoxItem.messages.addItem(message); //往消息盒子条目添加消息
			
			if (type==MessageBoxItem.TYPE_EMPLOYEE_MESSAGE)
			{
				var messageSoundAsset:SoundAsset = new messageSound() as SoundAsset;
				messageSoundAsset.play();
			}
			else if (type==MessageBoxItem.TYPE_SYSTEM_MESSAGE)
			{
				var systemSoundAsset:SoundAsset = new systemSound() as SoundAsset;
				systemSoundAsset.play();
			}
			
			updateMainWindowTrayIcon(); //更新系统托盘图标
		}
		
		/**
		 * 打开与给定人员的对话窗口，如果该窗口已创建则前置该窗口。
		 * @param employee 员工对象
		 * 
		 */
		public function openChatWindow(employee:Employee):void
		{
			var chatWindow:ChatWindow = WindowManager.get("chatWindow"+employee.id) as ChatWindow;
			if (chatWindow==null)
			{
				chatWindow = new ChatWindow();
				chatWindow.id = "chatWindow"+employee.id;
				chatWindow.employee = employee;
				chatWindow.appContext = this;
				chatWindow.ownerWindow = WindowManager.get("mainWindow");
			}
			chatWindow.show();
			chatWindow.init();
		}
		
		/**
		 * 打开给定人员的资料查看窗口。
		 * @param employee 员工对象
		 * 
		 */
		public function openEmployeeProfileWindow(employee:Employee):void
		{
			var employeeProfileWindow:EmployeeProfileWindow = WindowManager.get("employeeProfileWindow"+employee.id) as EmployeeProfileWindow;
			if (employeeProfileWindow==null)
			{
				employeeProfileWindow = new EmployeeProfileWindow();
				employeeProfileWindow.id = "employeeProfileWindow"+employee.id;
				employeeProfileWindow.employee = employee;
				employeeProfileWindow.ownerWindow = WindowManager.get("mainWindow");
			}
			employeeProfileWindow.show();
		}
		
		public function updateMainWindowTrayIcon():void
		{
			var mainWindowTrayIcon:TrayIcon = TrayIconManager.get("mainWindowTrayIcon" + employee.id);
			if (mainWindowTrayIcon!=null)
			{
				if (messageBoxItemList.length>0)
				{
					var lastMbi:MessageBoxItem = messageBoxItemList[messageBoxItemList.length-1];
					mainWindowTrayIcon.setImage(lastMbi.icon); //设置托盘图标为最后条目的图标
					mainWindowTrayIcon.startFlashImage(500);
				}
				else
				{
					mainWindowTrayIcon.setImage("images/logo_30x30.png"); //设置托盘图标为LOGO图标
					mainWindowTrayIcon.stopFlashImage();
				}
			}
		}
		
		
		/**
		 * 入群 
		 * @param message
		 * 
		 */
		public function inTeam(message:XML):void
		{
			var teamEmployee:TeamEmployee = getTeamEmployeeByTeamId(teamEmployeeList, message.id);
			if (teamEmployee==null)
			{ //处理新增群或刚入群
				teamEmployee = new TeamEmployee();
				var team:Team = new Team();
				team.id = message.id;
				team.name = message.name;
				team.icon = message.icon;
				team.placard = message.placard;
				team.summary = message.summary;
				teamEmployee.team = team;
				teamEmployee.employee = employee;
				teamEmployeeList.addItem(teamEmployee);
			}
			else
			{
				teamEmployee.team.name = message.name;
				teamEmployee.team.icon = message.icon;
				teamEmployee.team.placard = message.placard;
				teamEmployee.team.summary = message.summary;
				if (teamEmployee.team.teamEmployees.length>0)
				{ //如果群成员被加载过则处理新增人员和删除人员
					for (var i:Number=0; i<message.selectedteamemployees.teamemployee.length(); i++)
					{
						if (getTeamEmployee(teamEmployee.team.teamEmployees, message.selectedteamemployees.teamemployee[i].id)==null)
						{ //如果该人员不存在于这个群组中则往群组添加该人员
							var te:TeamEmployee = new TeamEmployee();
							te.id = message.selectedteamemployees.teamemployee[i].id;
							te.team = teamEmployee.team;
							te.employee = getEmployee(message.selectedteamemployees.teamemployee[i].employeeid);
							teamEmployee.team.teamEmployees.addItem(te);
						}
					}
					//处理删除群成员
					for (var j:Number=0; j<message.deletedteamemployees.teamemployee.length(); j++)
					{
						teamEmployee.team.teamEmployees.removeItemAt(
							teamEmployee.team.teamEmployees.getItemIndex(
								getTeamEmployee(
									teamEmployee.team.teamEmployees, message.deletedteamemployees.teamemployee[j].id
								)
							)
						);
					}
				}
			}
		}
		
		/**
		 * 出群 
		 * @param message
		 * 
		 */
		public function outTeam(message:XML):void
		{
			for (var i:Number=0; i<teamEmployeeList.length; i++)
			{
				if (teamEmployeeList[i].team.id==message.id)
				{
					teamEmployeeList.removeItemAt(i);
					var teamChatWindow:TeamChatWindow = WindowManager.get("teamChatWindow"+message.id) as TeamChatWindow;
					if (teamChatWindow!=null)
					{
						teamChatWindow.close();
					}
				}
			}
		}
		
		public function quitTeam(message:XML):void
		{
			var quitTeamEmployee:TeamEmployee = getTeamEmployeeByTeamId(teamEmployeeList, message.id); //取得退出的群
			if (quitTeamEmployee!=null)
			{
				//取得该群要退出的成员
				var deleteTeamEmployee:TeamEmployee = getTeamEmployeeByEmployeeId(quitTeamEmployee.team.teamEmployees, message.employeeid);
				if (deleteTeamEmployee!=null)
				{
					//删除该成员
					quitTeamEmployee.team.teamEmployees.removeItemAt(
						quitTeamEmployee.team.teamEmployees.getItemIndex(deleteTeamEmployee)
					);
				}
			}
		}
		
		public function dissolveTeam(id:Number):void
		{
			for (var i:Number=0; i<teamEmployeeList.length; i++)
			{
				if (teamEmployeeList[i].team.id==id)
				{
					teamEmployeeList.removeItemAt(i);
				}
			}
			var window:TeamChatWindow = WindowManager.get("teamChatWindow"+id) as TeamChatWindow;
			if (window!=null)
			{
				window.close(); //关闭对话窗口
			}
			var mbi:MessageBoxItem = getMessageBoxItem(MessageBoxItem.TYPE_TEAM_MESSAGE, id); //取出消息盒子条目
			if (mbi!=null)
			{
				messageBoxItemList.removeItemAt(messageBoxItemList.getItemIndex(mbi)); //移除消息盒子条目
			}
			updateMainWindowTrayIcon(); //更新系统托盘图标
		}
		
		/**
		 * 通过id获取Team 
		 * @param id
		 * @return 
		 * 
		 */
		public function getTeam(id:Number):Team
		{
			for (var i:Number=0; i<teamEmployeeList.length; i++)
			{
				if (teamEmployeeList[i].team.id==id)
				{
					return teamEmployeeList[i].team;
				}
			}
			return null;
		}
		
		/**
		 * 通过id取得 TeamEmployee
		 * @param teamEmployees
		 * @param id
		 * @return 
		 * 
		 */
		public function getTeamEmployee(teamEmployees:ArrayCollection, id:Number):TeamEmployee
		{
			for (var i:Number=0; i<teamEmployees.length; i++)
			{
				if (teamEmployees[i].id==id)
				{
					return teamEmployees[i];
				}
			}
			return null;
		}
		
		/**
		 * 通过人员id取得 TeamEmployee
		 * @param teamEmployees
		 * @param employeeid
		 * @return 
		 * 
		 */
		public function getTeamEmployeeByEmployeeId(teamEmployees:ArrayCollection, employeeid:Number):TeamEmployee
		{
			for (var i:Number=0; i<teamEmployees.length; i++)
			{
				if (teamEmployees[i].employee.id==employeeid)
				{
					return teamEmployees[i];
				}
			}
			return null;
		}
		
		/**
		 * 通过群组id取得 TeamEmployee
		 * @param teamEmployees
		 * @param teamid
		 * @return 
		 * 
		 */
		public function getTeamEmployeeByTeamId(teamEmployees:ArrayCollection, teamid:Number):TeamEmployee
		{
			for (var i:Number=0; i<teamEmployees.length; i++)
			{
				if (teamEmployees[i].team.id==teamid)
				{
					return teamEmployees[i];
				}
			}
			return null;
		}
		
		/**
		 * 打开与给定群的对话窗口，如果该窗口已创建则前置该窗口。
		 * @param employee
		 * 
		 */
		public function openTeamChatWindow(team:Team):void
		{
			var teamChatWindow:TeamChatWindow = WindowManager.get("teamChatWindow"+team.id) as TeamChatWindow;
			if (teamChatWindow==null)
			{
				teamChatWindow = new TeamChatWindow();
				teamChatWindow.id = "teamChatWindow"+team.id;
				teamChatWindow.team = team;
				teamChatWindow.ownerWindow = WindowManager.get("mainWindow");
			}
			teamChatWindow.show();
		}
		
		public function openSystemMessageWindow(message:SystemMessage):void
		{
			var systemMessageWindow:SystemMessageWindow = WindowManager.get("systemMessageWindow"+message.id) as SystemMessageWindow;
			if (systemMessageWindow==null)
			{
				systemMessageWindow = new SystemMessageWindow();
				systemMessageWindow.id = "systemMessageWindow"+message.id;
				systemMessageWindow.message = message;
				systemMessageWindow.ownerWindow = WindowManager.get("mainWindow");
			}
			systemMessageWindow.show();
		}
		
		
		public function WebIMAppContext()
		{
//			if ( modelLocator != null )
//			{
//				throw new Error( "Only one ModelLocator instance should be instantiated" );	
//			}
		}
		
		public static function getInstance():WebIMAppContext 
		{
//			if ( modelLocator == null )
//			{
//				modelLocator = new ModelLocator();
//			}
			return new WebIMAppContext;
		}
		
		private var dataService:DataService;
		
		public function connectServer(onError:Function):void
		{
			var message:String = "<message><type>shakeHands</type><id>"+employee.id+"</id></message>";
			var serverSettings:String = tcpPort+"";
			
			var appContext:WebIMAppContext = this;
			
			dataService = DataService.getInstance(URLUtil.getServerName(FlexGlobals.topLevelApplication.url), DataType.SOCKET);
			dataService.send(serverSettings, message)
				.addResultListener(function(message:*):void{
					if(message!=null) {
						MessageService.dispatch(message, appContext);
					}
				})
				.addFaultListener(function(e:Object):void{
					onError();
				});
		}
		
		public function closeSocket():void {
			dataService.close();
		}
	}
}