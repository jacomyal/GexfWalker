/*
# Copyright (c) 2009 Alexis Jacomy <alexis.jacomy@gmail.com>
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

package com.carte_du_tendre.y2010.loading {
	
	import com.carte_du_tendre.y2010.data.Graph;
	import com.carte_du_tendre.y2010.data.Node;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * Parses the GEXF file to enter into the memory everything about the graph, nodes and edges.
	 * 
	 * @author Alexis Jacomy <alexis.jacomy@gmail.com>
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 10
	 */
	public class GexfLoader extends EventDispatcher{
		
		public static const FILE_PARSED:String = "File totally parsed";
		
		private var _gexfPath:String;
		private var _graph:Graph;
		
		private var _fileLoader:URLLoader;
		private var _fileRequest:URLRequest;
		
		public function GexfLoader(newGraph:Graph,path:String){
			_graph = newGraph;
			_gexfPath = path;
			
		}
		
		public function openFile():void{
			_fileRequest = new URLRequest(_gexfPath);
			_fileLoader = new URLLoader();
			
			configureListeners(_fileLoader);
			
			try {
				_fileLoader.load(_fileRequest);
			} catch (error:Error) {
				trace("GexfLoader.openFile: Unable to load requested file.");
			}
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function completeHandler(event:Event):void{
			trace("GexfLoader.completeHandler: Loading complete");
			
			var xml:XML = new XML(event.target.data);
			parseXMLElement(xml);
		}
		
		private function openHandler(event:Event):void{
			trace("GexfLoader.openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void{
			trace("GexfLoader.progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void{
			trace("GexfLoader.securityErrorHandler: " + event);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void{
			trace("GexfLoader.httpStatusHandler: " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void{
			trace("GexfLoader.ioErrorHandler: " + event);
		}
		
		private function parseXMLElement(xml:XML):void{
			var xmlRoot:XMLList = xml.elements();
			var xmlMeta:XMLList;
			var xmlGraph:XMLList;
			var xmlNodes:XMLList;
			var xmlEdges:XMLList;
			var xmlNodesAttributes:XMLList;
			var xmlEdgesAttributes:XMLList;
			
			var xmlCursor:XML;
			
			// Parse at depth:=1:
			for(var i:int=0;i<xmlRoot.length();i++){
				if(xmlRoot[i].name().localName=='meta'){
					trace("GexfLoader.parseXMLElement: Meta data found.");
					xmlMeta = xmlRoot[i].children();
				}else if(xmlRoot[i].name().localName=='graph'){
					trace("GexfLoader.parseXMLElement: Graph found.");
					xmlGraph = xmlRoot[i].children();
				}
			}
			
			// Parse at depth:=2:
			for(i=0;i<xmlGraph.length();i++){
				if((xmlGraph[i].name().localName=='attributes')&&(xmlGraph[i].attribute("class")=='node')){
					trace("GexfLoader.parseXMLElement: Nodes attributes found.");
					xmlNodesAttributes = xmlGraph[i].children();
				}else if((xmlGraph[i].name().localName=='attributes')&&(xmlGraph[i].attribute("class")=='edge')){
					trace("GexfLoader.parseXMLElement: Edges attributes found.");
					xmlEdgesAttributes = xmlGraph[i].children();
				}else if(xmlGraph[i].name().localName=='nodes'){
					trace("GexfLoader.parseXMLElement: Nodes found.");
					xmlNodes = xmlGraph[i].children();
				}else if(xmlGraph[i].name().localName=='edges'){
					trace("GexfLoader.parseXMLElement: Edges found.");
					xmlEdges = xmlGraph[i].children();
				}
			}
			
			// Now we can easily parse all nodes...
			var nodesCounter:int = 0;
			for each(xmlCursor in xmlNodes){
				graph.addNode(new Node(nodesCounter,xmlCursor.@id,xmlCursor.@label));
				nodesCounter++;
			}
			
			trace("GexfLoader.parseXMLElement: "+nodesCounter+" nodes parsed.");
			
			// ... and edges:
			var edgesCounter:int = 0;
			for each(xmlCursor in xmlEdges){
				graph.getNode(xmlCursor.@source).addOutLink(graph.getNode(xmlCursor.@target));
				graph.getNode(xmlCursor.@target).addInLink(graph.getNode(xmlCursor.@source));
				edgesCounter++;
			}
			
			trace("GexfLoader.parseXMLElement: "+edgesCounter+" edges parsed.");
			
			// Finally, we just send an event to let MainElement start the GUI:
			trace("GexfLoader.parseXMLElement: File totally parsed, sending FILE_PARSED event.");
			dispatchEvent(new Event(FILE_PARSED));
		}
		
		public function get fileRequest():URLRequest{
			return _fileRequest;
		}
		
		public function set fileRequest(value:URLRequest):void{
			_fileRequest = value;
		}
		
		public function get fileLoader():URLLoader{
			return _fileLoader;
		}
		
		public function set fileLoader(value:URLLoader):void{
			_fileLoader = value;
		}
		
		public function get graph():Graph{
			return _graph;
		}
		
		public function set graph(value:Graph):void{
			_graph = value;
		}
		
		public function get gexfPath():String{
			return _gexfPath;
		}
		
		public function set gexfPath(value:String):void{
			_gexfPath = value;
		}
		
	}
}