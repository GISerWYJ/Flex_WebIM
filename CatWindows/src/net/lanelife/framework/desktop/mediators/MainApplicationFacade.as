package net.lanelife.framework.desktop.mediators
{
	import net.lanelife.framework.desktop.mediators.iface.IMediator;

	/**
	 *结合Mediator模式来完成一些UI上的功能。
	 * @author <a href="xusenhai@163.com">xusenhai@163.com</a>
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion Flex 4
	 */
	public class MainApplicationFacade
	{
		private static var mediators:Array=[];
		public function MainApplicationFacade()
		{
		}
		
		/**
		 * 注册视图
		 * @param mediator 实现了IMediator接口的类,可以从Mediator类继承实现也可以实现IMeidator接口自主实现.
		 *
		 */
		public static function registMediator(mediator:IMediator):void
		{
			mediators.push(mediator);
		}
		
		/**
		 * 根据视图中介者的名称来返回这个中介者
		 * @param name 中介名称
		 *
		 */
		public static function retrieveMediator(name:String):IMediator
		{
			for each (var m:IMediator in mediators)
			{
				if (m.name == name)
				{
					return m;
				}
			}
			return null;
		}
		
		/**
		 * 删除一个中介者
		 * @param mediator 实现了IMediator接口的类,可以从Mediator类继承实现也可以实现IMeidator接口自主实现.
		 *
		 */
		public static function deleteMediator(mediator:IMediator):void
		{
			var index:int=mediators.indexOf(mediator);
			if (index > 0)
			{
				mediators.splice(index, 1);
			}
		}
	}
}