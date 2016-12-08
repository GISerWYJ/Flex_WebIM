package net.lanelife.cat77.view.components
{
	import net.lanelife.cat77.vo.Team;
	
	import spark.components.Button;
	
	public class TeamListButton extends Button
	{
		[Bindable]
		public var team:Team;
		
		public function TeamListButton()
		{
			super();
		}
	}
}