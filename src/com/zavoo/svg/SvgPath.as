package com.zavoo.svg
{	
	import com.zavoo.svg.SvgMath;
	
	public class SvgPath
	{
		public var fill:uint = 0x000000;
		public var fillAlpha:Number = 0;
		public var stroke:uint = 0x000000;
		public var strokeAlpha:Number = 0;
		public var strokeWidth:Number = 0.25;		
		
		public var d:Array;
		
		
		
		public function SvgPath(pathData:String)
		{			
			var fields:Object = parsePath(pathData);
			d = fields['d'];
			setFill(fields);
			setStroke(fields);
			if ((fillAlpha == 0) && (strokeAlpha == 0))
			{
				fillAlpha = 1;
			}
		}
		
		public function parsePath(path:String):Object
		{
			var fields:Object = new Object;
			var fieldRE:RegExp = /\s+(\S+)=["'](.*?)["']/sg;
			
			var fieldArray:Array;
			while(fieldArray = fieldRE.exec(path))
			{
				if (fieldArray[1] == "style")
				{
					var styles:Array = fieldArray[2].split(';');
					for each (var style:String in styles)
					{
						var styleArray:Array = style.split(':',2);
						fields[styleArray[0]] = styleArray[1];
					}					
				}
				else if (fieldArray[1] == "d")
				{
					fields[fieldArray[1]] = createPathArray(splitPathElements(fieldArray[2]));
				}
				else
				{
					fields[fieldArray[1]] = fieldArray[2];
				}
			}
			
			return fields;
		}
		
		public function splitPathElements(elements:String):Array
		{
			elements = elements.replace(/(M)/si,"$1,");
			
			elements = elements.replace(/([ACSLHVQT])/sig,",$1,");
		
			elements = elements.replace(/(Z)/si,",$1");
			
			elements = elements.replace(/-/sg,",-");
			
			elements = elements.replace(/\s+/sg,",");
			elements = elements.replace(/,{2,}/sg,",");
			
			
			return elements.split(',');
		}	
		
		public function createPathArray(elements:Array):Array
		{
			/* Based on a portion of modified code from PathToArray.as by Helen Triolo */
			var path:Array = new Array();
			
			var i:int;
			
			var cmd:String;
			var qc:Array;
			var firstP:Object;
			var lastP:Object;
			var lastC:Object;
			
			var pos:int = 0;
			
			var cnt:int = 0;
			
			do
			{
				cnt++;
				if (cnt == 18)
				{
					1 == 1;
				}
				cmd = elements[pos++];
				switch(cmd)
				{
					case "M":
						// moveTo point
						firstP = lastP = {x:Number(elements[pos]), y:Number(elements[pos+1])};
						path.push(['M', [firstP.x, firstP.y]]);
						pos += 2;
						if (pos < elements.length && !isNaN(Number(elements[pos]))) {  
							do {
								// if multiple points listed, add the rest as lineTo points
								lastP = {x:Number(elements[pos]), y:Number(elements[pos+1])};
								path.push(['L', [lastP.x, lastP.y]]);
								firstP = lastP;
								pos += 2;
							} while (pos < elements.length && !isNaN(Number(elements[pos])));
						}
						break;
						
					case "l" :
						do {
							lastP = {x:lastP.x+Number(elements[pos]), y:lastP.y+Number(elements[pos+1])};
							path.push(['L', [lastP.x, lastP.y]]);
							firstP = lastP;
							pos += 2;
						} while (pos < elements.length && !isNaN(Number(elements[pos])));
						break;
						
					case "L" :
						do {
							lastP = {x:Number(elements[pos]), y:Number(elements[pos+1])};
							path.push(['L', [lastP.x, lastP.y]]);					
							firstP = lastP;
							pos += 2;
						} while (pos < elements.length && !isNaN(Number(elements[pos])));
						break;
						
					case "h" :
						do {
							lastP = {x:lastP.x+Number(elements[pos]), y:lastP.y};
							path.push(['L', [lastP.x, lastP.y]]);
							firstP = lastP;
							pos += 1;
						} while (pos < elements.length && !isNaN(Number(elements[pos])));
						break;
						
					case "H" :
						do {
							lastP = {x:Number(elements[pos]), y:lastP.y};
							path.push(['L', [lastP.x, lastP.y]]);
							firstP = lastP;
							pos += 1;
						} while (pos < elements.length && !isNaN(Number(elements[pos])));
						break;
						
					case "v" :
						do {
							lastP = {x:lastP.x, y:lastP.y+Number(elements[pos])};
							path.push(['L', [lastP.x, lastP.y]]);
							firstP = lastP;
							pos += 1;
						} while (pos < elements.length && !isNaN(Number(elements[pos])));
						break;
						
					case "V" :
						do {
							lastP = {x:lastP.x, y:Number(elements[pos])};
							path.push(['L', [lastP.x, lastP.y]]);
							firstP = lastP;
							pos += 1;
						} while (pos < elements.length && !isNaN(Number(elements[pos])));
						break;
			
					case "q" :
						do {
							// control is relative to lastP, not lastC
							lastC = {x:lastP.x+Number(elements[pos]), y:lastP.y+Number(elements[pos+1])};
							lastP = {x:lastP.x+Number(elements[pos+2]), y:lastP.y+Number(elements[pos+3])};
							path.push(['C', [lastC.x, lastC.y, lastP.x, lastP.y]]);
							firstP = lastP;
							pos += 4;
						} while (pos < elements.length && !isNaN(Number(elements[pos])));
						break;
						
					case "Q" :
						do {
							lastC = {x:Number(elements[pos]), y:Number(elements[pos+1])};					
							lastP = {x:Number(elements[pos+2]), y:Number(elements[pos+3])};
							path.push(['C', [lastC.x, lastC.y, lastP.x, lastP.y]]);
							firstP = lastP;
							pos += 4;
						} while (pos < elements.length && !isNaN(Number(elements[pos])));
						break;
						
					case "t" :
						do {
							// control is relative to lastP, not lastC
							lastC = {x:lastP.x, y:lastP.y+Number(elements[pos])};
							lastP = {x:lastP.x, y:lastP.y+Number(elements[pos+1])};
							path.push(['C', [lastC.x, lastC.y, lastP.x, lastP.y]]);
							firstP = lastP;
							pos += 2;
						} while (pos < elements.length && !isNaN(Number(elements[pos])));
						break;
						
					case "T" :
						do {
							lastC = {x:lastP.x, y:Number(elements[pos])};					
							lastP = {x:lastP.x, y:Number(elements[pos+1])};
							path.push(['C', [lastC.x, lastC.y, lastP.x, lastP.y]]);
							firstP = lastP;
							pos += 2;
						} while (pos < elements.length && !isNaN(Number(elements[pos])));
						break;						
						
					case "c" :
						do {
							// don't save if c1.x=c1.y=c2.x=c2.y=0 
							if (!Number(elements[pos]) && !Number(elements[pos+1]) && !Number(elements[pos+2]) && !Number(elements[pos+3])) {
							} else {
								qc = SvgMath.cubicBezierToQuadratic({x:lastP.x, y:lastP.y},   
										{x:lastP.x+Number(elements[pos]), y:lastP.y+Number(elements[pos+1])},
										{x:lastP.x+Number(elements[pos+2]), y:lastP.y+Number(elements[pos+3])},
										{x:lastP.x+Number(elements[pos+4]), y:lastP.y+Number(elements[pos+5])});
								for (i=0; i<qc.length; i++) {
									path.push(['C', [qc[i].cx, qc[i].cy, qc[i].ax, qc[i].ay]]);
								}
								lastC = {x:lastP.x+Number(elements[pos+2]), y:lastP.y+Number(elements[pos+3])};
								lastP = {x:lastP.x+Number(elements[pos+4]), y:lastP.y+Number(elements[pos+5])};
								firstP = lastP;
							}
							pos += 6;
						} while (pos < elements.length && !isNaN(Number(elements[pos])));							
						break;
			
					case "C" :
						do {
						// don't save if c1.x=c1.y=c2.x=c2.y=0 
							if (!Number(elements[pos]) && !Number(elements[pos+1]) && !Number(elements[pos+2]) && !Number(elements[pos+3])) {
							} else {
								qc = SvgMath.cubicBezierToQuadratic({x:firstP.x, y:firstP.y},   
										{x:Number(elements[pos]), y:Number(elements[pos+1])},
										{x:Number(elements[pos+2]), y:Number(elements[pos+3])},
										{x:Number(elements[pos+4]), y:Number(elements[pos+5])});
								for (i=0; i<qc.length; i++) {							
									path.push(['C', [qc[i].cx, qc[i].cy, qc[i].ax, qc[i].ay]]);
								}
		
		
								lastC = {x:Number(elements[pos+2]), y:Number(elements[pos+3])};
								lastP = {x:Number(elements[pos+4]), y:Number(elements[pos+5])};
								firstP = lastP;
							}
							pos += 6;
						} while (pos < elements.length && !isNaN(Number(elements[pos])));
						break;
					case "A" :
						/* TO DO: Add Support for elliptical arcs */		
						path.push(['L', [elements[pos+5], elements[pos+6]]]);		
						
						pos += 7;
						break;
					case "a" :
						/* TO DO: Add Support for elliptical arcs */		
						path.push(['L', [lastP.x + elements[pos+5], lastP.y + elements[pos+6]]]);								
						pos += 7;
						break;	
					case "s" :
						// don't save if c1.x=c1.y=c2.x=c2.y=0 
						if (!Number(elements[pos]) && !Number(elements[pos+1]) && !Number(elements[pos+2]) && !Number(elements[pos+3])) {
						} else {
							qc = SvgMath.cubicBezierToQuadratic({x:firstP.x, y:firstP.y},   
								{x:lastP.x + (lastP.x - lastC.x), y:lastP.y + (lastP.y - lastC.y)},
								{x:lastP.x+Number(elements[pos]), y:lastP.y+Number(elements[pos+1])},
								{x:lastP.x+Number(elements[pos+2]), y:lastP.y+Number(elements[pos+3])});
							for (i=0; i<qc.length; i++) {
								path.push(['C', [qc[i].cx, qc[i].cy, qc[i].ax, qc[i].ay]]);
							}
	
							lastC = {x:lastP.x+Number(elements[pos]), y:lastP.y+Number(elements[pos+1])};
							lastP = {x:lastP.x+Number(elements[pos+2]), y:lastP.y+Number(elements[pos+3])};
							firstP = lastP;
						}
						pos += 4;
						break;
						
					case "S" :
						// don't save if c1.x=c1.y=c2.x=c2.y=0 
						if (!Number(elements[pos]) && !Number(elements[pos+1]) && !Number(elements[pos+2]) && !Number(elements[pos+3])) {
						} else {
							qc = SvgMath.cubicBezierToQuadratic({x:firstP.x, y:firstP.y},   
								{x:lastP.x + (lastP.x - lastC.x), y:lastP.y + (lastP.y - lastC.y)},
								{x:Number(elements[pos]), y:Number(elements[pos+1])},
								{x:Number(elements[pos+2]), y:Number(elements[pos+3])});
							for (i=0; i<qc.length; i++) {
								path.push(['C', [qc[i].cx, qc[i].cy, qc[i].ax, qc[i].ay]]);
							}
	
							lastC = {x:Number(elements[pos]), y:Number(elements[pos+1])};
							lastP = {x:Number(elements[pos+2]), y:Number(elements[pos+3])};
							firstP = lastP;
						}
						pos += 4;
						break;
						
					case "z" :
					case "Z" :
						if (firstP.x != lastP.x || firstP.y != lastP.y) {
							path.push(['L', [firstP.x, firstP.y]]);
						}
						pos++;
						break;
				}
			} while(pos < elements.length);
			
			return path;
		}		
		
		public function setFill(fields:Object):void
		{
			var fillVal:String = 'none';
			if (fields.hasOwnProperty('fill'))
			{
				fillVal = fields['fill'];
			}
			if(fillVal.match(/^#/))
			{
				fillVal = fillVal.replace('#', '0x');
				fill = parseInt(fillVal);
				
				if (fillAlpha == 0)
				{	fillAlpha = 1; }
			}
			else if(SvgMath.colors.hasOwnProperty(fillVal))
			{
				fill = SvgMath.colors[fillVal];
				
				if (fillAlpha == 0)
				{	fillAlpha = 1; }
			}
			else
			{
				fill = 0x000000;
				fillAlpha = 0;
			}
			
			if (fields.hasOwnProperty('fill-opacity'))
			{
				fillAlpha = parseFloat(fields['fill-opacity']);
			}
		}
		
		public function setStroke(fields:Object):void
		{
			var fillVal:String = 'none';
			if (fields.hasOwnProperty('stroke'))
			{
				fillVal = fields['stroke'];
			}
			if(fillVal.match(/^#/))
			{
				fillVal = fillVal.replace('#', '0x');
				stroke = parseInt(fillVal);
				
				if (strokeAlpha == 0)
				{	strokeAlpha = 1; }
			}
			else if(SvgMath.colors.hasOwnProperty(fillVal))
			{
				stroke = SvgMath.colors[fillVal];
				
				if (strokeAlpha == 0)
				{	strokeAlpha = 1; }
			}
			else
			{
				stroke = 0x000000;
				strokeAlpha = 0;
			}
			
			if (fields.hasOwnProperty('stroke-opacity'))
			{
				strokeAlpha = parseFloat(fields['stroke-opacity']);
			}
			
			if (fields.hasOwnProperty('stroke-width'))
			{
				strokeWidth = parseFloat(fields['stroke-width']);
			}			
		
		}
		

	}
}