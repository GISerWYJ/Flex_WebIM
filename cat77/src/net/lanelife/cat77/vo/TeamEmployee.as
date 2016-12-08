package net.lanelife.cat77.vo
{
	[Bindable]
	[RemoteClass(alias="net.lanelife.cat77.vo.TeamEmployee")]
	public class TeamEmployee
	{
		public var id:Number;
		public var team:Team;
		public var employee:Employee;
		public var ismanager:Boolean;
		public var lastTeamMessage:Number = 0;
	}
}