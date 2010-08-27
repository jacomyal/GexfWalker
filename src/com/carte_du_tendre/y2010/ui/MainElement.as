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
	import com.carte_du_tendre.y2010.display.MainDisplayElement;
	import com.carte_du_tendre.y2010.loading.GexfLoader;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class MainElement extends Sprite{
		
		private var _graph:Graph;
		private var _gexfPath:String;
		private var _gexfLoader:GexfLoader;
		private var _controlPanel:ControlPanel;
		private var _mainDisplayElement:MainDisplayElement;
		
		public function MainElement(s:Stage){

			s.addChild(this);
			//stage.frameRate = 100;
			
			if(root.loaderInfo.parameters["gexfPath"]==undefined) _gexfPath = "./standard_graph.gexf";
			else _gexfPath = root.loaderInfo.parameters["gexfPath"];
			
			_graph = new Graph();
			_gexfLoader = new GexfLoader(this);
			
			trace("MainElement.MainElement: Open file at "+_gexfPath);
			_gexfLoader.addEventListener(GexfLoader.FILE_PARSED,launchGUI);
			_gexfLoader.openFile();
		}

		private function launchGUI(evt:Event):void{
			trace("MainElement.launchGUI: GexfLoader.FILE_PARSED event received.");
			_mainDisplayElement = new MainDisplayElement(this,_graph);
			_controlPanel = new ControlPanel(_graph.metaData,this);
		}

		public function get gexfPath():String{
			return _gexfPath;
		}
		
		public function set gexfPath(value:String):void{
			_gexfPath = value;
		}
		
		public function get gexfLoader():GexfLoader{
			return _gexfLoader;
		}
		
		public function set gexfLoader(value:GexfLoader):void{
			_gexfLoader = value;
		}
		
		public function get graph():Graph{
			return _graph;
		}
		
		public function set graph(value:Graph):void{
			_graph = value;
		}
		
		public function get controlPanel():ControlPanel{
			return _controlPanel;
		}
		
		public function set controlPanel(value:ControlPanel):void{
			_controlPanel = value;
		}
		
		public function get mainDisplayElement():MainDisplayElement{
			return _mainDisplayElement;
		}
		
		public function set mainDisplayElement(value:MainDisplayElement):void{
			_mainDisplayElement = value;
		}
		
	}
}