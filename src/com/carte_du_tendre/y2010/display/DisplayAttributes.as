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
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	
	public class DisplayAttributes extends Sprite{
		
		public static const TEXTFIELD_WIDTH:Number = 15;
		
		private var _attributesField:TextField;
		private var _displayNode:DisplayNode;
		private var _horizontalSlider:Sprite;
		private var _horizontalSliderHitArea:Sprite;
		private var _main:MainDisplayElement;
		
		public function DisplayAttributes(new_displayNode:DisplayNode,graph:Graph,new_main:MainDisplayElement,newWidth:Number){
			_displayNode = new_displayNode;
			_main = new_main;
			_main.attributesContainer.addChild(this);
			
			// Set HTML Text:
			var text:String = setHtmlText(graph);
			
			// Set TextField:
			_attributesField = new TextField();
			_attributesField.htmlText = text;
			//_attributesField.autoSize = TextFieldAutoSize.LEFT;
			_attributesField.wordWrap = true;
			_attributesField.selectable = true;
			_attributesField.mouseWheelEnabled = true;
			_attributesField.x = 10;
			_attributesField.y = 10;
			_attributesField.width = Math.abs(newWidth);
			_attributesField.height = stage.stageHeight-20;
			this.addChild(_attributesField);
			if(_attributesField.width<=50) _attributesField.alpha = 0;
			
			
			// Set slider hit area:
			_horizontalSliderHitArea = new Sprite();
			_horizontalSliderHitArea.graphics.beginFill(0x000000,0);
			_horizontalSliderHitArea.graphics.drawRect(-5,5,10,stage.stageHeight-10);
			_horizontalSliderHitArea.graphics.endFill();
			
			// Set slider:
			_horizontalSlider = new Sprite();
			
			this.addChild(_horizontalSlider);
			this.addChild(_horizontalSliderHitArea);
			
			_horizontalSlider.graphics.lineStyle(1,0x000000,1);
			_horizontalSlider.graphics.moveTo(0,10);
			_horizontalSlider.graphics.lineTo(0,stage.stageHeight-10);
			
			_horizontalSlider.graphics.lineStyle(1,0x888888,0);
			_horizontalSlider.graphics.beginFill(0x888888,1);
			_horizontalSlider.graphics.moveTo(-2,stage.stageHeight-10);
			_horizontalSlider.graphics.lineTo(-7.5,stage.stageHeight-14.5);
			_horizontalSlider.graphics.lineTo(-2,stage.stageHeight-19);
			_horizontalSlider.graphics.lineTo(-2,stage.stageHeight-10);
			_horizontalSlider.graphics.endFill();
			
			_horizontalSlider.graphics.beginFill(0x888888,1);
			_horizontalSlider.graphics.moveTo(3,stage.stageHeight-10);
			_horizontalSlider.graphics.lineTo(3,stage.stageHeight-19);
			_horizontalSlider.graphics.lineTo(7.5,stage.stageHeight-14.5);
			_horizontalSlider.graphics.lineTo(3,stage.stageHeight-10);
			_horizontalSlider.hitArea = _horizontalSliderHitArea;
			_horizontalSlider.graphics.endFill();
			
			this.x = stage.stageWidth-newWidth-20;
			this.y = 0;
			
			// Draw white backGround
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF,1);
			this.graphics.drawRect(0,0,_attributesField.width+20,stage.stageHeight);
			this.graphics.endFill();
			
			_horizontalSliderHitArea.addEventListener(MouseEvent.MOUSE_OVER,over);
			_horizontalSliderHitArea.addEventListener(MouseEvent.MOUSE_OUT,out);
			_horizontalSliderHitArea.addEventListener(MouseEvent.MOUSE_DOWN,down);
			stage.addEventListener(MouseEvent.MOUSE_UP,drop);
		}

		private function down(e:MouseEvent):void{
			var rect:Rectangle = new Rectangle(45,0,stage.stageWidth-60,0);
			this.startDrag(false,rect);
			addEventListener(Event.ENTER_FRAME,whileDragging);
		}
		
		private function drop(e:MouseEvent):void{
			this.stopDrag();
			removeEventListener(Event.ENTER_FRAME,whileDragging);
			_main.attributesAreaWidth = _main.stage.stageWidth-this.x;
		}
		
		private function whileDragging(e:Event):void{
			_attributesField.width = stage.stageWidth-this.x-20;
			_main.x = -(stage.stageWidth-this.x)/2;
			
			if(_attributesField.width<=50) _attributesField.alpha = 0;
			else  _attributesField.alpha = 1;
			
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF,1);
			this.graphics.drawRect(0,0,_attributesField.width+20,stage.stageHeight);
			this.graphics.endFill();
		}
		
		private function over(e:MouseEvent):void{
		}
		
		private function out(e:MouseEvent):void{
		}
		
		private function setHtmlText(graph:Graph):String{
			var new_text:String = '<font face="Verdana" size="12"><b>Node information:</b>\n';
			var newContent:Dictionary = _displayNode.node.getAttributes().getMap();
			
			// Add label:
			if(_displayNode.node.label=="http://"){
				new_text += "<p><b>Label:</b> "+'<a href="'+_displayNode.node.label+'" target="_blank" >'+'<font color="#444488">'+_displayNode.node.label+"</font></a><br/></p>\n";
			}else{
				new_text += "<p><b>Label:</b> "+_displayNode.node.label+"<br/></p>\n";
			}
			
			// Add attributes:
			for(var key:* in newContent){
				if(graph.getAttribute(key)!=null){
					if((_displayNode.node.getAttributes().getValue(key).substr(0,7)=="http://")||(graph.getAttribute(key).toLowerCase()=="url")){
						new_text += "<p><b>"+graph.getAttribute(key)+":</b> "+'<a href="'+_displayNode.node.getAttributes().getValue(key)+'" target="_blank" >'+'<font color="#444488">'+_displayNode.node.getAttributes().getValue(key)+"</font></a><br/></p>\n";
					}else{
						new_text += "<p><b>"+graph.getAttribute(key)+":</b> "+_displayNode.node.getAttributes().getValue(key)+"<br/></p>\n";
					}
				}
			}
			
			new_text += "</font>";
			
			return(new_text);
		}
		
		public function removeEventListeners():void{
			_horizontalSliderHitArea.removeEventListener(MouseEvent.MOUSE_OVER,over);
			_horizontalSliderHitArea.removeEventListener(MouseEvent.MOUSE_OUT,out);
			_horizontalSliderHitArea.removeEventListener(MouseEvent.MOUSE_DOWN,down);
			stage.addEventListener(MouseEvent.MOUSE_UP,drop);
		}
		
		public function addEventListeners():void{
			_horizontalSliderHitArea.addEventListener(MouseEvent.MOUSE_OVER,over);
			_horizontalSliderHitArea.addEventListener(MouseEvent.MOUSE_OUT,out);
			_horizontalSliderHitArea.addEventListener(MouseEvent.MOUSE_DOWN,down);
			stage.addEventListener(MouseEvent.MOUSE_UP,drop);
		}
		
		public function get attributesField():TextField{
			return _attributesField;
		}
		
		public function set attributesField(value:TextField):void{
			_attributesField = value;
		}
		
		public function get displayNode():DisplayNode{
			return _displayNode;
		}
		
		public function set displayNode(value:DisplayNode):void{
			_displayNode = value;
		}
		
		public function get horizontalSlider():Sprite{
			return _horizontalSlider;
		}
		
		public function set horizontalSlider(value:Sprite):void{
			_horizontalSlider = value;
		}
		
		public function get horizontalSliderHitArea():Sprite{
			return _horizontalSliderHitArea;
		}
		
		public function set horizontalSliderHitArea(value:Sprite):void{
			_horizontalSliderHitArea = value;
		}
		
		public function get main():MainDisplayElement{
			return _main;
		}
		
		public function set main(value:MainDisplayElement):void{
			_main = value;
		}
	}
}