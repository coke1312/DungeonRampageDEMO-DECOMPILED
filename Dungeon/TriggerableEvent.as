package Dungeon
{
   public class TriggerableEvent
   {
      
      public var triggerableId:uint;
      
      public var eventName:String;
      
      public function TriggerableEvent(param1:uint, param2:String)
      {
         super();
         triggerableId = param1;
         eventName = param2;
      }
   }
}

