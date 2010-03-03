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
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class DisplayNode extends Sprite{
		
		private var _labelField:TextField;
		private var _upperCircle:Sprite;
		private var _node:Node;
		
		public function DisplayNode(node:Node){
			_labelField = new TextField();
			_upperCircle = new Sprite();
			_node = node;
			
			this.hitArea = _upperCircle;
			
			draw();
		}

		private function draw():void{
			var format:TextFormat = new TextFormat("Verdana",12);
			var circleHitArea:Sprite = new Sprite;
			
			with(_labelField){
				text = _node.label;
				autoSize = TextFieldAutoSize.CENTER;
				selectable = false;
				setTextFormat(format);
			}
			
			with(this.graphics){
				beginFill(0xAAAAAA,1);
				drawCircle(0,0,30);
				endFill();
			}
			
			with(_upperCircle.graphics){
				beginFill(0x000000,0);
				drawCircle(0,0,30);
				endFill();
			}
		}
		
		public function moveTo(new_x:Number,new_y:Number):void{
			x = new_x;
			y = new_y;
			
			_upperCircle.x = new_x;
			_upperCircle.y = new_y;
			
			_labelField.x = new_x - _labelField.width/2;
			_labelField.y = new_y - _labelField.height/2;
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
		
		public function get node():Node
		{
			return _node;
		}
		
		public function set node(value:Node):void
		{
			_node = value;
		}
	}
}