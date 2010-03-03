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
	import com.carte_du_tendre.y2010.display.DisplayNode;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	public class DisplayMainElement extends Sprite{
		
		private var _currentDisplayedNodes:Vector.<DisplayNode>;
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
			var graphicSelectedNode:DisplayNode = new DisplayNode(_currentSelectedNode);
			
			_currentDisplayedNodes = new Vector.<DisplayNode>();
			_currentDisplayedNodes.push(graphicSelectedNode);
			
			//Remove from the scene every nodes:
			removeDisplayedNodes();
			
			//Add at the center of the screen the selected node:
			graphicSelectedNode.moveTo(stage.stageWidth/2,stage.stageHeight/2);;
			addNodeAsChild(graphicSelectedNode);
			
			//Add all the neighbours:
			var l1:int = _currentSelectedNode.outNeighbours.length;
			var l2:int = _currentSelectedNode.inNeighbours.length;
			
			var nodeCursor:Node;
			var displayNode:DisplayNode;
			
			var temp_x:Number;
			var temp_y:Number;
			var delay:Number = Math.random();
			
			for(i=0;i<l1;i++){
				nodeCursor = _currentSelectedNode.outNeighbours[i];
				displayNode = new DisplayNode(nodeCursor);
				_currentDisplayedNodes.push(displayNode);
				
				temp_x = 100*Math.cos(2*Math.PI*(i/(l1+l2)+delay)) + stage.stageWidth/2;
				temp_y = 100*Math.sin(2*Math.PI*(i/(l1+l2)+delay)) + stage.stageHeight/2;
				displayNode.moveTo(temp_x,temp_y);
				addNodeAsChild(displayNode);
				
				displayNode.upperCircle.addEventListener(MouseEvent.CLICK,whenClickANeighbour);
			}
			
			for(i=0;i<l2;i++){
				nodeCursor = _currentSelectedNode.inNeighbours[i];
				displayNode = new DisplayNode(nodeCursor);
				_currentDisplayedNodes.push(displayNode);
				
				temp_x = 100*Math.cos(2*Math.PI*((l1+i)/(l1+l2)+delay)) + stage.stageWidth/2;
				temp_y = 100*Math.sin(2*Math.PI*((l1+i)/(l1+l2)+delay)) + stage.stageHeight/2;
				displayNode.moveTo(temp_x,temp_y);
				addNodeAsChild(displayNode);
				
				displayNode.upperCircle.addEventListener(MouseEvent.CLICK,whenClickANeighbour);
			}
		}
		
		private function selectRandomNode():void{
			var l:int = _graph.nodes.length;
			var index:int = Math.floor(Math.random()*l);
			_currentSelectedNode = _graph.nodes[index];
		}
		
		private function addNodeAsChild(displayNode:DisplayNode):void{
			_nodesContainer.addChild(displayNode);
			_labelsContainer.addChild(displayNode.labelField);
			_nodesHitAreaContainer.addChild(displayNode.upperCircle);
		}
		
		private function removeNodeAsChild(displayNode:DisplayNode):void{
			_nodesContainer.removeChild(displayNode);
			_labelsContainer.removeChild(displayNode.labelField);
			_nodesHitAreaContainer.removeChild(displayNode.upperCircle);
		}
		
		public function whenClickANeighbour(e:MouseEvent):void{
			var l:int = _currentDisplayedNodes.length;
			var node:Node;
			var i:int;
			
			for(i=0;i<l;i++){
				if(_currentDisplayedNodes[i].upperCircle == e.target){
					node = _currentDisplayedNodes[i].node;
					break;
				}
			}
			
			trace("DisplayMainElement.whenClickANeighbour: New selected node.");
			
			_currentDisplayedNodes = new Vector.<DisplayNode>();
			_currentSelectedNode = node;
			drawNodes();
		}
		
		private function removeDisplayedNodes():void{
			var l:int;
			var i:int;
			
			//Remove first the nodes themselves:
			l = _nodesContainer.numChildren;
			for(i=0;i<l;i++){
				_nodesContainer.removeChildAt(l-1-i);
			}
			
			//Remove secondly the edges:
			l = _edgesContainer.numChildren;
			for(i=0;i<l;i++){
				_edgesContainer.removeChildAt(l-1-i);
			}
			
			//Remove next the labels:
			l = _labelsContainer.numChildren;
			for(i=0;i<l;i++){
				_labelsContainer.removeChildAt(l-1-i);
			}
			
			//Remove finally the hit areas:
			l = _nodesHitAreaContainer.numChildren;
			for(i=0;i<l;i++){
				_nodesHitAreaContainer.removeChildAt(l-1-i);
			}
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
		
		public function get currentDisplayedNodes():Vector.<DisplayNode>
		{
			return _currentDisplayedNodes;
		}
		
		public function set currentDisplayedNodes(value:Vector.<DisplayNode>):void
		{
			_currentDisplayedNodes = value;
		}
		
	}
}