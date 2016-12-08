package net.lanelife.cat77.vo
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="net.lanelife.cat77.vo.Team")]
	public class Team
	{
		public var id:Number;
		public var name:String;
		public var icon:String;
		public var placard:String;
		public var summary:String;
		public var teamEmployees:ArrayCollection = new ArrayCollection();
	}
}