/**
 * 
 * 
 * 
 * 
 **/
package com.infantium.adobe.ane
{
	import com.infantium.adobe.ane.events.InfantiumEvent;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.utils.describeType;
	
	// ALL THE OTHER NECESSARY FUNCTIONS

	
	/**
	 * 
	 */	
	public class InfantiumController extends EventDispatcher
	{
		//----------------------------------------
		//
		// Variables
		//
		//----------------------------------------
		
		private static var _instance:InfantiumController;
		private var extContext:ExtensionContext;
				
		//----------------------------------------
		//
		// Public Methods
		//
		//----------------------------------------
		
		public static function get instance():InfantiumController {
			if ( !_instance ) {
				_instance = new InfantiumController( new SingletonEnforcer() );
			}
			
			return _instance;
		}
		
		public function initInfantium(s1:String, s2:String, int1:int, int2:int, contentAppUUID:String = "3336498c39414e7ea4488b61011038c8"):void{
			onResumeInfantium();
			var isInited:* = extContext.call("initFunction", s1, s2, int1, int2);
			if(isInited){
				extContext.call(InfantiumEvent.setContentAppUUID, contentAppUUID);
			}
		}
		
		/**
		 * Cleans up the instance of the native extension. 
		 */		
		public function dispose():void {
			onPauseInfantium();
			extContext.dispose(); 
		}
		
		//----------------------------------------
		//
		// Handlers
		//
		//----------------------------------------
		
		//----------------------------------------
		//
		// Handlers
		//
		//----------------------------------------
		
		private function onStatus( event:StatusEvent ):void {
			trace("Infantium:onStatus:\nlevel:", event.level, "code:", event.code);
			var ok:Boolean = false;
			var constant:String = getConstant(event.level);
			if(constant){
				dispatchEvent(new InfantiumEvent(constant, event.code));
				dispatchEvent(new InfantiumEvent(InfantiumEvent.STATUS_EVENT, {code:event.code, level:constant}));
			}
		}
		
		private var description:XML;
		private function getConstant (str : String ) : String 
		{
			if (description == null) 
			{
				description = describeType (InfantiumEvent);      
			}
			for each ( var constant:XML in description.constant) 
			{
				if ((InfantiumEvent[constant.@name] as String).toLowerCase() == str.toLowerCase()) return InfantiumEvent[constant.@name];
			}
			return str;
		}
		
		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------
		
		/**
		 * Constructor. 
		 */		
		public function InfantiumController( enforcer:SingletonEnforcer ) {
			super();
			
			InfantiumResponse; // here just to be embeded in the swc
			
			extContext = ExtensionContext.createExtensionContext( "com.infantium.adobe.ane", "" );
			
			if ( !extContext ) {
				throw new Error( "Volume native extension is not supported on this platform." );
			}
			
			extContext.addEventListener( StatusEvent.STATUS, onStatus );
			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate);
		}
		
		private function onActivate(e:Event):void{
			trace("resume infantium");
			onResumeInfantium();
		}
		
		private function onDeactivate(e:Event):void{
			trace("pause infantium");
			onPauseInfantium();
		}
		// functions mapping
		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: String element_id
		* 1: String type
		* 2: String visual_type
		* 3: String dimension
		* 4: int size_x
		* 5: int size_y
		* 6: int size_z (-1 if non-existent)
		* 7: String color
		* 8: String category
		* 9: String subcategory
		* 10: int pos_x
		* 11: int pos_y
		* 12: int pos_z (-1 if non-existent)
		* 13: float visibility
		* 14: float alpha
		* 15: String extra_fields_json
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function addElement(element_id:String, type:String, visual_type:String, dimension:String, size_x:int, size_y:int, size_z:int, color:String, category:String, subcategory:String, pos_x:int, pos_y:int, pos_z:int, visibility:Number, alpha:Number, extra_fields_json:Vector.<DynamicField>):String{
			if(extra_fields_json == null){
				extra_fields_json = new Vector.<DynamicField>;
			}
			if(isNaN(size_z)) size_z = -1;
			if(isNaN(pos_z)) pos_z = -1;
			var response:String = extContext.call("addElement", element_id, type, visual_type, dimension, size_x, size_y, size_z, color, category, subcategory, pos_x, pos_y, pos_z, visibility, alpha, JSON.stringify(extra_fields_json)) as String;
			return response;
		}
		
		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: String sound_id
		* 1: String category (optional)
		* 2: String subcategory (optional)
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function addSound(sound_id:String, category:String = "", subcategory:String = ""):String{
			var response:String;
			if(category == ""){
				response = extContext.call("addSound", sound_id) as String;
			} else if(subcategory == ""){
				response = extContext.call("addSound", sound_id, category) as String;
			} else {
				response = extContext.call("addSound", sound_id, category, subcategory) as String;
			}
			return response;
		}
		
		public function getPlayerUUIDFromApp():void{
			extContext.call("getPlayerUUIDFromApp");
		}
		
		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: String contentapp_uuid
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function setContentAppUUID(contentapp_uuid:String):void{
			extContext.call("setContentAppUUID", contentapp_uuid);
		}
		
		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: String subcontent_uuid (optional for ebooks)
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/

		public function createGameplay(subcontent_uuid:String = ""):void{
			if(subcontent_uuid == ""){
				extContext.call("createGameplay");
			} else {
				extContext.call("createGameplay", subcontent_uuid);
			}
		}
		
		/* (non-Javadoc)
		* The parameters in the args should be empty
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function closeGameplay():void{
			extContext.call("closeGameplay");
		}
		
		public function setEvaluate(... args):String{
			var response:String = extContext.call.apply(extContext, ["setEvaluate"].concat(args)) as String;
			return response;
		}
		
		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: int successes
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function setSuccesses(successes:int):String{
			var response:String = extContext.call("setSuccesses", successes) as String;
			return response;
		}
		
		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: int failures
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function setFailures(failures:int):String{
			var response:String = extContext.call("setFailures", failures) as String;
			return response;
		}
		
		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: String element_id
		* 1: String goal_element_id
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/

		public function setTarget(element_id:String, goal_element_id:String):String{
			var response:String = extContext.call("setTarget", element_id, goal_element_id) as String;
			return response;
		}
		
		public function sendGameRawdata():void{
			extContext.call("sendGameRawdata");
		}
		
		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: String element_id
		* 1: String output
		* 2: String extra_fields_json
		* 3: String sound_id (optional)
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function tapOnObjects(element_id:String, output:String, extra_fields_json:Vector.<DynamicField>, sound_id:String = null):String{
			if(extra_fields_json == null){
				extra_fields_json = new Vector.<DynamicField>;
			}
			var response:String;
			if(sound_id != null){
				response = extContext.call("tapOnObjects", element_id, output, JSON.stringify(extra_fields_json), sound_id) as String;
			} else {
				response = extContext.call("tapOnObjects", element_id, output, JSON.stringify(extra_fields_json)) as String;
			}
			return response;
		}
		
		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: int pos_x
		* 1: int pos_y
		* 2: int pos_z (-1 if non-existent)
		* 3: String output
		* 4: String extra_fields_json
		* 5: String sound_id (optional)
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function tapNoObjects(pos_x:int, pos_y:int, pos_z:int, output:String, extra_fields_json:Vector.<DynamicField>, sound_id:String = null):String{
			if(extra_fields_json == null){
				extra_fields_json = new Vector.<DynamicField>;
			}
			if(isNaN(pos_z)){
				pos_z = -1;
			}
			var response:String;
			if(sound_id != null){
				response = extContext.call("tapNoObjects", pos_x, pos_y, pos_z, output, JSON.stringify(extra_fields_json), sound_id) as String;
			} else {
				response = extContext.call("tapNoObjects", pos_x, pos_y, pos_z, output, JSON.stringify(extra_fields_json)) as String;
			}
			return response;
		}
		
		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: String element_id
		* 1: int pos_x
		* 2: int pos_y
		* 3: int pos_z (-1 if non-existent)
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function startDragging(element_id:String, pos_x:int, pos_y:int, pos_z:int):String{
			if(isNaN(pos_z)){
				pos_z = -1;
			}
			var response:String;
			response = extContext.call("startDragging",element_id, pos_x, pos_y, pos_z) as String;
			return response;
		}
		
		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: int pos_x
		* 1: int pos_y
		* 2: int pos_z (-1 if non-existent)
		* 3: String output
		* 4: int max_x (-1 if non-existent)
		* 5: int max_y (-1 if non-existent)
		* 6: String extra_fields_json
		* 7: String sound_id (optional)
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function finishDragging(pos_x:int, pos_y:int, pos_z:int, output:String, max_x:int, max_y:int,  extra_fields_json:Vector.<DynamicField>, sound_id:String = null):String{
			if(extra_fields_json == null){
				extra_fields_json = new Vector.<DynamicField>;
			}
			if(isNaN(pos_z)){
				pos_z = -1;
			}
			if(isNaN(max_x)){
				max_x = -1;
			}
			if(isNaN(max_y)){
				max_y = -1;
			}
			var response:String;
			if(sound_id != null){
				trace("CALL finishDragging", pos_x, pos_y, pos_z, output, max_x, max_y, JSON.stringify(extra_fields_json), sound_id);
				response = extContext.call("finishDragging", pos_x, pos_y, pos_z, output, max_x, max_y, JSON.stringify(extra_fields_json), sound_id) as String;
			} else {
				response = extContext.call("finishDragging", pos_x, pos_y, pos_z, output, max_x, max_y, JSON.stringify(extra_fields_json)) as String;
			}
			return response;
		}
		
		public function startPlaying():String{
			/* (non-Javadoc)
			* The parameters in the args should be empty
			* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
			*/
			var response:String = extContext.call("startPlaying") as String;
			return response;
		}
		
		public function returnToInfantiumApp():String{
			/* 
			* The parameters in the args should be empty
			* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
			*/
			var response:String = extContext.call("returnToInfantiumApp") as String;
			return response;
		}
		
		public function setSubContentUUID(subcontent_uuid:String):String{
			/* (non-Javadoc)
			* The parameters in the args should be:
			* 0: String subcontent_uuid
			* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
			*/
			var response:String = extContext.call("setSubContentUUID", subcontent_uuid) as String;
			return response;
		}
		
		public function addDynamicField(dynamic_field_json:DynamicField):String{
			/* (non-Javadoc)
			* The parameters in the args should be:
			* 0: String dynamic_field_json
			* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
			*/
			var response:String = extContext.call("addDynamicField", JSON.stringify(dynamic_field_json)) as String;
			return response;
		}
		
		public function onPauseInfantium():void{
			extContext.call("onPauseInfantium");
		}
		
		public function onResumeInfantium():void{
			extContext.call("onResumeInfantium");
		}
		
	}
}

class SingletonEnforcer {
	
}