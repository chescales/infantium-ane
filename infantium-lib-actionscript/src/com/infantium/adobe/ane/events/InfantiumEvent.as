/**
 * 
 * 
 **/
package com.infantium.adobe.ane.events
{
	import flash.events.Event;
	
	/**
	 *  
	 */	
	public class InfantiumEvent extends Event
	{
		public var data:Object;
		//----------------------------------------
		//
		// Constants
		//
		//----------------------------------------
		
		/**
		 * Disatched when the system volume on the decive changes. 
		 */
		public static const STATUS_EVENT:String = "StatusEvent";
		public static const getPlayerUUIDFromApp:String = "getPlayerUUIDFromApp";
		public static const setContentAppUUID:String = "setContentAppUUID";
		public static const createGameplay:String = "createGameplay";
		public static const closeGameplay:String = "closeGameplay";
		public static const sendGameRawdata:String = "sendGameRawdata";
		
		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------
		
		/**
		 * Constructor.
		 *  
		 * @param type Event type.
		 * @param volume The system volume.
		 * @param bubbles Whether or not the event bubbles.
		 * @param cancelable Whether or not the event is cancelable.
		 */		
		public function InfantiumEvent( type:String, _data:Object = null , bubbles:Boolean=false, cancelable:Boolean=false ) {
			data = _data;
			super(type, bubbles, cancelable);
		}
	}
}


