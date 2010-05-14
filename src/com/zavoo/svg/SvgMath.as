package com.zavoo.svg
{
	public class SvgMath
	{
		static public var colors:Object = {};
			colors.blue=0x0000ff;
			colors.green=0x008000;
			colors.red=0xff0000;
			colors.aliceblue=0xf0f8ff;
			colors.antiquewhite=0xfaebd7;
			colors.aqua=0x00ffff;
			colors.aquamarine=0x7fffd4;
			colors.azure=0xf0ffff;
			colors.beige=0xf5f5dc;
			colors.bisque=0xffe4c4;
			colors.black=0x000000;
			colors.blanchedalmond=0xffebcd;
			colors.blueviolet=0x8a2be2;
			colors.brown= 0xa52a2a;
			colors.burlywood = 0xdeb887;
			colors.cadetblue = 0x5f9ea0;
			colors.chartreuse = 0x7fff00;
			colors.chocolate = 0xd2691e;
			colors.coral= 0xff7f50;
			colors.cornflowerblue = 0x6495ed;
			colors.cornsilk = 0xfff8dc;
			colors.crimson = 0xdc143c;
			colors.cyan = 0x00ffff;
			colors.darkblue = 0x00008b;
			colors.darkcyan = 0x008b8b;
			colors.darkgoldenrod = 0xb8860b;
			colors.darkgray = 0xa9a9a9;
			colors.darkgreen = 0x006400;
			colors.darkgrey = 0xa9a9a9;
			colors.darkkhaki = 0xbdb76b;
			colors.darkmagenta = 0x8b008b;
			colors.darkolivegreen = 0x556b2f;
			colors.darkorange = 0xff8c00;
			colors.darkorchid = 0x9932cc;
			colors.darkred = 0x8b0000;
			colors.darksalmon = 0xe9967a;
			colors.darkseagreen = 0x8fbc8f;
			colors.darkslateblue = 0x483d8b;
			colors.darkslategray = 0x2f4f4f;
			colors.darkslategrey = 0x2f4f4f;
			colors.darkturquoise = 0x00ced1;
			colors.darkviolet = 0x9400d3;
			colors.deeppink = 0xff1493;
			colors.deepskyblue = 0x00bfff;
			colors.dimgray = 0x696969;
			colors.dimgrey = 0x696969;
			colors.dodgerblue = 0x1e90ff;
			colors.firebrick = 0xb22222;
			colors.floralwhite = 0xfffaf0;
			colors.forestgreen = 0x228b22;
			colors.fuchsia = 0xff00ff;
			colors.gainsboro = 0xdcdcdc;
			colors.ghostwhite = 0xf8f8ff;
			colors.gold = 0xffd700;
			colors.goldenrod = 0xdaa520;
			colors.gray = 0x808080;
			colors.grey = 0x808080;
			colors.greenyellow = 0xadff2f;
			colors.honeydew = 0xf0fff0;
			colors.hotpink = 0xff69b4;
			colors.indianred = 0xcd5c5c;
			colors.indigo = 0x4b0082;
			colors.ivory = 0xfffff0;
			colors.khaki = 0xf0e68c;
			colors.lavender = 0xe6e6fa;
			colors.lavenderblush = 0xfff0f5;
			colors.lawngreen = 0x7cfc00;
			colors.lemonchiffon = 0xfffacd;
			colors.lightblue = 0xadd8e6;
			colors.lightcoral = 0xf08080;
			colors.lightcyan = 0xe0ffff;
			colors.lightgoldenrodyellow = 0xfafad2;
			colors.lightgray = 0xd3d3d3;
			colors.lightgreen = 0x90ee90;
			colors.lightgrey = 0xd3d3d3;
			colors.lightpink = 0xffb6c1;
			colors.lightsalmon = 0xffa07a;
			colors.lightseagreen = 0x20b2aa;
			colors.lightskyblue = 0x87cefa;
			colors.lightslategray = 0x778899;
			colors.lightslategrey = 0x778899;
			colors.lightsteelblue = 0xb0c4de;
			colors.lightyellow = 0xffffe0;
			colors.lime = 0x00ff00;
			colors.limegreen = 0x32cd32;
			colors.linen = 0xfaf0e6;
			colors.magenta = 0xff00ff;
			colors.maroon = 0x800000;
			colors.mediumaquamarine = 0x66cdaa;
			colors.mediumblue = 0x0000cd;
			colors.mediumorchid = 0xba55d3;
			colors.mediumpurple = 0x9370db;
			colors.mediumseagreen = 0x3cb371;
			colors.mediumslateblue = 0x7b68ee;
			colors.mediumspringgreen = 0x00fa9a;
			colors.mediumturquoise = 0x48d1cc;
			colors.mediumvioletred = 0xc71585;
			colors.midnightblue = 0x191970;
			colors.mintcream = 0xf5fffa;
			colors.mistyrose = 0xffe4e1;
			colors.moccasin = 0xffe4b5;
			colors.navajowhite = 0xffdead;
			colors.navy = 0x000080;
			colors.oldlace = 0xfdf5e6;
			colors.olive = 0x808000;
			colors.olivedrab = 0x6b8e23;
			colors.orange = 0xffa500;
			colors.orangered = 0xff4500;
			colors.orchid = 0xda70d6;
			colors.palegoldenrod = 0xeee8aa;
			colors.palegreen = 0x98fb98;
			colors.paleturquoise = 0xafeeee;
			colors.palevioletred = 0xdb7093;
			colors.papayawhip = 0xffefd5;
			colors.peachpuff = 0xffdab9;
			colors.peru = 0xcd853f;
			colors.pink = 0xffc0cb;
			colors.plum = 0xdda0dd;
			colors.powderblue = 0xb0e0e6;
			colors.purple = 0x800080;
			colors.rosybrown = 0xbc8f8f;
			colors.royalblue = 0x4169e1;
			colors.saddlebrown = 0x8b4513;
			colors.salmon = 0xfa8072;
			colors.sandybrown = 0xf4a460;
			colors.seagreen = 0x2e8b57;
			colors.seashell = 0xfff5ee;
			colors.sienna = 0xa0522d;
			colors.silver = 0xc0c0c0;
			colors.skyblue = 0x87ceeb;
			colors.slateblue = 0x6a5acd;
			colors.slategray = 0x708090;
			colors.slategrey = 0x708090;
			colors.snow = 0xfffafa;
			colors.springgreen = 0x00ff7f;
			colors.steelblue = 0x4682b4;
			colors.tan = 0xd2b48c;
			colors.teal = 0x008080;
			colors.thistle = 0xd8bfd8;
			colors.tomato = 0xff6347;
			colors.turquoise = 0x40e0d0;
			colors.violet = 0xee82ee;
			colors.wheat = 0xf5deb3;
			colors.white = 0xffffff;
			colors.whitesmoke = 0xf5f5f5;    
			colors.yellow = 0xffff00;
			colors.yellowgreen = 0x9acd32;
			
		static public function cubicBezierToQuadratic(P0:Object, P1:Object, P2:Object, P3:Object):Array
		{
			/* A portion of code from Bezier_lib.as by Timothee Groleau */
			// calculates the useful base points
			var PA:Object = getPointOnSegment(P0, P1, 3/4);
			var PB:Object = getPointOnSegment(P3, P2, 3/4);
			
			// get 1/16 of the [P3, P0] segment
			var dx:Number = (P3.x - P0.x)/16;
			var dy:Number = (P3.y - P0.y)/16;
			
			// calculates control point 1
			var Pc_1:Object = getPointOnSegment(P0, P1, 3/8);
			
			// calculates control point 2
			var Pc_2:Object = getPointOnSegment(PA, PB, 3/8);
			Pc_2.x -= dx;
			Pc_2.y -= dy;
			
			// calculates control point 3
			var Pc_3:Object = getPointOnSegment(PB, PA, 3/8);
			Pc_3.x += dx;
			Pc_3.y += dy;
			
			// calculates control point 4
			var Pc_4:Object = getPointOnSegment(P3, P2, 3/8);
			
			// calculates the 3 anchor points
			var Pa_1:Object = getMiddle(Pc_1, Pc_2);
			var Pa_2:Object = getMiddle(PA, PB);
			var Pa_3:Object = getMiddle(Pc_3, Pc_4);
			
			// draw the four quadratic subsegments
			return ([{cx:Pc_1.x, cy:Pc_1.y, ax:Pa_1.x, ay:Pa_1.y},
					{cx:Pc_2.x, cy:Pc_2.y, ax:Pa_2.x, ay:Pa_2.y},
					{cx:Pc_3.x, cy:Pc_3.y, ax:Pa_3.x, ay:Pa_3.y},
					{cx:Pc_4.x, cy:Pc_4.y, ax:P3.x, ay:P3.y}]);
						
		}
			
		static public function getMiddle(P0:Object, P1:Object):Object
		{
			/* A portion of code from Bezier_lib.as by Timothee Groleau */
			return {x: ((P0.x + P1.x) / 2), y: ((P0.y + P1.y) / 2)};
		}	
		
		static public function getPointOnSegment(P0:Object, P1:Object, ratio:Number):Object 
		{
			/* A portion of code from Bezier_lib.as by Timothee Groleau */
			return {x: (P0.x + ((P1.x - P0.x) * ratio)), y: (P0.y + ((P1.y - P0.y) * ratio))};
		}
		
		public function ellipticalArcToCurves(xRadius:Number, yRadius:Number, arc:Number, startAngle:Number, x:Number, y:Number, curves:Array):Object
		{
			/* Portions of code taken from drawArc.as by Ric Ewing */
			if (Math.abs(arc)>360) {
				arc = 360;
			}
			// Flash uses 8 segments per circle, to match that, we draw in a maximum
			// of 45 degree segments. First we calculate how many segments are needed
			// for our arc. 
			var segs:Number = Math.ceil(Math.abs(arc)/45);
			// Now calculate the sweep of each segment
			var segAngle:Number = arc/segs;
			// The math requires radians rather than degrees. To convert from degrees
			// use the formula (degrees/180)*Math.PI to get radians. 
			var theta:Number = -(segAngle/180)*Math.PI;
			// convert angle startAngle to radians
			var angle:Number = -(startAngle/180)*Math.PI;
			// find our starting points (ax,ay) relative to the secified x,y
			var ax:Number = x-Math.cos(angle)*xRadius;
			var ay:Number = y-Math.sin(angle)*yRadius;
			// if our arc is larger than 45 degrees, draw as 45 degree segments
			// so that we match Flash's native circle routines.
			if (segs>0) {
				// Loop for drawing arc segments
				for (var i:int = 0; i<segs; i++) {
					// increment our angle
					angle += theta;
					// find the angle halfway between the last angle and the new
					var angleMid:Number = angle-(theta/2);
					// calculate our end point
					var bx:Number = ax+Math.cos(angle)*xRadius;
					var by:Number = ay+Math.sin(angle)*yRadius;
					// calculate our control point
					var cx:Number = ax+Math.cos(angleMid)*(xRadius/Math.cos(theta/2));
					var cy:Number = ay+Math.sin(angleMid)*(yRadius/Math.cos(theta/2));
					// draw the arc segment
					curves.push({cx:cx, cy:cy, ax:bx, ay:by});
				}
			}
			// In the native draw methods the user must specify the end point
			// which means that they always know where they are ending at, but
			// here the endpoint is unknown unless the user calculates it on their 
			// own. Lets be nice and let save them the hassle by passing it back. 
			return {x:bx, y:by};
		}		
	}
}