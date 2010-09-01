/*
# Copyright (c) 2010 Alexis Jacomy <alexis.jacomy@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
*/

package com.carte_du_tendre.y2010.display{
	
	import com.carte_du_tendre.y2010.data.Node;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class DisplayNode extends Sprite{
		
		public static const NODES_SCALE:Number = 1;
		public static const NODES_SCALE_LOCAL:Number = 15;
		
		private var _labelField:TextField;
		private var _upperCircle:Sprite;
		private var _size:Number;
		private var _step:Array; // step := (x_step,y_step)
		private var _node:Node;
		
		public function DisplayNode(node:Node,new_x:Number,new_y:Number){
			_labelField = new TextField();
			_upperCircle = new Sprite();
			_step = new Array();
			_node = node;
			
			x = new_x;
			y = new_y;
			_size = NODES_SCALE*_node.size;
			
			this.hitArea = _upperCircle;
			
			draw();
		}

		public function draw():void{
			var format:TextFormat = new TextFormat("Verdana",12*_size/10,brightenColor(_node.color,15));
			var circleHitArea:Sprite = new Sprite;
			
			with(_labelField){
				text = _node.label;
				selectable = false;
				setTextFormat(format);
				autoSize = TextFieldAutoSize.CENTER;
			}
			_labelField.x = this.x - _labelField.width/2;
			_labelField.y = this.y - _labelField.height/2;
			
			this.graphics.clear();
			this.graphics.beginFill(_node.color,1);
			this.graphics.lineStyle(0,0,0);
			switch(_node.type.toLowerCase()){
				case "square":
					this.graphics.drawRect(-Math.sqrt(2)*_size,-Math.sqrt(2)*_size,_size,_size);
					break;
				case "hexagon":
					drawPoly(_size,6,0,0,this.graphics);
					break;
				case "triangle":
					drawPoly(_size,3,0,0,this.graphics);
					break;
				default:
					this.graphics.drawCircle(0,0,_size);
					break;
			}
			this.graphics.endFill();
			
			_upperCircle.graphics.clear();
			_upperCircle.graphics.beginFill(_node.color,0);
			_upperCircle.graphics.lineStyle(0,0,0);
			switch(_node.type.toLowerCase()){
				case "square":
					_upperCircle.graphics.drawRect(-Math.sqrt(2)*_size,-Math.sqrt(2)*_size,_size,_size);
					break;
				case "hexagon":
					drawPoly(_size,6,0,0,_upperCircle.graphics);
					break;
				case "triangle":
					drawPoly(_size,3,0,0,_upperCircle.graphics);
					break;
				default:
					_upperCircle.graphics.drawCircle(0,0,_size);
					break;
			}
			_upperCircle.graphics.endFill();
			
			_upperCircle.x = this.x;
			_upperCircle.y = this.y;
		}
		
		public function moveTo(new_x:Number,new_y:Number):void{
			x = new_x;
			y = new_y;
			
			_upperCircle.x = new_x;
			_upperCircle.y = new_y;
			
			_labelField.x = new_x - _labelField.width/2;
			_labelField.y = new_y - _labelField.height/2;
		}
		
		public function setStep(goal_x:Number,goal_y:Number,stepsNumber:int):void{
			step[0] = (goal_x-this.x)/stepsNumber;
			step[1] = (goal_y-this.y)/stepsNumber;
		}
		
		public function whenMouseOver():void{
			/*with(this.graphics){
				clear();
				lineStyle(_size/4,brightenColor(_node.color,40));
				beginFill(_node.color,1);
				drawCircle(0,0,_size);
				endFill();
			}*/
			
			this.graphics.clear();
			this.graphics.beginFill(brightenColor(_node.color,85),1);
			this.graphics.drawRoundRect(-_labelField.width/2,-_labelField.height/2,_labelField.width,_labelField.height,10,10);
			this.graphics.endFill();
		}
			
		public function whenMouseOut():void{
			this.graphics.clear();
			this.graphics.beginFill(_node.color,1);
			this.graphics.lineStyle(0,0,0);
			switch(_node.type.toLowerCase()){
				case "square":
					this.graphics.drawRect(-Math.sqrt(2)*_size,-Math.sqrt(2)*_size,_size,_size);
					break;
				case "hexagon":
					drawPoly(_size,6,0,0,this.graphics);
					break;
				case "triangle":
					drawPoly(_size,3,0,0,this.graphics);
					break;
				default:
					this.graphics.drawCircle(0,0,_size);
					break;
			}
			this.graphics.endFill();
		}
		
		/**
		 * Makes a uint color become brigther or darker, depending of the parameter.
		 * If the <code>perc</code> parameter is above 50, it will brighten the color.
		 * If the parameter is below 50, it will darken it.
		 * 
		 * @param color Original color value, such as 0x88AACC.
		 * @param perc Value between 0 and 100 to modify original color.
		 * @return New color value (still such as 0x113355)
		 * 
		 * @author Martin Legris
		 * @see http://blog.martinlegris.com
		 */
		protected function brightenColor(color:Number, perc:Number):Number{
			var factor:Number;
			var blueOffset:Number = color % 256;
			var greenOffset:Number = ( color >> 8 ) % 256;
			var redOffset:Number = ( color >> 16 ) % 256;
			
			if(perc > 50 && perc <= 100) {
				factor = ( ( perc-50 ) / 50 );
				
				redOffset += ( 255 - redOffset ) * factor;
				blueOffset += ( 255 - blueOffset ) * factor;
				greenOffset += ( 255 - greenOffset ) * factor;
			}
			else if( perc < 50 && perc >= 0 ){
				factor = ( ( 50 - perc ) / 50 );
				
				redOffset -= redOffset * factor;
				blueOffset -= blueOffset * factor;
				greenOffset -= greenOffset * factor;
			}
			
			return (redOffset<<16|greenOffset<<8|blueOffset);
		}
		
		private function drawPoly(r:int,seg:int,cx:Number,cy:Number,container:Graphics):void{
			var poly_id:int = 0;
			var coords:Array = new Array();
			var ratio:Number = 360/seg;
			
			for(var i:int=0;i<=360;i+=ratio){
				var px:Number=cx+Math.sin(radians(i))*r;
				var py:Number=cy+Math.cos(radians(i))*r;
				coords[poly_id]=new Array(px,py);
				
				if(poly_id>=1){
					container.lineTo(coords[poly_id][0],coords[poly_id][1]);
				}else{
					container.moveTo(coords[poly_id][0],coords[poly_id][1]);
				}
				
				poly_id++;
			}
			
			poly_id=0;
		}
		
		//degrees2radians
		private function radians(n:Number):Number{
			return(Math.PI/180*n);
		}
		
		public function get upperCircle():Sprite{
			return _upperCircle;
		}
		
		public function set upperCircle(value:Sprite):void{
			_upperCircle = value;
		}
		
		public function get labelField():TextField{
			return _labelField;
		}
		
		public function set labelField(value:TextField):void{
			_labelField = value;
		}
		
		public function get node():Node{
			return _node;
		}
		
		public function set node(value:Node):void{
			_node = value;
		}
		
		public function get step():Array{
			return _step;
		}
		
		public function set step(value:Array):void{
			_step = value;
		}
		
		public function get size():Number{
			return _size;
		}
		
		public function set size(value:Number):void{
			_size = value;
		}
	}
}