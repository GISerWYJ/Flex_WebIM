package net.lanelife.cat77.vo
{
	[Bindable]
	[RemoteClass(alias="net.lanelife.cat77.vo.Message")]
	public class Message
	{
		public var id:Number;
		public var sender:Employee;
		public var receiver:Employee;
		public var content:String;
		public var dt:Date;
		public var status:Number;
	}
}