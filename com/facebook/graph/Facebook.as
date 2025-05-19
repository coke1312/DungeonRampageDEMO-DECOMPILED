package com.facebook.graph
{
   import com.adobe.serialization.json.JSON;
   import com.adobe.serialization.json.JSONParseError;
   import com.facebook.graph.core.AbstractFacebook;
   import com.facebook.graph.core.FacebookJSBridge;
   import com.facebook.graph.core.FacebookURLDefaults;
   import com.facebook.graph.data.Batch;
   import com.facebook.graph.data.FQLMultiQuery;
   import com.facebook.graph.data.FacebookAuthResponse;
   import com.facebook.graph.net.FacebookRequest;
   import com.facebook.graph.utils.IResultParser;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.utils.Dictionary;
   
   public class Facebook extends AbstractFacebook
   {
      
      protected static var _instance:Facebook;
      
      protected static var _canInit:Boolean = false;
      
      protected var jsCallbacks:Object;
      
      protected var openUICalls:Dictionary;
      
      protected var jsBridge:FacebookJSBridge;
      
      protected var applicationId:String;
      
      protected var _initCallback:Function;
      
      protected var _loginCallback:Function;
      
      protected var _logoutCallback:Function;
      
      public function Facebook()
      {
         super();
         if(_canInit == false)
         {
            throw new Error("Facebook is an singleton and cannot be instantiated.");
         }
         this.jsBridge = new FacebookJSBridge();
         this.jsCallbacks = {};
         this.openUICalls = new Dictionary();
      }
      
      public static function init(param1:String, param2:Function = null, param3:Object = null, param4:String = null) : void
      {
         getInstance().init(param1,param2,param3,param4);
      }
      
      public static function set locale(param1:String) : void
      {
         getInstance().locale = param1;
      }
      
      public static function login(param1:Function, param2:Object = null) : void
      {
         getInstance().login(param1,param2);
      }
      
      public static function mobileLogin(param1:String, param2:String = "touch", param3:Array = null) : void
      {
         var _loc4_:URLVariables = new URLVariables();
         _loc4_.client_id = getInstance().applicationId;
         _loc4_.redirect_uri = param1;
         _loc4_.display = param2;
         if(param3 != null)
         {
            _loc4_.scope = param3.join(",");
         }
         var _loc5_:URLRequest = new URLRequest(FacebookURLDefaults.AUTH_URL);
         _loc5_.method = URLRequestMethod.GET;
         _loc5_.data = _loc4_;
         navigateToURL(_loc5_,"_self");
      }
      
      public static function mobileLogout(param1:String) : void
      {
         getInstance().authResponse = null;
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.confirm = 1;
         _loc2_.next = param1;
         var _loc3_:URLRequest = new URLRequest("http://m.facebook.com/logout.php");
         _loc3_.method = URLRequestMethod.GET;
         _loc3_.data = _loc2_;
         navigateToURL(_loc3_,"_self");
      }
      
      public static function logout(param1:Function) : void
      {
         getInstance().logout(param1);
      }
      
      public static function ui(param1:String, param2:Object, param3:Function = null, param4:String = null) : void
      {
         getInstance().ui(param1,param2,param3,param4);
      }
      
      public static function api(param1:String, param2:Function = null, param3:* = null, param4:String = "GET") : void
      {
         getInstance().api(param1,param2,param3,param4);
      }
      
      public static function getRawResult(param1:Object) : Object
      {
         return getInstance().getRawResult(param1);
      }
      
      public static function hasNext(param1:Object) : Boolean
      {
         var _loc2_:Object = getInstance().getRawResult(param1);
         if(!_loc2_.paging)
         {
            return false;
         }
         return _loc2_.paging.next != null;
      }
      
      public static function hasPrevious(param1:Object) : Boolean
      {
         var _loc2_:Object = getInstance().getRawResult(param1);
         if(!_loc2_.paging)
         {
            return false;
         }
         return _loc2_.paging.previous != null;
      }
      
      public static function nextPage(param1:Object, param2:Function) : FacebookRequest
      {
         return getInstance().nextPage(param1,param2);
      }
      
      public static function previousPage(param1:Object, param2:Function) : FacebookRequest
      {
         return getInstance().previousPage(param1,param2);
      }
      
      public static function postData(param1:String, param2:Function = null, param3:Object = null) : void
      {
         api(param1,param2,param3,URLRequestMethod.POST);
      }
      
      public static function uploadVideo(param1:String, param2:Function = null, param3:* = null) : void
      {
         getInstance().uploadVideo(param1,param2,param3);
      }
      
      public static function fqlQuery(param1:String, param2:Function = null, param3:Object = null) : void
      {
         getInstance().fqlQuery(param1,param2,param3);
      }
      
      public static function fqlMultiQuery(param1:FQLMultiQuery, param2:Function = null, param3:IResultParser = null) : void
      {
         getInstance().fqlMultiQuery(param1,param2,param3);
      }
      
      public static function batchRequest(param1:Batch, param2:Function = null) : void
      {
         getInstance().batchRequest(param1,param2);
      }
      
      public static function callRestAPI(param1:String, param2:Function, param3:* = null, param4:String = "GET") : void
      {
         getInstance().callRestAPI(param1,param2,param3,param4);
      }
      
      public static function getImageUrl(param1:String, param2:String = null) : String
      {
         return getInstance().getImageUrl(param1,param2);
      }
      
      public static function deleteObject(param1:String, param2:Function = null) : void
      {
         getInstance().deleteObject(param1,param2);
      }
      
      public static function addJSEventListener(param1:String, param2:Function) : void
      {
         getInstance().addJSEventListener(param1,param2);
      }
      
      public static function removeJSEventListener(param1:String, param2:Function) : void
      {
         getInstance().removeJSEventListener(param1,param2);
      }
      
      public static function hasJSEventListener(param1:String, param2:Function) : Boolean
      {
         return getInstance().hasJSEventListener(param1,param2);
      }
      
      public static function setCanvasAutoResize(param1:Boolean = true, param2:uint = 100) : void
      {
         getInstance().setCanvasAutoResize(param1,param2);
      }
      
      public static function setCanvasSize(param1:Number, param2:Number) : void
      {
         getInstance().setCanvasSize(param1,param2);
      }
      
      public static function callJS(param1:String, param2:Object) : void
      {
         getInstance().callJS(param1,param2);
      }
      
      public static function getAuthResponse() : FacebookAuthResponse
      {
         return getInstance().getAuthResponse();
      }
      
      public static function getLoginStatus() : void
      {
         getInstance().getLoginStatus();
      }
      
      protected static function getInstance() : Facebook
      {
         if(_instance == null)
         {
            _canInit = true;
            _instance = new Facebook();
            _canInit = false;
         }
         return _instance;
      }
      
      protected function init(param1:String, param2:Function = null, param3:Object = null, param4:String = null) : void
      {
         ExternalInterface.addCallback("handleJsEvent",this.handleJSEvent);
         ExternalInterface.addCallback("authResponseChange",this.handleAuthResponseChange);
         ExternalInterface.addCallback("logout",this.handleLogout);
         ExternalInterface.addCallback("uiResponse",this.handleUI);
         this._initCallback = param2;
         this.applicationId = param1;
         this.oauth2 = true;
         if(param3 == null)
         {
            param3 = {};
         }
         param3.appId = param1;
         param3.oauth = true;
         ExternalInterface.call("FBAS.init",com.adobe.serialization.json.JSON.encode(param3));
         if(param4 != null)
         {
            authResponse = new FacebookAuthResponse();
            authResponse.accessToken = param4;
         }
         if(param3.status !== false)
         {
            this.getLoginStatus();
         }
         else if(this._initCallback != null)
         {
            this._initCallback(authResponse,null);
            this._initCallback = null;
         }
      }
      
      protected function getLoginStatus() : void
      {
         ExternalInterface.call("FBAS.getLoginStatus");
      }
      
      protected function callJS(param1:String, param2:Object) : void
      {
         ExternalInterface.call(param1,param2);
      }
      
      protected function setCanvasSize(param1:Number, param2:Number) : void
      {
         ExternalInterface.call("FBAS.setCanvasSize",param1,param2);
      }
      
      protected function setCanvasAutoResize(param1:Boolean = true, param2:uint = 100) : void
      {
         ExternalInterface.call("FBAS.setCanvasAutoResize",param1,param2);
      }
      
      protected function login(param1:Function, param2:Object = null) : void
      {
         this._loginCallback = param1;
         ExternalInterface.call("FBAS.login",com.adobe.serialization.json.JSON.encode(param2));
      }
      
      protected function logout(param1:Function) : void
      {
         this._logoutCallback = param1;
         ExternalInterface.call("FBAS.logout");
      }
      
      protected function getAuthResponse() : FacebookAuthResponse
      {
         var a:FacebookAuthResponse;
         var authResponseObj:Object = null;
         var result:String = ExternalInterface.call("FBAS.getAuthResponse");
         try
         {
            authResponseObj = com.adobe.serialization.json.JSON.decode(result);
         }
         catch(e:*)
         {
            return null;
         }
         a = new FacebookAuthResponse();
         a.fromJSON(authResponseObj);
         this.authResponse = a;
         return authResponse;
      }
      
      protected function ui(param1:String, param2:Object, param3:Function = null, param4:String = null) : void
      {
         param2.method = param1;
         if(param3 != null)
         {
            this.openUICalls[param1] = param3;
         }
         if(param4)
         {
            param2.display = param4;
         }
         ExternalInterface.call("FBAS.ui",com.adobe.serialization.json.JSON.encode(param2));
      }
      
      protected function addJSEventListener(param1:String, param2:Function) : void
      {
         if(this.jsCallbacks[param1] == null)
         {
            this.jsCallbacks[param1] = new Dictionary();
            ExternalInterface.call("FBAS.addEventListener",param1);
         }
         this.jsCallbacks[param1][param2] = null;
      }
      
      protected function removeJSEventListener(param1:String, param2:Function) : void
      {
         if(this.jsCallbacks[param1] == null)
         {
            return;
         }
         delete this.jsCallbacks[param1][param2];
      }
      
      protected function hasJSEventListener(param1:String, param2:Function) : Boolean
      {
         if(this.jsCallbacks[param1] == null || this.jsCallbacks[param1][param2] !== null)
         {
            return false;
         }
         return true;
      }
      
      protected function handleUI(param1:String, param2:String) : void
      {
         var _loc3_:Object = param1 ? com.adobe.serialization.json.JSON.decode(param1) : null;
         var _loc4_:Function = this.openUICalls[param2];
         if(_loc4_ === null)
         {
            delete this.openUICalls[param2];
         }
         else
         {
            _loc4_(_loc3_);
            delete this.openUICalls[param2];
         }
      }
      
      protected function handleLogout() : void
      {
         authResponse = null;
         if(this._logoutCallback != null)
         {
            this._logoutCallback(true);
            this._logoutCallback = null;
         }
      }
      
      protected function handleJSEvent(param1:String, param2:String = null) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         if(this.jsCallbacks[param1] != null)
         {
            try
            {
               _loc3_ = com.adobe.serialization.json.JSON.decode(param2);
            }
            catch(e:JSONParseError)
            {
            }
            for(_loc4_ in this.jsCallbacks[param1])
            {
               (_loc4_ as Function)(_loc3_);
               delete this.jsCallbacks[param1][_loc4_];
            }
         }
      }
      
      protected function handleAuthResponseChange(param1:String) : void
      {
         var resultObj:Object = null;
         var result:String = param1;
         var success:Boolean = true;
         if(result != null)
         {
            try
            {
               resultObj = com.adobe.serialization.json.JSON.decode(result);
            }
            catch(e:JSONParseError)
            {
               success = false;
            }
         }
         else
         {
            success = false;
         }
         if(success)
         {
            if(authResponse == null)
            {
               authResponse = new FacebookAuthResponse();
               authResponse.fromJSON(resultObj);
            }
            else
            {
               authResponse.fromJSON(resultObj);
            }
         }
         if(this._initCallback != null)
         {
            this._initCallback(authResponse,null);
            this._initCallback = null;
         }
         if(this._loginCallback != null)
         {
            this._loginCallback(authResponse,null);
            this._loginCallback = null;
         }
      }
   }
}

