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

	public class InfantiumController extends EventDispatcher
	{
		//----------------------------------------
		// Variables
		//----------------------------------------
		
		private static var _instance:InfantiumController;
		private var extContext:ExtensionContext;
				
		//----------------------------------------
		// Public Methods
		//----------------------------------------
		
		public static function get instance():InfantiumController {
			if ( !_instance ) {
				_instance = new InfantiumController( new SingletonEnforcer() );
			}
			
			return _instance;
		}
		
		public function initInfantium(api_user:String, api_key:String, w_dev:int, h_dev:int, contentAppUUID:String = "3336498c39414e7ea4488b61011038c8"):void{
			onResumeInfantium();
			var isInited:* = extContext.call("initFunction", api_user, api_key, w_dev, h_dev);
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
		// Handlers
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
		
		/**
		 * Constructor. 
		 */		
		public function InfantiumController( enforcer:SingletonEnforcer ) {
			super();
			
			InfantiumResponse; // here just to be embeded in the swc
			
			extContext = ExtensionContext.createExtensionContext( "com.infantium.adobe.ane", "" );
			
			if ( !extContext ) {
				throw new Error( "Sorry, Infantium native extension is not supported on this platform." );
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
		* 1: Integer width (optional).
		* 2: Integer height (optional).
		* 3: String movement (optional).
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function addElement(element_id:String, width:int, height:int, movement:String):String{
			if(isNaN(width)) width = -1;
			if(isNaN(height)) height = -1;
			if(movement != null && movement.length>0) movement = "";
			var response:String = extContext.call("addElement",width, height, movement) as String;
			return response;
		}



		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: String element_id
		* 1: int width (optional)
		* 2: int height (optional)
		* 3: String movement (optional)
		* 4: int value
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function addNumberElement(element_id:String, width:int, height:int, movement:String, value:int):String{
			if(isNaN(width)) width = -1;
			if(isNaN(height)) height = -1;
			if(movement != null && movement.length>0) movement = "";
			var response:String = extContext.call("addNumberElement", element_id, width, height, movement, value) as String;
			return response;
		}

		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: String element_id
		* 1: int width (optional)
		* 2: int height (optional)
		* 3: String movement (optional)
		* 4: String text
		* 5: String language (optional)
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function addTextElement(element_id:String, width:int, height:int, movement:String, text:String, language:String):String{
			if(isNaN(width)) width = -1;
			if(isNaN(height)) height = -1;
			if(movement == null) movement = "";
			if(language == null) language = "";

			var response:String = extContext.call("addTextElement", element_id, width, height, movement, text, language) as String;
			return response;
		}

		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: String element_id
		* 1: int width
		* 2: int height
		* 3: String movement
		* 4: int n_sides
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function addShapeElement(element_id:String, width:int, height:int, movement:String, n_sides:int):String{
			if(isNaN(width)) width = -1;
			if(isNaN(height)) height = -1;
			if(movement == null) movement = "";
			if(isNaN(n_sides)) n_sides = -1;
			var response:String = extContext.call("addShapeElement", element_id, width, height, movement, n_sides) as String;
			return response;
		}

		/* (non-Javadoc)
		* The parameters in the args should be:
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function addPaintedElement():String{
			throw new Error( "addPaintedElement is not implemented yet, sorry" );
		 	var response:String = "";
			return response;
		}

		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: String contentapp_uuid
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function addPictureElement():String{
			throw new Error( "addPictureElement is not implemented yet, sorry" );
			var response:String = "";
			return response;
		}

		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: String goal_id
		* 1: int time_limit (optional)
		* 2: String instructions (optional)
		* 3: Boolean auto_eval (default=true)
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function addGoal(goal_id:String, time_limit:int, instructions:String, auto_eval:Boolean=true):String{
			if(isNaN(time_limit)) time_limit = -1;
			if(instructions == null) instructions = "";
			var response:String = extContext.call("addGoal", goal_id, time_limit, auto_eval, instructions) as String;
			return response;
		}

		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: String goal_id
		* 1: int time_limit (optional)
		* 2: String instructions (optional)
		* 3: int n_correct_choices (optional)
		* 4: int n_incorrect_choices (optional)
		* 5: String needed_action (optional)
		* 7: Boolean unique_solution (default=true)
		* 2: Boolean auto_eval (default=true)

		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function addSelectionGoal(goal_id:String, time_limit:int, instructions:String, n_correct_choices:int, n_incorrect_choices:int, needed_action:String, unique_solution:Boolean=true, auto_eval:Boolean=true):String{
			if(isNaN(time_limit)) time_limit = -1;
			if(isNaN(n_correct_choices)) n_correct_choices = -1;
			if(isNaN(n_incorrect_choices)) n_incorrect_choices = -1;
			if(instructions == null) instructions = "";
			if(needed_action == null) needed_action = "";

			var response:String = extContext.call("addSelectionGoal", goal_id, time_limit, auto_eval, instructions, n_correct_choices, n_incorrect_choices, unique_solution, needed_action) as String;
			return response;
		}


		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: String goal_id
		* 1: int time_limit (optional)
		* 2: String instructions (optional)
		* 3: String matching_element
		* 4: String correspondence_type (optional)
		* 5: Boolean auto_eval (optional)
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function addMatchingGoal(goal_id:String, time_limit:int, instructions:String, matching_element:String, correspondence_type:String, auto_eval:Boolean=true):String{
			if(isNaN(time_limit)) time_limit = -1;
			if(instructions == null) instructions = "";
			if(correspondence_type == null) correspondence_type = "";
			
			var response:String = extContext.call("addMatchingGoal", goal_id, time_limit, auto_eval, instructions, matching_element, correspondence_type) as String;
			return response;
		}

		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: String goal_id
		* 1: int time_limit (optional)
		* 2: String instructions (optional)
		* 3: String element_to_tap
		* 4: int auto_eval (optional)
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function addTappingGoal(goal_id:String, time_limit:int, instructions:String, element_to_tap:String, auto_eval:Boolean=true):String{
			if(isNaN(time_limit)) time_limit = -1;
			if(instructions == null) instructions = "";
			var response:String = extContext.call("addTappingGoal", goal_id, time_limit, instructions, element_to_tap) as String;
			return response;
		}

		/* (non-Javadoc)
		* The parameters in the args should be:
		* 0: String interaction_type
		* 1: String object_type
		* 2: String goal_type
		* 3: int lifetime (optional)
 		* 4: int n_concurrent_oks (optional)
		* 5: int n_concurrent_kos (optional)
		* @see com.adobe.fre.FREFunction#call(com.adobe.fre.FREContext, com.adobe.fre.FREObject[])
		*/
		public function newBasicInteraction(interaction_type:String, object_type:String, goal_type:String, lifetime:int, n_concurrent_oks:int, n_concurrent_kos:int):String{
			if(isNaN(lifetime)) lifetime = -1;
			if(isNaN(n_concurrent_oks)) n_concurrent_oks = -1;
			if(isNaN(n_concurrent_kos)) n_concurrent_kos = -1;

			var response:String = extContext.call("newBasicInteraction", interaction_type, object_type, goal_type, lifetime, n_concurrent_oks, n_concurrent_kos) as String;
			return response;
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
		
		public function sendGameRawdata():void{
			extContext.call("sendGameRawdata");
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