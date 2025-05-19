package com.maccherone.json
{
   public class JSON
   {
      
      public function JSON()
      {
         super();
      }
      
      public static function decode(param1:String, param2:Boolean = true) : *
      {
         return new JSONDecoder(param1,param2).getValue();
      }
      
      public static function encode(param1:Object, param2:Boolean = false, param3:int = 60) : String
      {
         return new JSONEncoder(param1,param2,param3).getString();
      }
   }
}

