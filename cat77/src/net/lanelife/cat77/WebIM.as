package net.lanelife.cat77
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import net.lanelife.framework.app.AppManager;
	import net.lanelife.cat77.EventType;
	import net.lanelife.framework.event.XEvent;
	import net.lanelife.framework.event.XEventDispatcher;
	import net.lanelife.cat77.service.MessageService;
	import net.lanelife.cat77.service.ServerSettingsService;
	import net.lanelife.cat77.service.SystemService;
	import net.lanelife.cat77.service.TeamMessageService;
	import net.lanelife.framework.desktop.MessageBoxItem;
	import net.lanelife.framework.component.SkinManager;
	import net.lanelife.cat77.view.windows.CatIMLoginWindow;
	import net.lanelife.cat77.view.windows.MainWindow;
	import net.lanelife.cat77.view.windows.MessageBox;
	import net.lanelife.framework.cw.Alert;
	import net.lanelife.framework.cw.TrayIcon;
	import net.lanelife.framework.cw.Window;
	import net.lanelife.framework.cw.WindowManager;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	
	public class WebIM
	{
		private var mainWindow:MainWindow;
		private var mainWindowTrayIcon:TrayIcon;
		private var messageBox:MessageBox;
		private var messageBoxHideTimer:Timer;
		
		[Bindable]
		private var appContext:WebIMAppContext = WebIMAppContext.getInstance();
		private var serverSettingsService:ServerSettingsService = new ServerSettingsService;
		
		private var loginWindow:CatIMLoginWindow;
		
		public function WebIM() {
			init();
		}
		
		private function init():void {
			//侦听改变状态成功事件
			appContext.eventDispatcher.addEventListener(EventType.STATUS_CHANGE_SUCCESSFUL_EVENT, employee_statusChangeSuccessfulHandler);
			
			// 获取服务器设置
			serverSettingsService.FaultMessage = "获取不到服务器设置,请检查网络!";
			serverSettingsService.find().addResultListener(onGetServerSettingsResult);
		}
		
		public function onGetServerSettingsResult(event:ResultEvent):void
		{
			var serverSettings:int = event.result as int;
			if (serverSettings != 0) { // 服务器设置获取成功后创建并显示登录窗口。
				appContext.tcpPort = serverSettings;
				
				loginWindow = new CatIMLoginWindow();
				loginWindow.id = "loginWindow";
				loginWindow.appContext = appContext;
				
				loginWindow.show();
				
			} else {// 服务器设置获取不成功后提示错误。
				Alert.show("服务器设置错误,请联系管理员!","错误提示");
			}
		}
		
		
		/**
		 * 状态改变成功后，如果主窗口还没创建（代表登录时的改变状态）则移除登录窗口并分发登录成功事件。
		 * 
		 */
		private function employee_statusChangeSuccessfulHandler(event:Event):void
		{
			if (WindowManager.get("loginWindow")!=null)
			{
				(WindowManager.get("loginWindow") as CatIMLoginWindow).remove();
				employee_loginSuccessfulHandler();
			}
		}
		
		/**
		 * 登录成功后加载默认皮肤，创建主窗口，创建系统托盘，创建消息盒子
		 * 
		 */
		private function employee_loginSuccessfulHandler():void
		{
			
			//创建主窗口
			mainWindow = new MainWindow();
			mainWindow.id = "mainWindow" + appContext.employee.id;
			mainWindow.appContext = appContext;
			mainWindow.show();
			
			//创建系统托盘
			mainWindowTrayIcon = new TrayIcon();
			mainWindowTrayIcon.id = "mainWindowTrayIcon" + appContext.employee.id;
			mainWindowTrayIcon.label = "CAT77";
			mainWindowTrayIcon.setImage("images/logo_30x30.png");
			mainWindowTrayIcon.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void{
				mainWindow.show(); //单击系统托盘图标显示主窗口
			});
			mainWindowTrayIcon.addEventListener(MouseEvent.MOUSE_OVER, function(event:MouseEvent):void{
				stopMessageBoxHideTimer();
				if (appContext.messageBoxItemList.length>0)
				{
					messageBox.visible = true; //如果消息盒子条目数量大于0即有未读消息时，当鼠标移到托盘图标上显示消息盒子窗口
				}
			});
			mainWindowTrayIcon.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):void{
				startMessageBoxHideTimer(); //当鼠标从托盘图标移开后隐藏消息盒子窗口
			});
			
			//创建消息盒子
			messageBox = new MessageBox();
			messageBox.id = "messageBox" + appContext.employee.id;
			messageBox.ownerWindow = mainWindow;
			messageBox.messageBoxItemList = appContext.messageBoxItemList;
			messageBox.show();
			messageBox.visible = false; //默认隐藏消息盒子窗口
			messageBox.addEventListener(MouseEvent.MOUSE_OVER, function(event:MouseEvent):void{
				stopMessageBoxHideTimer();
			});
			messageBox.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):void{
				startMessageBoxHideTimer();
			});
			
			//分发离线消息获取事件
			MessageService.getOfflineMessage(appContext).addResultListener( function result(data:Object):void {
				var list:ArrayCollection = data.result as ArrayCollection;
				var sort:Sort = new Sort();
				var sf:SortField = new SortField("dt",false);
				sort.fields = [sf];
				list.sort = sort;
				list.refresh();
				for (var i:Number=0; i<list.length; i++) {
					WebIMAppContext.getInstance().pushMessageBoxItemMessage(MessageBoxItem.TYPE_EMPLOYEE_MESSAGE, list[i]); //将离线消息加到消息盒子
				}
			}).addFaultListener( function fault(info:Object):void {
				Alert.show("拉取离线消息失败!"+info.toString(),"错误提示")
			});
			
			//分发离线群消息获取事件
			TeamMessageService.getOfflineTeamMessage().addResultListener(function result(data:Object):void {
				var list:ArrayCollection = data.result as ArrayCollection;
				var sort:Sort = new Sort();
				var sf:SortField = new SortField("dt",false);
				sort.fields = [sf];
				list.sort = sort;
				list.refresh();
				for (var i:Number=0; i<list.length; i++) {
					WebIMAppContext.getInstance().pushMessageBoxItemMessage(MessageBoxItem.TYPE_TEAM_MESSAGE, list[i]); //将离线消息加到消息盒子
				}
			})
			
			//分发离线系统消息获取事件
			SystemService.getOfflineSystemMessage().addResultListener( function result(data:Object):void {
				var list:ArrayCollection = data.result as ArrayCollection;
				var sort:Sort = new Sort();
				var sf:SortField = new SortField("dt",false);
				sort.fields = [sf];
				list.sort = sort;
				list.refresh();
				for (var i:Number=0; i<list.length; i++) {
					WebIMAppContext.getInstance().pushMessageBoxItemMessage(MessageBoxItem.TYPE_SYSTEM_MESSAGE, list[i]); //将离线消息加到消息盒子
				}
			}).addFaultListener(function fault(info:Object):void {
				Alert.show("拉取离线系统消息失败!"+info.toString(),"错误提示")
			});
		}
		
		
		
		private function startMessageBoxHideTimer():void
		{
			messageBoxHideTimer = new Timer(200, 1);   
			messageBoxHideTimer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void{
				stopMessageBoxHideTimer();
				messageBox.visible = false;
			});   
			messageBoxHideTimer.start();  
		}
		
		private function stopMessageBoxHideTimer():void
		{
			if (messageBoxHideTimer)
			{
				messageBoxHideTimer.stop();
				messageBoxHideTimer = null;
			}
		}
	}
}