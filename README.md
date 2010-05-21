#**GexfWalker** - *What happens after Gephi?*

- **author**: Alexis Jacomy, *alexis dot jacomy at gmail dot com*
- **project**: La Carte du Tendre du Web / The Web Tenderness Map

##I. Introduction

This open source web widget is developped as part of the **Web Tenderness Map project**. This project aims to represent the current tenderness map as a websites network.

If many applications are already available to explore and visualize graphs (as Gephi, GUESS, Pajek, etc...), there is not a lot of ways to experience **on the Web** a **local** and **global** navigation of these graphs (the best examples I know are the noticeable [Moritz Stefaner's Relation Browser](http://moritz.stefaner.eu/projects/relation-browser/) and the really good [MindPlayer](http://thisislike.com/mindplayer) of [ThisIsLike.com](http://thisislike.com/) for the local view). This tool is particularly developped for the Gephi and GEXF users community. It is all about GEXF, and is supposed to work with **any graph spatialised from Gephi and exported as a GEXF file**.

###1. Related links

Here are some interesting links relatively to this tool.

- [Web Tenderness Map](http://carte-du-tendre.com/)
- [GexfExplorer](http://github.com/jacomyal/GexfExplorer)
- [GexfWalker](http://github.com/jacomyal/GexfWalker)
- [GEXF Format](http://gexf.net/format/)
- [Gephi](http://www.gephi.org/)

##II. Functionalities

Currently, GexfWalker allows the user to:

- Explore the global layout of the graph (the global view)
- Explore the relations related the nodes (the local view)
- In local view:
  - Visualize the attributes of the current selected node
  - Click on a neighbour of the current selected node to select it
  - In case of too many neighbours, choose the neighbour to select with a combo box (bottom left on the screen)
- In global view:
  - Click on a node to select it into the local view
  - Select a node in the bottom left combo box to pass to the local view
  - Zoom with the mouse wheel
  - Drag and drop the graph with the mouse
- And even more:
  - Meta data visualisation
  - Hypertext links automatically recognized in meta data and attributes
  - The SVG background of your choice (comming soon)

##III. How to try it

You need first to have installed on your computer the Adobe Flash Player (if you can watch videos on YouTube, then it is already done). Then:

1. Download the last stable version in the [Downloads](http://github.com/jacomyal/GexfWalker/downloads) section of this GitHub homepage.
2. Open with your web browser the file **GexfWalker_sample/index.html**
3. Enjoy the exploration!

##IV. How to install it on your website

You need first to have a spatialised GEXF-formated graph from the open-source software [Gephi](http://www.gephi.org/) (see the tutorials [here](http://www.gephi.org/users)). Then:

1. Download the last stable version in the [Downloads](http://github.com/jacomyal/GexfWalker/downloads) section of this GitHub homepage.
2. Host somewhere on your website the file **GexfWalker_sample/GexfWalker.swf** and **your GEXF file**.
3. Replace in **GexfWalker_sample/index.html** on lines 73 and 77 **"./GexfWalker.swf"** by the relative path of this file on your server.
4. Replace in **GexfWalker_sample/index.html** on lines 73 and 77 **"./sample.gexf"** by the relative path of your gexf file on your server. 
5. Copy/paste on your web page the new HTML code where you want to display your graph.

Finally, your webpage will allow users to explore the graph of your choice.

**You can also change some other display settings**, for example by replacing the values of **width** and **height** in lines 8 and 77 of the HTML code.

* * * *

For any question (bugs, ideas of new features, etc...), send me an e-mail, but **check first if there isn't already an answer on the related [wiki](http://wiki.github.com/jacomyal/GexfWalker/) or on [the related thread on the forum of Gephi](http://forum.gephi.org/viewforum.php?f=14&sid=7e2338295bc017436f82b787d14091b4)**