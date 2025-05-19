package Events
{
   import DistributedObjects.MatchMaker;
   import flash.events.Event;
   
   public class MatchMakerLoadedEvent extends Event
   {
      
      public static const EVENT_NAME:String = "MATCH_MAKER_LOADED";
      
      private var mMatchMaker:MatchMaker;
      
      public function MatchMakerLoadedEvent(param1:MatchMaker, param2:Boolean = false, param3:Boolean = false)
      {
         super("MATCH_MAKER_LOADED",param2,param3);
         mMatchMaker = param1;
      }
      
      public function get matchMaker() : MatchMaker
      {
         return mMatchMaker;
      }
   }
}

