package net.lanelife.framework.cmp.login
{
	import flash.net.SharedObject;
	
	import mx.collections.ArrayCollection;
	
	import spark.collections.Sort;
	import spark.collections.SortField;

	public class AccountManager
	{
		public function AccountManager()
		{
		}
		
		/**
		 * 获取所有登录过的用户
		 */
		public static function getAccounts():ArrayCollection {
			var accountSharedObject:SharedObject = SharedObject.getLocal("accounts");
			var accounts:ArrayCollection = accountSharedObject.data.accounts as ArrayCollection;
			
			if (accounts == null) {
				accounts = new ArrayCollection;
			}
			
			//按最后登录时间排序帐号
			var s:Sort = new Sort();
			s.fields = [new SortField("lastLoginTime",true)];
			accounts.sort = s;
			accounts.refresh();
			
			return accounts;
		}
		
		/**
		 * 获取自动登录的用户
		 */
		public static function getAutoLoginAccount():Object {
			var accounts:ArrayCollection = getAccounts();
			
			for(var i:Number=0; i<accounts.length; i++) {
				if (accounts[i].autoLogin && accounts[i].rememberPassword) {//循环判断如果帐号勾选了自动登录且记住密码
					return accounts.getItemAt(i);
				}
			}
			
			return null;
		}
		
		/**
		 * 获取最后登录的用户
		 */
		public static function getLastLoginAccount():Object {
			var accounts:ArrayCollection = getAccounts();
			if(accounts.length > 0) {
				return accounts.getItemAt(0)
			}
			return null;
		}
		
		/**
		 * 添加账户
		 */
		public static function addAccount(account:Object):void {
			
			var accounts:ArrayCollection = getAccounts();
			
			for(var i:Number=0; i<accounts.length; i++) {
				if (accounts[i].userid == account.userid) {
					accounts.removeItemAt(i);
				}
			}
			accounts.addItem(account);
			
			var accountSharedObject:SharedObject = SharedObject.getLocal("accounts");
			accountSharedObject.data.accounts = accounts;
			//accountSharedObject.flush();
		}
	}
}