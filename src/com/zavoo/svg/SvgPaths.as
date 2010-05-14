package com.zavoo.svg
{	
	import com.zavoo.svg.SvgPath;
	
	import flash.display.Graphics;
	
	public class SvgPaths
	{
		public var paths:Array = new Array();
		
		public function SvgPaths(svgData:String)
		{
			var pathTagRE:RegExp = /(<path.*?\/>)/sig;
		    var pathArray:Array;
		    while(pathArray = pathTagRE.exec(svgData))
		    {
		    	paths.push(new SvgPath(pathArray[1]));						    		
		    }
		}
		
		public function drawToGraphics(g:Graphics, scale:Number = 1, offsetX:Number = 0, offsetY:Number = 0):void	
		{
			g.clear();
			for each(var path:SvgPath in paths)
			{
				g.beginFill(path.fill,path.fillAlpha);
				g.lineStyle(path.strokeWidth,path.stroke,path.strokeAlpha);
	
				for each(var line:Array in path.d)
				{
					switch(line[0])
					{
						case "M":
							g.moveTo(Number(line[1][0]) * scale + offsetX, Number(line[1][1]) * scale + offsetY);
							break;
							
						case "L":
							g.lineTo(Number(line[1][0]) * scale + offsetX, Number(line[1][1]) * scale + offsetY);
							break;
							
						case "C":
							g.curveTo(Number(line[1][0]) * scale + offsetX, Number(line[1][1]) * scale + offsetY, 
								Number(line[1][2]) * scale + offsetX, Number(line[1][3]) * scale + offsetY);
							break;
					}
				}
				g.endFill();
			}
		}
	}
}