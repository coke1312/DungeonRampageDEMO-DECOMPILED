package com.facebook.graph.data
{
   public class FacebookSession
   {
      
      public var uid:String;
      
      public var user:Object;
      
      public var sessionKey:String;
      
      public var expireDate:Date;
      
      public var accessToken:String;
      
      public var secret:String;
      
      public var sig:String;
      
      public var availablePermissions:Array;
      
      public function FacebookSession()
      {
         super();
      }
      
      public function fromJSON(param1:Object) : void
      {
         if(param1 != null)
         {
            this.sessionKey = param1.session_key;
            this.expireDate = new Date(param1.expires);
            this.accessToken = param1.access_token;
            this.secret = param1.secret;
            this.sig = param1.sig;
            this.uid = param1.uid;
         }
      }
      
      public function toString() : String
      {
         return "[userId:" + this.uid + "]";
      }
   }
}

