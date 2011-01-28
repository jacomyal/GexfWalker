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
	
	public class Node{
		
		private var _x:Number;
		private var _y:Number;
		private var _size:Number;
		private var _color:uint;
		private var _type:String;
		private var _flex_id:Number;
		private var _gexf_id:String;
		private var _label:String;
		private var _outNeighbours:Vector.<Node>;
		private var _inNeighbours:Vector.<Node>;
		
		private var _attributes:HashMap;
		private var _isHashNull:Boolean;
		
		public function Node(newFlexId:int,newGexfId:String,newLabel:String){
			_flex_id = newFlexId;
			_gexf_id = newGexfId;
			_label = newLabel;
			_type = "ellipse";
			
			_outNeighbours = new Vector.<Node>();
			_inNeighbours = new Vector.<Node>();
			
			_isHashNull = true;
			
			_color = 0x888888;
		}

		public function addInLink(node:Node):void{
			_inNeighbours.push(node);
		}
		
		public function addOutLink(node:Node):void{
			_outNeighbours.push(node);
		}
		
		/**
		 * Pushes an attribute.
		 * 
		 * @param attribute The ID of the attribute.
		 * @param attributeID The value of this attribute.
		 */
		public function setAttribute(attributeID:String,attributeValue:String):void{
			if(_isHashNull){
				_attributes = new HashMap();
				_isHashNull = false;
			}
			
			_attributes.put(attributeID,attributeValue);
		}
		
		/**
		 * Returns this node attributes.
		 * 
		 * @return This node attributes hash tab
		 */
		public function getAttributes():HashMap{
			return _attributes;
		}
		
		public function setSize(newSize:Number):void{
			_size = newSize;
		}
		
		/**
		 * Sets this node color, from three <code>Number</code> value (B, G, R) into a <code>uint</code> value.
		 * 
		 * @param B Blue value, between 0 and 255
		 * @param G Green value, between 0 and 255
		 * @param R Red value, between 0 and 255
		 * @see #decaToHexa
		 */
		public function setColor(B:String,G:String,R:String):void{
			var tempColor:String ="0x"+decaToHexa(R)+decaToHexa(G)+decaToHexa(B);
			_color = new uint(tempColor);
		}
		
		/**
		 * Transforms a decimal value (int formated) into an hexadecimal value.
		 * Is only useful with the other function, decaToHexa.
		 * 
		 * @param d int formated decimal value
		 * @return Hexadecimal string translation of d
		 * 
		 * @author Ammon Lauritzen
		 * @see http://goflashgo.wordpress.com/
		 * @see #decaToHexa
		 */
		private function decaToHexaFromInt(d:int):String{
			var c:Array = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];
			if(d>255) d = 255;
			var l:int = d/16;
			var r:int = d%16;
			return c[l]+c[r];
		}
		
		/**
		 * Transforms a decimal value (string formated) into an hexadecimal value.
		 * Really helpfull to adapt the RGB gexf color format in AS3 uint format.
		 * 
		 * @param dec String formated decimal value
		 * @return Hexadecimal string translation of dec
		 * 
		 * @author Ammon Lauritzen
		 * @see http://goflashgo.wordpress.com/
		 */
		private function decaToHexa(dec:String):String {
			var hex:String = "";
			var bytes:Array = dec.split(" ");
			for( var i:int = 0; i <bytes.length; i++ )
				hex += decaToHexaFromInt( int(bytes[i]) );
			return hex;
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
		
		public function get color():uint{
			return _color;
		}
		
		public function set color(value:uint):void{
			_color = value;
		}
		
		public function get size():Number{
			return _size;
		}
		
		public function set size(value:Number):void{
			_size = value;
		}
		
		public function get attributes():HashMap{
			return _attributes;
		}
		
		public function set attributes(value:HashMap):void{
			_attributes = value;
		}
		
		public function get isHashNull():Boolean{
			return _isHashNull;
		}
		
		public function set isHashNull(value:Boolean):void{
			_isHashNull = value;
		}
		
		public function get y():Number{
			return _y;
		}
		
		public function set y(value:Number):void{
			_y = value;
		}
		
		public function get x():Number{
			return _x;
		}
		
		public function set x(value:Number):void{
			_x = value;
		}
		
		public function get type():String{
			return _type;
		}
		
		public function set type(value:String):void{
			_type = value;
		}
	}
}