package net.lanelife.cat77.vo
{
	[Bindable]
	[RemoteClass(alias="net.lanelife.cat77.vo.Employee")]
	public dynamic class Employee
	{
		/**
		 * 员工ID
		 */
		public var id:Number;
		/**
		 *  员工名称
		 */
		public var username:String;
		/**
		 * 密码
		 */
		public var password:String;
		/**
		 * 启用状态
		 */
		public var enable:Boolean;
		/**
		 * 在线状态
		 */
		public var status:Number;
		/**
		 * 头像
		 */
		public var face:String;
		/**
		 * 照片
		 */
		public var photo:String;
		/**
		 * 个性签名
		 */
		public var sign:String;
		/**
		 * 性别
		 */
		public var sex:String;
		/**
		 * 生日
		 */
		public var birthday:Date;
		/**
		 * 年龄
		 */
		public var age:Number;
		/**
		 * 生肖
		 */
		public var zodiac:String;
		/**
		 * 星座
		 */
		public var constellation:String;
		/**
		 * 血型
		 */
		public var bloodtype:String;
		/**
		 * 职务
		 */
		public var job:String;
		/**
		 * 手机号码
		 */
		public var mobile:String;
		/**
		 * 电话号码
		 */
		public var telephone:String;
		/**
		 * 邮箱
		 */
		public var email:String;
		/**
		 * QQ号码
		 */
		public var qq:String;
		/**
		 * 毕业院校
		 */
		public var graduateschool:String;
		/**
		 * 专业
		 */
		public var professional:String;
		/**
		 * 籍贯
		 */
		public var birthplace:String;
		/**
		 * 个人说明
		 */
		public var confessions:String;
		/**
		 * 部门
		 */
		public var department:Department;
		
	}
}