Infantium-ane
=============

Adobe Native Extension to connect your apps to the Infantium Platform

Version: v2.2.13 (22 September 2014)

## How to build it
	1. Import infantium-lib-actionscript on FlexBuilder 4.6 and build swf file
	2. Run bash script ./build_ane.sh

Check build folder for built ane plugin. Ensure you have Adobe (R) AIR (R) Developer Tool (ADT) installed on $PATH

## Explanation of directories:
	- /infantium-ane: This folder is the Adobe Air way to pack .swf library and .jar files together. 
	- /infantium-ane/extension.xml: Main Adobe Native Extension definition XML.
	- /infantium-ane/platformoptions.xml: Here is where android .jar dependencies are defined
	- /infantium-lib-actionscript: Here is the ActionScript code for the extension, this is a FlashBuilder 4.6 project. Import the project, and compile it to get the .swf file.Then dun build_ane.sh, it will place previously compiled swf file on infantium-ane directory and make the ANE extension
	- /build where final ANE extension is placed


## Help
	
	* Need help? Send a mail to support@infantium.com

## Authors & Contributions
	
	* Chesco Igual
	* Marc Pomar
