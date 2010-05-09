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
	import com.carte_du_tendre.y2010.display.DisplayAttributes;
	import com.carte_du_tendre.y2010.display.DisplayNode;
	import com.dncompute.graphics.ArrowStyle;
	import com.dncompute.graphics.GraphicsUtil;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class DisplayMainElement extends Sprite{
		
		public static const EDGES_SCALE:Number = 180;
		
		private var _currentSelectionDisplayAttributes:DisplayAttributes;
		private var _currentDisplayedNodes:Vector.<DisplayNode>;
		private var _currentSelectedDisplayNode:DisplayNode;
		private var _currentSelectedNode:Node;
		private var _graph:Graph;
		
		private var _isReady:Boolean;
		private var _angleDelay:Number;
		private var _edgesContainer:Sprite;
		private var _nodesContainer:Sprite;
		private var _labelsContainer:Sprite;
		private var _attributesContainer:Sprite;
		private var _nodesHitAreaContainer:Sprite;
		
		public function DisplayMainElement(newStage:Stage,newGraph:Graph){
			newStage.addChild(this);
			_graph = newGraph;
			_angleDelay = 1/8.5;
			
			_attributesContainer = new Sprite();
			_edgesContainer = new Sprite();
			_nodesContainer = new Sprite();
			_labelsContainer = new Sprite();
			_nodesHitAreaContainer = new Sprite();
			
			_labelsContainer.alpha = 0;
			_isReady = false;
			
			addChild(_attributesContainer);
			addChild(_edgesContainer);
			addChild(_nodesContainer);
			addChild(_labelsContainer);
			addChild(_nodesHitAreaContainer);
			
			trace("DisplayMainElement.DisplayMainElement: GUI initiated.");
			
			selectRandomNode();
			
			drawNodes();
		}

		public function afterSelection():void{
			_labelsContainer.addChild(_currentSelectedDisplayNode.labelField);
			_currentSelectedDisplayNode = null;
			_isReady = false;
			addEventListener(Event.ENTER_FRAME,transitionFirstStep);
		}
		
		private function drawNodes():void{
			var i:int = 0;
			var j:int = 0;
			
			//Value of the FlashVar to know if all the neighbours must be drawn or only the out ones:
			var onlyOuts:Boolean;
			if((root.loaderInfo.parameters["onlyOutNeighbours"]=="true")||(root.loaderInfo.parameters["onlyOutNeighbours"]=="1")) onlyOuts = true;
			else onlyOuts = false;
			
			if(_currentSelectedDisplayNode!=null){
				_labelsContainer.addChild(_currentSelectedDisplayNode.labelField);
			}
			
			_currentSelectedDisplayNode = new DisplayNode(_currentSelectedNode);
			
			_currentDisplayedNodes = new Vector.<DisplayNode>();
			_currentDisplayedNodes.push(_currentSelectedDisplayNode);
			
			//Remove from the scene every nodes:
			removeDisplayedNodes();
			
			//Clear every edges:
			_edgesContainer.graphics.clear();
			
			removeLabelFieldFromStage();
			
			//Add at the center of the screen the selected node:
			_currentSelectedDisplayNode.moveTo(stage.stageWidth/2,stage.stageHeight/2);;
			addNodeAsChild(_currentSelectedDisplayNode);
			this.addChild(_currentSelectedDisplayNode.labelField);
			
			//Add all the neighbours:
			var l1:int = _currentSelectedNode.outNeighbours.length;
			var l2:int = 0;
			var l3:int = 0; //number of common neighbors
			var a_in:Array = [];
			var a_out:Array = [];
			
			var nodeCursor:Node;
			var displayNode:DisplayNode;
			
			var style:ArrowStyle = new ArrowStyle();
			style.headLength = 10;
			style.headWidth = 10;
			style.shaftPosition = 0;
			style.shaftThickness = 4;
			style.edgeControlPosition = 0.5;
			style.edgeControlSize = 0.5;
			
			var temp_x0:Number;
			var temp_y0:Number;
			var temp_x1:Number;
			var temp_y1:Number;
			var temp_x2:Number;
			var temp_y2:Number;
			var temp_x3:Number;
			var temp_y3:Number;
			
			//Attributes of the selected node:
			var a:int = 0;
			if((_graph.isAttributesHashNull!=true)&&(_currentSelectedNode.isHashNull!=true)){
				temp_x0 = (EDGES_SCALE+1*DisplayNode.NODES_SCALE)*Math.cos(2*Math.PI*_angleDelay) + stage.stageWidth/2;
				temp_y0 = (EDGES_SCALE+1*DisplayNode.NODES_SCALE)*Math.sin(2*Math.PI*_angleDelay) + stage.stageHeight/2;
				if(_attributesContainer.numChildren>=1) _attributesContainer.removeChildAt(0);
				_attributesContainer.alpha = 1;
				_currentSelectionDisplayAttributes = new DisplayAttributes(_currentSelectedNode,_graph,_attributesContainer,temp_x0,temp_y0);
				a = 1;
			}
			
			//In and Out Neighbors (recensing):
			if(!onlyOuts){
				l2 = _currentSelectedNode.inNeighbours.length;
				for(i=0;i<l1;i++){
					if(_currentSelectedNode.outNeighbours[i].flex_id!=_currentSelectedNode.flex_id){
						for(j=0;j<l2;j++){
							if(_currentSelectedNode.outNeighbours[i].flex_id == _currentSelectedNode.inNeighbours[j].flex_id){
								nodeCursor = _currentSelectedNode.outNeighbours[i];
								displayNode = new DisplayNode(nodeCursor);
								_currentDisplayedNodes.push(displayNode);
								
								l3++;
							}
						}
					}
				}
			}
			
			//Out neighbors (drawing):
			for(i=0;i<l1;i++){
				if(_currentSelectedNode.outNeighbours[i].flex_id!=_currentSelectedNode.flex_id){
					for(j=0;j<l3;j++){
						if(_currentDisplayedNodes[j+1].node.flex_id == _currentSelectedNode.outNeighbours[i].flex_id){
							a_out.push(i);
						}
					}
					
					if(a_out.indexOf(i)>=0){
						continue;
					}
					
					nodeCursor = _currentSelectedNode.outNeighbours[i];
					displayNode = new DisplayNode(nodeCursor);
					_currentDisplayedNodes.push(displayNode);
					
					temp_x0 = EDGES_SCALE*Math.cos(2*Math.PI*((i-a_out.length+1)/(l1+l2-l3+a)+_angleDelay)) + stage.stageWidth/2;
					temp_y0 = EDGES_SCALE*Math.sin(2*Math.PI*((i-a_out.length+1)/(l1+l2-l3+a)+_angleDelay)) + stage.stageHeight/2;
					displayNode.moveTo(stage.stageWidth/2,stage.stageHeight/2);
					addNodeAsChild(displayNode);
					displayNode.moveToSlowly(temp_x0,temp_y0);
					
					//Draw the edge as an arrow:
					temp_x1 = DisplayNode.NODES_SCALE/EDGES_SCALE*stage.stageWidth/2 + (EDGES_SCALE-DisplayNode.NODES_SCALE)/EDGES_SCALE*temp_x0;
					temp_y1 = DisplayNode.NODES_SCALE/EDGES_SCALE*stage.stageHeight/2 + (EDGES_SCALE-DisplayNode.NODES_SCALE)/EDGES_SCALE*temp_y0;
					
					temp_x2 = (EDGES_SCALE-DisplayNode.NODES_SCALE)/EDGES_SCALE*stage.stageWidth/2 + DisplayNode.NODES_SCALE/EDGES_SCALE*temp_x0;
					temp_y2 = (EDGES_SCALE-DisplayNode.NODES_SCALE)/EDGES_SCALE*stage.stageHeight/2 + DisplayNode.NODES_SCALE/EDGES_SCALE*temp_y0;
					
					_edgesContainer.graphics.lineStyle(1,_currentSelectedNode.color);
					_edgesContainer.graphics.beginFill(_currentSelectedNode.color);
					
					GraphicsUtil.drawArrow(_edgesContainer.graphics,
						new Point(temp_x2,temp_y2),new Point(temp_x1,temp_y1),
						style
					);
					
					_edgesContainer.graphics.endFill();
				}
			}
			
			
			//In neighbors (drawing):
			if(!onlyOuts){
				for(i=0;i<l2;i++){
					if(_currentSelectedNode.inNeighbours[i].flex_id!=_currentSelectedNode.flex_id){
						for(j=0;j<l3;j++){
							if(_currentDisplayedNodes[j+1].node.flex_id == _currentSelectedNode.inNeighbours[i].flex_id){
								a_in.push(i);
							}
						}
						
						if(a_in.indexOf(i)>=0){
							continue;
						}
						
						nodeCursor = _currentSelectedNode.inNeighbours[i];
						displayNode = new DisplayNode(nodeCursor);
						_currentDisplayedNodes.push(displayNode);
						
						temp_x0 = EDGES_SCALE*Math.cos(2*Math.PI*((l1-l3-a_in.length+i+1)/(l1+l2-l3+a)+_angleDelay)) + stage.stageWidth/2;
						temp_y0 = EDGES_SCALE*Math.sin(2*Math.PI*((l1-l3-a_in.length+i+1)/(l1+l2-l3+a)+_angleDelay)) + stage.stageHeight/2;
						displayNode.moveTo(stage.stageWidth/2,stage.stageHeight/2);
						addNodeAsChild(displayNode);
						displayNode.moveToSlowly(temp_x0,temp_y0);
						
						//Draw the edge as an arrow:
						temp_x1 = DisplayNode.NODES_SCALE/EDGES_SCALE*stage.stageWidth/2 + (EDGES_SCALE-DisplayNode.NODES_SCALE)/EDGES_SCALE*temp_x0;
						temp_y1 = DisplayNode.NODES_SCALE/EDGES_SCALE*stage.stageHeight/2 + (EDGES_SCALE-DisplayNode.NODES_SCALE)/EDGES_SCALE*temp_y0;
						
						temp_x2 = (EDGES_SCALE-DisplayNode.NODES_SCALE)/EDGES_SCALE*stage.stageWidth/2 + DisplayNode.NODES_SCALE/EDGES_SCALE*temp_x0;
						temp_y2 = (EDGES_SCALE-DisplayNode.NODES_SCALE)/EDGES_SCALE*stage.stageHeight/2 + DisplayNode.NODES_SCALE/EDGES_SCALE*temp_y0;
						
						_edgesContainer.graphics.lineStyle(1,nodeCursor.color);
						_edgesContainer.graphics.beginFill(nodeCursor.color);
						
						GraphicsUtil.drawArrow(_edgesContainer.graphics,
							new Point(temp_x1,temp_y1),new Point(temp_x2,temp_y2),
							style
						);
						
						_edgesContainer.graphics.endFill();
					}
				}
				
				//In and Out neighbors (drawing):
				for(i=0;i<l3;i++){
					displayNode = _currentDisplayedNodes[i+1];
					
					temp_x0 = EDGES_SCALE*Math.cos(2*Math.PI*((l1-2*l3+l2+i+1)/(l1+l2-l3+a)+_angleDelay)) + stage.stageWidth/2;
					temp_y0 = EDGES_SCALE*Math.sin(2*Math.PI*((l1-2*l3+l2+i+1)/(l1+l2-l3+a)+_angleDelay)) + stage.stageHeight/2;
					displayNode.moveTo(stage.stageWidth/2,stage.stageHeight/2);
					addNodeAsChild(displayNode);
					displayNode.moveToSlowly(temp_x0,temp_y0);
					
					//Draw the edge as an arrow:
					temp_x1 = (EDGES_SCALE*Math.cos(2*Math.PI*((l1-2*l3+l2+i+1)/(l1-l3+l2+a)+_angleDelay)) + stage.stageWidth)/2;
					temp_y1 = (EDGES_SCALE*Math.sin(2*Math.PI*((l1-2*l3+l2+i+1)/(l1-l3+l2+a)+_angleDelay)) + stage.stageHeight)/2;
					
					temp_x2 = (EDGES_SCALE-DisplayNode.NODES_SCALE)/EDGES_SCALE*stage.stageWidth/2 + DisplayNode.NODES_SCALE/EDGES_SCALE*temp_x0;
					temp_y2 = (EDGES_SCALE-DisplayNode.NODES_SCALE)/EDGES_SCALE*stage.stageHeight/2 + DisplayNode.NODES_SCALE/EDGES_SCALE*temp_y0;
					
					temp_x3 = DisplayNode.NODES_SCALE/EDGES_SCALE*stage.stageWidth/2 + (EDGES_SCALE-DisplayNode.NODES_SCALE)/EDGES_SCALE*temp_x0;
					temp_y3 = DisplayNode.NODES_SCALE/EDGES_SCALE*stage.stageHeight/2 + (EDGES_SCALE-DisplayNode.NODES_SCALE)/EDGES_SCALE*temp_y0;
					
					temp_x0 = (EDGES_SCALE*Math.cos(2*Math.PI*((l1-2*l3+l2+i+1)/(l1-l3+l2+a)+_angleDelay)) + stage.stageWidth)/2;
					temp_y0 = (EDGES_SCALE*Math.sin(2*Math.PI*((l1-2*l3+l2+i+1)/(l1-l3+l2+a)+_angleDelay)) + stage.stageHeight)/2
					
					_edgesContainer.graphics.lineStyle(1,displayNode.node.color);
					_edgesContainer.graphics.beginFill(displayNode.node.color);
					
					GraphicsUtil.drawArrow(_edgesContainer.graphics,
						new Point(temp_x1,temp_y1),new Point(temp_x2,temp_y2),
						style
					);
					
					_edgesContainer.graphics.lineStyle(1,_currentSelectedNode.color);
					_edgesContainer.graphics.beginFill(_currentSelectedNode.color);
					
					GraphicsUtil.drawArrow(_edgesContainer.graphics,
						new Point(temp_x0,temp_y0),new Point(temp_x3,temp_y3),
						style
					);
					
					_edgesContainer.graphics.endFill();
				}
			}
			
			addEventListener(Event.ENTER_FRAME,increaseAlpha);
		}
		
		private function increaseAlpha(e:Event):void{
			if(_labelsContainer.alpha<0.99||_edgesContainer.alpha<0.99){
				_labelsContainer.alpha = Math.min(1,_labelsContainer.alpha+0.05);
				_edgesContainer.alpha = Math.min(1,_edgesContainer.alpha+0.05);
			}else{
				removeEventListener(Event.ENTER_FRAME,increaseAlpha);
				var l:int = _currentDisplayedNodes.length - 1;
				
				addEventListeners();
			}
		}
		
		private function onMouseOverNodeHandler(e:MouseEvent):void{
			for each(var displayNode:DisplayNode in _currentDisplayedNodes){
				if(displayNode.upperCircle == (e.target as Sprite)){
					displayNode.whenMouseOver();
					break;
				}
			}
		}
		
		private function onMouseOutNodeHandler(e:MouseEvent):void{
			for each(var displayNode:DisplayNode in _currentDisplayedNodes){
				if(displayNode.upperCircle == (e.target as Sprite)){
					displayNode.whenMouseOut();
					break;
				}
			}
		}
		
		public function selectRandomNode():void{
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
		
		private function removeLabelFieldFromStage():void{
			var l:int = this.numChildren;
			var i:int;
			
			for(i=0;i<l;i++){
				if(this.getChildAt(l-1-i) is TextField){
					this.removeChildAt(l-1-i);
				}
			}
		}
		
		private function whenClickANeighbour(e:MouseEvent):void{
			var l:int = _currentDisplayedNodes.length;
			var node:Node;
			var i:int;
			
			_labelsContainer.addChild(_currentSelectedDisplayNode.labelField);
			_isReady = false;
			
			for(i=0;i<l;i++){
				if(_currentDisplayedNodes[i].upperCircle == e.target){
					node = _currentDisplayedNodes[i].node;
					_nodesContainer.addChild(_currentDisplayedNodes[i]);
					this.addChild(_currentDisplayedNodes[i].labelField);
					break;
				}
			}
			
			trace("DisplayMainElement.whenClickANeighbour: New selected node "+node.label);
			
			_currentSelectedNode = node;
			
			addEventListener(Event.ENTER_FRAME,transitionFirstStep);
		}
		
		private function transitionFirstStep(e:Event):void{
			if(_edgesContainer.alpha>0.01){
				_edgesContainer.alpha -= 0.1;
				_labelsContainer.alpha -= 0.1;
				_attributesContainer.alpha -= 0.1;
			}else{
				removeEventListener(Event.ENTER_FRAME,transitionFirstStep);
				addEventListener(Event.ENTER_FRAME,transitionSecondStep);
			}
		}
		
		private function transitionSecondStep(e:Event):void{
			var d:Number = 0;
			var x_to:Number;
			var y_to:Number;
			var l:Number = _currentDisplayedNodes.length;
			
			for each(var displayNode:DisplayNode in _currentDisplayedNodes){
				x_to = displayNode.x*2/3 + stage.stageWidth/6;
				y_to = displayNode.y*2/3 + stage.stageHeight/6;
				
				displayNode.moveTo(x_to,y_to);
				
				d += Math.pow(x_to-stage.stageWidth/2,2) + Math.pow(y_to-stage.stageHeight/2,2);
			}
			
			if(d<l+1){
				removeEventListener(Event.ENTER_FRAME,transitionSecondStep);
				drawNodes();
			}
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
		
		public function addEventListeners():void{
			var l:int = _currentDisplayedNodes.length - 1;
			for(var i:int=0;i<l;i++){
				_currentDisplayedNodes[i+1].upperCircle.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverNodeHandler);
				_currentDisplayedNodes[i+1].upperCircle.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutNodeHandler);
				_currentDisplayedNodes[i+1].upperCircle.addEventListener(MouseEvent.CLICK,whenClickANeighbour);
			}
			
			isReady = true;
		}
		
		public function removeEventListeners():void{
			var l:int = _currentDisplayedNodes.length - 1;
			for(var i:int=0;i<l;i++){
				_currentDisplayedNodes[i+1].upperCircle.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverNodeHandler);
				_currentDisplayedNodes[i+1].upperCircle.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutNodeHandler);
				_currentDisplayedNodes[i+1].upperCircle.removeEventListener(MouseEvent.CLICK,whenClickANeighbour);
			}
		}
		
		public function freezeBackGround():void{
			this.removeEventListeners();
			this._currentSelectionDisplayAttributes.attributesField.selectable=false;
		}
		
		public function unfreezeBackGround():void{
			this.addEventListeners();
			this._currentSelectionDisplayAttributes.attributesField.selectable=true;
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
		
		public function get currentDisplayedNodes():Vector.<DisplayNode>{
			return _currentDisplayedNodes;
		}
		
		public function set currentDisplayedNodes(value:Vector.<DisplayNode>):void{
			_currentDisplayedNodes = value;
		}
		
		public function get currentSelectedDisplayNode():DisplayNode{
			return _currentSelectedDisplayNode;
		}
		
		public function set currentSelectedDisplayNode(value:DisplayNode):void{
			_currentSelectedDisplayNode = value;
		}
		
		public function get angleDelay():Number{
			return _angleDelay;
		}
		
		public function set angleDelay(value:Number):void{
			_angleDelay = value;
		}
		
		public function get currentSelectionDisplayAttributes():DisplayAttributes{
			return _currentSelectionDisplayAttributes;
		}
		
		public function set currentSelectionDisplayAttributes(value:DisplayAttributes):void{
			_currentSelectionDisplayAttributes = value;
		}
		
		public function get isReady():Boolean{
			return _isReady;
		}
		
		public function set isReady(value:Boolean):void{
			_isReady = value;
		}
	}
}