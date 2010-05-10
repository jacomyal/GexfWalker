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
	
	import com.carte_du_tendre.y2010.display.MainDisplayElement;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class ControlPanel extends Sprite{
		
		private var _infoButton:infobutton;
		private var _metaButton:metabutton;
		private var _resetButton:resetbutton;
		
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
			this.addChild(searchInstruction);
			
			_resetButton = new resetbutton();
			with(_resetButton){
				width = 25;
				height = 25;
				x = 10;
				y = 10;
				addEventListener(MouseEvent.CLICK,resetClickHandler);
			}
			this.addChild(_resetButton);
			
			// Info button and text field:
			_infoButton = new infobutton();
			with(_infoButton){
				width = 25;
				height = 25;
				x = 10;
				y = 45;
				addEventListener(MouseEvent.CLICK,infoDownHandler);
			}
			this.addChild(_infoButton);
			
			_infoField = new TextField();
			_infoField.htmlText = '<font face="Verdana" size="12"><b>Graph information:</b>\n\t<a href="http://github.com/jacomyal/GexfWalker#readme" target="_blank"><font color="#444488">GexfWalker README</font></a>\n\t<a href="http://gexf.net/format/" target="_blank"><font color="#444488">GEXF file format</font></a>\n\t<a href="http://gephi.org/" target="_blank"><font color="#444488">Gephi team</font></a>';
			_infoField.autoSize = TextFieldAutoSize.LEFT;
			_infoField.x = 40;
			_infoField.y = 45;
			_infoField.alpha = 0;
			
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
				}
				this.addChild(_metaButton);
				
				_metaField.htmlText = newMeta;
				_metaField.autoSize = TextFieldAutoSize.LEFT;
				_metaField.x = 40;
				_metaField.y = 80;
				_metaField.alpha = 0;
			}
		}
		
		private function resetClickHandler(e:Event):void{
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			if((dME.isReady)&&(_infoField.alpha==0)&&(_metaField.alpha==0)){
				dME.isReady = false;
				dME.selectRandomNode();
			}
		}
		
		private function infoDownHandler(e:Event):void{
			infoButton.removeEventListener(MouseEvent.CLICK,infoDownHandler);
			metaButton.removeEventListener(MouseEvent.CLICK,metaDownHandler);
			if(_infoField.alpha==0){
				(this.parent as MainElement).mainDisplayElement.freezeBackGround();
				addEventListener(Event.ENTER_FRAME,metaUpInfoDownHandler);
			}else{
				addEventListener(Event.ENTER_FRAME,infoUpFrameHandler);
			}
		}
		
		private function infoUpFrameHandler(e:Event):void{
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			
			if(_infoField.alpha>0.02){
				_infoField.alpha = _infoField.alpha/2;
				dME.alpha = (1-(1-dME.alpha)/2)/2 + 1/2;
			}else{
				_infoField.alpha = 0;
				if(this.contains(_infoField)) removeChild(_infoField);
				dME.alpha = 1;
				dME.unfreezeBackGround();
				removeEventListener(Event.ENTER_FRAME,infoUpFrameHandler);
				infoButton.addEventListener(MouseEvent.CLICK,infoDownHandler);
				metaButton.addEventListener(MouseEvent.CLICK,metaDownHandler);
			}
		}
		
		private function metaDownHandler(e:Event):void{
			infoButton.removeEventListener(MouseEvent.CLICK,infoDownHandler);
			metaButton.removeEventListener(MouseEvent.CLICK,metaDownHandler);
			if(_metaField.alpha==0){
				(this.parent as MainElement).mainDisplayElement.freezeBackGround();
				addEventListener(Event.ENTER_FRAME,infoUpMetaDownHandler);
			}else{
				addEventListener(Event.ENTER_FRAME,metaUpFrameHandler);
			}
		}
		
		private function metaUpFrameHandler(e:Event):void{
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			
			if(_metaField.alpha>0.02){
				_metaField.alpha = _metaField.alpha/2;
				dME.alpha = (1-(1-dME.alpha)/2)/2 + 1/2;
			}else{
				_metaField.alpha = 0;
				if(this.contains(_metaField)) removeChild(_metaField);
				dME.alpha = 1;
				dME.unfreezeBackGround();
				removeEventListener(Event.ENTER_FRAME,metaUpFrameHandler);
				infoButton.addEventListener(MouseEvent.CLICK,infoDownHandler);
				metaButton.addEventListener(MouseEvent.CLICK,metaDownHandler);
			}
		}
		
		private function metaUpInfoDownHandler(e:Event):void{
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			
			addChild(_infoField);
			if((_metaField.alpha>0.02)||(_infoField.alpha<0.98)){
				_metaField.alpha = _metaField.alpha/2;
				_infoField.alpha = 1-(1-_infoField.alpha)/2;
				dME.alpha = (dME.alpha-1/4)/2 + 1/4;
			}else{
				_metaField.alpha = 0;
				_infoField.alpha = 1;
				dME.alpha = 0.25;
				if(this.contains(_metaField)) removeChild(_metaField);
				removeEventListener(Event.ENTER_FRAME,metaUpInfoDownHandler);
				infoButton.addEventListener(MouseEvent.CLICK,infoDownHandler);
				metaButton.addEventListener(MouseEvent.CLICK,metaDownHandler);
			}
		}
		
		private function infoUpMetaDownHandler(e:Event):void{
			var dME:MainDisplayElement = (this.parent as MainElement).mainDisplayElement;
			
			addChild(_metaField);
			if((_infoField.alpha>0.02)||(_metaField.alpha<0.98)){
				_infoField.alpha = _infoField.alpha/2;
				_metaField.alpha = 1-(1-_metaField.alpha)/2;
				dME.alpha = (dME.alpha-1/4)/2 + 1/4;
			}else{
				_infoField.alpha = 0;
				_metaField.alpha = 1;
				if(this.contains(_infoField)) removeChild(_infoField);
				dME.alpha = 0.25;
				removeEventListener(Event.ENTER_FRAME,infoUpMetaDownHandler);
				infoButton.addEventListener(MouseEvent.CLICK,infoDownHandler);
				metaButton.addEventListener(MouseEvent.CLICK,metaDownHandler);
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
		
	}
}