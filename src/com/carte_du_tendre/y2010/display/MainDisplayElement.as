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
	
	import com.carte_du_tendre.y2010.data.Graph;
	import com.carte_du_tendre.y2010.data.Node;
	import com.dncompute.graphics.ArrowStyle;
	import com.dncompute.graphics.GraphicsUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import flashx.textLayout.formats.Float;
	
	public class MainDisplayElement extends Sprite{
		
		public static const NODE_SELECTED:String= "New node selected";
		public static const GRAPH_VIEW:String = "Graph view";
		public static const EDGES_SCALE:Number = 180;
		public static const MAX_SCALE:Number = 50;
		public static const STEPS:Number = 12;
		
		private var _currentSelectionDisplayAttributes:DisplayAttributes;
		private var _currentDisplayedNodes:Vector.<DisplayNode>;
		private var _constantDisplayNodes:Vector.<DisplayNode>;
		private var _currentDisplayedMainNode:DisplayNode;
		private var _nextNodesToDisplay:Vector.<Node>;
		private var _isGraphView:Boolean; //true: Graph view, false: Local view
		private var _selectedNode:Node;
		private var _graph:Graph;
		
		private var _initialGraphSpatialState:Array; //[top_left_x,top_left_y,bottom_right_x,bottom_right_y,scale]
		private var _localView_edgesToDraw:Array;
		private var _attributesAreaWidth:Number;
		private var _sceneXCenter:Number;
		private var _sceneYCenter:Number;
		private var _historic:Array;
		
		private var _moveStep:Array;
		private var _isReady:Boolean;
		private var _framesNumber:int;
		private var _style:ArrowStyle;
		private var _angleDelay:Number;
		private var _edgesContainer:Sprite;
		private var _nodesContainer:Sprite;
		private var _labelsContainer:Sprite;
		private var _attributesContainer:Sprite;
		private var _nodesHitAreaContainer:Sprite;
		
		public function MainDisplayElement(new_parent:DisplayObjectContainer,newGraph:Graph){
			new_parent.addChild(this);
			_graph = newGraph;
			
			_moveStep = new Array();
			_angleDelay = 1/8.5;
			
			_attributesContainer = new Sprite();
			_edgesContainer = new Sprite();
			_nodesContainer = new Sprite();
			_labelsContainer = new Sprite();
			_nodesHitAreaContainer = new Sprite();
			_attributesAreaWidth = DisplayAttributes.TEXTFIELD_WIDTH;
			
			_isReady = false;
			_currentDisplayedMainNode = null;
			_currentSelectionDisplayAttributes = null;
			_initialGraphSpatialState = [-500,-500,500,500,1];
			
			_sceneXCenter = stage.stageWidth/2;
			_sceneYCenter = stage.stageHeight/2;
			
			addChild(_edgesContainer);
			addChild(_nodesContainer);
			addChild(_labelsContainer);
			addChild(_nodesHitAreaContainer);
			parent.addChild(_attributesContainer);
			
			_style = new ArrowStyle();
			_style.headLength = 10;
			_style.headWidth = 10;
			_style.shaftPosition = 0;
			_style.shaftThickness = 4;
			_style.edgeControlPosition = 0.5;
			_style.edgeControlSize = 0.5;
			
			trace("MainDisplayElement.MainDisplayElement: GUI initiated.");
			
			drawGraph();
		}

		public function drawGraph():void{
			var node:Node;
			var displayNode:DisplayNode;
			
			_historic = null;
			_isReady = false;
			_isGraphView = true;
			_currentSelectionDisplayAttributes = null;
			_edgesContainer.graphics.clear();
			removeDisplayedNodes();
			
			if(_currentDisplayedMainNode!=null){
				_currentDisplayedMainNode = null;
			}
			
			_currentDisplayedNodes = new Vector.<DisplayNode>();
			
			for each(node in _graph.nodes){
				displayNode = new DisplayNode(node,stage.stageWidth/2,stage.stageHeight/2);
				_currentDisplayedNodes.push(displayNode);
				
				addNodeAsChild(displayNode);
				displayNode.setStep(node.x,node.y,2*STEPS);
			}
			
			graphView_processDisplayNodesScaling();
			graphView_addEventListeners();
			graphView_transitionLauncher();
			processScaling();
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,graphView_zoomScene);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,graphView_drag);
			stage.addEventListener(MouseEvent.MOUSE_UP,graphView_drop);
		}
		
		private function drawLocalView():void{
			var new_x:Number;
			var new_y:Number;
			var isAlreadyDrawn:Boolean;
			
			var i:int;
			var index:int = 0;
			var l:int = _constantDisplayNodes.length;
			var l2:int = _nextNodesToDisplay.length;
			
			var node:Node;
			var displayNode:DisplayNode;
			
			var crownsNumber:int = 1+Math.floor((DisplayNode.NODES_SCALE_LOCAL*2*l2)/(1*Math.PI*EDGES_SCALE));
			var diameter:Number;
			
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL,graphView_zoomScene);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,graphView_drag);
			stage.removeEventListener(MouseEvent.MOUSE_UP,graphView_drop);
			
			_currentDisplayedNodes = new Vector.<DisplayNode>();
			
			// Selected node:
			_currentDisplayedMainNode.setStep(stage.stageWidth/2,stage.stageHeight/2,STEPS);
			
			//Attributes of the selected node:
			if((_graph.isAttributesHashNull!=true)&&(_currentDisplayedMainNode.node.isHashNull!=true)){
				if(_attributesContainer.numChildren>=1) _attributesContainer.removeChildAt(0);
				_attributesContainer.alpha = 1;
				_currentSelectionDisplayAttributes = new DisplayAttributes(_currentDisplayedMainNode,_graph,this,_attributesAreaWidth-20);
				_currentSelectionDisplayAttributes.alpha = 0;
			}else{
				_currentSelectionDisplayAttributes = null;
			}
			
			// Already displayed nodes:
			for each(displayNode in _constantDisplayNodes){
				diameter = EDGES_SCALE+(index%crownsNumber-(crownsNumber-1)/2)*3.5*DisplayNode.NODES_SCALE_LOCAL;
				
				new_x = diameter*Math.cos(2*Math.PI*((index+1)/(l2)+_angleDelay)) + stage.stageWidth/2;
				new_y = diameter*Math.sin(2*Math.PI*((index+1)/(l2)+_angleDelay)) + stage.stageHeight/2;
				
				displayNode.setStep(new_x,new_y,STEPS);
				_currentDisplayedNodes.push(displayNode);
				
				index++;
			}
			
			for each(node in _nextNodesToDisplay){
				isAlreadyDrawn = false;
				
				for(i=0;i<l;i++){
					if(_constantDisplayNodes[i].node.flex_id == node.flex_id) isAlreadyDrawn = true;
				}
				
				if(isAlreadyDrawn) continue;
				
				diameter = EDGES_SCALE+(index%crownsNumber-(crownsNumber-1)/2)*3.5*DisplayNode.NODES_SCALE_LOCAL;
				
				displayNode = new DisplayNode(node,stage.stageWidth/2,stage.stageHeight/2);
				_currentDisplayedNodes.push(displayNode);
				
				new_x = diameter*Math.cos(2*Math.PI*((index+1)/(l2)+_angleDelay)) + stage.stageWidth/2;
				new_y = diameter*Math.sin(2*Math.PI*((index+1)/(l2)+_angleDelay)) + stage.stageHeight/2;
				
				displayNode.moveTo(stage.stageWidth/2,stage.stageHeight/2);
				addNodeAsChild(displayNode);
				displayNode.setStep(new_x,new_y,STEPS);
				
				index++;
			}
			
			setLocalExploration(true);
			localView_processDisplayNodesScaling();
			localView_transitionLauncher();
			localView_addEventListeners();
		}
		
		private function processScaling():void{
			var xMin:Number = _graph.nodes[0].x;
			var xMax:Number = _graph.nodes[0].x;
			var yMin:Number = _graph.nodes[0].y;
			var yMax:Number = _graph.nodes[0].y;
			var ratio:Number;
			
			for (var i:Number = 1;i<_graph.nodes.length;i++){
				if(_graph.nodes[i].x < xMin)
					xMin = _graph.nodes[i].x;
				if(_graph.nodes[i].x > xMax)
					xMax = _graph.nodes[i].x;
				if(_graph.nodes[i].y < yMin)
					yMin = _graph.nodes[i].y;
				if(_graph.nodes[i].y > yMax)
					yMax = _graph.nodes[i].y;
			}
			
			var xCenter:Number = (xMax + xMin)/2;
			var yCenter:Number = (yMax + yMin)/2;
			
			var xSize:Number = xMax - xMin;
			var ySize:Number = yMax - yMin;
			
			ratio = Math.min(stage.stageWidth/(xSize),stage.stageHeight/(ySize))*0.9;
			
			_initialGraphSpatialState = [stage.stageWidth/2-xCenter*ratio,stage.stageHeight/2-yCenter*ratio,
										 stage.stageWidth/2-xCenter*ratio+stage.stageWidth/ratio,
										 stage.stageHeight/2-yCenter*ratio+stage.stageHeight/ratio,ratio];
			
			moveGraphSceneSlowly(stage.stageWidth/2-xCenter*ratio,stage.stageHeight/2-yCenter*ratio,ratio);
		}
		
		private function setNextDisplayedNodes():void{
			var i:int;
			var j:int;
			var l:int;
			var l2:int;
			
			_nextNodesToDisplay = new Vector.<Node>();
			_constantDisplayNodes = new Vector.<DisplayNode>();
			
			if(_currentDisplayedMainNode!=null){
				removeNodeAsChild(_currentDisplayedMainNode);
			}
			
			// First, let's identify the new selected node if it is already displayed:
			l = _currentDisplayedNodes.length;
			
			_currentDisplayedMainNode = new DisplayNode(_selectedNode,stage.stageWidth/2,stage.stageHeight/2);
			for(i=0;i<l;i++){
				if(_currentDisplayedNodes[i].node.flex_id == _selectedNode.flex_id){
					_currentDisplayedMainNode = _currentDisplayedNodes[i];
				}
			}
			
			// Secondly, let's recense all the nodes (except the selected one) which will be displayed:
			l = _selectedNode.outNeighbours.length;
			for(i=0;i<l;i++){
				if(_nextNodesToDisplay.indexOf(_selectedNode.outNeighbours[i])<0){
					_nextNodesToDisplay.push(_selectedNode.outNeighbours[i]);
				}
			}
			
			l = _selectedNode.inNeighbours.length;
			for(i=0;i<l;i++){
				if(_nextNodesToDisplay.indexOf(_selectedNode.inNeighbours[i])<0){
					_nextNodesToDisplay.push(_selectedNode.inNeighbours[i]);
				}
			}
			
			// Now, let's recense the nodes already displayed:
			l = _nextNodesToDisplay.length;
			l2 = _currentDisplayedNodes.length;
			for(i=0;i<l;i++){
				for(j=0;j<l2;j++){
					if(_currentDisplayedNodes[j].node.flex_id == _nextNodesToDisplay[i].flex_id){
						_constantDisplayNodes.push(_currentDisplayedNodes[j]);
						break;
					}
				}
			}
			
			_currentDisplayedNodes = _constantDisplayNodes;
			removeDisplayedNodes();
			
			l = _currentDisplayedNodes.length;
			for(i=0;i<l;i++){
				addNodeAsChild(_currentDisplayedNodes[i]);
			}
			
			addNodeAsChild(_currentDisplayedMainNode);
			
			drawLocalView();
		}
		
		private function setLocalExploration(slowly:Boolean):void{
			if(_currentSelectionDisplayAttributes!=null){
				if(slowly){
					moveGraphSceneSlowly(-_attributesAreaWidth/2,0,1);
				}else{
					moveGraphScene(-_attributesAreaWidth/2,0,1);
				}
			}else{
				if(slowly){
					moveGraphSceneSlowly(0,0,1);
				}else{
					moveGraphScene(0,0,1);
				}
			}
		}
		
		private function moveGraphScene(new_x:Number,new_y:Number,new_ratio:Number):void{
			this.x = new_x;
			this.y = new_y;
			this.scaleX = new_ratio;
			this.scaleY = new_ratio;
		}
		
		private function moveGraphSceneSlowly(new_x:Number,new_y:Number,new_ratio:Number):void{
			_moveStep[0] = new_x;
			_moveStep[1] = new_y;
			_moveStep[2] = new_ratio;
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,graphView_drag);
			stage.removeEventListener(MouseEvent.MOUSE_UP,graphView_drop);
			addEventListener(Event.ENTER_FRAME,slowDisplacementHandler);
		}
		
		private function slowDisplacementHandler(e:Event):void{
			var d2:Number = Math.pow(this.x-_moveStep[0],2)+Math.pow(this.y-_moveStep[1],2)+Math.pow(this.scaleX-_moveStep[2],2);
			
			if(d2<1){
				moveGraphScene(_moveStep[0], _moveStep[1], _moveStep[2]);
				removeEventListener(Event.ENTER_FRAME,slowDisplacementHandler);
				if(_isGraphView==true){
					stage.addEventListener(MouseEvent.MOUSE_DOWN,graphView_drag);
					stage.addEventListener(MouseEvent.MOUSE_UP,graphView_drop);
				}
			}else{
				moveGraphScene(this.x/2 + _moveStep[0]/2, this.y/2 + _moveStep[1]/2, this.scaleX/2 + _moveStep[2]/2);
			}
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
		
		private function addNodeAsTopChild(displayNode:DisplayNode):void{
			this.addChild(displayNode);
			this.addChild(displayNode.labelField);
			this.addChild(displayNode.upperCircle);
		}
		
		private function removeNodeAsTopChild(displayNode:DisplayNode):void{
			this.removeChild(displayNode);
			this.removeChild(displayNode.labelField);
			this.removeChild(displayNode.upperCircle);
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
			
			//Remove the attributes:
			l = _attributesContainer.numChildren;
			for(i=0;i<l;i++){
				_attributesContainer.removeChildAt(l-1-i);
			}
			
			//Remove finally the hit areas:
			l = _nodesHitAreaContainer.numChildren;
			for(i=0;i<l;i++){
				_nodesHitAreaContainer.removeChildAt(l-1-i);
			}
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
		
		private function onMouseOverNodeHandler(e:MouseEvent):void{
			for each(var displayNode:DisplayNode in _currentDisplayedNodes){
				if(displayNode.upperCircle == (e.target as Sprite)){
					removeNodeAsChild(displayNode);
					addNodeAsTopChild(displayNode);
					displayNode.whenMouseOver();
					break;
				}
			}
		}
		
		private function onMouseOutNodeHandler(e:MouseEvent):void{
			for each(var displayNode:DisplayNode in _currentDisplayedNodes){
				if(displayNode.upperCircle == (e.target as Sprite)){
					removeNodeAsTopChild(displayNode);
					addNodeAsChild(displayNode);
					displayNode.whenMouseOut();
					break;
				}
			}
		}
		
		private function afterSelection():void{
			_isReady = false;
			_isGraphView = false;
			graphView_removeEventListeners();
			localView_removeEventListeners();
			
			if(_historic==null) _historic = new Array();
			
			_historic.push(_selectedNode);
			
			setNextDisplayedNodes()
		}
		
		private function whenClickANeighbour(e:MouseEvent):void{
			var l:int = _currentDisplayedNodes.length;
			var node:Node;
			var i:int;
			
			if(_isReady==true){
				for(i=0;i<l;i++){
					if(_currentDisplayedNodes[i].upperCircle == e.target){
						node = _currentDisplayedNodes[i].node;
					}
				}
				
				_selectedNode = node;
				
				afterSelection();
			}
		}
		
		public function selectRandomNode():void{
			var l:int = _graph.nodes.length;
			var index:int = Math.floor(Math.random()*l);
			
			if(_isReady==true){
				_selectedNode = _graph.nodes[index];
				_historic = null;
				afterSelection();
			}
		}
		
		public function selectNode(node:Node):void{
			if(_isReady==true){
				_selectedNode = node;
				afterSelection();
			}
		}
		
		public function freezeBackGround():void{
			this.graphView_removeEventListeners();
			if(_isGraphView==true){
				
			}
			
			if(_currentSelectionDisplayAttributes!=null){
				this._currentSelectionDisplayAttributes.attributesField.selectable=false;
				_currentSelectionDisplayAttributes.removeEventListeners();
			}
		}
		
		public function unfreezeBackGround():void{
			this.graphView_addEventListeners();
			if(_currentSelectionDisplayAttributes!=null){
				this._currentSelectionDisplayAttributes.attributesField.selectable=true;
				_currentSelectionDisplayAttributes.addEventListeners();
			}
		}
		
		private function graphView_addEventListeners():void{
			var l:int = _currentDisplayedNodes.length;
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,graphView_zoomScene);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,graphView_drag);
			stage.addEventListener(MouseEvent.MOUSE_UP,graphView_drop);
			
			for(var i:int=0;i<l;i++){
				_currentDisplayedNodes[i].upperCircle.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverNodeHandler);
				_currentDisplayedNodes[i].upperCircle.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutNodeHandler);
				_currentDisplayedNodes[i].upperCircle.addEventListener(MouseEvent.CLICK,whenClickANeighbour);
			}
		}
		
		private function graphView_removeEventListeners():void{
			var l:int = _currentDisplayedNodes.length;
			
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL,graphView_zoomScene);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,graphView_drag);
			stage.removeEventListener(MouseEvent.MOUSE_UP,graphView_drop);
			
			for(var i:int=0;i<l;i++){
				_currentDisplayedNodes[i].upperCircle.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverNodeHandler);
				_currentDisplayedNodes[i].upperCircle.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutNodeHandler);
				_currentDisplayedNodes[i].upperCircle.removeEventListener(MouseEvent.CLICK,whenClickANeighbour);
			}
		}
		
		private function graphView_transitionLauncher():void{
			_framesNumber = 0;
			addEventListener(Event.ENTER_FRAME,graphView_transition);
		}
		
		private function graphView_transition(e:Event):void{
			if(_framesNumber>=2*STEPS){
				removeEventListener(Event.ENTER_FRAME,graphView_transition);
				_isReady = true;
				dispatchEvent(new Event(GRAPH_VIEW));
			}else{
				// All nodes:
				var displayNode:DisplayNode;
				
				for each(displayNode in _currentDisplayedNodes){
					displayNode.moveTo(displayNode.x+displayNode.step[0],displayNode.y+displayNode.step[1]);
				}
				
				_framesNumber++;
			}
		}
		
		private function graphView_processDisplayNodesScaling():void{
			var displayNode:DisplayNode;
			
			for each(displayNode in _currentDisplayedNodes){
				displayNode.size = DisplayNode.NODES_SCALE*displayNode.node.size;
				displayNode.draw();
			}
		}
		
		public function graphView_zoomScene(evt:MouseEvent):void{
			var new_scale:Number;
			var new_x:Number;
			var new_y:Number;
			var a:Array = _initialGraphSpatialState;
			
			if (evt.delta>=0){
				new_scale = Math.min(a[4]*MAX_SCALE,this.scaleX*1.5);
				new_x = evt.stageX+(this.x-evt.stageX)*new_scale/this.scaleX;
				new_y = evt.stageY+(this.y-evt.stageY)*new_scale/this.scaleY;
			}else{
				new_scale = Math.max(a[4]/2,this.scaleX*2/3);
				new_x = evt.stageX+(this.x-evt.stageX)*new_scale/this.scaleX;
				new_y = evt.stageY+(this.y-evt.stageY)*new_scale/this.scaleY;
			}
			
			//new_x = Math.min(a[2]-stage.stageWidth/new_scale,new_x);
			//new_x = Math.max(a[0],new_x);
			//new_y = Math.min(a[3]-stage.stageHeight/new_scale,new_y);
			//new_y = Math.max(a[1],new_y);
			
			moveGraphSceneSlowly(new_x,new_y,new_scale);
		}
		
		private function graphView_drag(evt:MouseEvent):void{
			var a:Array = _initialGraphSpatialState;
			var rect:Rectangle = new Rectangle(a[0]/a[4]*this.scaleX,
											   a[1]/a[4]*this.scaleY,
											   10000,10000);
											   //a[2]-stage.stageWidth/a[4]-a[0],
											   //a[3]-stage.stageHeight/a[4]-a[1]);
			//this.startDrag(false,rect);
			this.startDrag();
		}
		
		private function graphView_drop(evt:MouseEvent):void{
			this.stopDrag();
		}
		
		private function localView_addEventListeners():void{
			var l:int = _currentDisplayedNodes.length;
			for(var i:int=0;i<l;i++){
				_currentDisplayedNodes[i].upperCircle.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverNodeHandler);
				_currentDisplayedNodes[i].upperCircle.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutNodeHandler);
				_currentDisplayedNodes[i].upperCircle.addEventListener(MouseEvent.CLICK,whenClickANeighbour);
			}
		}
		
		private function localView_removeEventListeners():void{
			var l:int = _currentDisplayedNodes.length;
			for(var i:int=0;i<l;i++){
				_currentDisplayedNodes[i].upperCircle.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverNodeHandler);
				_currentDisplayedNodes[i].upperCircle.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutNodeHandler);
				_currentDisplayedNodes[i].upperCircle.removeEventListener(MouseEvent.CLICK,whenClickANeighbour);
			}
		}
		
		private function localView_transitionLauncher():void{
			_isReady = false;
			_framesNumber = 0;
			localView_setEdgesToDisplay();
			addEventListener(Event.ENTER_FRAME,localView_transition);
		}
		
		private function localView_transition(e:Event):void{
			if(_framesNumber>=STEPS){
				removeEventListener(Event.ENTER_FRAME,localView_transition);
				_isReady = true;
				dispatchEvent(new Event(NODE_SELECTED));
				localView_drawEdges();
			}else{
				// Currently selected node:
				_currentDisplayedMainNode.moveTo(_currentDisplayedMainNode.x+_currentDisplayedMainNode.step[0],_currentDisplayedMainNode.y+_currentDisplayedMainNode.step[1]);
				
				// Attributes:
				if(_currentSelectionDisplayAttributes!=null){
					_currentSelectionDisplayAttributes.alpha += 1/STEPS;
				}
				
				// Neighbours and edges:
				var displayNode:DisplayNode;
				
				for each(displayNode in _currentDisplayedNodes){
					displayNode.moveTo(displayNode.x+displayNode.step[0],displayNode.y+displayNode.step[1]);
				}
				
				localView_drawEdges()
				
				_framesNumber++;
			}
		}
		
		private function localView_processDisplayNodesScaling():void{
			var sizeMin:Number = _currentDisplayedMainNode.node.size;
			var sizeMax:Number = _currentDisplayedMainNode.node.size;
			var sizeInterval:Number;
			var sizeCenter:Number;
			
			var displayNode:DisplayNode;
			
			for each(displayNode in _currentDisplayedNodes){
				if(displayNode.node.size < sizeMin)
					sizeMin = displayNode.node.size;
				if(displayNode.node.size > sizeMax)
					sizeMax = displayNode.node.size;
			}
			
			sizeInterval = sizeMax - sizeMin;
			sizeCenter = (sizeMax+sizeMin)/2;
			
			if(sizeInterval>0.1){
				_currentDisplayedMainNode.size = DisplayNode.NODES_SCALE_LOCAL*(1+(_currentDisplayedMainNode.node.size-sizeCenter)*1/sizeInterval);
				_currentDisplayedMainNode.draw();
				
				for each(displayNode in _currentDisplayedNodes){
					displayNode.size = DisplayNode.NODES_SCALE_LOCAL*(1+(displayNode.node.size-sizeCenter)*1/sizeInterval);
					displayNode.draw();
				}
			}else{
				_currentDisplayedMainNode.size = DisplayNode.NODES_SCALE_LOCAL;
				_currentDisplayedMainNode.draw();
				
				for each(displayNode in _currentDisplayedNodes){
					displayNode.size = DisplayNode.NODES_SCALE_LOCAL;
					displayNode.draw();
				}
			}
		}
		
		private function localView_setEdgesToDisplay():void{
			var displayNode:DisplayNode;
			_localView_edgesToDraw = new Array();
			
			var l1:int = _currentDisplayedMainNode.node.outNeighbours.length;
			var l2:int = _currentDisplayedMainNode.node.inNeighbours.length;
			var i:int;
			var j:int;
			
			var isOut:Boolean;
			var isIn:Boolean;
			
			for each(displayNode in _currentDisplayedNodes){
				isOut = false;
				isIn = false;
				
				for(i=0;i<l1;i++){
					if(displayNode.node.flex_id==_currentDisplayedMainNode.node.outNeighbours[i].flex_id){
						isOut = true;
					}
				}
				
				for(j=0;j<l2;j++){
					if(displayNode.node.flex_id==_currentDisplayedMainNode.node.inNeighbours[j].flex_id){
						isIn = true;
					}
				}
				
				if(isOut&&isIn){
					_localView_edgesToDraw.push(["mutual",displayNode]);
				}else if(isOut){
					_localView_edgesToDraw.push(["out",displayNode]);
				}else if(isIn){
					_localView_edgesToDraw.push(["in",displayNode]);
				}
			}
		}
		
		private function localView_drawEdges():void{
			var displayNode:DisplayNode;
			
			var l:int = _localView_edgesToDraw.length;
			var i:int;
			
			var distance:Number;
			var x0:Number;
			var y0:Number;
			var size0:Number;
			var xNeighbour:Number;
			var yNeighbour:Number;
			var xCenter:Number;
			var yCenter:Number;
			var xMiddle:Number;
			var yMiddle:Number;
			
			_edgesContainer.graphics.clear();
			
			for(i=0;i<l;i++){
				displayNode = _localView_edgesToDraw[i][1];
				x0 = _currentDisplayedMainNode.x;
				y0 = _currentDisplayedMainNode.y;
				size0 = _currentDisplayedMainNode.size;
				
				distance = Math.sqrt(Math.pow(displayNode.x-x0,2)+Math.pow(displayNode.y-y0,2));
				if(distance<=(Math.max(size0,displayNode.size)+10)) continue;
				
				xNeighbour = displayNode.x*(distance-displayNode.size)/distance + x0*displayNode.size/distance;
				yNeighbour = displayNode.y*(distance-displayNode.size)/distance + y0*displayNode.size/distance;
				
				xCenter = displayNode.x*size0/distance + x0*(distance-size0)/distance;
				yCenter = displayNode.y*size0/distance + y0*(distance-size0)/distance;
				
				if(_localView_edgesToDraw[i][0]=="mutual"){
					xMiddle = (x0+displayNode.x)/2;
					yMiddle = (y0+displayNode.y)/2;
					
					_edgesContainer.graphics.lineStyle(1,_currentDisplayedMainNode.node.color);
					_edgesContainer.graphics.beginFill(_currentDisplayedMainNode.node.color);
					
					GraphicsUtil.drawArrow(_edgesContainer.graphics,
						new Point(xMiddle,yMiddle),new Point(xNeighbour,yNeighbour),
						style
					);
					
					_edgesContainer.graphics.endFill();
					
					_edgesContainer.graphics.lineStyle(1,displayNode.node.color);
					_edgesContainer.graphics.beginFill(displayNode.node.color);
					
					GraphicsUtil.drawArrow(_edgesContainer.graphics,
						new Point(xMiddle,yMiddle),new Point(xCenter,yCenter),
						style
					);
					
					_edgesContainer.graphics.endFill();
				}else if(_localView_edgesToDraw[i][0]=="out"){
					_edgesContainer.graphics.lineStyle(1,_currentDisplayedMainNode.node.color);
					_edgesContainer.graphics.beginFill(_currentDisplayedMainNode.node.color);
					
					GraphicsUtil.drawArrow(_edgesContainer.graphics,
						new Point(xCenter,yCenter),new Point(xNeighbour,yNeighbour),
						style
					);
					
					_edgesContainer.graphics.endFill();
				}else if(_localView_edgesToDraw[i][0]=="in"){
					_edgesContainer.graphics.lineStyle(1,displayNode.node.color);
					_edgesContainer.graphics.beginFill(displayNode.node.color);
					
					GraphicsUtil.drawArrow(_edgesContainer.graphics,
						new Point(xNeighbour,yNeighbour),new Point(xCenter,yCenter),
						style
					);
					
					_edgesContainer.graphics.endFill();
				}
			}
		}
		
		public function get graph():Graph{
			return _graph;
		}

		public function set graph(value:Graph):void{
			_graph = value;
		}

		public function get nodesHitAreaContainer():Sprite{
			return _nodesHitAreaContainer;
		}
		
		public function set nodesHitAreaContainer(value:Sprite):void{
			_nodesHitAreaContainer = value;
		}
		
		public function get attributesContainer():Sprite{
			return _attributesContainer;
		}
		
		public function set attributesContainer(value:Sprite):void{
			_attributesContainer = value;
		}
		
		public function get labelsContainer():Sprite{
			return _labelsContainer;
		}
		
		public function set labelsContainer(value:Sprite):void{
			_labelsContainer = value;
		}
		
		public function get nodesContainer():Sprite{
			return _nodesContainer;
		}
		
		public function set nodesContainer(value:Sprite):void{
			_nodesContainer = value;
		}
		
		public function get edgesContainer():Sprite{
			return _edgesContainer;
		}
		
		public function set edgesContainer(value:Sprite):void{
			_edgesContainer = value;
		}
		
		public function get angleDelay():Number{
			return _angleDelay;
		}
		
		public function set angleDelay(value:Number):void{
			_angleDelay = value;
		}
		
		public function get isReady():Boolean{
			return _isReady;
		}
		
		public function set isReady(value:Boolean):void{
			_isReady = value;
		}
		
		public function get selectedNode():Node{
			return _selectedNode;
		}
		
		public function set selectedNode(value:Node):void{
			_selectedNode = value;
		}
		
		public function get nextNodesToDisplay():Vector.<Node>{
			return _nextNodesToDisplay;
		}
		
		public function set nextNodesToDisplay(value:Vector.<Node>):void{
			_nextNodesToDisplay = value;
		}
		
		public function get currentDisplayedMainNode():DisplayNode{
			return _currentDisplayedMainNode;
		}
		
		public function set currentDisplayedMainNode(value:DisplayNode):void{
			_currentDisplayedMainNode = value;
		}
		
		public function get currentDisplayedNodes():Vector.<DisplayNode>{
			return _currentDisplayedNodes;
		}
		
		public function set currentDisplayedNodes(value:Vector.<DisplayNode>):void{
			_currentDisplayedNodes = value;
		}
		
		public function get currentSelectionDisplayAttributes():DisplayAttributes{
			return _currentSelectionDisplayAttributes;
		}
		
		public function set currentSelectionDisplayAttributes(value:DisplayAttributes):void{
			_currentSelectionDisplayAttributes = value;
		}
		
		public function get constantDisplayNodes():Vector.<DisplayNode>{
			return _constantDisplayNodes;
		}
		
		public function set constantDisplayNodes(value:Vector.<DisplayNode>):void{
			_constantDisplayNodes = value;
		}
		
		public function get moveStep():Array{
			return _moveStep;
		}
		
		public function set moveStep(value:Array):void{
			_moveStep = value;
		}
		
		public function get isGraphView():Boolean{
			return _isGraphView;
		}
		
		public function set isGraphView(value:Boolean):void{
			_isGraphView = value;
		}
		
		public function get style():ArrowStyle{
			return _style;
		}
		
		public function set style(value:ArrowStyle):void{
			_style = value;
		}
		
		public function get framesNumber():int{
			return _framesNumber;
		}
		
		public function set framesNumber(value:int):void{
			_framesNumber = value;
		}
		
		public function get localView_edgesToDraw():Array{
			return _localView_edgesToDraw;
		}
		
		public function set localView_edgesToDraw(value:Array):void{
			_localView_edgesToDraw = value;
		}
		
		public function get attributesAreaWidth():Number{
			return _attributesAreaWidth;
		}
		
		public function set attributesAreaWidth(value:Number):void{
			_attributesAreaWidth = value;
		}
		
		public function get sceneYCenter():Number{
			return _sceneYCenter;
		}
		
		public function set sceneYCenter(value:Number):void{
			_sceneYCenter = value;
		}
		
		public function get sceneXCenter():Number{
			return _sceneXCenter;
		}
		
		public function set sceneXCenter(value:Number):void{
			_sceneXCenter = value;
		}
		
		public function get initialGraphSpatialState():Array{
			return _initialGraphSpatialState;
		}
		
		public function set initialGraphSpatialState(value:Array):void{
			_initialGraphSpatialState = value;
		}
		
		public function get historic():Array{
			return _historic;
		}
		
		public function set historic(value:Array):void{
			_historic = value;
		}
	}
}