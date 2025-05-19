package Metrics
{
   import Brain.Logger.Logger;
   import Facade.DBFacade;
   import flash.events.Event;
   
   public class PixelTracker
   {
      
      public function PixelTracker()
      {
         super();
      }
      
      public static function tutorialComplete(param1:DBFacade) : void
      {
      }
      
      public static function purchaseEvent(param1:DBFacade, param2:uint) : void
      {
      }
      
      public static function nodeCompleted(param1:DBFacade) : void
      {
      }
      
      public static function nodeIndexCompleted(param1:DBFacade, param2:uint) : void
      {
      }
      
      public static function logMapNodeUnlocked(param1:DBFacade, param2:uint) : void
      {
      }
      
      public static function wallPost(param1:DBFacade) : void
      {
      }
      
      public static function invitedFriend(param1:DBFacade) : void
      {
      }
      
      public static function returnDAU(param1:DBFacade) : void
      {
      }
      
      public static function visitedStore(param1:DBFacade) : void
      {
      }
      
      public static function completeHandler(param1:Event) : void
      {
         Logger.debug("Tracker completeHandler" + param1.toString());
      }
      
      public static function securityErrorHandler(param1:Event) : void
      {
         Logger.warn("Tracker securityErrorHandler: " + param1.toString());
      }
      
      public static function ioErrorHandler(param1:Event) : void
      {
         Logger.warn("Tracker ioErrorHandler: " + param1.toString());
      }
   }
}

