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

	public class Node extends Sprite{
		
		private var _flex_id:Number;
		private var _gexf_id:String;
		private var _label:String;
		private var _outNeighbours:Vector.<Node>;
		private var _inNeighbours:Vector.<Node>;
		
		public function Node(newFlexId:int,newGexfId:String,newLabel:String){
			_flex_id = newFlexId;
			_gexf_id = newGexfId;
			_label = newLabel;
			_outNeighbours = new Vector.<Node>();
			_inNeighbours = new Vector.<Node>();
			
			draw();
		}
		
		public function addInLink(node:Node):void{
			_inNeighbours.push(node);
		}
		
		public function addOutLink(node:Node):void{
			_outNeighbours.push(node);
		}
		
		private function draw():void{
			var labelField:TextField = new TextField();
			
			with(labelField){
				text = _label;
				autoSize = TextFieldAutoSize.CENTER;
				selectable = false;
			}
			
			with(this.graphics){
				beginFill(0x808080,1);
				drawCircle(0,0,30);
				endFill();
			}
			
			addChild(labelField);
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
		
	}
}