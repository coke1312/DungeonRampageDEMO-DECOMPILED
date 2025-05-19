package Brain.jsonRPC
{
   public dynamic class JSONRPCService
   {
      
      public static var GLobalcounter:int = 0;
      
      public function JSONRPCService()
      {
         super();
      }
      
      public static function getFunction(param1:String, param2:String) : Function
      {
         return getMethod(param1,param2);
      }
   }
}

import Brain.Logger.Logger;
import com.maccherone.json.JSON;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.net.URLStream;

function getMethod(param1:String, param2:String):Function
{
   var name:String = param1;
   var url:String = param2;
   var fn:Function = function(... rest):*
   {
      var counter:int;
      var req:URLRequest;
      var resp:URLStream;
      var inv:JSONRPCPendingInvokation;
      var args:Array = rest;
      var cbResult:Function = null;
      var cbError:Function = null;
      JSONRPCService.GLobalcounter++;
      counter = JSONRPCService.GLobalcounter;
      if(args.length == 1 && args[0] is Array)
      {
         args = args[0];
      }
      if(args.length && args[args.length - 1] is Function)
      {
         cbResult = args.pop();
         if(args.length && args[args.length - 1] is Function)
         {
            cbError = cbResult;
            cbResult = args.pop();
         }
      }
      req = new URLRequest(url);
      req.contentType = "application/json";
      req.method = "POST";
      resp = new URLStream();
      inv = new JSONRPCPendingInvokation(resp);
      if(cbError != null)
      {
         inv.addListener("fault",function(param1:FaultEvent):void
         {
            cbError(param1.fault);
         });
      }
      if(cbResult != null)
      {
         inv.addListener("result",function(param1:ResultEvent):void
         {
            cbResult(param1.result);
         });
      }
      try
      {
         req.data = com.maccherone.json.JSON.encode({
            "jsonrpc":"2.0",
            "method":name,
            "params":args,
            "id":1
         },false,7000);
         Logger.debug(counter.toString() + " Request=" + url + " data=" + req.data.toString());
      }
      catch(e:Error)
      {
         inv.handleError(e);
         return inv;
      }
      resp.addEventListener("ioError",function(param1:IOErrorEvent):void
      {
         Logger.error(counter.toString() + " IOErrorEvent: " + param1.toString() + " Data:" + req.data.toString() + " URL:" + url.toString());
         inv.handleError(new Error(param1.text));
      });
      resp.addEventListener("securityError",function(param1:SecurityErrorEvent):void
      {
         Logger.error(counter.toString() + " SecurityErrorEvent: " + param1.toString() + " Data:" + req.data.toString() + " URL:" + url.toString());
         inv.handleError(new Error(param1.text));
      });
      resp.addEventListener("complete",function(param1:Event):void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         try
         {
            _loc2_ = resp.readUTFBytes(resp.bytesAvailable);
            Logger.debug(counter.toString() + " " + name + " Responce=" + _loc2_);
            _loc3_ = com.maccherone.json.JSON.decode(_loc2_);
         }
         catch(e:Error)
         {
            Logger.warn(counter.toString() + " JSONRPCService error parsing JSON: " + _loc2_);
            inv.handleError(e);
            return;
         }
         if(_loc3_.error == null)
         {
            if(false && _loc3_.result == null)
            {
               inv.handleError(new Error("result is missing in json",-1));
            }
            else
            {
               inv.handleResult(_loc3_.result);
            }
         }
         else if(_loc3_.error.message != null)
         {
            if(_loc3_.error.code != null)
            {
               inv.handleError(new Error(_loc3_.error.message,_loc3_.error.code));
            }
            else
            {
               inv.handleError(new Error(_loc3_.error.message,-1));
            }
         }
         else
         {
            inv.handleError(new Error(_loc2_,-1));
         }
      });
      resp.load(req);
      return inv;
   };
   return fn;
}
var e_32700:Object = {
   "code":-32700,
   "message":"Parse error.",
   "data":"Invalid JSON. An error occurred on the server while parsing the JSON text."
};

var e_32600:Object = {
   "code":-32700,
   "message":"Invalid Request.",
   "data":"The received JSON is not a valid JSON-RPC Request."
};

var e_32601:Object = {
   "code":-32601,
   "message":"Method not found.",
   "data":"The requested remote-procedure does not exist / is not available."
};

var e_32602:Object = {
   "code":-32700,
   "message":"Invalid params.",
   "data":"Invalid method parameters."
};

var e_32603:Object = {
   "code":-32700,
   "message":"Internal error.",
   "data":"Internal JSON-RPC error."
};

