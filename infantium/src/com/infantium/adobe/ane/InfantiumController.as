/**
 * 
 * 
 * 
 * 
 **/
package com.infantium.adobe.ane
{
	import com.infantium.adobe.ane.events.InfantiumEvent;
	
	import flash.events.EventDispatcher;
	
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

		}
		
		/**
		 * Cleans up the instance of the native extension. 
		 */		
		public function dispose():void { 
			 
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
			InfantiumEvent;
			InfantiumResponse; // here just to be embeded in the swc
			
		}

		public function addElement(element_id:String, type:String, visual_type:String, dimension:String, size_x:int, size_y:int, size_z:int, color:String, category:String, subcategory:String, pos_x:int, pos_y:int, pos_z:int, visibility:Number, alpha:Number, extra_fields_json:Vector.<DynamicField>):String{
			return "";
		}

		public function addSound(sound_id:String, category:String = "", subcategory:String = ""):String{
			return "";
		}
		
		public function getPlayerUUIDFromApp():void{
		}
		

		public function setContentAppUUID(contentapp_uuid:String):void{

		}
		

		public function createGameplay(subcontent_uuid:String = ""):void{

		}

		public function closeGameplay():void{
			
		}
		
		public function setEvaluate(... args):String{
			return "";
		}
		public function setSuccesses(successes:int):String{
			return "";
		}

		public function setFailures(failures:int):String{
			return "";
		}

		public function setTarget(element_id:String, goal_element_id:String):String{
			return "";
		}
		
		public function sendGameRawdata():void{
			
		}

		public function tapOnObjects(element_id:String, output:String, extra_fields_json:Vector.<DynamicField>, sound_id:String = null):String{
			return "";
		}
		public function tapNoObjects(pos_x:int, pos_y:int, pos_z:int, output:String, extra_fields_json:Vector.<DynamicField>, sound_id:String = null):String{
			return "";
		}
		public function startDragging(element_id:String, pos_x:int, pos_y:int, pos_z:int):String{
			return "";
		}
		
		public function finishDragging(pos_x:int, pos_y:int, pos_z:int, output:String, max_x:int, max_y:int,  extra_fields_json:Vector.<DynamicField>, sound_id:String = null):String{
			return "";
		}
		
		public function startPlaying():String{
			return "";
		}
		
		public function returnToInfantiumApp():String{
			return "";
		}
		
		public function setSubContentUUID(subcontent_uuid:String):String{
			return "";
		}
		
		public function addDynamicField(dynamic_field_json:DynamicField):String{
			return "";
		}
		public function onPauseInfantium():void{
			
		}
		
		public function onResumeInfantium():void{
			
		}

		
	}
}

class SingletonEnforcer {
	
}