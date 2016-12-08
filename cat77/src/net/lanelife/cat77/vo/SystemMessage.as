package net.lanelife.cat77.vo
{
	[Bindable]
	[RemoteClass(alias="net.lanelife.cat77.vo.SystemMessage")]
	public class SystemMessage
	{
		public var id:Number;
		public var receiver:Employee;
		public var title:String;
		public var content:String;
		public var dt:Date;
		public var status:Number;
	}
}