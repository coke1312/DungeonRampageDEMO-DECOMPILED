package com.maccherone.json
{
   import flash.utils.describeType;
   
   public class JSONEncoder
   {
      
      private static const tabWidth:int = 4;
      
      private var jsonString:String;
      
      private var level:int;
      
      private var maxLength:int;
      
      private var pretty:Boolean;
      
      public function JSONEncoder(param1:*, param2:Boolean = false, param3:int = 60)
      {
         super();
         level = 0;
         this.pretty = param2;
         if(param2)
         {
            this.maxLength = param3;
         }
         else
         {
            this.maxLength = int.MAX_VALUE;
         }
         jsonString = convertToString(param1);
      }
      
      private static function getPadding(param1:int) : String
      {
         var _loc2_:int = param1 * tabWidth;
         var _loc3_:String = "";
         var _loc4_:int = 1;
         while(_loc4_ <= _loc2_)
         {
            _loc3_ += " ";
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function objectToStringPretty(param1:Object) : String
      {
         var s:String;
         var classInfo:XML;
         var value:Object = null;
         var key:String = null;
         var v:XML = null;
         var o:Object = param1;
         ++level;
         s = "";
         classInfo = describeType(o);
         if(classInfo.@name.toString() == "Object")
         {
            for(key in o)
            {
               value = o[key];
               if(!(value is Function))
               {
                  if(s.length > 0)
                  {
                     s += ",\n";
                  }
                  s += getPadding(level) + escapeString(key) + ":";
                  if(pretty)
                  {
                     s += " ";
                  }
                  s += convertToString(value);
               }
            }
         }
         else
         {
            for each(v in classInfo..*.(name() == "variable" || name() == "accessor"))
            {
               if(s.length > 0)
               {
                  s += ",\n";
               }
               s += getPadding(level) + escapeString(v.@name.toString()) + ":";
               if(pretty)
               {
                  s += " ";
               }
               s += convertToString(o[v.@name]);
            }
         }
         --level;
         return "{" + "\n" + s + "\n" + getPadding(level) + "}";
      }
      
      private function arrayToString(param1:Array) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(_loc2_.length > 0)
            {
               _loc2_ += ",";
               if(pretty)
               {
                  _loc2_ += " ";
               }
            }
            _loc2_ += convertToString(param1[_loc3_]);
            _loc3_++;
         }
         return "[" + _loc2_ + "]";
      }
      
      public function getString() : String
      {
         return jsonString;
      }
      
      private function objectToString(param1:Object) : String
      {
         var value:Object = null;
         var key:String = null;
         var v:XML = null;
         var o:Object = param1;
         var s:String = "";
         var classInfo:XML = describeType(o);
         if(classInfo.@name.toString() == "Object")
         {
            for(key in o)
            {
               value = o[key];
               if(!(value is Function))
               {
                  if(s.length > 0)
                  {
                     s += ",";
                     if(pretty)
                     {
                        s += " ";
                     }
                  }
                  s += escapeString(key) + ":";
                  if(pretty)
                  {
                     s += " ";
                  }
                  s += convertToString(value);
               }
            }
         }
         else
         {
            for each(v in classInfo..*.(name() == "variable" || name() == "accessor"))
            {
               if(s.length > 0)
               {
                  s += ",";
                  if(pretty)
                  {
                     s += " ";
                  }
               }
               s += escapeString(v.@name.toString()) + ":";
               if(pretty)
               {
                  s += " ";
               }
               s += convertToString(o[v.@name]);
            }
         }
         return "{" + s + "}";
      }
      
      private function escapeString(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc2_:String = "";
         var _loc4_:Number = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = param1.charAt(_loc5_);
            switch(_loc3_)
            {
               case "\"":
                  _loc2_ += "\\\"";
                  break;
               case "\\":
                  _loc2_ += "\\\\";
                  break;
               case "\b":
                  _loc2_ += "\\b";
                  break;
               case "\f":
                  _loc2_ += "\\f";
                  break;
               case "\n":
                  _loc2_ += "\\n";
                  break;
               case "\r":
                  _loc2_ += "\\r";
                  break;
               case "\t":
                  _loc2_ += "\\t";
                  break;
               default:
                  if(_loc3_ < " ")
                  {
                     _loc6_ = _loc3_.charCodeAt(0).toString(16);
                     _loc7_ = _loc6_.length == 2 ? "00" : "000";
                     _loc2_ += "\\u" + _loc7_ + _loc6_;
                  }
                  else
                  {
                     _loc2_ += _loc3_;
                  }
                  break;
            }
            _loc5_++;
         }
         return "\"" + _loc2_ + "\"";
      }
      
      private function arrayToStringPretty(param1:Array) : String
      {
         ++level;
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(_loc2_.length > 0)
            {
               _loc2_ += ",\n";
            }
            _loc2_ += getPadding(level) + convertToString(param1[_loc3_]);
            _loc3_++;
         }
         --level;
         return "[" + "\n" + _loc2_ + "\n" + getPadding(level) + "]";
      }
      
      private function convertToString(param1:*) : String
      {
         var _loc2_:String = null;
         if(param1 is String)
         {
            return escapeString(param1 as String);
         }
         if(param1 is Number)
         {
            return isFinite(param1 as Number) ? param1.toString() : "null";
         }
         if(param1 is Boolean)
         {
            return param1 ? "true" : "false";
         }
         if(param1 is Array)
         {
            if(maxLength <= 2)
            {
               _loc2_ = arrayToStringPretty(param1 as Array);
            }
            else
            {
               _loc2_ = arrayToString(param1 as Array);
               if(_loc2_.length > maxLength)
               {
                  _loc2_ = arrayToStringPretty(param1 as Array);
               }
            }
            return _loc2_;
         }
         if(param1 is Object && param1 != null)
         {
            if(maxLength <= 2)
            {
               _loc2_ = objectToStringPretty(param1);
            }
            else
            {
               _loc2_ = objectToString(param1);
               if(_loc2_.length > maxLength)
               {
                  _loc2_ = objectToStringPretty(param1);
               }
            }
            return _loc2_;
         }
         return "null";
      }
   }
}

