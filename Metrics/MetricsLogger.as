package Metrics
{
   import Brain.Logger.Logger;
   import Facade.DBFacade;
   import com.maccherone.json.JSON;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   
   public class MetricsLogger
   {
      
      private var mMetricsURL:String;
      
      protected var mDBFacade:DBFacade;
      
      public function MetricsLogger(param1:DBFacade, param2:String)
      {
         super();
         mDBFacade = param1;
         mMetricsURL = param2;
         if(!mMetricsURL || mMetricsURL.length == 0)
         {
            Logger.info("Empty metrics URL. Cannot log metrics.");
         }
      }
      
      public function log(param1:String, param2:Object = null) : void
      {
         if(!mMetricsURL)
         {
            return;
         }
         var _loc3_:URLRequest = new URLRequest(mMetricsURL);
         if(param2 == null)
         {
            param2 = {};
         }
         for(var _loc6_ in mDBFacade.demographics)
         {
            if(param2.hasOwnProperty(_loc6_))
            {
               Logger.warn("Duplicate metric property: " + _loc6_ + " in event: " + param1);
            }
            param2[_loc6_] = mDBFacade.demographics[_loc6_];
         }
         var _loc4_:String = com.maccherone.json.JSON.encode(param2);
         var _loc7_:URLVariables = new URLVariables();
         _loc7_.e = param1;
         _loc7_.parameters = _loc4_;
         _loc3_.data = _loc7_;
         _loc3_.method = "POST";
         var _loc5_:URLLoader = new URLLoader(_loc3_);
         _loc5_.addEventListener("complete",completeHandler);
         _loc5_.addEventListener("securityError",securityErrorHandler);
         _loc5_.addEventListener("ioError",ioErrorHandler);
         _loc5_.load(_loc3_);
      }
      
      private function completeHandler(param1:Event) : void
      {
      }
      
      private function securityErrorHandler(param1:Event) : void
      {
         Logger.warn("SecurityError on metrics logging: " + param1.toString());
      }
      
      private function ioErrorHandler(param1:Event) : void
      {
         Logger.warn("IOError on metrics logging: " + param1.toString());
      }
   }
}

