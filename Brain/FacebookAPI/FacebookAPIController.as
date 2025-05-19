package Brain.FacebookAPI
{
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import com.facebook.graph.Facebook;
   import flash.external.ExternalInterface;
   
   public class FacebookAPIController
   {
      
      protected var mAccessToken:String = "";
      
      protected var mScope:String;
      
      protected var mUserId:String = "";
      
      public function FacebookAPIController(param1:Facade, param2:String)
      {
         super();
         var _loc3_:Object = {
            "appId":param2,
            "status":true,
            "cookie":true,
            "xfbml":true,
            "frictionlessRequests":true,
            "oauth":true
         };
         Logger.debug("Initing app: " + param2.toString());
         if(ExternalInterface.available)
         {
            Facebook.addJSEventListener("auth.authResponseChange",onAuthResponseChange);
            Facebook.init(param2,handleInit,_loc3_);
         }
      }
      
      public function get accessToken() : String
      {
         return mAccessToken;
      }
      
      public function get fbUserId() : String
      {
         return mUserId;
      }
      
      private function onAuthResponseChange(param1:Object) : void
      {
         Logger.debug("Auth response Changed");
      }
      
      protected function handleLogin(param1:Function) : void
      {
         var successCallback:Function = param1;
         Facebook.login((function():*
         {
            var detectLogin:Function;
            return detectLogin = function(param1:Object, param2:Object):void
            {
               if(param1)
               {
                  Logger.debug("Logged in to FB");
                  mAccessToken = param1.accessToken;
                  successCallback();
               }
               else
               {
                  Logger.debug("Login Failed ");
               }
            };
         })(),{"scope":mScope});
      }
      
      protected function handleInit(param1:Object, param2:Object) : void
      {
         if(param1)
         {
            Logger.debug("Init Success ");
            if(param1.accessToken)
            {
               mAccessToken = param1.accessToken;
            }
         }
         else
         {
            Logger.debug("Init Failed");
         }
      }
      
      protected function detectLogin(param1:Object, param2:Object) : void
      {
         if(param1)
         {
            Logger.debug("Logged in to FB");
            mAccessToken = param1.accessToken;
         }
         else
         {
            Logger.debug("Login Failed ");
         }
      }
      
      protected function feedPost(param1:String = " ", param2:String = " ", param3:String = " ", param4:String = "", param5:String = "", param6:String = "dialog", param7:Function = null, param8:String = "", param9:Object = null, param10:Object = null) : void
      {
         var _loc11_:Object = {
            "name":param1,
            "link":param4,
            "picture":param5,
            "caption":param2,
            "description":param3,
            "to":param8,
            "properties":param9,
            "actions":param10
         };
         Facebook.ui("feed",_loc11_,param7,param6);
      }
      
      protected function friendRequests(param1:String, param2:String = "Invite Friends", param3:String = "dialog", param4:Function = null, param5:Array = null, param6:Object = null, param7:String = "50", param8:String = "", param9:Array = null) : void
      {
         var _loc10_:Object = {
            "message":param1,
            "title":param2,
            "filters":param5,
            "max_recipients":param7,
            "data":param6,
            "to":param8,
            "exclude_ids":param9
         };
         Facebook.ui("apprequests",_loc10_,param4,param3);
      }
      
      protected function postAchievement(param1:String, param2:Object, param3:Function = null) : void
      {
         var _loc4_:String = "/" + param1 + "/achievements";
         Facebook.api(_loc4_,param3,param2,"POST");
      }
   }
}

