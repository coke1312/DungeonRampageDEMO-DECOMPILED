package Events
{
   import flash.events.Event;
   
   public class FirstScalingEvent extends Event
   {
      
      public static const EVENT_NAME:String = "FirstScaling";
      
      public function FirstScalingEvent(param1:Boolean = false, param2:Boolean = false)
      {
         super("FirstScaling",param1,param2);
      }
   }
}

