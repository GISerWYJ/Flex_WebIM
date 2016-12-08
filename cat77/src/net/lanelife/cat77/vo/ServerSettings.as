package net.lanelife.cat77.vo
{
	[Bindable]
	[RemoteClass(alias="net.lanelife.cat77.vo.ServerSettings")]
	public class ServerSettings
	{
		public var name:String;
		public var host:String;
		public var port:Number;
	}
}