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

package com.carte_du_tendre.y2010.ui{
	
	import com.carte_du_tendre.y2010.data.Graph;
	import com.carte_du_tendre.y2010.data.Node;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class DisplayMainElement extends Sprite{
		
		private var _currentSelectedNode:Node;
		private var _graph:Graph;
		
		private var _edgesContainer:Sprite;
		private var _nodesContainer:Sprite;
		private var _labelsContainer:Sprite;
		private var _nodesHitAreaContainer:Sprite;
		
		public function DisplayMainElement(newStage:Stage,newGraph:Graph){
			newStage.addChild(this);
			_graph = newGraph;
			
			_edgesContainer = new Sprite();
			_nodesContainer = new Sprite();
			_labelsContainer = new Sprite();
			_nodesHitAreaContainer = new Sprite();
			
			addChild(_edgesContainer);
			addChild(_nodesContainer);
			addChild(_labelsContainer);
			addChild(_nodesHitAreaContainer);
			
			trace("DisplayMainElement.DisplayMainElement: GUI initiated.");
			
			selectRandomNode();
			drawNodes();
		}
		
		private function drawNodes():void{
			var i:int = 0;
			var a:Array = new Array();
			var l:int = stage.numChildren;
			
			//Remove from the scene every nodes:
			for(i=0;i<l;i++){
				if(stage.getChildAt(l-1-i) is Node){
					stage.removeChildAt(l-1-i);
				}
			}
			
			//Add at the center of the screen the selected node:
			_currentSelectedNode.moveTo(stage.stageWidth/2,stage.stageHeight/2);;
			addNodeAsChild(_currentSelectedNode);
			
			//Add all the neighbours:
			var l1:int = _currentSelectedNode.outNeighbours.length;
			var l2:int = _currentSelectedNode.inNeighbours.length;
			var nodeCursor:Node;
			var temp_x:Number;
			var temp_y:Number;
			var delay:Number = Math.random();
			
			for(i=0;i<l1;i++){
				nodeCursor = _currentSelectedNode.outNeighbours[i];
				temp_x = 100*Math.cos(2*Math.PI*(i/(l1+l2)+delay)) + stage.stageWidth/2;
				temp_y = 100*Math.sin(2*Math.PI*(i/(l1+l2)+delay)) + stage.stageHeight/2;
				nodeCursor.moveTo(temp_x,temp_y);
				addNodeAsChild(nodeCursor);
			}
			
			for(i=0;i<l2;i++){
				nodeCursor = _currentSelectedNode.inNeighbours[i];
				temp_x = 100*Math.cos(2*Math.PI*((l1+i)/(l1+l2)+delay)) + stage.stageWidth/2;
				temp_y = 100*Math.sin(2*Math.PI*((l1+i)/(l1+l2)+delay)) + stage.stageHeight/2;
				nodeCursor.moveTo(temp_x,temp_y);
				addNodeAsChild(nodeCursor);
			}
		}
		
		private function selectRandomNode():void{
			var l:int = _graph.nodes.length;
			var index:int = Math.floor(Math.random()*l);
			_currentSelectedNode = _graph.nodes[index];
		}
		
		private function addNodeAsChild(node:Node):void{
			_nodesContainer.addChild(node);
			_labelsContainer.addChild(node.labelField);
			_nodesHitAreaContainer.addChild(node.upperCircle);
		}
		
		private function removeNodeAsChild(node:Node):void{
			_nodesContainer.removeChild(node);
			_labelsContainer.removeChild(node.labelField);
			_nodesHitAreaContainer.removeChild(node.upperCircle);
		}
		
		public function get currentSelectedNode():Node{
			return _currentSelectedNode;
		}
		
		public function set currentSelectedNode(value:Node):void{
			_currentSelectedNode = value;
		}
		
		public function get graph():Graph{
			return _graph;
		}
		
		public function set graph(value:Graph):void{
			_graph = value;
		}
		
		public function get labelsContainer():Sprite{
			return _labelsContainer;
		}
		
		public function set labelsContainer(value:Sprite):void{
			_labelsContainer = value;
		}
		
		public function get edgesContainer():Sprite{
			return _edgesContainer;
		}
		
		public function set edgesContainer(value:Sprite):void{
			_edgesContainer = value;
		}
		
		public function get nodesContainer():Sprite{
			return _nodesContainer;
		}
		
		public function set nodesContainer(value:Sprite):void{
			_nodesContainer = value;
		}
		
	}
}