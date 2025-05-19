package com.facebook.graph.data
{
   import com.adobe.serialization.json.JSON;
   
   public class FQLMultiQuery
   {
      
      public var queries:Object;
      
      public function FQLMultiQuery()
      {
         super();
         this.queries = {};
      }
      
      public function add(param1:String, param2:String, param3:Object = null) : void
      {
         var _loc4_:String = null;
         if(this.queries.hasOwnProperty(param2))
         {
            throw new Error("Query name already exists, there cannot be duplicate names");
         }
         for(_loc4_ in param3)
         {
            param1 = param1.replace(new RegExp("\\{" + _loc4_ + "\\}","g"),param3[_loc4_]);
         }
         this.queries[param2] = param1;
      }
      
      public function toString() : String
      {
         return com.adobe.serialization.json.JSON.encode(this.queries);
      }
   }
}

