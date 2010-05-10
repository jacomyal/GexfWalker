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
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	
	public class DisplayAttributes extends Sprite{
		
		private var _attributesField:TextField;
		private var _displayNode:DisplayNode;
		private var _currentState:Array;
		private var _framesCounter:int;
		private var _goal:Array;
		
		public function DisplayAttributes(new_displayNode:DisplayNode,graph:Graph,container:DisplayObjectContainer,new_x:Number,new_y:Number){
			_displayNode = new_displayNode;
			var new_text:String = '<font face="Verdana" size="12"><b>Attributes:</b>\n';
			var newContent:Dictionary = _displayNode.node.getAttributes().getMap();
			
			_framesCounter = 0;
			container.addChild(this);
			_currentState = [0,0];
			_goal = [new_x-this.stage.stageWidth/2,new_y-this.stage.stageHeight/2];
			
			for(var key:* in newContent){
				if((_displayNode.node.getAttributes().getValue(key).substr(0,7)=="http://")||(graph.getAttribute(key).toLowerCase()=="url")){
					new_text += "<p><b>"+graph.getAttribute(key)+":</b> "+'<a href="'+_displayNode.node.getAttributes().getValue(key)+'" target="_blank" >'+'<font color="#444488">'+_displayNode.node.getAttributes().getValue(key)+"</font></a><br/></p>\n";
				}else{
					new_text += "<p><b>"+graph.getAttribute(key)+":</b> "+_displayNode.node.getAttributes().getValue(key)+"<br/></p>\n";
				}
			}
			
			new_text += "</font>";
			
			_attributesField = new TextField();
			with(_attributesField){
				htmlText = new_text;
				autoSize = TextFieldAutoSize.LEFT;
				selectable = true;
			}
			
			this.graphics.lineStyle(1,0x000000);
			this.graphics.moveTo(_currentState[0],_currentState[1]);
			_currentState[0] = _goal[0]/8 + _currentState[0]*7/8;
			_currentState[1] = _goal[1]/8 + _currentState[1]*7/8;
			this.graphics.moveTo(_currentState[0],_currentState[1]);
			
			trace("DisplayAttributes.DisplayAttributes: Launch drawing process.");
			addEventListener(Event.ENTER_FRAME,drawFirstStep);
		}

		private function drawFirstStep(e:Event):void{
			var d:Number = Math.pow(_goal[0]-_currentState[0],2)+Math.pow(_goal[1]-_currentState[1],2);
			_currentState[0] = _goal[0]/2 + _currentState[0]/2;
			_currentState[1] = _goal[1]/2 + _currentState[1]/2;
			
			this.graphics.lineTo(_currentState[0],_currentState[1]);
			this.x = _displayNode.x;
			this.y = _displayNode.y;
			
			if(d<10){
				this.graphics.lineTo(_goal[0],_goal[1]);
				removeEventListener(Event.ENTER_FRAME,drawFirstStep);
				_attributesField.x = _currentState[0]+5;
				_attributesField.y = _currentState[1]+5;
				_attributesField.alpha = 0;
				addChild(_attributesField);
				
				_currentState[2] = _currentState[0];
				_currentState[3] = _currentState[1];
				
				addEventListener(Event.ENTER_FRAME,drawSecondStep);
			}
		}
		
		private function drawSecondStep(e:Event):void{
			this.x = _displayNode.x;
			this.y = _displayNode.y;
			
			this.graphics.moveTo(_currentState[0],_currentState[1]);
			_currentState[1] += 12;
			this.graphics.lineTo(_currentState[0],_currentState[1]);
			
			this.graphics.moveTo(_currentState[2],_currentState[3]);
			_currentState[2] += 12;
			this.graphics.lineTo(_currentState[2],_currentState[3]);
			
			_framesCounter ++;
			
			if(_framesCounter==3){
				removeEventListener(Event.ENTER_FRAME,drawSecondStep);
				addEventListener(Event.ENTER_FRAME,drawThirdStep);
				this.x = _displayNode.x;
				this.y = _displayNode.y;
			}
		}
		
		private function drawThirdStep(e:Event):void{
			if(_attributesField.alpha<0.98){
				_attributesField.alpha = 1-(1-_attributesField.alpha)/2;
			}else{
				removeEventListener(Event.ENTER_FRAME,drawThirdStep);
				(_displayNode.parent.parent as MainDisplayElement).isReady = true;
			}
		}
		
		public function get goal():Array{
			return _goal;
		}

		public function set goal(value:Array):void{
			_goal = value;
		}
		
		public function get attributesField():TextField{
			return _attributesField;
		}
		
		public function set attributesField(value:TextField):void{
			_attributesField = value;
		}
		
		public function get currentState():Array{
			return _currentState;
		}
		
		public function set currentState(value:Array):void{
			_currentState = value;
		}
		
		public function get framesCounter():int{
			return _framesCounter;
		}
		
		public function set framesCounter(value:int):void{
			_framesCounter = value;
		}
		
		public function get displayNode():DisplayNode{
			return _displayNode;
		}
		
		public function set displayNode(value:DisplayNode):void{
			_displayNode = value;
		}
	}
}