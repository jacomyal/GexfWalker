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
	
	import com.carte_du_tendre.y2010.data.Node;
	import com.carte_du_tendre.y2010.display.DisplayNode;
	import com.carte_du_tendre.y2010.display.MainDisplayElement;
	
	import fl.controls.ComboBox;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import mx.controls.Button;
	
	public class ControlPanel extends Sprite{
		
		private var _infoButton:infobutton;
		private var _metaButton:metabutton;
		private var _resetButton:resetbutton;
		private var _nodesBox:ComboBox;
		
		private var _resetOverField:TextField;
		private var _infoOverField:TextField;
		private var _metaOverField:TextField;
		
		private var _infoField:TextField;
		private var _metaField:TextField;
		
		public function ControlPanel(newMeta:String,s:DisplayObjectContainer){
			
			s.addChild(this);
			
			// Reset button and text field:
			var searchInstruction:TextField = new TextField();
			with(searchInstruction){
				htmlText = '<font face="Verdana" size="12" color="#333333">Random reset</font>';
				selectable = false;
				autoSize = TextFieldAutoSize.LEFT;
				x = 45;
				y = 13;
			}
			//this.addChild(searchInstruction);
			
			_resetButton = new resetbutton();
			with(_resetButton){
				width = 25;
				height = 25;
				x = 10;
				y = 10;
				addEventListener(MouseEvent.CLICK,resetClickHandler);
				addEventListener(MouseEvent.MOUSE_OVER,resetOverHandler);
			}
			this.addEventListener(MouseEvent.MOUSE_OUT,resetOutHandler);
			this.addChild(_resetButton);
			
			_resetOverField = new TextField();
			
			_resetOverField.selectable = false;
			_resetOverField.autoSize = TextFieldAutoSize.LEFT;
			_resetOverField.x = _resetButton.x + _resetButton.width + 10;
			_resetOverField.y = _resetButton.y + (_resetButton.height-18)/2;
			addChild(_resetOverField);
			
			// Info button and text field:
			_infoButton = new infobutton();
			with(_infoButton){
				width = 25;
				height = 25;
				x = 10;
				y = 45;
				addEventListener(MouseEvent.CLICK,infoDownHandler);
				addEventListener(MouseEvent.MOUSE_OVER,infoOverHandler);
			}
			this.addEventListener(MouseEvent.MOUSE_OUT,infoOutHandler);
			this.addChild(_infoButton);
			
			_infoField = new TextField();
			_infoField.htmlText = '<font face="Verdana" size="12"><b>GexfWalker information:</b>\n\t' +
				'<a href="http://github.com/jacomyal/GexfWalker#readme" target="_blank"><font color="#444488">GexfWalker README</font></a>\n\t' +
				'<a href="http://gexf.net/format/" target="_blank"><font color="#444488">GEXF file format</font></a>\n\t' +
				'<a href="http://gephi.org/" target="_blank"><font color="#444488">Gephi team</font></a>\n\n' +
				'<font face="Verdana" size="12">' +
				'<b>Global view:</b>\n\t' +
				'- Zoom with mouse wheel\n\t' +
				'- Drag and drop with clicking\n\t' +
				'- Click on a node to see its neighbours\n\t' +
				'- Use the comboBox in the bottom of the screen to select\n\t' +
				'  a node\n' +
				'<b>Local view:</b>\n\t' +
				'- Click on a neighbour to explore the network\n\t' +
				'- If a bar appears on the right side of the screen, move it\n\t' +
				'  to see more informations about the current central node\n\t' +
				'- Use the comboBox in the bottom of the screen to select\n\t' +
				'  a neighbour\n\n' +
				'<b>Enjoy the exploration!</b></font>';
			_infoField.autoSize = TextFieldAutoSize.LEFT;
			_infoField.x = 40;
			_infoField.y = 10;
			_infoField.alpha = 0;
			
			_infoOverField = new TextField();
			
			_infoOverField.selectable = false;
			_infoOverField.autoSize = TextFieldAutoSize.LEFT;
			_infoOverField.x = _infoButton.x + _infoButton.width + 10;
			_infoOverField.y = _infoButton.y + (_infoButton.height-18)/2;
			addChild(_infoOverField);
			
			// Meta button and text field:
			_metaButton = new metabutton();
			_metaField = new TextField();
			
			if(newMeta!=""){
				with(_metaButton){
					width = 25;
					height = 25;
					x = 10;
					y = 80;
					addEventListener(MouseEvent.CLICK,metaDownHandler);
					addEventListener(MouseEvent.MOUSE_OVER,metaOverHandler);
				}
				this.addChild(_metaButton);
				this.addEventListener(MouseEvent.MOUSE_OUT,metaOutHandler);
				
				_metaField.htmlText = newMeta;
				_metaField.autoSize = TextFieldAutoSize.LEFT;
				_metaField.width = stage.stageWidth/2;
				_metaField.wordWrap = true;
				_metaField.x = 40;
				_metaField.y = 10;
				_metaField.alpha = 0;
				
				_metaOverField = new TextField();
				
				_metaOverField.selectable = false;
				_metaOverField.autoSize = TextFieldAutoSize.LEFT;
				_metaOverField.x = _metaButton.x + _metaButton.width + 10;
				_metaOverField.y = _metaButton.y + (_metaButton.height-18)/2;
				addChild(_metaOverField);
			}else{
				_metaButton = null;
			}
			
			// ComboBox
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			_nodesBox = new ComboBox();
			_nodesBox.x = 10;
			_nodesBox.y = stage.stageHeight-30;
			_nodesBox.width = 190;
			_nodesBox.rowCount = 20;
			_nodesBox.editable = false;
			addChild(_nodesBox);
			
			dME.addEventListener(MainDisplayElement.NODE_SELECTED,fillComboBox);
			dME.addEventListener(MainDisplayElement.GRAPH_VIEW,fillComboBox);
			_nodesBox.addEventListener(Event.CHANGE,newNodeSelected);
			_nodesBox.addEventListener(Event.CLOSE,nodesBoxClose);
			_nodesBox.addEventListener(Event.OPEN,nodesBoxOpen);
		}

		private function resetClickHandler(e:Event):void{
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			if((_infoField.alpha==0)&&(_metaField.alpha==0)&&(dME.isReady==true)){
				if(dME.isGraphView==true){
					dME.selectRandomNode();
					_resetOverField.htmlText = '<font face="Verdana" size="12" color="#333333">( back to global view )</font>';
				}else{
					dME.drawGraph();
					_resetOverField.htmlText = '<font face="Verdana" size="12" color="#333333">( select a random node )</font>';
				}
			}
		}
		
		private function resetOverHandler(e:Event):void{
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			
			if(dME.isGraphView==true) _resetOverField.htmlText = '<font face="Verdana" size="12" color="#333333">( select a random node )</font>';
			else _resetOverField.htmlText = '<font face="Verdana" size="12" color="#333333">( back to global view )</font>';
		}
		
		private function resetOutHandler(e:Event):void{
			_resetOverField.htmlText = '';
		}
		
		private function infoOverHandler(e:Event):void{
			_infoOverField.htmlText = '<font face="Verdana" size="12" color="#333333">( gexfWalker information )</font>';
			trace(_infoOverField.height);
		}
		
		private function infoOutHandler(e:Event):void{
			_infoOverField.htmlText = '';
		}
		
		private function metaOverHandler(e:Event):void{
			_metaOverField.htmlText = '<font face="Verdana" size="12" color="#333333">( graph information )</font>';
		}
		
		private function metaOutHandler(e:Event):void{
			_metaOverField.htmlText = '';
		}
		
		private function infoDownHandler(e:Event):void{
			stage.addEventListener(MouseEvent.CLICK,infoDownHandler);
			stage.removeEventListener(MouseEvent.CLICK,metaDownHandler);
			infoButton.removeEventListener(MouseEvent.CLICK,metaDownHandler);
			if(_metaButton!=null) metaButton.removeEventListener(MouseEvent.CLICK,metaDownHandler);
			if(_infoField.alpha==0){
				freeze();
				addEventListener(Event.ENTER_FRAME,metaUpInfoDownHandler);
				if(contains(_nodesBox)) removeChild(_nodesBox);
			}else{
				addEventListener(Event.ENTER_FRAME,infoUpFrameHandler);
				addChild(_nodesBox);
			}
		}
		
		private function infoUpFrameHandler(e:Event):void{
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			
			if(_infoField.alpha>0.02){
				_infoField.alpha = _infoField.alpha/2;
				dME.alpha = (dME.alpha+1)/2;
				if(dME.currentSelectionDisplayAttributes!=null) dME.currentSelectionDisplayAttributes.alpha = (dME.currentSelectionDisplayAttributes.alpha+1)/2;
			}else{
				_infoField.alpha = 0;
				if(this.contains(_infoField)) removeChild(_infoField);
				dME.alpha = 1;
				if(dME.currentSelectionDisplayAttributes!=null) dME.currentSelectionDisplayAttributes.alpha = 1;
				unfreeze();
				removeEventListener(Event.ENTER_FRAME,infoUpFrameHandler);
				infoButton.addEventListener(MouseEvent.CLICK,infoDownHandler);
				stage.removeEventListener(MouseEvent.CLICK,infoDownHandler);
				stage.removeEventListener(MouseEvent.CLICK,metaDownHandler);
				if(_metaButton!=null) metaButton.addEventListener(MouseEvent.CLICK,metaDownHandler);
			}
		}
		
		private function metaDownHandler(e:Event):void{
			stage.addEventListener(MouseEvent.CLICK,metaDownHandler);
			stage.removeEventListener(MouseEvent.CLICK,infoDownHandler);
			infoButton.removeEventListener(MouseEvent.CLICK,infoDownHandler);
			if(_metaButton!=null) metaButton.removeEventListener(MouseEvent.CLICK,metaDownHandler);
			if(_metaField.alpha==0){
				freeze();
				addEventListener(Event.ENTER_FRAME,infoUpMetaDownHandler);
				if(contains(_nodesBox)) removeChild(_nodesBox);
			}else{
				addEventListener(Event.ENTER_FRAME,metaUpFrameHandler);
				addChild(_nodesBox);
			}
		}
		
		private function metaUpFrameHandler(e:Event):void{
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			
			if(_metaField.alpha>0.02){
				_metaField.alpha = _metaField.alpha/2;
				dME.alpha = (dME.alpha+1)/2;
				if(dME.currentSelectionDisplayAttributes!=null) dME.currentSelectionDisplayAttributes.alpha = (dME.currentSelectionDisplayAttributes.alpha+1)/2;
			}else{
				_metaField.alpha = 0;
				if(this.contains(_metaField)) removeChild(_metaField);
				dME.alpha = 1;
				if(dME.currentSelectionDisplayAttributes!=null) dME.currentSelectionDisplayAttributes.alpha = 1;
				unfreeze();
				removeEventListener(Event.ENTER_FRAME,metaUpFrameHandler);
				infoButton.addEventListener(MouseEvent.CLICK,infoDownHandler);
				stage.removeEventListener(MouseEvent.CLICK,infoDownHandler);
				stage.removeEventListener(MouseEvent.CLICK,metaDownHandler);
				if(_metaButton!=null) metaButton.addEventListener(MouseEvent.CLICK,metaDownHandler);
			}
		}
		
		private function metaUpInfoDownHandler(e:Event):void{
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			
			addChild(_infoField);
			if((_metaField.alpha>0.02)||(_infoField.alpha<0.98)){
				_metaField.alpha = _metaField.alpha/2;
				_infoField.alpha = 1-(1-_infoField.alpha)/2;
				dME.alpha = (dME.alpha+0.1)/2;
				if(dME.currentSelectionDisplayAttributes!=null) dME.currentSelectionDisplayAttributes.alpha = (dME.currentSelectionDisplayAttributes.alpha+0.1)/2;
			}else{
				_metaField.alpha = 0;
				_infoField.alpha = 1;
				dME.alpha = 0.1;
				if(dME.currentSelectionDisplayAttributes!=null) dME.currentSelectionDisplayAttributes.alpha = 0.1;
				if(this.contains(_metaField)) removeChild(_metaField);
				removeEventListener(Event.ENTER_FRAME,metaUpInfoDownHandler);
				infoButton.addEventListener(MouseEvent.CLICK,infoDownHandler);
				if(_metaButton!=null) metaButton.addEventListener(MouseEvent.CLICK,metaDownHandler);
			}
		}
		
		private function infoUpMetaDownHandler(e:Event):void{
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			
			addChild(_metaField);
			if((_infoField.alpha>0.02)||(_metaField.alpha<0.98)){
				_infoField.alpha = _infoField.alpha/2;
				_metaField.alpha = 1-(1-_metaField.alpha)/2;
				dME.alpha = (dME.alpha+0.1)/2;
				if(dME.currentSelectionDisplayAttributes!=null) dME.currentSelectionDisplayAttributes.alpha = (dME.currentSelectionDisplayAttributes.alpha+0.1)/2;;
			}else{
				_infoField.alpha = 0;
				_metaField.alpha = 1;
				if(this.contains(_infoField)) removeChild(_infoField);
				dME.alpha = 0.1;
				if(dME.currentSelectionDisplayAttributes!=null) dME.currentSelectionDisplayAttributes.alpha = 0.1;
				removeEventListener(Event.ENTER_FRAME,infoUpMetaDownHandler);
				infoButton.addEventListener(MouseEvent.CLICK,infoDownHandler);
				if(_metaButton!=null) metaButton.addEventListener(MouseEvent.CLICK,metaDownHandler);
			}
		}
		
		private function freeze():void{
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			
			dME.freezeBackGround();
			
			_resetButton.removeEventListener(MouseEvent.MOUSE_OVER,resetOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,resetOutHandler);
			_resetOverField.text = '';
			
			_infoButton.removeEventListener(MouseEvent.MOUSE_OVER,infoOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,infoOutHandler);
			_infoOverField.text = '';
			
			if(_metaButton!=null){
				_metaButton.removeEventListener(MouseEvent.MOUSE_OVER,metaOverHandler);
				this.removeEventListener(MouseEvent.MOUSE_OUT,metaOutHandler);
				_metaOverField.text = '';
			}
		}
		
		private function unfreeze():void{
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			
			dME.unfreezeBackGround();
			
			_resetButton.addEventListener(MouseEvent.MOUSE_OVER,resetOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,resetOutHandler);
			
			_infoButton.addEventListener(MouseEvent.MOUSE_OVER,infoOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,infoOutHandler);
			
			if(_metaButton!=null){
				_metaButton.addEventListener(MouseEvent.MOUSE_OVER,metaOverHandler);
				this.addEventListener(MouseEvent.MOUSE_OUT,metaOutHandler);
			}
		}
		
		private function fillComboBox(e:Event):void{
			var displayNode:DisplayNode;
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			
			var l:int = _nodesBox.length;
			var i:int;
			
			for(i=0;i<l;i++){
				_nodesBox.removeItemAt(l-1-i);
			}
			
			for each(displayNode in dME.currentDisplayedNodes){
				_nodesBox.addItem({label:displayNode.node.label, data:displayNode.node.flex_id});
			}
			
			_nodesBox.sortItemsOn("label");
		}
		
		private function newNodeSelected(e:Event):void{
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			var node:Node = dME.graph.nodes[_nodesBox.selectedItem.data];
			
			if((_infoField.alpha==0)&&(_metaField.alpha==0)&&(dME.isReady==true)){
				dME.selectNode(node);
			}
		}
		
		private function nodesBoxOpen(e:Event):void{
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			
			if(dME.isGraphView==true){
				stage.removeEventListener(MouseEvent.MOUSE_WHEEL,dME.graphView_zoomScene);
			}
		}
		
		private function nodesBoxClose(e:Event):void{
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			
			if(dME.isGraphView==true){
				stage.addEventListener(MouseEvent.MOUSE_WHEEL,dME.graphView_zoomScene);
			}
		}
		
		public function get resetButton():resetbutton{
			return _resetButton;
		}
		
		public function set resetButton(value:resetbutton):void{
			_resetButton = value;
		}
		
		public function get metaButton():metabutton{
			return _metaButton;
		}
		
		public function set metaButton(value:metabutton):void{
			_metaButton = value;
		}
		
		public function get infoButton():infobutton{
			return _infoButton;
		}
		
		public function set infoButton(value:infobutton):void{
			_infoButton = value;
		}
		
		public function get metaField():TextField{
			return _metaField;
		}
		
		public function set metaField(value:TextField):void{
			_metaField = value;
		}
		
		public function get infoField():TextField{
			return _infoField;
		}
		
		public function set infoField(value:TextField):void{
			_infoField = value;
		}
		
		public function get metaOverField():TextField{
			return _metaOverField;
		}
		
		public function set metaOverField(value:TextField):void{
			_metaOverField = value;
		}
		
		public function get infoOverField():TextField{
			return _infoOverField;
		}
		
		public function set infoOverField(value:TextField):void{
			_infoOverField = value;
		}
		
		public function get resetOverField():TextField{
			return _resetOverField;
		}
		
		public function set resetOverField(value:TextField):void{
			_resetOverField = value;
		}
		
		public function get nodesBox():ComboBox{
			return _nodesBox;
		}
		
		public function set nodesBox(value:ComboBox):void{
			_nodesBox = value;
		}
		
	}
}