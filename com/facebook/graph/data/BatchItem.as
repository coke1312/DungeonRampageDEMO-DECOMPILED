package com.facebook.graph.data
{
   public class BatchItem
   {
      
      public var relativeURL:String;
      
      public var callback:Function;
      
      public var params:*;
      
      public var requestMethod:String;
      
      public function BatchItem(param1:String, param2:Function = null, param3:* = null, param4:String = "GET")
      {
         super();
         this.relativeURL = param1;
         this.callback = param2;
         this.params = param3;
         this.requestMethod = param4;
      }
   }
}

