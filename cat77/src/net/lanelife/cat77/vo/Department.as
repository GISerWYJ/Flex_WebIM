package net.lanelife.cat77.vo
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	[RemoteClass(alias="net.lanelife.cat77.vo.Department")]
	public class Department
	{
		/**
		 * 部门ID
		 */
		public var id:Number;
		/**
		 * 部门名称
		 */
		public var name:String;
		/**
		 * 员工
		 */
		public var employees:ArrayCollection = new ArrayCollection();
		
	}
}