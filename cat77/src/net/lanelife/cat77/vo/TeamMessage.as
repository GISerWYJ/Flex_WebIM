package net.lanelife.cat77.vo
{
	[Bindable]
	[RemoteClass(alias="net.lanelife.cat77.vo.TeamMessage")]
	public class TeamMessage
	{
		public var id:Number;
		public var sender:Employee;
		public var team:Team;
		public var content:String;
		public var dt:Date;
	}
}