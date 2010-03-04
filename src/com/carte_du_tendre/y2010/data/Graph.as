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
	
	public class Graph{
		
		private var _nodes:Vector.<Node>;
		private var _attributes:HashMap;
		private var _metaData:HashMap;
		
		public function Graph(){
			nodes = new Vector.<Node>();
			_attributes = new HashMap();
			_metaData = new HashMap();
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
		 * Returns true if attributes is null, false else.
		 * 
		 * @return The boolean result of this test.
		 */
		public function isAttributeHashNull():Boolean {
			return (_attributes==null);
		}
		
		/**
		 * Returns key of parameter meta data.
		 * 
		 * @param s A string ID
		 * @return An attribute ID
		 */
		public function getMetaDataKey(s:String):String {
			return _metaData.getKey(s);
		}
		
		/**
		 * Returns value of parameter meta data.
		 * 
		 * @param s A string ID
		 * @return An attribute ID
		 */
		public function getMetaData(s:String):String {
			return _metaData.getValue(s);
		}
		
		/**
		 * Returns true if meta data hash is null, false else.
		 * 
		 * @return The boolean result of this test.
		 */
		public function isMetaDataHashNull():Boolean {
			return (_metaData==null);
		}
		
		/**
		 * Sets an attribute.
		 * 
		 * @param attributeID The ID of this attribute.
		 * @param attributeName The name of the attribute.
		 */
		public function setAttribute(attributeID:String,attributeName:String):void{
			attributes.put(attributeID,attributeName);
		}
		
		/**
		 * Sets attributes as null.
		 */
		public function setAttributesNull():void{
			attributes = null;
		}
		
		public function addNode(node:Node):void{
			nodes.push(node);
		}
		
		public function get nodes():Vector.<Node>{
			return _nodes;
		}
		
		public function set nodes(value:Vector.<Node>):void{
			_nodes = value;
		}
		
		public function get attributes():HashMap
		{
			return _attributes;
		}
		
		public function set attributes(value:HashMap):void
		{
			_attributes = value;
		}
		
		public function get metaData():HashMap
		{
			return _metaData;
		}
		
		public function set metaData(value:HashMap):void
		{
			_metaData = value;
		}
	}
}