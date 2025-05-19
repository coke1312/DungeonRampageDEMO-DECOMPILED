package Actor.Player.Input
{
   import flash.events.Event;
   
   public class DungeonBusterControlActivatedEvent extends Event
   {
      
      public static const TYPE:String = "DungeonBusterControlActivatedEvent";
      
      public function DungeonBusterControlActivatedEvent(param1:Boolean = false, param2:Boolean = false)
      {
         super("DungeonBusterControlActivatedEvent",param1,param2);
      }
   }
}

