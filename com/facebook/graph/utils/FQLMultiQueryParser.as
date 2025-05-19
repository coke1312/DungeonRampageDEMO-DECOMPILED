package com.facebook.graph.utils
{
   public class FQLMultiQueryParser implements IResultParser
   {
      
      public function FQLMultiQueryParser()
      {
         super();
      }
      
      public function parse(param1:Object) : Object
      {
         var _loc3_:String = null;
         var _loc2_:Object = {};
         for(_loc3_ in param1)
         {
            _loc2_[param1[_loc3_].name] = param1[_loc3_].fql_result_set;
         }
         return _loc2_;
      }
   }
}

