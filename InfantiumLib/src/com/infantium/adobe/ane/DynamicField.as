package com.infantium.adobe.ane
{
	public class DynamicField
	{
		public var name:String;
		public var type:String;
		public var value:String;
		public var fields:Vector.<DynamicField>;
		public var category:String;
		public var subcategory:String;
		
		public function DynamicField(_name:String, _type:String, _value:String="", _fields:Vector.<DynamicField>=null, _category:String="", _subcategory:String="")
		{
			if(_fields == null) _fields = Vector.<DynamicField>([]);
			
			name = _name;
			type = _type;
			value = _value;
			fields = _fields;
			category = _category;
			subcategory = _subcategory; 
		}
	}
}