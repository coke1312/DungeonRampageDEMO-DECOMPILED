package Events
{
   import flash.events.Event;
   
   public class FirstCooldownEvent extends Event
   {
      
      public static const EVENT_NAME:String = "FirstCooldown";
      
      public function FirstCooldownEvent(param1:Boolean = false, param2:Boolean = false)
      {
         super("FirstCooldown",param1,param2);
      }
   }
}

