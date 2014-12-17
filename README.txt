=== ShapeSorter ===
Contributors: Attila Farkas
Tags: AS3, Starling, Nape, Kinect, Flox
Requires at least: AIR SDK 3.2
Tested up to: AIR SDK 3.8
Stable tag: AIR SDK 3.8
License: MIT
License URI: http://opensource.org/licenses/MIT

ShapeSorter

Best game in the class. True story.

== Description ==
As part of the continuous assessment of the Creative Multimedia course at LIT-Tipperary/LSAD, 
we were given the task of developing an interactive application that integrates a physics engine, 
uses  a 3rd party online service, and even supports some type of alternative interface, e.g. Adobe Air GamePad, 
Microsoft Kinect.

== Installation ==
Now, this might be tricky:

In Adobe Flash navigate to File->ActionScript Settings, and remove the following files from the library:
1. airkinect-2-core-mssdk.ane 
2. CEV-1-10-ALL.swc
3.Flox-AS3.swc
Then add them back->Click OK->Save.

It is very likely that this process has to be repeated.

== Usage ==
Use your mouse to deliver shapes to their assigned places:
From the top towards the bottom on the right side:
1. Square
2.Circle
3.Triangle

The shapes coming from the left side randomly.
If a shape touches the ground it dies and goes to heaven, cannot be clicked on or moved.
Each shape can fit into only one place.
The game lasts for 50 seconds.
Hit the "R" button to restart.

Have fun!

