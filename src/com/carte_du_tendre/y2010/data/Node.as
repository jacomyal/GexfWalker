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

package com.carte_du_tendre.y2010.data{
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Node extends Sprite{
		
		private var _flex_id:Number;
		private var _gexf_id:String;
		private var _label:String;
		private var _outNeighbours:Vector.<Node>;
		private var _inNeighbours:Vector.<Node>;
		
		private var _labelField:TextField;
		private var _upperCircle:Sprite;
		
		public function Node(newFlexId:int,newGexfId:String,newLabel:String){
			_flex_id = newFlexId;
			_gexf_id = newGexfId;
			_label = newLabel;
			
			_outNeighbours = new Vector.<Node>();
			_inNeighbours = new Vector.<Node>();
			_labelField = new TextField();
			_upperCircle = new Sprite();
			
			this.hitArea = _upperCircle;
			
			draw();
		}
		
		private function draw():void{
			var format:TextFormat = new TextFormat("Verdana",12);
			var circleHitArea:Sprite = new Sprite;
			
			with(_labelField){
				text = _label;
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
		
		public function addInLink(node:Node):void{
			_inNeighbours.push(node);
		}
		
		public function addOutLink(node:Node):void{
			_outNeighbours.push(node);
		}
		
		public function get gexf_id():String{
			return _gexf_id;
		}
		
		public function set gexf_id(value:String):void{
			_gexf_id = value;
		}
		
		public function get flex_id():Number{
			return _flex_id;
		}
		
		public function set flex_id(value:Number):void{
			_flex_id = value;
		}
		
		public function get label():String{
			return _label;
		}
		
		public function set label(value:String):void{
			_label = value;
		}
		
		public function get outNeighbours():Vector.<Node>{
			return _outNeighbours;
		}
		
		public function set outNeighbours(value:Vector.<Node>):void{
			_outNeighbours = value;
		}
		
		public function get inNeighbours():Vector.<Node>{
			return _inNeighbours;
		}
		
		public function set inNeighbours(value:Vector.<Node>):void{
			_inNeighbours = value;
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
		
	}
}