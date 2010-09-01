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
	import flash.display.Stage;
	
	public class Graph{
		
		private var _nodes:Vector.<Node>;
		private var _attributes:HashMap;
		private var _defaultEdgeType:String;
		private var _metaData:String;
		private var _backgroundX:Number;
		private var _backgroundY:Number;
		private var _backgroundXRatio:Number;
		private var _backgroundYRatio:Number;
		
		private var _isAttributesHashNull:Boolean;
		private var _isMetaDataHashNull:Boolean;
		
		public function Graph(){
			_nodes = new Vector.<Node>();
			_attributes = new HashMap();
			
			_metaData = "";
			_isAttributesHashNull = true;
			_isMetaDataHashNull = true;
			
			_backgroundXRatio = undefined;
			_backgroundYRatio = undefined;
			_backgroundX = undefined;
			_backgroundY = undefined;
			
			_defaultEdgeType = 'directed';
		}

		public function getNode(nodeGexfId:String):Node{
			var i:int = 0;
			var l:int = nodes.length;
			var res:Node = null;
			
			while(i<l){
				if(nodes[i].gexf_id==nodeGexfId){
					res = nodes[i];
					break;
				}
				i++;
			}
			
			return res;
		}
		
		public function getNodeByLabel(nodeLabel:String):Node{
			var i:int = 0;
			var l:int = nodes.length;
			var res:Node = null;
			
			while(i<l){
				if(nodes[i].label==nodeLabel){
					res = nodes[i];
					break;
				}
				i++;
			}
			
			return res;
		}
		
		public function resize(stage:Stage):void{
			var sizeMin:Number = _nodes[0].size;
			var sizeMax:Number = _nodes[0].size;
			
			for (var i:Number = 1;i<_nodes.length;i++){
				if(_nodes[i].size < sizeMin)
					sizeMin = _nodes[i].size;
				if(_nodes[i].size > sizeMax)
					sizeMax = _nodes[i].size;
			}
			
			var a:Number = (Math.min(stage.stageWidth,stage.stageHeight)/2/Math.sqrt(_nodes.length))/(sizeMax-sizeMin+0.001);
			var b:Number = Math.min(stage.stageWidth,stage.stageHeight)/4/Math.sqrt(_nodes.length)*5/2-a*sizeMax;
			
			for (i = 0;i<_nodes.length;i++){
				_nodes[i].setSize(a*_nodes[i].size+b);
			}
		}
		
		public function center():void{
			var xMin:Number = _nodes[0].x;
			var xMax:Number = _nodes[0].x;
			var yMin:Number = _nodes[0].y;
			var yMax:Number = _nodes[0].y;
			var ratio:Number;
			
			for (var i:Number = 1;i<_nodes.length;i++){
				if(_nodes[i].x < xMin)
					xMin = _nodes[i].x;
				if(_nodes[i].x > xMax)
					xMax = _nodes[i].x;
				if(_nodes[i].y < yMin)
					yMin = _nodes[i].y;
				if(_nodes[i].y > yMax)
					yMax = _nodes[i].y;
			}
			
			var xCenter:Number = (xMax + xMin)/2;
			var yCenter:Number = (yMax + yMin)/2;
			
			for (i = 0;i<_nodes.length;i++){
				_nodes[i].x = _nodes[i].x-xCenter;
				_nodes[i].y = _nodes[i].y-yCenter;
			}
		}
		
		/**
		 * Returns key of parameter attribute.
		 * 
		 * @param s A string ID
		 * @return An attribute ID
		 */
		public function getAttributeKey(s:String):String {
			return _attributes.getKey(s);
		}
		
		/**
		 * Returns value of parameter attribute.
		 * 
		 * @param s A string ID
		 * @return An attribute ID
		 */
		public function getAttribute(s:String):String {
			return _attributes.getValue(s);
		}
		
		/**
		 * Sets an attribute.
		 * 
		 * @param attributeID The ID of this attribute.
		 * @param attributeName The name of the attribute.
		 */
		public function setAttribute(attributeID:String,attributeName:String):void{
			if(_isAttributesHashNull){
				_attributes = new HashMap();
				_isAttributesHashNull = false;
			}
			
			_attributes.put(attributeID,attributeName);
		}
		
		/**
		 * Sets attributes as null.
		 */
		public function setAttributesNull():void{
			_attributes = null;
		}
		
		public function addNode(node:Node):void{
			_nodes.push(node);
		}
		
		public function get nodes():Vector.<Node>{
			return _nodes;
		}
		
		public function set nodes(value:Vector.<Node>):void{
			_nodes = value;
		}
		
		public function get attributes():HashMap{
			return _attributes;
		}
		
		public function set attributes(value:HashMap):void{
			_attributes = value;
		}
		
		public function get metaData():String{
			return _metaData;
		}
		
		public function set metaData(value:String):void{
			_metaData = value;
		}
		
		public function get isMetaDataHashNull():Boolean{
			return _isMetaDataHashNull;
		}
		
		public function set isMetaDataHashNull(value:Boolean):void{
			_isMetaDataHashNull = value;
		}
		
		public function get isAttributesHashNull():Boolean{
			return _isAttributesHashNull;
		}
		
		public function set isAttributesHashNull(value:Boolean):void{
			_isAttributesHashNull = value;
		}
		
		public function get backgroundYRatio():Number{
			return _backgroundYRatio;
		}
		
		public function set backgroundYRatio(value:Number):void{
			_backgroundYRatio = value;
		}
		
		public function get backgroundXRatio():Number{
			return _backgroundXRatio;
		}
		
		public function set backgroundXRatio(value:Number):void{
			_backgroundXRatio = value;
		}
		
		public function get backgroundY():Number{
			return _backgroundY;
		}
		
		public function set backgroundY(value:Number):void{
			_backgroundY = value;
		}
		
		public function get backgroundX():Number{
			return _backgroundX;
		}
		
		public function set backgroundX(value:Number):void{
			_backgroundX = value;
		}
		
		public function get defaultEdgeType():String{
			return _defaultEdgeType;
		}
		
		public function set defaultEdgeType(value:String):void{
			_defaultEdgeType = value;
		}
	}
}