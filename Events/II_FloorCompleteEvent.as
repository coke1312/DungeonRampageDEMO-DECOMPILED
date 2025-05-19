package Events
{
   import flash.events.Event;
   
   public class II_FloorCompleteEvent extends Event
   {
      
      public static const TYPE:String = "II_FLOOR_COMPLETE";
      
      public function II_FloorCompleteEvent(param1:Boolean = false, param2:Boolean = false)
      {
         super("II_FLOOR_COMPLETE",param1,param2);
      }
   }
}

