package com.facebook.graph.data
{
   import com.facebook.graph.core.FacebookLimits;
   
   public class Batch
   {
      
      protected var _requests:Array;
      
      public function Batch()
      {
         super();
         this._requests = [];
      }
      
      public function get requests() : Array
      {
         return this._requests;
      }
      
      public function add(param1:String, param2:Function = null, param3:* = null, param4:String = "GET") : void
      {
         if(this._requests.length == FacebookLimits.BATCH_REQUESTS)
         {
            throw new Error("Facebook limits you to " + FacebookLimits.BATCH_REQUESTS + " requests in a single batch.");
         }
         this._requests.push(new BatchItem(param1,param2,param3,param4));
      }
   }
}

