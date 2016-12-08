package net.lanelife.framework.desktop.util.math
{

	public class MathD
	{
		public function MathD()
		{
		}

		public static function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var dx:Number=x2 - x1;
			var dy:Number=y2 - y1;
			var d:Number=Math.sqrt(dx * dx + dy * dy);
			return d;
		}

		public static function degreesToRadians(angel:Number):Number
		{
			return angel * Math.PI / 180;
		}

		public static function RadiansTodegrees(angel:Number):Number
		{
			return angel * 180 / Math.PI;
		}

		public static function sin(angel:Number):Number
		{
			return Math.sin(angel * Math.PI / 180);
		}

		public static function cos(angel:Number):Number
		{
			return Math.cos(angel * Math.PI / 180);
		}

		public static function tan(angel:Number):Number
		{
			return Math.tan(angel * Math.PI / 180);
		}

		public static function atan(rad:Number):Number
		{
			return Math.atan(rad) * 180 / Math.PI;
		}

		public static function atan2(x:Number, y:Number):Number
		{
			return Math.atan2(y, x) * 180 / Math.PI;
		}

		public static function angle(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			return atan2(y2 - y1, x2 - x1);
		}

		public static function acos(ratio:Number):Number
		{
			return Math.round(Math.acos(ratio) * 180 / Math.PI);
		}

		public static function asin(ratio:Number):Number
		{
			return Math.round(Math.asin(ratio) * 180 / Math.PI);
		}
	}
}